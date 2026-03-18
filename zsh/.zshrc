# -----------------------------------------------------------------------------
# 1. Core Environment
# -----------------------------------------------------------------------------
export POETRY_HOME="$HOME/.poetry"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export DBT_PRODUCT_PATH="$HOME/Documents/1_Projects/product"
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export HIDE_STACK_TRACE=1
export WORKON_HOME="$HOME/Envs"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${ZDOTDIR:-$HOME}/.cache}"
export PIPX_HOME="$HOME/.local/pipx"
export PIPX_BIN_DIR="$HOME/.local/bin"

typeset -g ZDOT_ROOT="${ZDOTDIR:-$HOME}"
typeset -g HOMEBREW_PREFIX=""
typeset -g ZSH="$HOME/.oh-my-zsh"
typeset -g ZSH_THEME="${ZSH_THEME:-powerlevel9k/powerlevel9k}"
typeset -g ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$XDG_CACHE_HOME/oh-my-zsh}"
typeset -g ZSH_COMPDUMP="$ZDOT_ROOT/.zcompdump"
typeset -g ZSH_COMPLETIONS_DIR="$ZDOT_ROOT/.zfunc"
typeset -g ZSH_DISABLE_COMPFIX=true

if [[ -d /opt/homebrew ]]; then
  HOMEBREW_PREFIX=/opt/homebrew
elif [[ -d /usr/local ]]; then
  HOMEBREW_PREFIX=/usr/local
elif (( $+commands[brew] )); then
  HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null)"
fi

typeset -U path fpath
path=(
  "$HOME/.cargo/bin"
  "$PYENV_ROOT/bin"
  "$PIPX_BIN_DIR"
  "$HOME/.local/bin"
  "$HOME/go/bin"
  /usr/local/go/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /usr/local/bin
  /usr/local/sbin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/homebrew/opt/sphinx-doc/bin
)

