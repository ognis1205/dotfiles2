info() {
    printf "\e[32m[INFO]\e[0m ${*}"
}

if_yes_then() {
    while true; do
        echo -n "${1}" ; read -p " (y/n): " yn
        case "${yn}" in
            [Yy]*) echo "Yes" ; eval "${@/${1}}" ; break ;;
            [Nn]*) echo  "No" ; break ;;
            *)     echo "Please enter a valid parameter (y/n)." ;;
        esac
    done
}
