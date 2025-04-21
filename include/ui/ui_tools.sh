function ui_choose_one_option() {
    fzf --tmux --select-1 --prompt="${*:?Need prompt}: "
}

function ui_choose_multiple_options() {
    fzf --tmux --multi --prompt="${*:?Need prompt}: "
}

function ui_query_string() {
    prompt="${@:?Need prompt}"

    tmux display-popup -E \
        "printf '$prompt: ' && read response && echo \"\$response\" > /tmp/tx_response" || {
        echo ""
        exit 0
    }

    cat /tmp/tx_response
    rm /tmp/tx_response
}

function list_sessions() {
    tmux list-sessions | sed "s/^/[$c_host_alias] /"
    cat "${c_remote_sessions_file_path}" | grep -v "\[$c_host_alias\]" || true
}

function ui_choose_one_session() {
    list_sessions |
        ui_choose_one_option "${*:?Need prompt}" |
        sed 's/:.*//g'
}

function ui_choose_multiple_sessions() {
    list_sessions |
        ui_choose_multiple_options "${*:?Need prompt}" |
        sed 's/:.*//g'
}
