local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'OneHalfDark'
config.font = wezterm.font 'RobotoMono Nerd Font'
config.enable_tab_bar = false
config.scrollback_lines = 100000

config.keys = {
  {
    key = 'f',
    mods = 'CMD',
    action = wezterm.action.Search { CaseInSensitiveString = "" },
  },
  {
    key = 'f',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.Search { CaseInSensitiveString = "" },
  },
}


return config
