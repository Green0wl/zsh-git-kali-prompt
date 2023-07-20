# To install source this file from your .zshrc file

# see documentation at http://linux.die.net/man/1/zshexpn
# A: finds the absolute path, even if this is symlinked
# h: equivalent to dirname
export __GIT_PROMPT_DIR=${0:A:h}

export GIT_PROMPT_EXECUTABLE=${GIT_PROMPT_EXECUTABLE:-"python3"}

# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook

add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

## Function definitions
function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

function chpwd_update_git_vars() {
    update_current_git_vars
}

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    if [[ "$GIT_PROMPT_EXECUTABLE" == "python3" ]]; then
        local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
        _GIT_STATUS=`python3 ${gitstatus} 2>/dev/null`
    fi
     __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
	GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
	GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
	GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
	GIT_STAGED=$__CURRENT_GIT_STATUS[4]
	GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
	GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
	GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
	GIT_DELETED=$__CURRENT_GIT_STATUS[8]
}


git_super_status() {
	precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"
	  if [ "$GIT_BEHIND" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND\e[0m"
	  fi
	  if [ "$GIT_AHEAD" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD\e[0m"
	  fi
	  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED\e[0m"
	  fi
	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS\e[1m"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_MODIFIED$GIT_CHANGED\e[0m"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED\e[0m"
	  fi
	  if [ "$GIT_DELETED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DELETED$GIT_DELETED\e[0m"
	  fi
	  if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ] && [ "$GIT_DELETED" -eq "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
	  fi

	  STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
	  echo "$STATUS"
	fi
} 

# Default values for the appearance of the prompt. Configure at will.
ZSH_THEME_GIT_PROMPT_PREFIX="-["
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{%(#.blue.green)}]"
ZSH_THEME_GIT_PROMPT_SEPARATOR="%b\e[0m%F{%(#.blue.green)} | %f"
ZSH_THEME_GIT_PROMPT_BRANCH="%B\e[38;2;236;195;11m"
ZSH_THEME_GIT_PROMPT_STAGED="\e[38;5;82m+"
ZSH_THEME_GIT_PROMPT_CONFLICTS="\e[38;5;196;1m!"
ZSH_THEME_GIT_PROMPT_MODIFIED="\e[38;5;222m*"
ZSH_THEME_GIT_PROMPT_BEHIND="\e[38;5;202m<"
ZSH_THEME_GIT_PROMPT_AHEAD="\e[38;5;123m>"
ZSH_THEME_GIT_PROMPT_UNTRACKED="\e[38;5;197m?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{-%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="\e[38;5;139mD"
