session_spec="${1:?Need session spec}"
host_alias="${session_spec%%]*}"
host_alias="${host_alias#[}"
session="${session_spec#*] }"

log "cmd=switch_session host_alias=$host_alias, session=$session"

if is_on_host_alias "$host_alias"; then
    local_tmux switch-client -t "$session"
else
    send attach "$host_alias" "$session"
    local_tmux detach
fi
