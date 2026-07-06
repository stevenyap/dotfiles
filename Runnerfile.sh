#!/usr/bin/env bash
# https://github.com/stylemistake/runner

task_default() {
  echo "Available tasks to run:"
  runner --list-tasks
}

task_start:toppan() {
  projects=("toppan-dashboard" "toppan-media" "agilelab-devops")

  for project in "${projects[@]}"; do
    echo "Starting tmux session for $project..."
    tmuxinator start "$project" --no-attach
  done
}

task_xiaosteve() {
  export OP_ACCOUNT=my.1password.com
  local SSH_KEY="$HOME/.ssh/xiaosteve-ssh-task-key"
  OPITEM="XiaoSteve/XiaoSteve SSH Key"
  op read "op://${OPITEM}/private key" \
    --force \
    --no-newline \
    --out-file "$SSH_KEY" \
    --file-mode 400
  echo "Loaded SSH Key to $SSH_KEY"

  SSH_USER="$(op read "op://${OPITEM}/user")"
  SSH_HOST="$(op read "op://${OPITEM}/host")"
  echo "ssh -i $SSH_KEY $SSH_USER@$SSH_HOST"
  ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST"
}
