function _get_all_sessions() {
    for host_alias in "${c_host_aliases[@]}"; do
        log "cmd=get_all_sessions host=$host_alias"

        if is_on_host_alias "$host_alias"; then
            local_tmux list-sessions | sed "s/^/[$host_alias] /"
        else
            remote_tmux "$host_alias" list-sessions | sed "s/^/[$host_alias] /"
        fi
    done
}

function _send_sessions_to_all_hosts() {
    sessions="${1:?Need sessions}"
    log "cmd=send_sessions host=$host_alias path=${c_remote_sessions_file_path}"

    for host_alias in "${c_host_aliases[@]}"; do
        if is_on_host_alias "$host_alias"; then
            echo "$sessions" >"${c_remote_sessions_file_path}"
        else
            remote_cmd "$host_alias" "echo '$sessions' > ${c_remote_sessions_file_path}"
        fi
    done
}

if is_on_remote; then
    send synchronize
else
    sessions=$(_get_all_sessions)
    _send_sessions_to_all_hosts "$sessions"
fi
