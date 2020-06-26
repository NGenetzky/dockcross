#!/bin/bash

_echoerr() {
	echo "$*" >&2
}

_args_run_internal_ssh_sock(){
    if [ ! -S "${SSH_AUTH_SOCK:-}" ]; then
        _echoerr 'WARNING: Missing SSH_AUTH_SOCK. Skipping volume and env.'
        return 0
    fi
    # NOTE: Currently assumes 'SSH_AUTH_SOCK' is an absolute path
    ARGS_RUN_INTERNAL+=( \
        --env 'SSH_AUTH_SOCK=/ssh-agent' \
        --volume "${SSH_AUTH_SOCK}:/ssh-agent" \
    )
}

_args_run_internal_gitconfig(){
    local gitconfig
    gitconfig="$(readlink -f "$HOME/.gitconfig")"
    if [ ! -f "${gitconfig}" ]; then
        _echoerr 'WARNING: Missing gitconfig. Skipping volume.'
        return 0
    fi
    ARGS_RUN_INTERNAL+=( \
        --volume "${gitconfig}:/etc/gitconfig:ro" \
    )
}

_generate_args_run_internal(){
    ARGS_RUN_INTERNAL=('')
    _args_run_internal_ssh_sock
    _args_run_internal_gitconfig
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    _echoerr "Script must be sourced. Such as: \". '${0}' \""
    exit 1
fi

# Global read-write variables!
ARGS_RUN_INTERNAL=('')
_generate_args_run_internal

# Choose 'ARG' to ignore command line '--args'.
# Choose 'DOCKCROSS' to allow '--args' to bypass.
# Or choose 'ARG' and include original 'ARG_ARGS'.
DOCKCROSS_ARGS="${ARGS_RUN_INTERNAL[@]}"
