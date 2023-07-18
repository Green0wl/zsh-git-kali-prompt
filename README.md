# Informative git prompt for zsh in Linux

[![Build Status](https://travis-ci.org/olivierverdier/zsh-git-prompt.svg)](https://travis-ci.org/olivierverdier/zsh-git-prompt)

This prompt is a specialisation of repository called "Informative git prompt for zsh" for Kali Linux, which you can find [here](https://github.com/olivierverdier/zsh-git-prompt). Thanks to its author for the idea and implementation!

A `zsh` prompt that displays information about the current git repository. In particular the branch name, difference with remote branch, number of files staged, changed, etc.

<img src="https://raw.githubusercontent.com/Green0wl/zsh-git-kali-prompt/main/screenshot.png" width="auto"/>

## Designations
You can find all the repository state designations in the `zshrc.sh` file by copying the repository.

## Install

1.  Clone this repository to the $HOME directory or some other location (I'll do it in $HOME, and use that as the path in the future).
2.  Source the file `zshrc.sh` from your `~/.zshrc` config file, and
    configure your prompt. So, somewhere (might be in the end of the file) in `~/.zshrc`, you should have:

    ```sh
    # zsh git prompt setup.
    source $HOME/zsh-git-kali-prompt/git_prompt_injector.sh
    ```
3.  Restart the console, or write the `zsh` command to start a new session with the applied changes to the `~/.zshrc` settings. 
4.  Go in a git repository and test it! This only works if you are in a repository.

## Customisation

- You may redefine the function `git_super_status` (after the `source` statement) to adapt it to your needs (to change the order in which the information is displayed).
- Define the variable `ZSH_THEME_GIT_PROMPT_CACHE` in order to enable caching.
- You may also change a number of variables (which name start with `ZSH_THEME_GIT_PROMPT_`) to change the appearance of the prompt.  Take a look in the file `zshrc.sh` to see how the function `git_super_status` is defined, and what variables are available.
