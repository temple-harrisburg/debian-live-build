#!/bin/sh
#
# Reconfigure GRUB after customizations 
# specified in /etc/default/grub have 
# been loaded
#

in-target grub-mkconfig -o /boot/grub/grub.cfg