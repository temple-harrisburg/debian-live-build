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

warn () {
    echo "WARNING: $1 exited with code $2" >&2
}

run_scripts () {
    for SCRIPT in "${@}"; do
        "${SCRIPT}" || warn "${SCRIPT}" "${?}"
    done
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

    run_scripts /preseed/hooks/preinst_profile.d/*.sh || echo "Failed to run pre-install scripts" >&2

    install_profile "common" || EXIT_CODE=$((EXIT_CODE+$?))
    
    # shellcheck disable=SC2086
    run_scripts /preseed/hooks/pre_$1.d/*.sh || echo "Failed to run pre-install scripts for $1" >&2

    install_profile "$1" || EXIT_CODE=$((EXIT_CODE+$?))
    
    # shellcheck disable=SC2086
    run_scripts /preseed/hooks/post_$1.d/*.sh || echo "Failed to run post-install scripts for $1" >&2

    run_scripts /preseed/hooks/postinst_profile.d/*.sh || echo "Failed to run post-install scripts" >&2

    # exit $EXIT_CODE
    echo "late_command finished with exit code ${EXIT_CODE}" >&2
    exit ${EXIT_CODE}
}

main "$@"
