export PATH=/Users/vladimir/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/vladimir/.local/bin:/usr/local/sbin:/opt/homebrew/sbin:/usr/local/go/bin
export PATH="$PATH:$HOME/go/bin"
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export DBT_PRODUCT_PATH=/Users/vladimir/Documents/1_Projects/product
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export HIDE_STACK_TRACE=1
export WORKON_HOME=~/Envs
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel9k/powerlevel9k"
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
export POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
# Visual customisation of the second prompt line
#

local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
export POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"
export PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%1~%f%b %# '
alias poet="source $(poetry env info --path)/bin/activate"
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source virtualenvwrapper.sh
source ~/Documents/config/.dbt-completion.bash
source ~/.keys

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi




test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/opt/homebrew/opt/sphinx-doc/bin:$PATH"

zstyle ':completion:*' menu select
fpath+=~/.zfunc

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/Users/vladimir/yandex-cloud/path.bash.inc' ]; then source '/Users/vladimir/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/Users/vladimir/yandex-cloud/completion.zsh.inc' ]; then source '/Users/vladimir/yandex-cloud/completion.zsh.inc'; fi

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3 # run chruby to see actual version

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(zoxide init --cmd cd zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vladimir/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vladimir/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vladimir/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vladimir/google-cloud-sdk/completion.zsh.inc'; fi
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -s ^f "~/.local/bin/tmux-sessionizr\n"

function v() {
	nvim "$@"
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

