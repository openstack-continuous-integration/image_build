build {
  name = "packer"
  sources = [
    "source.openstack.image-build"
  ]

  provisioner "shell-local" {
    environment_vars = [
      "PROJECT_REPO_PATH=${local.project_repo_path}",
      "REMOTE_SSH_PRIVATE_KEY=${build.SSHPrivateKey}"
    ]
    script = "${local.constructor_repo_path}/scripts/local/ssh_add.bash"
  }
  #
  # https://www.packer.io/docs/templates/hcl_templates/contextual-variables
  #
  provisioner "shell-local" {
    environment_vars = [
      "PROJECT_REPO_PATH=${local.project_repo_path}",
      "REMOTE_FQDN=${build.Host}",
      "REMOTE_USER=${build.User}"
    ]
    script = "${local.constructor_repo_path}/scripts/local/exec_provisioner_task.bash"
  }

    #
    # cleanup if all goes well
    #
    #provisioner "shell-local" {
    # script = "${local.constructor_path}/local/install/scripts/ssh_del.bash"
    #}
    #
    # cleanup if something goes wrong
    #
    #error-cleanup-provisioner "shell-local" {
    # script = "${local.constructor_path}/local/install/scripts/ssh_del.bash"
    #}
    post-processor "manifest" {
        output = "${local.project_repo_path}/${var.TARGET_IMAGE_MANIFEST}"
        strip_path = true
        custom_data = {
            DISTRIBUTION_NAME = var.SYSTEM_DISTRIBUTION_NAME
            DISTRIBUTION_VERSION_NUMBER = var.SYSTEM_DISTRIBUTION_VERSION_NUMBER
            DISTRIBUTION_VERSION_NAME = var.SYSTEM_DISTRIBUTION_VERSION_NAME
            DISTRIBUTION_ARCH = var.SYSTEM_DISTRIBUTION_ARCH
            BUILD_UUID = var.TARGET_IMAGE_BUILD_UUID
            BUILD_TAG = var.TARGET_IMAGE_BUILD_TAG
            BUILD_VERSION = var.TARGET_IMAGE_BUILD_VERSION
            BUILD_OWNER = var.TARGET_IMAGE_BUILD_OWNER
            BUILD_ORGANIZATION = var.TARGET_IMAGE_BUILD_ORGANIZATION
            BUILD_YEAR = var.TARGET_IMAGE_BUILD_YEAR
            BUILD_MONTH = var.TARGET_IMAGE_BUILD_MONTH
            BUILD_DAY = var.TARGET_IMAGE_BUILD_DAY
            BUILD_TIME = var.TARGET_IMAGE_BUILD_TIME
            BUILD_TOOL_NAME = var.BUILD_TOOL_NAME
            BUILD_TOOL_VERSION = var.BUILD_TOOL_VERSION
            BUILD_IMAGE_NAME = var.TARGET_IMAGE_NAME
        }
    }
    post-processor "shell-local" {
      script = "${local.constructor_repo_path}/scripts/local/exec_post_processor_task.bash"
    }
}