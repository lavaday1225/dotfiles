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

export PATH=$PATH:~/bin

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

# lazygit
alias lg='lazygit'

# ghq
# Custom ghq function to auto-expand MobilityTechnologies repo
ghqc() {
  ghq clone "https://github.com/MobilityTechnologies/$1.git"
}

# Function to sync AWS SSO credentials into the lbox environment
lboxstart() {
    local PROFILE="mot-sandbox-software-dev-aws_llm-trial-emp-ro"
    local CRED_FILE="$HOME/.llm-aws-credentials"

    echo "🔑 [lbox] Initiating AWS SSO Login..."
    aws sso login --profile "$PROFILE"

    # Check if login was successful before proceeding
    if [ $? -eq 0 ]; then
        echo "📤 [lbox] Exporting credentials to $CRED_FILE"
        aws configure export-credentials --profile "$PROFILE" --format env-no-export > "$CRED_FILE"
        
        echo "🔄 [lbox] Updating container environment..."
        lbox update-env
        
        echo "🚀 [lbox] Entering sandbox..."
        lbox
    else
        echo "❌ [lbox] Login failed. Sequence aborted."
        return 1
    fi
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
eval "$(mise activate zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/syuanwei.kuo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/syuanwei.kuo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/syuanwei.kuo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/syuanwei.kuo/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# ghq
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

