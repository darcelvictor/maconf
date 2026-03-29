#####################################
#          ZSH COMPLETIONS          #
#####################################

# Custom function autoload
fpath=(~/.zsh_func $fpath)
autoload -U $fpath[1]/*(.:t)

# Docker CLI completions
fpath=(/Users/darcel-batier_v/.docker/completions $fpath)

# Cached compinit — only regenerates once per day (speeds up startup by ~100ms)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi


#####################################
#           ZSH OPTIONS             #
#####################################

# Ignore commands that start with a space (don't add to history)
setopt HIST_IGNORE_SPACE


#####################################
#        ENVIRONMENT VARIABLES      #
#####################################

# Homebrew
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Podman / Docker socket
DOCKER_HOST='unix:///var/folders/gw/9m9mrs6d4397bvycnkw_m4vr0000gq/T/podman/podman-machine-default-api.sock'

# Node TLS (disabled for internal corporate certs)
export NODE_TLS_REJECT_UNAUTHORIZED=false


#####################################
#              NVM                  #
# Lazy-loaded — saves 300-400ms on  #
# every shell open. nvm/node/npm/   #
# npx initialize on first call.     #
#####################################

export NVM_DIR="$HOME/.nvm"

_nvm_load() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

nvm()  { _nvm_load; nvm "$@"; }
node() { _nvm_load; command node "$@"; }
npm()  { _nvm_load; command npm "$@"; }
npx()  { _nvm_load; command npx "$@"; }


#####################################
#          CLAUDE API KEYS          #
#####################################

# Reads key from macOS Keychain (never hardcoded)
# To update: security add-generic-password -a 'victor' -s 'claude-api-key' -w '<new-key>' -U
ANTHROPIC_AUTH_TOKEN=$(security find-generic-password -a victor -s claude-api-key -w 2>/dev/null)
if [[ -n "$ANTHROPIC_AUTH_TOKEN" ]]; then
  export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-6'
  export ANTHROPIC_DEFAULT_SONNET_MODEL='claude-sonnet-4-6'
  export ANTHROPIC_DEFAULT_HAIKU_MODEL='claude-haiku-4-5'
  export ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_AUTH_TOKEN
  export ANTHROPIC_BASE_URL='https://litellm-dev.hors-prod.caas.lcl.gca'
  export NODE_TLS_REJECT_UNAUTHORIZED='0'
  export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
fi


#####################################
#             ALIASES               #
#####################################

# Editor
alias c="code ."

# Modern ls (eza) — falls back gracefully if not installed
if command -v eza &>/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --group-directories-first --git"
  alias la="eza -a --icons --group-directories-first"
  alias tree="eza --tree --icons --level=3"
fi

# Modern cat (bat) — syntax-highlighted file viewing
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
fi

# Git shortcuts
alias ga='git add'
alias gp='git push'
alias gs='git status'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gpl='git pull'
alias gcd='git checkout development'
alias gcm='git checkout main'


#####################################
#           ZSH PLUGINS             #
#####################################

# Fish-style inline history suggestions (accept with →)
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (valid = green, invalid = red)
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#####################################
#         MODERN CLI TOOLS          #
#####################################

# zoxide — smarter cd (learns your most-used dirs, jump with `z <partial>`)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# fzf — fuzzy finder (Ctrl+R: history, Ctrl+T: files, Alt+C: directories)
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

#####################################
#        STARSHIP PROMPT            #
# Must be last — wraps the prompt   #
# after all other setup is done.    #
#####################################

eval "$(starship init zsh)"
