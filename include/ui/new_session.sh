host_alias="${1:?Need host alias}"
session=$(ui_query_string "Session name (on [$host_alias])")

if [ -z "${session}" ]; then
    log "cmd=new_session status=error reason=empty_session"
    exit 0
fi

log "cmd=new_session host=$host_alias session=${session}"

if is_on_host_alias "$host_alias"; then
    local_tmux new-session -d -s "${session}"
    local_tmux switch-client -t "${session}"
else
    send attach "${host_alias}" "${session}"
    local_tmux detach
fi
