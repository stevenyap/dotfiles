#!/usr/bin/env bash
# https://github.com/stylemistake/runner

task_default() {
  echo "Available tasks to run:"
  runner --list-tasks
}

task_start:work() {
  projects=("papa-core" "papa-media" "papa-api" "papa-admin" "papa-mobile")

  for project in "${projects[@]}"; do
    echo "Starting tmux session for $project..."
    tmuxinator start "$project" --no-attach
  done
}