[[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/share/zsh-completions" ]] && \
  fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
[[ -d "$ZSH_COMPLETIONS_DIR" ]] && fpath=("$ZSH_COMPLETIONS_DIR" $fpath)

# -----------------------------------------------------------------------------
# 2. Helpers
# -----------------------------------------------------------------------------
is_tty_session() {
  [[ -o interactive && -t 0 && -t 1 ]]
}

source_if_exists() {
  [[ -r "$1" ]] && source "$@"
}

with_mysql_libs() {
  local mysql_lib_dir="/usr/local/mysql/lib"
  if [[ -d "$mysql_lib_dir" ]]; then
    DYLD_LIBRARY_PATH="$mysql_lib_dir${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}" "$@"
  else
    "$@"
  fi
}

prepend_path_if_dir() {
  [[ -d "$1" ]] && path=("$1" $path)
}

lazy_wrap_commands() {
  local loader="$1"
  shift

  local cmd
  for cmd in "$@"; do
    eval "
${cmd}() {
  unfunction ${cmd}
  ${loader} || return \$?
  ${cmd} \"\$@\"
}
"
  done
}

poetry_completion_setup() {
  (( $+commands[poetry] )) || return

  local completion_file="$ZSH_COMPLETIONS_DIR/_poetry"

  [[ -d "$ZSH_COMPLETIONS_DIR" ]] || mkdir -p "$ZSH_COMPLETIONS_DIR"
  fpath=("$ZSH_COMPLETIONS_DIR" $fpath)

  if [[ ! -f "$completion_file" || "${commands[poetry]}" -nt "$completion_file" ]]; then
    poetry completions zsh >| "$completion_file" 2>/dev/null || return
  fi
}

poetry_autoenter() {
  [[ -o interactive ]] || return
  [[ "${POETRY_AUTO:-1}" != "0" ]] || return
  (( $+commands[poetry] )) || return
  [[ -f "$PWD/pyproject.toml" ]] || return
  [[ -n "$VIRTUAL_ENV" || -n "$POETRY_ACTIVE" ]] && return

  if [[ "$PWD" == "$LAST_POETRY_DIR" ]]; then
    return
  fi
  typeset -g LAST_POETRY_DIR="$PWD"

  local activate_cmd=""
  activate_cmd="$(poetry env activate 2>/dev/null)" || activate_cmd=""
  if [[ -n "$activate_cmd" ]]; then
    print -r -- "Activating Poetry environment for ${PWD:t}"
    eval "$activate_cmd"
    return
  fi

  print -r -- "Entering Poetry shell for ${PWD:t}"
  poetry shell
}

load_nvm() {
  (( ${+_lazy_nvm_loaded} )) && return 0
  typeset -g _lazy_nvm_loaded=1

  source_if_exists "$NVM_DIR/nvm.sh" --no-use || return 1
  source_if_exists "$NVM_DIR/bash_completion"
}

load_nvm_runtime() {
  load_nvm || return $?

  if (( ! $+commands[node] )) && (( $+functions[nvm] )); then
    nvm use --silent default >/dev/null 2>&1 || nvm use --silent >/dev/null 2>&1 || true
  fi
}

load_virtualenvwrapper() {
  (( ${+_lazy_virtualenvwrapper_loaded} )) && return 0
  typeset -g _lazy_virtualenvwrapper_loaded=1

  (( $+commands[virtualenvwrapper.sh] )) || return 1
  source "${commands[virtualenvwrapper.sh]}"
}

load_yandex_cloud_support() {
  (( ${+_lazy_yandex_cloud_loaded} )) && return 0
  typeset -g _lazy_yandex_cloud_loaded=1

  source_if_exists "$HOME/yandex-cloud/completion.zsh.inc"
}

load_google_cloud_support() {
  (( ${+_lazy_google_cloud_loaded} )) && return 0
  typeset -g _lazy_google_cloud_loaded=1

  source_if_exists "$HOME/google-cloud-sdk/completion.zsh.inc"
}

# -----------------------------------------------------------------------------
# 3. Completion Setup
# -----------------------------------------------------------------------------
zstyle ':completion:*' menu select
poetry_completion_setup

# -----------------------------------------------------------------------------
# 4. Prompt and Framework
# -----------------------------------------------------------------------------
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"

typeset -g user_symbol='$'
[[ $(print -P "%#") == "#" ]] && user_symbol='#'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit -d "$ZSH_COMPDUMP"
fi

# -----------------------------------------------------------------------------
# 5. Language Managers and Tooling
# -----------------------------------------------------------------------------
if (( $+commands[virtualenvwrapper.sh] )); then
  lazy_wrap_commands load_virtualenvwrapper \
    add2virtualenv allvirtualenv cdproject cdsitepackages cdvirtualenv cpvirtualenv \
    lssitepackages lsvirtualenv mkproject mktmpenv mkvirtualenv rmvirtualenv \
    setvirtualenvproject showvirtualenv toggleglobalsitepackages wipeenv workon
fi

prepend_path_if_dir "$HOME/yandex-cloud/bin"
prepend_path_if_dir "$HOME/google-cloud-sdk/bin"
(( $+commands[yc] )) && lazy_wrap_commands load_yandex_cloud_support yc
(( $+commands[gcloud] )) && lazy_wrap_commands load_google_cloud_support gcloud
(( $+commands[gsutil] )) && lazy_wrap_commands load_google_cloud_support gsutil
(( $+commands[bq] )) && lazy_wrap_commands load_google_cloud_support bq

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  source_if_exists "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
  source_if_exists "$HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh"
  (( $+functions[chruby] )) && chruby ruby-3.1.3
fi

if is_tty_session; then
  source_if_exists "$HOME/.fzf.zsh"
fi

[[ -d "$NVM_DIR" ]] && lazy_wrap_commands load_nvm nvm
[[ -d "$NVM_DIR" ]] && lazy_wrap_commands load_nvm_runtime node npm npx corepack pnpm yarn

if is_tty_session && [[ -n "$HOMEBREW_PREFIX" ]]; then
  source_if_exists "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# -----------------------------------------------------------------------------
# 6. Aliases, Functions, and Hooks
# -----------------------------------------------------------------------------
if is_tty_session; then
  bindkey -s '^f' "~/.local/bin/tmux-sessionizr\n"
fi

v() {
  nvim "$@"
}

y() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if [[ -s "$tmp" ]]; then
    cd "$(cat "$tmp")"
  fi
  rm -f "$tmp"
}

[[ -f "$HOME/.keys" ]] && source "$HOME/.keys"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

autoload -Uz add-zsh-hook
typeset -g LAST_POETRY_DIR=""
add-zsh-hook chpwd poetry_autoenter
poetry_autoenter

if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd cd zsh)"
fi
