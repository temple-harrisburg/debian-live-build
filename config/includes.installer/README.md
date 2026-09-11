# Preseeding Overview

This directory is copied to the root of the file system in which `debian-installer` runs.

## Overview
### Preseeding
The most significant part of the configuration takes place within the `preseed_*.cfg` files. The options in these files are pre-defined options for the Debian installer. They also invoke the `late_command

### Late Command Script

`late_command.sh` does two things:
1. Copies files to the target system ('profiles')
2. Runs commands in the target system ('hooks')

#### Profiles

An invocation of `late_command.sh` is hard-coded into each preseed file. `late_command.sh` requires a single argument: the name of the profile to install.

Each subdirectory of the 'profile' directory contains configurations to be copied to the target file system. 'Profile' directories mimic the structure of the target file system.

#### Hooks

Hooks are run at certain points by `late_command.sh`. 

The hooks are run in this order:
1. `preinst_profile.d/*.sh`
2. `pre_${PROFILE_NAME}.d/*.sh`
3. `post_${PROFILE_NAME}.d/*.sh`
4. `postint_profile.d/*.sh`

Where ${PROFILE_NAME} is the argument passed to `late_command.sh`.

Putting numbers at the start of each script's file name controls the order in which each script will be run (as a side effect of automatic sorting).


## Resources

- [Debian Manual Appendix B: "Automating the installation using preseeding"](https://www.debian.org/releases/stable/amd64/apb.en.html)
