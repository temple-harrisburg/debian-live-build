#!/bin/sh
# 
# Delete default Grub config to prevent falling back to built-in Debian theme.
# Regenerate config to use newly configured custom theme.
# 

rm "${TARGET_ROOT}/etc/grub.d/05_debian_theme" || echo "Failed to delete Debian GRUB theme configuration" >&2
in-target grub-mkconfig -o /boot/grub/grub.cfg || echo "Failed to update GRUB configuration" >&2