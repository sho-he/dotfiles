for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
  ~/go/bin
)

# use reguler expression without escape
setopt nonomatch

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -Uz compinit && compinit
fi

eval "$(rbenv init - zsh)"

[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"

# set up go
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# set pyenv path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# import git-prompt
source ~/.zsh/git-prompt.sh

# inport git-completion
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# setup prompt option
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

setopt PROMPT_SUBST ; PS1='%n@%m%f: %~%f $(__git_ps1 )%f\$ '

eval "$(direnv hook zsh)"

# set up git alias
alias g='git'
alias gst='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git pull'
alias gup='git pull --rebase'
alias gp='git push'
alias gd='git diff'
alias gc='git checkout'
export GOPATH=~/go
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#set up docker compose alias
alias d='docker'
alias dc='docker compose'
alias dce='docker compose exec'
alias dct='docker compose exec web yarn test'
alias dcl='docker compose exec web yarn lint --fix'
alias dcr='docker compose exec web bundle exec rspec'
alias eslint='yarn lint --fix'


function aws-sso-login() {
  # get aws profiles
  local profiles=($(aws configure list-profiles))

  if [[ ${#profiles[@]} -eq 0 ]]; then
    echo "Cannot find profiles. Please exec 'aws configure'"
    return 1
  fi
  echo "Select Profile:"
  select profile in "${profiles[@]}"; do
    [[ -n "$profile" ]] && break
    echo "Input valid number"
  done

  aws sso login --profile "$profile"
  export AWS_PROFILE="$profile"
  echo "AWS_PROFILE=$AWS_PROFILE"
}

function claude-set() {
  # select Claude model
  local models=(
    "us.anthropic.claude-opus-4-20250514-v1:0" 
    "anthropic.claude-sonnet-4-20250514-v1:0"
    "anthropic.claude-3-5-sonnet-20240620-v1:0"
    "anthropic.claude-3-5-sonnet-20241022-v2:0"
  )

  echo "Select model: "
  select model in "${models[@]}"; do
    [[ -n "$model" ]] && break
    echo "input valid number"
  done

  export AWS_PROFILE="developer"
  export ANTHROPIC_MODEL="$model"
  export AWS_REGION=us-west-2
  export CLAUDE_CODE_USE_BEDROCK=1
  export CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096

  echo "AWS_PROFILE=$AWS_PROFILE"
  echo "ANTHROPIC_MODEL=$ANTHROPIC_MODEL"
  claude
}

