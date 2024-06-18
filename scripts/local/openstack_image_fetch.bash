#!/usr/bin/env bash

set -x

function Curl::Response::Get.body {
    local -r curl_response_full="${1}"

    echo "${curl_response_full}" \
  | head -c-4
}

function Curl::Response::Get.code {
    local -r curl_response_full="${1}"

    echo "${curl_response_full}" \
  | tail -n1
}

function Openstack::Token.issue {
    local -r openstack_token_file_path="${1}"

    openstack token issue \
              --format json \
            > "${openstack_token_file_path}"
}

function Openstack::Image::API {
    local -r openstack_cache_dir_path="${1}"
    local -r jq_filter='.[]|select(.Name=="glance")|.Endpoints|.[]|select(.interface=="public")|.url'
    #local -r openstack_catalog_cache_file_name="openstack-catalog-${CLOUD_DOMAIN}-${CLOUD_INSTANCE}-${CLOUD_PROJECT}.json"
    local -r openstack_catalog_cache_file_name="openstack-catalog.json"
    local -r openstack_catalog_cache_file_path="${openstack_cache_dir_path}/${openstack_catalog_cache_file_name}"
    local    glance_endpoint=UNSET
    local    glance_api=UNSET

    #
    # create the cache file if it does not exsists
    #
    test -f "${openstack_catalog_cache_file_path}" \
 || pkgx openstack catalog list \
                   --format json \
  > "${openstack_catalog_cache_file_path}"

    #
    # retrieve the public glance endpoint
    #
    glance_endpoint="$(
        cat "${openstack_catalog_cache_file_path}" \
      | pkgx jq --raw-output "${jq_filter}"
    )"

    glance_api="${glance_endpoint}/v2/images"
    echo "${glance_api}"
}

function Openstack::Token::Get.id {
    local -r openstack_token_file_path="${1}"
    local -r jq_filter='.id'

    cat "${openstack_token_file_path}" \
  | pkgx jq --raw-output "${jq_filter}"
}

function Openstack::Image::Get.uuid {
    local -r jq_filter='.["builds"][0]["artifact_id"]'

    cat "${manifest_file_path}" \
  | pkgx jq --raw-output "${jq_filter}"
}

function Openstack::Image::Get.name {
    local -r jq_filter='.["builds"][0]["custom_data"]["BUILD_IMAGE_NAME"]'

    cat "${manifest_file_path}" \
  | pkgx jq --raw-output "${jq_filter}"
}

function Openstack::Image.fetch {
    local -r openstack_token_file_path="${1}"
    local -r glance_api="${2}"
    local -r image_uuid="${3}"
    local -r image_name="${4}"
    local -r os_token_value="$(
        Openstack::Token::Get.id "${openstack_token_file_path}"
    )"
    local curl_response_full=UNSET
    local curl_response_code=UNSET
    local curl_response_body=UNSET
   
    curl_response_full="$(pkgx +curl.se +rockdaboot.github.io/libpsl curl \
                               --header "X-Auth-Token: ${os_token_value}" \
                               --request GET "${glance_api}/${image_uuid}/file" \
                               --output "${image_name}" \
                               --write-out "%{http_code}")"
    curl_response_body="$(Curl::Response::Get.body "${curl_response_full}")"
    curl_response_code="$(Curl::Response::Get.code "${curl_response_full}")"
    echo "${curl_response_code}"
}

function main {
    local -r manifest_file_path="${PKR_VAR_TARGET_IMAGE_MANIFEST}"
    local -r openstack_cache_dir_path="${PROJECT_REPO_PATH}/.openstack-cache"

    mkdir -p "${openstack_cache_dir_path}"

    local -r openstack_token_file_name="openstack-token.json"
    local -r openstack_token_file_path="${openstack_cache_dir_path}/${openstack_token_file_name}"
    local -r http_unauthorized='401'
    local    curl_response_code=UNSET
    local -r glance_api="$(Openstack::Image::API "${openstack_cache_dir_path}")"
    local -r image_uuid="$(Openstack::Image::Get.uuid)"
    local -r image_name="$(Openstack::Image::Get.name)"

    #
    # if we already have a cached token, try to use it
    # otherwise re-issue a token
    #
    test -f "${openstack_token_file_path}" \
 || Openstack::Token.issue "${openstack_token_file_path}"
    #
    # 
    #
    curl_response_code="$(
        Openstack::Image.fetch "${openstack_token_file_path}"\
                               "${glance_api}" \
                               "${image_uuid}" \
                               "${image_name}"
    )"
    #
    # if the fetch is unauthorized
    #
    if [ "${curl_response_code}" == "${http_unauthorized}" ]; then
        #
        # re-issue a token 
        # 
        Openstack::Token.issue "${openstack_token_file_path}"
        Openstack::Image.fetch "${openstack_token_file_path}" \
                               "${glance_api}" \
                               "${image_uuid}" \
                               "${image_name}"
    fi
}

main

