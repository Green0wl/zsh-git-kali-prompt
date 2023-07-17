# Informative git prompt for zsh in Linux

[![Build Status](https://travis-ci.org/olivierverdier/zsh-git-prompt.svg)](https://travis-ci.org/olivierverdier/zsh-git-prompt)

This prompt is a specialisation of repository called "Informative git prompt for zsh" for Kali Linux, which you can find [here](https://github.com/olivierverdier/zsh-git-prompt). Thanks to its author for the idea and implementation!

A `zsh` prompt that displays information about the current git repository. In particular the branch name, difference with remote branch, number of files staged, changed, etc.

<img src="https://github.com/Green0wl/zsh-git-kali-prompt/raw/master/screenshot.png" width=300/>

## Designations
You can find all the repository state designations in the `zshrc.sh` file by copying the repository. Here they are:
```
# Default values for the appearance of the prompt. Configure at will.
ZSH_THEME_GIT_PROMPT_PREFIX="-["
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{%(#.blue.green)}]"
ZSH_THEME_GIT_PROMPT_SEPARATOR="%b\e[0m%B\e[38;2;247;174;248m:\e[0m" 				# \e[0;37;1m \e[1m (old)
ZSH_THEME_GIT_PROMPT_BRANCH="%B\e[38;2;247;174;248m" 						# \e[38;5;216;1m (old)
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{!%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{*%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{<%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{>%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{U%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{-%G%}"
```

## Install

1.  Clone this repository somewhere on your hard drive.
2.  Source the file `zshrc.sh` from your `~/.zshrc` config file, and
    configure your prompt. So, somewhere (might be in the end of the file) in `~/.zshrc`, you should have:

    ```sh
    # zsh git prompt setup.
    source $HOME/zsh-git-prompt/zshrc.sh
    prompt_symbol=㉿
    git_prompt_injection_string='$(git_super_status)'

    # standard twoline linux prompt.
    # can be found in this script above.
    # PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '

    # injecting git prompt.
    PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]'$git_prompt_injection_string$'\n%F{%(#.blue.green)}└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
    ```
3.  Go in a git repository and test it! This only works if you are in a repository.

```bash
	  # if there is name of branch in current directory.
	  # I mean this name is not ":".
	  if [ "${STATUS:24:1}" = ":" ]; then
		echo ""
	  else
		echo "$STATUS"
	  fi
```

### Haskell (optional)

There is now a Haskell implementation as well, which can be four to six times faster than the Python one. The reason is not that Haskell is faster in itself (although it is), but that this implementation calls `git` only once. To install, do the following:

1.  Make sure [Haskell's stack](http://docs.haskellstack.org/en/stable/README.html#how-to-install) is installed on your system
2.  `cd` to this folder
2.  Run `stack setup` to install the Haskell compiler, if it is not already there
3.  Run `stack build && stack install` (don't worry, the executable is only “installed” in this folder, not on your system)
4.  Define the variable `GIT_PROMPT_EXECUTABLE="haskell"` somewhere in
    your `.zshrc`

## Customisation

- You may redefine the function `git_super_status` (after the `source` statement) to adapt it to your needs (to change the order in which the information is displayed).
- Define the variable `ZSH_THEME_GIT_PROMPT_CACHE` in order to enable caching.
- You may also change a number of variables (which name start with `ZSH_THEME_GIT_PROMPT_`) to change the appearance of the prompt.  Take a look in the file `zshrc.sh` to see how the function `git_super_status` is defined, and what variables are available.

**Enjoy!**

  [blog post]: http://sebastiancelis.com/2009/nov/16/zsh-prompt-git-users/
  
