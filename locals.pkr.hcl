locals {
    constructor_repo_path = abspath(path.root)
    project_repo_path = dirname(local.constructor_repo_path)
    #provisioner_repo_path = join("/", [local.project_path, ".provisioner"])
}