# hosts and their aliases
c_host_alias_to_hostname["my_alias_1"]="hostname_1"
c_host_alias_to_hostname["my_alias_2"]="hostname_2"

# path where all hosts' sessions lists will be stored (a file)
c_remote_sessions_file_path="/tmp/tses-remote-sessions"

# local log path
c_log_file_path="${HOME}/.local/share/tx/tx.log"

# port that will be forwared to remote hosts and used to communicate to the server
c_ctrl_port="12399"

# other ports that should be forwarded, for example:
c_forward_ports+=("12398")
