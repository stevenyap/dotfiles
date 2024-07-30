#!/bin/bash

# List of tmuxinator projects to start
projects=("papa-core" "papa-media" "papa-api" "papa-admin" "papa-mobile")

# Iterate over each project and start it
for project in "${projects[@]}"; do
  echo "Starting tmux session for $project..."
  tmuxinator start $project
done

echo "Attaching to first project: ${projects[0]}"
tmux attach-session -t ${projects[0]}
