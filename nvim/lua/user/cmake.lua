local Path = require("plenary.path")

-- Returns a table of start_line->end_line for each target in the file
function extract_targets(lines)
  local target_lines = {}

  -- Extract all the target declarations
  local target_start = nil
  for i = 1, #lines do
    if string.sub(lines[i], 1, 6) == "ht_add" then
      target_start = i
    elseif lines[i] == ")" then
      if target_start ~= nil then
        target_lines[target_start] = i
        target_start = nil
      end
    end
  end
  return target_lines
end

-- Returns a table containing the {dependencies,files}.{first,last} for the target.
-- `dependencies` and `files` can be nil if not found.
function extract_dependencies_and_files(lines, start_line, end_line)
  local keywords = {}
  for i = start_line, end_line do
    local keyword, count = string.gsub(lines[i], "^%s+([A-Z_]+)%s", "%1")
    if count == 0 then
      keyword, count = string.gsub(lines[i], "^%s+([A-Z_]+)$", "%1")
    end
    if count == 1 then
      table.insert(keywords, {name = keyword, line = i})
    end
  end
  local result = {}
  for i = 1, #keywords do
    if keywords[i].name == "DEPENDS" then
      result.dependencies = {}
      result.dependencies.first = keywords[i].line
      result.dependencies.last = (keywords[i + 1] or {line = end_line}).line
    elseif keywords[i].name == "FILES" then
      result.files = {}
      result.files.first = keywords[i].line
      result.files.last = (keywords[i + 1] or {line = end_line}).line
    end
  end
  return result
end

-- For the given path, returns a table with:
-- {
--   "cmake_file": "the path object to the CMakeLists.txt",
--   "target_name": "the target name",
--   "dependencies": {
--     "first": the line number for the DEPENDS part,
--     "last": the line number for the first line after the DEPENDS section,
--   },
--   "files": {
--     "first": the line number for the FILES part,
--     "last": the line number for the first line after the FILES section.
--   },
-- }
--
-- In case of errors, it returns the error message
--
--  ht_add_unit_test(
--    my_unit_test    <-- target name
--    DEPENDS         <-- first depends line
--      ht_lib_1
--      ht_lib_2
--    VERY_SLOW       <-- first line after depends
--    FILES           <-- first files line
--      my_file.cpp
--  )                 <-- first line after files
function get_dependencies(root, path)
  local filename = string.gsub(path, "^.*/", "")
  local dir = Path:new(path):parent()
  while tostring(dir) ~= root do
    local cmake = dir:joinpath("CMakeLists.txt")
    if cmake:exists() then
      local lines = cmake:readlines()

      local target_lines = extract_targets(lines)

      for start_line, end_line in pairs(target_lines) do
        local result = extract_dependencies_and_files(lines, start_line, end_line)
        result.target_name = string.gsub(lines[start_line + 1], "^%s*", "")
        if result.files ~= nil then
          for i = result.files.first + 1, result.files.last - 1 do
            if string.gsub(lines[i], "^%s*", "") == filename then
              -- Found the target.
              if result.dependencies == nil then
                return "Could not parse the target for " .. Path:new(path):make_relative(root) .. " in " .. cmake:make_relative(root)
              end
              result.cmake_file = cmake
              return result
            end
          end
        end
      end
    end
    dir = dir:parent()
  end
  return "Could not find the cmake target for the current file"
end

function update_dependencies()
  local root_dir = vim.fs.dirname(vim.fs.find({".git"}, { upward = true })[1])
  local current_file = vim.api.nvim_buf_get_name(0)
  local spec = get_dependencies(root_dir, string.gsub(current_file, "%..-$", ".cpp"))
  if type(spec) == "string" then
    print(spec) -- here, the error
    return
  end
  local cmake_lines = spec.cmake_file:readlines()
  local current_directory = Path:new(current_file):parent()
  local all_target_files = {} -- absolute .cpp/.h as keys
  for file_index = spec.files.first + 1, spec.files.last - 1 do
    local target_file = string.gsub(cmake_lines[file_index], "^%s*(.+)%s*$", "%1")
    local target_header = string.gsub(target_file, "%.cpp$", ".h")
    for _, file in ipairs({target_file, target_header}) do
      all_target_files[tostring(current_directory / file)] = true
    end
  end

  local dependencies = {} -- targets as keys
  local get_dependency_from_line = function(line)
    local header_path, count = string.gsub(line, '^%#include "(.*)"$', "%1")
    if count == 1 then 
      local resolve_dependency = function(path)
        local dependency = get_dependencies(root_dir, string.gsub(path, "%.h$", ".cpp"))
        if type(dependency) == "table" then
          dependencies[dependency.target_name] = true
        end
      end
      if not (all_target_files[root_dir .. "/source/cpp/app/" .. header_path] or all_target_files[root_dir .. "/source/cpp/lib/" .. header_path]) then
        local full_header_path = root_dir .. "/source/cpp/app/" .. header_path
        if Path:new(full_header_path):exists() then
          resolve_dependency(full_header_path)
        else
          resolve_dependency(root_dir .. "/source/cpp/lib/" .. header_path)
        end
      end
    else
      header_path, count = string.gsub(line, '^%#include <absl/container/(.*)%.h>$', "%1")
      if count == 1 then
        dependencies["absl::" .. header_path] = true
      elseif string.find(line, '^%#include <absl/strings/(.*)>$') ~= nil then
        dependencies["absl::strings"] = true
      elseif string.find(line, '^%#include <boost/container/(.*)>$') ~= nil then
        dependencies["boost::headers"] = true
      elseif string.find(line, '^%#include <sparsehash/(.*)>$') ~= nil then
        dependencies["sparsehash::sparsehash"] = true
      elseif line == '#include "ht_test_helpers/gmock.h' then
        dependencies["ht_gmock"] = true
      end
    end
  end

  for file, _ in pairs(all_target_files) do
    if file ~= nil then 
      local file_path = Path:new(file)
      if file_path:exists() then 
        for line in file_path:iter() do
          get_dependency_from_line(line)
        end
      end
    end
  end
  dependencies["ht_test"] = nil
  local sorted_deps = {}
  for k, _ in pairs(dependencies) do
    table.insert(sorted_deps, "    " .. k)
  end
  table.sort(sorted_deps)
  print("Updating target", spec.target_name, "in", tostring(spec.cmake_file:make_relative(root_dir)))
  local new_cmake_content = table.concat(
    {
      table.concat(cmake_lines, "\n", 1, spec.dependencies.first), 
      table.concat(sorted_deps, "\n"),
      table.concat(cmake_lines, "\n", spec.dependencies.last)
    }, 
    "\n"
  )
  Path:new(spec.cmake_file):write(new_cmake_content, "w", 420) -- mode: 644
end

vim.keymap.set("n", "<leader>uc", update_dependencies, {})
