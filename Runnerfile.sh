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
