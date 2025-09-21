# ------------------------------------------------------------------------------
# 1. Initialization and Plugins
# ------------------------------------------------------------------------------

# Enable command completion features
autoload -Uz compinit
compinit

# Enable shell features for history and other options
# (These can also be moved to the "History Settings" section if preferred)
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# ------------------------------------------------------------------------------
# 2. Environment Variables
# ------------------------------------------------------------------------------

# Locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History file configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

# Go (Golang) environment
export GOPATH="$HOME/go"
export GOPROXY='https://proxy.golang.org,direct'
#export GOROOT='/usr/local/go'  # Uncomment if GOROOT is needed

# Update PATH
export PATH="${PATH}:${HOME}/.krew/bin:/usr/local/bin:${BREWPATH}:${GOPATH}/bin/:${GOROOT}/bin/:${HOME}/.local/bin"

# GPG Configuration
export GPG_TTY=$(tty)

# Editor Configuration
export EDITOR="/usr/bin/nvim"
export KUBE_EDITOR="/usr/bin/nvim"

# Cargo (Rust) environment
#source $HOME/.cargo/env

# Ghostty Resources Directory
export GHOSTTY_RESOURCES_DIR="$HOME/.local/share/ghostty/"

# Direnv hook
eval "$(direnv hook zsh)"

# ------------------------------------------------------------------------------
# 3. Key Bindings
# ------------------------------------------------------------------------------

# Bind Ctrl + Left Arrow to move backward by a word
bindkey '^[[1;5D' backward-word

# Bind Ctrl + Right Arrow to move forward by a word
bindkey '^[[1;5C' forward-word

# ------------------------------------------------------------------------------
# 4. Aliases
# ------------------------------------------------------------------------------

# ----------------------------
# General Navigation Aliases
# ----------------------------
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# ----------------------------
# Command Aliases
# ----------------------------
alias ls="ls --color=tty"
alias ll="ls -lah --color=tty"
alias cat="bat --plain --plain"
alias vi="nvim"
alias vim="nvim"
alias nv="nvim"

# ----------------------------
# Kubernetes Aliases
# ----------------------------
alias k="kubectl"
alias ka="kubectl --as cluster-admin"
alias kns="kubectl ns"
alias kgn="kubectl get nodes -o wide"
alias kgp="kubectl get pods -o wide"
alias kgpa="kubectl get pods -o wide -A --sort-by=.metadata.namespace"
alias kwp="watch kubectl get pods -o wide"
alias kdp="kubectl delete pod"
alias kgi="kubectl get ingress"
alias kgia="kubectl get ingress -A --sort-by=.metadata.namespace"
alias kgsa="kubectl get service -A --sort-by=.metadata.namespace"
alias kgd="kubectl get deployments"
alias klf="kubectl logs -f"
alias kl="kubectl logs"
alias kds="decode_kubernetes_secret"
alias kgo="kubectl get objects"
alias kgr="kubectl get release"

alias ha="helm --kube-as-user=system:admin"

# ----------------------------
# Git Aliases
# ----------------------------
alias g="git"
alias grt="git rebase origin/master -X theirs"
alias lg="lazygit"

# ----------------------------
# Git Repo Shortcuts
# ----------------------------
alias repos="cd ~/Documents/gitrepos/"
alias appcat="cd ~/Documents/gitrepos/schedar-devcontainer/appcat"
alias compappcat="cd ~/Documents/gitrepos/schedar-devcontainer/component-appcat"
alias clusters="cd ~/Documents/gitrepos/openshift4-clusters"

#-----------------------------
# DevContainer
#-----------------------------
alias devcon="devcontainer exec --workspace-folder ~/Documents/gitrepos/schedar-devcontainer zsh"

# ------------------------------------------------------------------------------
# 5. Functions
# ------------------------------------------------------------------------------

bd() {
  base64 -d <<< "$@"
}

