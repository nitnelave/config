#!/opt/venvs/platform/bin/python
'''
If several stacked branches need to rebase,
this binary can push all of them at once,
to avoid cluttering PRs with conflicts
and unrelated commits.
'''

import os
import pwd
import sys
start, stop = [*sys.argv[1:], None, None][:2]

def run(cmd):
    return os.popen(cmd).read()

stop = stop or 'HEAD'
start = start or run(f'git merge-base origin/master {stop}').strip()

username = pwd.getpwuid(os.getuid()).pw_name

def branch_name_from_line(line):
    hash_, type_, ref = line.split()
    assert len(hash_) == 40
    assert type_ == 'commit', type_

    remote_branch_prefix = 'refs/remotes/origin/'
    if ref.startswith(remote_branch_prefix):
        return None

    local_branch_prefix = 'refs/heads/'
    assert ref.startswith(f'{local_branch_prefix}{username}/'), ref
    return ref[len(local_branch_prefix):]

branches = [branch
            for branch in
            map(branch_name_from_line, run(f'git rev-list {start}...{stop} | xargs -i git for-each-ref --points-at {{}}').splitlines())
            if branch is not None]

print('Pushing branches:')
for branch in branches:
    print(f'    {branch}')

assert input('confirm? (y/N)').lower() == 'y'

print(run(f'git push -f origin {" ".join(branches)}'), end='')
