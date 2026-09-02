#!/bin/sh
# 
# ${PRESEED_ROOT}/preseed/late_command.sh
# 
# This script is run by the Debian installer after the base system is 
# installed, but before booting into the installed system. 
# 
# TIPS:
#   1. '/' is the root of installer files
# 
#   2. '/target/' is the root of the target system
# 
#   3. 'in-target' handles executing commands by chroot-ing into the 
#       target system. 
# 
#       NOTICE!: Drop '/target/' from paths when using 'in-target'.
# 
#       See https://salsa.debian.org/installer-team/debian-installer-utils/
# 
#   4. Open a debug console in the Debian Installer with Alt+F2. Switch back to graphical installer with Alt+F1.
# 
#   5. Logs are written to `/var/log/syslog`.

set -vx # Verbose debugging. See `/var/log/syslog` in the live system.

export USER="tuhadmin" # WARNING: 'tuhadmin' is hard-coded as the home directory under the 'profiles' directory.
export USER_ROOT="home/$USER"
export PRESEED_ROOT=""
export TARGET_ROOT="/target"

run_scripts () {
    for SCRIPT in "${@}"; do
        "${SCRIPT}"
    done
}

preinst_hooks () {
    run_scripts /preseed/hooks/presinst-profile.d/*.sh
}

postinst_hooks () {
    run_scripts /preseed/hooks/postinst-profile.d/*.sh
}

install_profile () {
    cp -rT "/preseed/profiles/${1}" "$TARGET_ROOT"
}

main() {
    EXIT_CODE=0
    # When the late_command fails, the Debian installer only returns the exit code. 

    if [ "$#" -lt 1 ]; then # Require at least 1 argument, i.e. the name of the profile we're installing.
        exit 10
    fi

    preinst_hooks || EXIT_CODE=$((EXIT_CODE+3))

    install_profile "common" || EXIT_CODE=$((EXIT_CODE+3))

    install_profile "$1" || EXIT_CODE=$((EXIT_CODE+3))

    postinst_hooks || EXIT_CODE=$((EXIT_CODE+3))

    exit $EXIT_CODE
}

main "$@"
