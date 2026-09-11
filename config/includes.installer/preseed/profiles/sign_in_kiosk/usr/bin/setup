#!/usr/bin/env bash
# 
# /usr/bin/setup --> $HOME/setup.sh
# 
# Runs on first login of sign-in kiosk.

ENV_FILE="${ENV_FILE:-"${HOME}/sign-in-kiosk/.env"}"
DB_URI="${DB_URI:-"${HOME}/sign-in-kiosk/db.sqlite"}"
LOG_FILE="${LOG_FILE:-"/var/log/sign-in-kiosk/log.txt"}"

usage(){
    cat << EOF
    Usage: setup [-i <true|false> | -h]
        -i <true|false>     Configure interactively; else, use defaults.
        -h                  print usage and quit
EOF
}

create_log_dir () {
    sudo mkdir -p "$(dirname "${LOG_FILE}")" 
    sudo touch "${LOG_FILE}"
    sudo chown tuhadmin:tuhadmin "${LOG_FILE}"
}

CONFIG_FILE="${HOME}/.kiosk_config"

install_deps () {
    echo "Installing dependencies"
    sudo apt install git \
        curl \
        cups \
        printer-driver-dymo \
        -y

    echo "Installing PNPM"
    curl -o- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -
    # shellcheck disable=SC1091
    . "${HOME}/.bashrc"
}

install_kiosk() {
    # shellcheck disable=SC2164
    cd "${HOME}"
    git clone https://github.com/temple-harrisburg/sign-in-kiosk.git
    cd "${HOME}/sign-in-kiosk" || exit 1
    pnpm install
}

print_config() {
    cat <<- EOF
        export ENV_FILE="${ENV_FILE}"
        export DB_URI="${DB_URI}"
        export LOG_FILE="${LOG_FILE}"
EOF
}

save_config() {
    cat <<- EOF > "${CONFIG_FILE}"
        export ENV_FILE="${ENV_FILE}"
        export DB_URI="${DB_URI}"
        export LOG_FILE="${LOG_FILE}"
EOF

}

configure_kiosk_variables() {    
    read -r -p "Enter path to kiosk .env file (leave blank for default: [$ENV_FILE]): " input_env
    ENV_FILE="${input_env:-$ENV_FILE}"

    read -r -p "Enter path to SQLite Database (leave blank for default: [$DB_URI]): " input_db
    DB_URI="${input_db:-$DB_URI}"

    read -r -p "Enter path to log file (leave blank for default: [$LOG_FILE]): " input_log
    LOG_FILE="${input_log:-$LOG}"

    echo "New configuration: "
    print_config
    echo
}

interactive_config() {
 while true; do
        echo
        echo "1) Reinstall dependencies"
        echo "2) Modify kiosk env, database and log file paths"
        echo "3) Exit & Start Kiosk"
        echo "4) Exit"
        read -r -p "Select [1-2]: " choice
        case $choice in
            1) 
                clear
                if ! install_deps; then
                    echo "An error ocurred while installing dependencies"
                    exit 1
                fi

                if ! install_kiosk; then 
                    echo "An error ocurred while installing the kiosk"
                    exit 1
                fi
            ;;

            2) 
                clear
                configure_kiosk_variables
                ;;
            3) 
                clear
                    echo "Starting kiosk..."
                zutty -e start &
                break 
                ;;
            4) 
                break
            ;;
            *) ;;
        esac
    done
}

automated_config() {
    if ! install_deps; then
        echo "An error ocurred while installing dependencies"
        exit 1
    fi

    if ! install_kiosk; then 
        echo "An error ocurred while installing the kiosk"
        exit 1
    fi
}

set_skip_config () {
        echo "export SKIP_CONFIG=\"1\"" >> "${HOME}/.config/openbox/environment"
}

main() {
    if [ "${#}" -lt 1 ]; then
        # Print usage and exit if no args are provided
        usage
        exit 1
    else 
        # If args are provided, parse and execute
        while getopts ":i:h" opt; do
            case $opt in
                i) 
                    if [ "${OPTARG}" = "true" ]; then 
                        interactive_config 
                    else
                        automated_config
                    fi 
                ;;
                h) 
                    usage 
                    exit 0
                ;;
                *) 
                    usage
                    exit 1
                ;;
            esac
        done
    fi
    set_skip_config
}

main "${@}"