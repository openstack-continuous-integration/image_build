source "openstack" "image-build" {

    flavor = var.FLAVOR_NAME
    floating_ip_network = var.FLOATING_IP_NETWORK

    external_source_image_url = var.SOURCE_IMAGE_URL
    image_name = var.TARGET_IMAGE_NAME
    skip_create_image = var.SKIP_IMAGE_CREATION
    #use_blockstorage_volume = true
    #image_disk_format = var.TARGET_IMAGE_FORMAT

    volume_size = var.VOLUME_SIZE
    volume_name = var.VOLUME_NAME

    image_visibility = "private"

    #
    # applied to the exported image
    #
    metadata = (
        var.SET_IMAGE_METADATA == false ? null : {
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
        }
    )

    network_discovery_cidrs = [ var.NETWORK_DISCOVERY_CIDRS ]

    ssh_username = var.TARGET_SSH_USERNAME
}