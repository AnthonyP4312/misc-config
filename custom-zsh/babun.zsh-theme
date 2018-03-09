local return_code="%(?..%{$FG[196]%}%? %{$reset_color%})"

PROMPT='%{$FG[014]%}{ %c } \
%{$FG[010]%}$(  git rev-parse --abbrev-ref HEAD 2> /dev/null || echo ""  )%{$reset_color%} \
%{$FG[009]%}%(!.#.»)%{$reset_color%} '

PROMPT2='%{$FG[014]%}\ %{$reset_color%}'

RPS1='%{$FG[014]%}%~%{$reset_color%} ${return_code} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}:: %{$FG[010]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[010]%}*%{$FG[010]%}"
