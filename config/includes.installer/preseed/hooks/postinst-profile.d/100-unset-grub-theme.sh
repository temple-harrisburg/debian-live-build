#!/bin/sh
# 
# Prevent grub from falling back to built-in Debian theme
# 

rm "${TARGET_ROOT}/etc/grub.d/05_debian_theme"
in-target update-grub
