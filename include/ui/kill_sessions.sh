while read -r session; do
    parse_session_spec "$session"

    log "cmd=kill_sessions host=$host_alias session=$session"

    if is_on_host_alias "$host_alias"; then
        local_tmux kill-session -t "$session"
    else
        send tmux_dispatch "$host_alias" kill-session -t "$session"
    fi
done < <(ui_choose_multiple_sessions "Sessions to delete")
