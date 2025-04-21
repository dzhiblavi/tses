session=$(ui_choose_one_session "Session to rename")
if [ -z "${session[@]}" ]; then
    log "cmd=rename_session status=error reason=empty_session"
    exit 0
fi

IFS=$' ' session=($session)
host_alias="$(echo "${session[0]}" | tr -d '[]')"
session="${session[1]}"

new_name=$(ui_query_string "Rename $session (on [$host_alias]) to")
if [ -z "$new_name" ]; then
    log "cmd=rename_session status=cancelled reason=new_session_name_is_empty"
    exit 0
fi

log "cmd=rename_session host=$host_alias session=$session new_session=$new_name"

if is_on_host_alias "$host_alias"; then
    local_tmux rename-session -t "$session" "$new_name"
else
    send tmux_dispatch "$host_alias" rename-session -t "$session" "$new_name"
fi
