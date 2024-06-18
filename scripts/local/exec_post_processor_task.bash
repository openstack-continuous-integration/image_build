#!/usr/bin/env bash

function pp {
    local -r message="${1}"

    printf '\e[104m[ %s ] %s\e[0m\n' \
           "$( date '+%Y/%m/%d-%H:%M:%S' )" \
           "${message}"
}

function main {
    if [ "X${PKR_VAR_CONSTRUCTOR_EXEC_POST_PROCESSOR_TASK_INSTALL}" == "Xtrue" ]; then
        local parent_dir="$(dirname $PWD)"
        task --taskfile "${parent_dir}/Taskfile.yaml" provisioner:fetch
        #task provisioner:push
    else
        pp 'Set the environment variable PKR_VAR_CONSTRUCTOR_EXEC_POST_PROCESSOR_TASK_INSTALL to true to execute the constructor post-processor task'
    fi
}

main