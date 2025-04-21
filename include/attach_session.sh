if is_on_remote; then
    log "cmd=attach_session status=error reason='should be run on source (local) host only'"
    exit 11
fi

if is_in_tmux; then
    log "cmd=attach_session status=error reason='should not be executed from within running tmux'"
    exit 13
fi

session=("$@")
host_alias="${session[0]?No host in session spec}"
session="${session[1]?No session in session spec}"

log "cmd=attach_session host=$host_alias session=$session"

if is_on_host_alias "$host_alias"; then
    local_tmux new-session -A -s "$session"
else
    remote_tmux_interactive "$host_alias" new-session -A -s "$session"
fi
