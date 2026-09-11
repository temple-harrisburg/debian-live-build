#!/bin/sh
#
# Install xidlehook, which is used to create a fake screensaver after 60 seconds of idle time.
# See: 
# - /preseed/profiles/common/home/tuhadmin/.config/systemd/user/screensaver.service
# - /preseed/profiles/common/usr/bin/screensaver
#

in-target cargo install xidlehook --bins --root=/usr