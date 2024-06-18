# openstack-continuous-integration / image_build

This repository defines some **constructor** code to build an openstack image using [HashiCorp Packer](https://www.packer.io/).  
It must be used together with a **provisioner** repository code that will configure the packer image.

## Usage

This repository must be cloned into a top-level project using the folowing base task config files

### Taskfile.env
```bash
export GIT_URL_BASE='https://github.com/openstack-continuous-integration'

#############################################################################
#
# The repository containing the constructor code to instantiate the VM
#
#############################################################################
export CONSTRUCTOR_REPO_URL="${GIT_URL_BASE}/image_build.git"
export CONSTRUCTOR_REPO_BRANCH='main'
export CONSTRUCTOR_REPO_TAG=''
export CONSTRUCTOR_REPO_DIR='.constructor'

#############################################################################
#
# The repository containing the provisioner code to install/configure ci instance
#
#############################################################################
export PROVISIONER_REPO_URL="${GIT_URL_BASE}/ci_provisioner.git"
export PROVISIONER_REPO_BRANCH='main'
export PROVISIONER_REPO_TAG=''
export PROVISIONER_REPO_DIR='.provisioner'
```

### Taskfile.yaml

```yaml
version: '3'

dotenv:
- Taskfile.env

includes:
  constructor:
    taskfile: .constructor/Taskfile.yaml
    dir: .constructor
    optional: true

  provisioner:
    taskfile: .provisioner/Taskfile.yaml
    dir: .provisioner
    optional: true

tasks:
  default:
    silent: true
    cmds:
    - task --list

  git_clone_if_not_exist:
    vars:
      REPO_URL: '{{.REPO_URL}}'
      REPO_BRANCH: '{{.REPO_BRANCH}}'
      REPO_DIR: '{{.REPO_DIR}}'
    status:
    - test -d "{{.REPO_DIR}}"
    cmds:
    - git clone --progress
                --verbose
                --single-branch
                --branch '{{.REPO_BRANCH}}'
                '{{.REPO_URL}}'
                '{{.REPO_DIR}}'

  git_checkout_or_pull:
    deps:
    - task: git_clone_if_not_exist
      vars:
        REPO_URL: '{{.REPO_URL}}'
        REPO_BRANCH: '{{.REPO_BRANCH}}'
        REPO_DIR: '{{.REPO_DIR}}'
    vars:
      REPO_DIR: '{{.REPO_DIR}}'
      REPO_TAG: '{{.REPO_TAG}}'
    cmds:
    - cd '{{.REPO_DIR}}' &&
      {{if eq .REPO_TAG ""}}
        git pull
      {{else}}
        git checkout tags/{{.REPO_TAG}}
      {{end}}

  init:
    desc: Initializes constructor and provisioner repositories
    deps:
    - task: git_checkout_or_pull
      vars:
        REPO_URL: '{{.CONSTRUCTOR_REPO_URL}}'
        REPO_BRANCH: '{{.CONSTRUCTOR_REPO_BRANCH}}'
        REPO_TAG: '{{.CONSTRUCTOR_REPO_TAG}}'
        REPO_DIR: '{{.CONSTRUCTOR_REPO_DIR}}'
    - task: git_checkout_or_pull
      vars:
        REPO_URL: '{{.PROVISIONER_REPO_URL}}'
        REPO_BRANCH: '{{.PROVISIONER_REPO_BRANCH}}'
        REPO_TAG: '{{.PROVISIONER_REPO_TAG}}'
        REPO_DIR: '{{.PROVISIONER_REPO_DIR}}'
```
