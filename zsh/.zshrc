# -----------------------------------------------------------------------------
# 1. PATH Configuration
# -----------------------------------------------------------------------------
# Ensure unique entries and let Zsh auto-export PATH
typeset -U path
path=(
  $HOME/.cargo/bin
  /opt/homebrew/bin           # Homebrew on Apple Silicon
  /usr/local/bin              # (Intel & some tools)
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $HOME/.local/bin
  /usr/local/sbin
  /opt/homebrew/sbin
  /usr/local/go/bin
	$HOME/.local/pipx
  $HOME/go/bin                # Go workspace
  /opt/homebrew/opt/sphinx-doc/bin
)


# -----------------------------------------------------------------------------
# 2. Environment Variables
# -----------------------------------------------------------------------------
export POETRY_HOME="$HOME/.poetry"                     # Poetry installer
export DYLD_LIBRARY_PATH="/usr/local/mysql/lib"        # MySQL on macOS
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES         # Fix for Python multiprocessing on macOS
export DBT_PRODUCT_PATH="$HOME/Documents/1_Projects/product"
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export HIDE_STACK_TRACE=1                               # Custom debug flag
export WORKON_HOME="$HOME/Envs"                         # virtualenvwrapper dir
export PYENV_ROOT="$HOME/.pyenv"                        # pyenv installs
export NVM_DIR="$HOME/.nvm"                             # nvm installs
export XDG_CONFIG_HOME="$HOME/.config"
export PIPX_HOME="$HOME/.local/pipx"
export PIPX_BIN_DIR="$HOME/.local/bin"

# -----------------------------------------------------------------------------
# 3. Oh My Zsh & Prompt Theme
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel9k/powerlevel9k"                   # consider upgrading to powerlevel10k

# Prompt elements
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"

# Detect if root to adjust prompt symbol
user_symbol='$'
if [[ $(print -P "%#") == "#" ]]; then
  user_symbol='#'
fi

POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"
PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%1~%f%b %# '



# -----------------------------------------------------------------------------
# 5. Python Virtual Environments
# -----------------------------------------------------------------------------
# virtualenvwrapper
source virtualenvwrapper.sh

# pyenv shim (ensure before PATH modifications if using `pyenv global`)
if [[ -d "$PYENV_ROOT/bin" ]]; then
  path=($PYENV_ROOT/bin $path)
fi


# -----------------------------------------------------------------------------
# 6. Cloud SDKs & CLIs
# -----------------------------------------------------------------------------
# Yandex Cloud
[[ -f "$HOME/yandex-cloud/path.bash.inc" ]]       && source "$HOME/yandex-cloud/path.bash.inc"
[[ -f "$HOME/yandex-cloud/completion.zsh.inc" ]]   && source "$HOME/yandex-cloud/completion.zsh.inc"

# Google Cloud SDK
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]    && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"


# -----------------------------------------------------------------------------
# 7. Ruby via chruby
# -----------------------------------------------------------------------------
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3                                    # pin default Ruby version


# -----------------------------------------------------------------------------
# 8. Utilities & Plugins
# -----------------------------------------------------------------------------
# fzf fuzzy finder
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# zoxide quick directory jumper
eval "$(zoxide init --cmd cd zsh)"

# nvm (Node Version Manager)
[[ -s "$NVM_DIR/nvm.sh" ]]     && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

eval "$(direnv hook zsh)"

# -----------------------------------------------------------------------------
# 9. Aliases & Functions
# -----------------------------------------------------------------------------
# Tmux session launcher
bindkey -s '^f' "~/.local/bin/tmux-sessionizr\n"

# Quick edit with Neovim
v() { nvim "$@"; }

# Yazi workspace-aware navigation
y() {
  local tmp=$(mktemp -t yazi-cwd.XXXXXX)
  yazi "$@" --cwd-file="$tmp"
  if [[ -s "$tmp" ]]; then
    cd "$(cat "$tmp")"
  fi
  rm -f "$tmp"
}

# Load any additional secrets or keys (be cautious!)
[[ -f ~/.keys ]] && source ~/.keys

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."



# -----------------------------------------------------------------------------
# COMPLETIONS: FINAL INITIALIZATION (MUST BE LAST)
# -----------------------------------------------------------------------------

# 1) Assemble fpath entries before init:
if (( $+commands[brew] )); then
  local bprefix=$(brew --prefix)
  [[ -d "$bprefix/share/zsh-completions" ]] && fpath=($bprefix/share/zsh-completions $fpath)
fi
[[ -d "$HOME/.zfunc" ]] && fpath=($HOME/.zfunc $fpath)

# 2) Initialize Zsh’s native completion system exactly once:
rm -f ~/.zcompdump*            # force fresh rebuild
autoload -Uz compinit
compinit -u                    # skip insecure-dir warnings if you’ve fixed perms

# 3) Enable Bash‐style completions under zsh (for .bash_completion scripts):
autoload -Uz bashcompinit
bashcompinit

# 4) Configure the UI:
zstyle ':completion:*' menu select

# 5) Source any completion scripts now that both compinit & bashcompinit are active:

# 5a) Poetry (Zsh function-based)
if (( $+commands[poetry] )); then
  poetry completions zsh > ~/.zfunc/_poetry
  autoload -Uz _poetry
fi


### POETRY HOOK
#
#
# --- Auto-enter Poetry shell when in a folder with pyproject.toml ---
# Works on: cd, new shells (including new tmux windows), and first prompt.
# --- Auto-enter Poetry shell when in a folder with pyproject.toml ---
# Works on: cd and new tmux windows; avoids double entry.

autoload -Uz add-zsh-hook

# Remember last dir we attempted to enter poetry in (per shell)
typeset -g LAST_POETRY_DIR=""

_poetry_autoenter() {
  # Only in interactive shells
  [[ -o interactive ]] || return

  # Allow disabling: export POETRY_AUTO=0
  if [[ -n "$POETRY_AUTO" && "$POETRY_AUTO" == "0" ]]; then
    return
  fi

  # Poetry must exist; project must have pyproject.toml
  command -v poetry >/dev/null 2>&1 || return
  [[ -f "$PWD/pyproject.toml" ]] || return

  # If already inside any venv or poetry-managed shell — do nothing
  [[ -n "$VIRTUAL_ENV" || -n "$POETRY_ACTIVE" ]] && return

  # Debounce: if we already tried in this exact dir, skip
  if [[ "$PWD" == "$LAST_POETRY_DIR" ]]; then
    return
  fi
  typeset -g LAST_POETRY_DIR="$PWD"

  echo "📦 Entering Poetry shell for $(basename "$PWD")..."
  poetry shell
}

# Fire on directory change and before each prompt (covers tmux new windows)
add-zsh-hook chpwd _poetry_autoenter
add-zsh-hook precmd _poetry_autoenter
