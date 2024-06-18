variable OS_CLOUD {
  description = "The openstack cloud instance on which we provision (ex: project@openstack-site)"
  type = string
}

variable FLAVOR_NAME {
  description = "The instance flavor name to use to build the image (ex: m1.medium)"
  type = string
}
variable SOURCE_IMAGE_URL {
  description = "The source image url (ex: https://cloud-images.ubuntu.com/releases/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img)"
  type = string
}
variable VOLUME_SIZE {
  description = "The instance volume size (ex: 20)"
  type = string
}
variable VOLUME_NAME {
  description = "The instance volume name"
  type = string
}

variable TARGET_IMAGE_BUILD_UUID {
  description = "The target image build UUID (ex: 2e36711d-81fa-498f-975b-4669f814e886)"
  type = string
}

variable SYSTEM_DISTRIBUTION_NAME {
  description = "The target system distribution name (ex: ubuntu)"
  type = string
}

variable SYSTEM_DISTRIBUTION_VERSION_NUMBER {
  description = "The target system distribution version number (ex: 24.04)"
  type = string
}

variable SYSTEM_DISTRIBUTION_VERSION_NAME {
  description = "The target system distribution version name (ex: noble)"
  type = string
}

variable SYSTEM_DISTRIBUTION_ARCH {
  description = "The target system distribution arch (ex: amd64, arm64)"
  type = string
}

variable TARGET_IMAGE_BUILD_TAG {
  description = "The target image build tag (ex: ci)"
  type = string
}
variable TARGET_IMAGE_BUILD_VERSION {
  description = "The target image build version (ex: v1.0)"
  type = string
}

variable TARGET_IMAGE_BUILD_OWNER {
  description = "The target image build owner (ex: bot)"
  type = string
}

variable TARGET_IMAGE_BUILD_ORGANIZATION {
  description = "The target image build organization (ex: openstack-continuous-integration)"
  type = string
}

variable TARGET_IMAGE_BUILD_YEAR {
  description = "The target image build year (ex: 2024)"
  type = string
}

variable TARGET_IMAGE_BUILD_MONTH {
  description = "The target image build month (ex: 08)"
  type = string
}

variable TARGET_IMAGE_BUILD_DAY {
  description = "The target image build day (ex: 31)"
  type = string
}

variable TARGET_IMAGE_BUILD_TIME {
  description = "The target image build time (ex: 125959)"
  type = string
}

variable TARGET_IMAGE_BUILD_DATETIME {
  description = "The target image build datetime (ex: 20210831125959)"
  type = string
}

variable BUILD_TOOL_NAME {
  description = "The build tool name (ex: packer)"
  type = string
  default = "packer"
}

variable BUILD_TOOL_VERSION {
  description = "The build tool version (ex: v1.7.4)"
  type = string
}

variable SKIP_IMAGE_CREATION {
  description = "Skip the image creation"
  type = string
  default = true
}
variable TARGET_IMAGE_FORMAT {
  description = "the target image format (ex: qcow2)"
  type = string
}

variable TARGET_IMAGE_NAME {
  description = "The target image name"
  type = string
}
variable TARGET_IMAGE_MANIFEST {
  description = "The target image manifest"
  type = string
  default = "manifest.json"
}

variable FLOATING_IP_NETWORK {
  description = "The floating ip network name (ex: dmz)"
  type = string
}

variable NETWORK_DISCOVERY_CIDRS {
  description = "The cidr on wich creating the instance (ex: 192.168.1.0/24)"
  type = string
}

variable TARGET_SSH_USERNAME {
  description = "The ssh username (ex: ubuntu)"
  type = string
}

variable SET_IMAGE_METADATA {
  type = bool
  default  = false
}

variable IMAGE_VISIBILITY {
  type = string
  default = "private"
}

variable IMAGE_MEMBERS {
  type = list(string)
  default = [ ]
}

variable OPENSSH_VERSION {
  description = "The OpenSSH commands version to use"
  type = string
}