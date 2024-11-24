#!/bin/bash

# Define the session name
SESSION_NAME="my_session"

# Define SSH connections with specific key
SSH_KEY="~/.ssh/id_captain_daddy"
SSH_TARGETS=("jadennation@192.168.1.68" "jadennation@192.168.1.19")

# Check if the tmux session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
    # Create a new tmux session and split into the main left pane
    tmux new-session -d -s $SESSION_NAME
    tmux rename-window -t $SESSION_NAME:0 'SSH Connections'

    # Split the main window horizontally (creates the main left pane)
    tmux split-window -h -t $SESSION_NAME:0

    # Split the right pane vertically, creating two right-side panes
    tmux split-window -v -t $SESSION_NAME:0.1

    # Connect the top right pane to the first SSH target using the specified key
    tmux send-keys -t $SESSION_NAME:0.1 "ssh -i $SSH_KEY ${SSH_TARGETS[0]}" C-m

    # Connect the bottom right pane to the second SSH target using the specified key
    tmux send-keys -t $SESSION_NAME:0.2 "ssh -i $SSH_KEY ${SSH_TARGETS[1]}" C-m

    # Select the first pane (left side) to keep it active
    tmux select-pane -t $SESSION_NAME:0.0
fi

# Attach to the session
tmux attach -t $SESSION_NAME
