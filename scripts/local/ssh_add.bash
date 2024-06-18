function main {
    set -x
    local -r ssh_private_key_dir="${PROJECT_REPO_PATH}/temp"
    local -r ssh_private_key_file="packer_temporary_ssh_key"
    local -r ssh_private_key_file_path="${ssh_private_key_dir}/${ssh_private_key_file}"

    mkdir -p "${ssh_private_key_dir}"

    #
    # write the packer private key to disk
    #
    echo "${REMOTE_SSH_PRIVATE_KEY}" > "${ssh_private_key_file_path}"

    #
    # fix the private key permissions
    #
    chmod go-rwx "${ssh_private_key_file_path}"

    #
    # add the packer key to the ssh agent
    #
    ssh-add "${ssh_private_key_file_path}"
}

main