#!/usr/bin/env bash
set -eu

function log() {
    echo "date=$(date) mod=$(basename $0) $*" >>"${c_log_file_path}"
}

function run() {
    path="${1:?Need include path}"
    shift
    . "${_include}/${path}" "$@"
}

function include() {
    . "${_include}/${1:?Need include path}"
}

function init_log() {
    # initialize logging file
    mkdir -p "$(dirname ${c_log_file_path})" 2>/dev/null
    touch "${c_log_file_path}" 2>/dev/null || true
}

function send() {
    echo "$@" | {
        nc -w 0 localhost "${c_ctrl_port}" &&
            log "cmd=send status=success args='$@'" ||
            log "cmd=send status=err args='$@'"
    }
}

function is_in_tmux() {
    [[ -n "${TMUX:-}" ]]
}

function is_on_remote() {
    [[ -n "${SSH_TTY:-}" ]]
}

function is_on_host_alias() {
    host_alias="${1:?Need host alias}"
    [[ "$host_alias" == "$c_host_alias" ]]
}

function remote_cmd() {
    host_alias="${1:?Need host alias}"
    shift

    log "cmd=remote_cmd host=$host_alias command='$@'"
    ssh "$host_alias" "$@"
}

function local_tmux() {
    log "cmd=local_tmux command='tmux $@'"
    tmux "$@"
}

function remote_tmux() {
    host_alias="${1:?Need host alias}"
    shift

    log "cmd=remote_tmux host=$host_alias command='tmux $@'"
    ssh "$host_alias" "tmux $@"
}

function remote_tmux_interactive() {
    host_alias="${1:?Need host alias}"
    shift

    port_fwd_spec=()
    for port in "${c_forward_ports[@]}"; do
        port_fwd_spec+=("-R $port:localhost:$port")
    done

    log "cmd=remote_tmux_interactive host=$host_alias\$ command='tmux $@'"
    ssh -t ${port_fwd_spec[@]} "$host_alias" "tmux $@"
}

function _cleanup() {
    log "cmd=_cleanup"
    [[ -z "$(jobs -p)" ]] || kill $(jobs -p)
}

_root="$(realpath $(dirname ${BASH_SOURCE}))"
_config_path="${_root}/config.sh"
_include="${_root}/include"

. "${_include}/read_config.sh"
init_log
trap _cleanup SIGINT SIGTERM EXIT
