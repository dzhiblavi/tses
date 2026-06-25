function ui_choose_one_option() {
    fzf --tmux --select-1 --prompt="${*:?Need prompt}: "
}

function ui_choose_multiple_options() {
    fzf --tmux --multi --prompt="${*:?Need prompt}: "
}

function ui_query_string() {
    local prompt="${@:?Need prompt}"
    local prompt_quoted
    local response_file
    local response_file_quoted

    prompt_quoted="$(printf "%q" "$prompt: ")"
    response_file="$(mktemp "${TMPDIR:-/tmp}/tses_response.XXXXXX")"
    response_file_quoted="$(printf "%q" "$response_file")"

    tmux display-popup -E \
        "printf %s $prompt_quoted && IFS= read -r response && printf '%s\n' \"\$response\" > $response_file_quoted" || {
        rm -f "$response_file"
        echo ""
        exit 0
    }

    cat "$response_file"
    rm -f "$response_file"
}

function list_sessions() {
    tmux list-sessions | sed "s/^/[$c_host_alias] /"
    cat "${c_remote_sessions_file_path}" | grep -v "\[$c_host_alias\]" || true
}

function parse_session_spec() {
    local session_spec="${1:?Need session spec}"

    host_alias="${session_spec%%]*}"
    host_alias="${host_alias#[}"
    session="${session_spec#*] }"
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
