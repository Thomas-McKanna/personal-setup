# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#########################################################################
# Manual Additions
#########################################################################

export GOPATH="$HOME/go/bin"
export PATH="$PATH:$GOPATH"

# Needed for Ansible to work on MacOS
# See https://github.com/ansible/ansible/issues/32499
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Needed for enabling symlinks in Terragrunt
export TERRAGRUNT_EXPERIMENT_MODE=true

alias sb="sam build"
alias sd="sam deploy"
alias d="deactivate"
alias rz="omz reload" # Reload Zsh profile
alias ez="vim ~/.zshrc"
alias kc="kubectl"
alias tf="terraform"
alias ga="git add ."
alias gc="git commit"
alias g="git add . && git commit"
alias px="chmod +x"
alias gci="aws sts get-caller-identity"
alias myip="curl -s -4 http://ifconfig.me | pbcopy; echo 'IP copied to clipboard'"
alias git-clone-personal="git clone git@github.com:Thomas-McKanna/$1.git"
alias tf_wipe_local_files='find . \( -name ".terraform" -o -name ".terraform.lock.hcl" -o -name "backend.tf" -o -name "provider.tf" -o -name ".terragrunt-cache" \) -exec rm -rf {} +'

# Kubernetes related aliases and variables
alias k=kubectl
export do='--dry-run=clienti -o yaml'
export now="--force --grace-period 0"

function sp() {
    export AWS_PROFILE=$1
}

function lp() {
    aws sso login --profile=$1
    sp $1
}

function s() {
    default_region=$(aws configure get region)
    region=${1:-$default_region}
    sam build && sam deploy --no-confirm-changeset --region=${region}
}

# Open VS Code
function c () {
    if [ -z "$1" ]; then
        code .
    else
        code "$(zoxide query $1)"
    fi
}

function v {
    if [[ ! -d venv ]]; then
        py -m venv venv
    fi
    source venv/bin/activate
}

# Function to load Aider with a local model. Prompts user to select a model from
# LM Studio dynamically.
function alms {
    # Query the list of models from the localhost endpoint
    response=$(curl -s http://127.0.0.1:1234/v1/models/)

    # Check if the response is empty or there's an error
    if [[ -z "$response" ]]; then
        echo "Error: Unable to fetch models from localhost:1234."
        return 1
    fi

    # Parse the JSON response to extract model IDs
    models=("${(@f)$(echo "$response" | jq -r '.data[].id')}")
    if [[ ${#models[@]} -eq 0 ]]; then
        echo "No models found in the response."
        return 1
    fi

    # Display the models as a numbered list
    echo "Available models:"
    integer i
    for ((i=1; i<=${#models[@]}; i++)); do
        echo "$i. ${models[$i]}"
    done

    # Prompt the user to select a model
    echo -n "Select a model (1-${#models[@]}): "
    read -r selection

    # Validate the user's selection
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || (( selection < 1 || selection > ${#models[@]} )); then
        echo "Invalid selection. Please choose a number between 1 and ${#models[@]}."
        return 1
    fi

    # Get the selected model
    selected_model=${models[$((selection - 1))]}

    # Pass the selected model to the `a` alias
    a --model "lm_studio/$selected_model" --no-show-model-warnings
}

