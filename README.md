# tses: tmux session switcher

## Problem

Suppose the following:

- You have a work laptop and a dedicated development virtual machine.
- You run tmux on both machines as a primary way to organize your workspace.
- You switch between VM and local tmux sessions rather often.
- You interact with your VM via SSH.

To switch between local and remote tmux sessions you have to either:

- Detach and connect to tmux sessions each time you switch contexts.
- Have multiple terminal windows running, each connected to its own tmux server.
- Use some other layer of terminal multiplexing on top of tmux.

This extra overhead when switching between sessions bothered me enough so that
I decided to put some effort to implement a tool to make the switch less involved.

## Solution

The tool provides two bash scripts. One is used to start the session and the other
is used to switch between different sessions, create, delete and rename them.

Both scripts' interfaces do not care whether the tmux sessions being manipulated
are local or remote. You can manipulate tmux sessions running on different machines
uniformly from any of the said machines.

## Usage

This sections provides instructions on how to configure and use the scripts. It
is not meant to be complete: feel free to read the source code or to create an issue.

### Configuration

An example configuration can be found in `config.sh` file.
Put it in `~/.config/tses/config.sh` file.

| Field  | Type | Meaning |
|---|---|---|
| c_host_alias_to_hostname | Map | Define aliases for each remote machine. Alias is the key and hostname is the value. |
| c_remote_sessions_file_path | String | Path for file where the remote sessions will be cached. |
| c_log_file_path | String | Logs path |
| c_forward_ports | Array | Ports that should be forwarded over SSH (optional) |

### Attach via tlaunch

In order to attach to tmux session `a_session` running on host with alias
`a_host_alias`, issue the following command:

```bash
tlaunch a_host_alias a_session
```

The tool will attach to an existing session or create a new one. It does not
matter on which host you issue this command as long as the the host has correct configuration.

### Switch via tswitch

After you've successfully attached to a tmux session via `tlaunch`, you can
manipulate tmux sessions and switch between them freely, without thinking about
the host the session in running on.

In order to use `tswitch`, simply run it and follow the instructions. I hope that
the interface is rather intuitive.

```bash
tswitch
```

## Installation

The downside of this tool is that you have to install it on all of
the machines that are going to be used. This should only be done once
though.

1. Clone this repository on each of the machines you are going to use.
2. Put your configuration file in `~/.config/tses/config.sh` on each machine.
3. Optionally add a tmux keybinding to issue `tswitch` command:

```tmux
bind-key -n C-s run-shell -b "<your_path_to>/tswitch"
```

## Architecture

TBD Someday

## Dependencies

Apart from some common bash command the tool requires

- [fzf](https://github.com/junegunn/fzf)
- nc
- tmux
- ssh
