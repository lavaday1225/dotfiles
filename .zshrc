# ==========================================
# 1. Powerlevel10k Instant Prompt
# ==========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==========================================
# 2. Oh My Zsh Configuration
# ==========================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ==========================================
# 3. Environment Variables & Security
# ==========================================
export EDITOR='nvim'
export GPG_TTY=$(tty)
export GOPRIVATE="github.com/MobilityTechnologies/*"

# ==========================================
# 4. PATH Adjustments (Portable)
# ==========================================
typeset -U path

path=(
  /opt/homebrew/opt/mysql@8.0/bin
  /opt/homebrew/opt/openssl@3/bin
  /opt/homebrew/opt/icu4c/bin
  /opt/homebrew/opt/gdal/bin
  $HOME/.pub-cache/bin
  $HOME/go/bin
  $HOME/development/flutter/bin
  $HOME/Library/Android/sdk/platform-tools
  $path
)
export PATH

# Compiler Flags
export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/gdal/lib"
export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/gdal/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig:/opt/homebrew/opt/gdal/lib/pkgconfig"

# ==========================================
# 5. Tool Initializations
# ==========================================

# asdf
[[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] && . /opt/homebrew/opt/asdf/libexec/asdf.sh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Google Cloud SDK
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# direnv
eval "$(direnv hook zsh)"

# ==========================================
# 6. Aliases & Functions
# ==========================================
alias ssh-bastion='ssh -A -t gateway -- ssh -t bastion -- sudo su - tfsys'

fcd() {
  local dir
  dir=$(find ${1:-.} -type d -not -path '*/\.*' 2> /dev/null | fzf +m) && cd "$dir"
}

# ==========================================
# 7. Final Theming
# ==========================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Bash completions bridge
if [ -d ~/.local/share/bash-completion/completions ]; then
  for completion in ~/.local/share/bash-completion/completions/*; do
    [ -r "$completion" ] && . "$completion"
  done
fi
