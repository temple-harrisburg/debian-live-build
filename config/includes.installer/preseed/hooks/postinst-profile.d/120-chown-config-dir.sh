#!/bin/sh
# 
# Make sure all config files have the correct permissions
# 

in-target chown "$USER:$USER" -R "/$USER_ROOT/.config"