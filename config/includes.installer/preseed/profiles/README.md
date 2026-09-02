# Late-command Profiles Overview
Each subdirectory of this directory is a 'profile' to be copied to the target
file system. Directories here mimic the structure of the target file system.

A profile is selected by passing an argument to `late_command.sh`. Only one 
profile can be selected.

The 'common' directory is copied to every target system regardless of profile.

## Example

The "common" profile could have the following structure:
```
common
├── etc
│   ├── default
│   │   └── grub
│   └── lightdm
│       └── lightdm.conf
├── home
│   └── tuhadmin
│       ├── .config
│       │   ├── openbox
│       │   │   └── rc.xml
│       │   └── systemd
│       │       └── user
│       │           └── screensaver.service
│       └── .xinitrc
└── usr
    ├── bin
    │   └── screensaver
    └── share
        └── grub
            └── themes
                ├── background.png
                └── theme.txt/common
```

All the files below 'common' be copied recursively into the target system,
so e.g. 'common/etc/lightdm/lightdm.conf' will appear in the target system
at '/etc/lightdm/lightdtm.conf', providing a default configuration for 
the lightdm display manager.