# Decode Kubernetes secrets
decode_kubernetes_secret() {
  kubectl get secret "$@" -o json | jq '.data | map_values(@base64d)'
}

# Override kubectl to pipe YAML output through yq for pretty formatting
kubectl() {
  if [[ "$*" == *"-o yaml"* ]]; then
    command kubecolor "$@" | yq eval -P
  else
    command kubecolor "$@"
  fi
}

oargo () {
  kubecolor -n syn get secret steward -o json --as cluster-admin | jq -r .data.token | base64 --decode | wl-copy
  kubecolor -n syn port-forward svc/syn-argocd-server 8080:80 --as cluster-admin
}

update-sshop () {
  cp ~/.ssh/sshop_config ~/.ssh/sshop_config.previous && ssh management2.corp.vshn.net -- "sshop --output-archive /dev/stdout" | tar -C ~ -xvzf - && diff -u ~/.ssh/sshop_config.previous ~/.ssh/sshop_config
}

# Load vshn ssh key
start_ssh_agent() {
  eval $(keychain --eval --agents ssh id_ed25519 2> /dev/null)
}

approve-sg() {
  ka -n syn-stackgres-operator patch installplan -p '{"spec":{"approved":true}}' --type merge "$(ka -n syn-stackgres-operator get installplans.operators.coreos.com | grep false | cut -d" " -f1)"
}

spks-contact () {
  kubectl delete pod contactpod --ignore-not-found
  kubectl run contactpod --restart=Never --rm -ti --image remote-docker.artifactory.swisscom.com/curlimages/curl -- -u contacts:e7ffb277-a058-4c86-9884-c0a69e4bc08c https://iapc-governance-api.scapp-console.swisscom.com/api/contacts\?instanceId=$1  | jq -r '.users'
}

mariadb_state () {
  if [ -z "$1" ]
  then
          echo "mariadb-0:"
          kubecolor exec mariadb-0 -it -c mariadb-galera -- bash -c "mysql -u root --password=\$MARIADB_ROOT_PASSWORD -e \"SHOW STATUS LIKE 'wsrep_%';\"" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} --color=auto "cluster_size\|cluster_status\|connected\|evs_state\|local_state_comment"
          echo "====================="
          echo "mariadb-1:"
          kubecolor exec mariadb-1 -it -c mariadb-galera -- bash -c "mysql -u root --password=\$MARIADB_ROOT_PASSWORD -e \"SHOW STATUS LIKE 'wsrep_%';\"" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} --color=auto "cluster_size\|cluster_status\|connected\|evs_state\|local_state_comment"
          echo "====================="
          echo "mariadb-2:"
          kubecolor exec mariadb-2 -it -c mariadb-galera -- bash -c "mysql -u root --password=\$MARIADB_ROOT_PASSWORD -e \"SHOW STATUS LIKE 'wsrep_%';\"" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} --color=auto "cluster_size\|cluster_status\|connected\|evs_state\|local_state_comment"
          echo "====================="
  else
          kubecolor exec mariadb-$1 -it -c mariadb-galera -- bash -c "mysql -u root --password=\$MARIADB_ROOT_PASSWORD -e \"SHOW STATUS LIKE 'wsrep_%';\"" | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv} --color=auto "cluster_size\|cluster_status\|connected\|evs_state\|local_state_comment"
  fi
}

node_distribution() {
  kubectl get no -o yaml | grep topology.kubernetes.io/zone | awk '{print $2}' | sort | uniq -c
}

# ------------------------------------------------------------------------------
# 6. Completions and Auto-Completion
# ------------------------------------------------------------------------------

# Kubernetes auto-completion
source <(kubectl completion zsh)

# FZF auto-completion
source <(fzf --zsh)

# Starship prompt initialization
eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
# 7. Terminal Multiplexer (tmux) Integration
# ------------------------------------------------------------------------------

# Automatically attach to an existing tmux session or create a new one
if [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi


# krew path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
