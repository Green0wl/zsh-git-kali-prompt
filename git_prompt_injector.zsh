#!/bin/zsh -i

source $HOME/zsh-git-kali-prompt/zsh-git-kali-prompt.zsh

git_prompt_injection_string='$(git_super_status)'
prompt_value=$(echo "$PROMPT")

if [[ $prompt_value =~ '^(.*)'$'\n''(.*)$' ]]; then 
  PROMPT=${match[1]}$git_prompt_injection_string$'\n'${match[2]}
fi
