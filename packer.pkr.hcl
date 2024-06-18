packer {
  required_plugins {
    #
    # https://developer.hashicorp.com/packer/integrations/hashicorp/openstack/latest/components/builder/openstack
    #
    openstack = {
      version = "~>1.1"
      source = "github.com/hashicorp/openstack"
    }
  }
}