#!/bin/sh
# 
# Make sure all config files have the correct permissions
# 

in-target chown "$USER:$USER" -R "/$USER_ROOT/.config" || echo "Failed to change permissions on .config dir" >&2
