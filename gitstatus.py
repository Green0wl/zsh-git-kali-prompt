#!/usr/bin/env python
from __future__ import print_function
from subprocess import Popen, PIPE

# change this symbol to whatever you prefer
prehash = ':'

# checking if i am inside git work tree.
# git rev-parse --is-inside-work-tree
gitsym = Popen(['git', 'rev-parse', '--is-inside-work-tree'], stdout=PIPE, stderr=PIPE)
error = gitsym.communicate()[1]

# code 128: git did not exit cleanly (exit code 128).
# in this case, it means that there is no ".git" directory.
if (gitsym.returncode == 128):
	gitsym.kill()
	exit(1)

error_string = error.decode('utf-8')
if 'fatal: Not a git repository' in error_string: 
    gitsym.kill()
    exit(1)

res, err = Popen(['git','diff','--name-status'], stdout=PIPE, stderr=PIPE).communicate()
err_string = err.decode('utf-8')
if 'fatal' in err_string: 
        gitsym.kill()   
        exit(1)

# get name of current branch
# git rev-parse --abbrev-ref HEAD
branch = Popen(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], stdout=PIPE).communicate()[0].decode().strip()

# gets number of staged files
# git diff --cached --numstat | wc -l
staged = len(Popen(['git', 'diff', '--cached', '--numstat'], stdout=PIPE).communicate()[0].decode().strip().splitlines())

# gets number of conflicts
# git --no-pager diff --name-only --diff-filter=U | wc -l 
conflicts = len(Popen(['git', '--no-pager', 'diff', '--name-only', '--diff-filter=U'], stdout=PIPE).communicate()[0].decode().strip().splitlines())

# gets number of modified files
# git --no-pager diff --name-only --diff-filter=M | wc -l
modified = len(Popen(['git', '--no-pager', 'diff', '--name-only', '--diff-filter=M'], stdout=PIPE).communicate()[0].decode().strip().splitlines())

# gets number of untracked files
# git ls-files --others --exclude-standard | wc -l
untracked = len(Popen(['git', 'ls-files', '--others', '--exclude-standard'], stdout=PIPE).communicate()[0].decode().strip().splitlines())

# gets number of deleted files
# git --no-pager diff --name-only --diff-filter=D | wc -l
deleted = len(Popen(['git', '--no-pager', 'diff', '--name-only', '--diff-filter=D'], stdout=PIPE).communicate()[0].decode().strip().splitlines())

ahead, behind = 0,0

if not branch: # not on any branch
	branch = prehash + Popen(['git','rev-parse','--short','HEAD'], stdout=PIPE).communicate()[0].decode("utf-8")[:-1]
else:
	remote_name = Popen(['git','config','branch.%s.remote' % branch], stdout=PIPE).communicate()[0].decode("utf-8").strip()
	if remote_name:
		merge_name = Popen(['git','config','branch.%s.merge' % branch], stdout=PIPE).communicate()[0].decode("utf-8").strip()
		if remote_name == '.': # local
			remote_ref = merge_name
		else:
			remote_ref = 'refs/remotes/%s/%s' % (remote_name, merge_name[11:])
		revgit = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % remote_ref],stdout=PIPE, stderr=PIPE)
		revlist = revgit.communicate()[0]
		if revgit.poll(): # fallback to local
			revlist = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % merge_name],stdout=PIPE, stderr=PIPE).communicate()[0]
		behead = revlist.decode("utf-8").splitlines()
		ahead = len([x for x in behead if x[0]=='>'])
		behind = len(behead) - ahead

out = ' '.join([
	branch,
	str(ahead),
	str(behind),
	str(staged),
	str(conflicts),
	str(modified),
	str(untracked),
	str(deleted)
	])
print(out, end='')

