#!/bin/bash

# Install tmux if not already installed
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    brew install tmux
else
    echo "tmux is already installed."
fi

# Create a basic tmux configuration file
TMUX_CONF=~/.tmux.conf

echo "Setting up tmux configuration..."

cat > $TMUX_CONF << EOF
# Set prefix to Ctrl-A instead of default Ctrl-B for easier access
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Enable mouse mode
set -g mouse on

# Split panes using | and -
bind | split-window -h
bind - split-window -v

# Enable faster response times
set -s escape-time 0

# Allow reloading the tmux configuration
bind r source-file ~/.tmux.conf \; display-message "Configuration reloaded!"

# Start with 256 colors
set -g default-terminal "screen-256color"
EOF

echo "tmux configuration completed at $TMUX_CONF."

# Launch tmux with 2-3 panes setup
echo "Starting tmux session with 2-3 terminals in one window..."
tmux new-session \; \
  split-window -h \; \
  split-window -v \; \
  select-pane -t 0

echo "tmux session started. Use Ctrl-A + | to split horizontally and Ctrl-A + - to split vertically."
