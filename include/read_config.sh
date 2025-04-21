c_ctrl_port="12399"
declare -A c_host_alias_to_hostname=()
declare -a c_forward_ports=($c_ctrl_port)

. "${HOME}/.config/tses/config.sh" || {
    echo "cmd=read_config status=error reason='no configuration found at ~/.config/tses/config.sh'"
    exit 1
}

declare -a c_host_aliases=()
declare -A c_hostname_to_host_alias=()

for host_alias in "${!c_host_alias_to_hostname[@]}"; do
    c_host_aliases+=("$host_alias")
    hostname="${c_host_alias_to_hostname[$host_alias]}"
    c_hostname_to_host_alias["$hostname"]="$host_alias"
done

c_hostname="$(hostname)"
c_host_alias="${c_hostname_to_host_alias[${c_hostname}]}"
