#!/bin/bash

url=$artifactory_url/security-tools/latest/security-scan.sh

options=''

if [[ -z "$artifactory_user" ]] || [[ -z "$artifactory_password" ]]; then
  echo "Missing artifactory credentials"
  exit 1
fi

export BD_HUB_TOKEN=$blackduck_token
export VERACODE_ID=$veracode_id
export VERACODE_KEY=$veracode_key

if [[ ! -z "$signing_path" ]]; then
  options="$options --signArtifacts $signing_path"
fi

if [[ $project_type == 'android' ]]; then
  if [[ ! -z "$gradle_project" ]]; then
    options="$options --detectGradleProject $gradle_project"
  fi
  if [[ ! -z "$gradle_configuration" ]]; then
    options="$options --detectGradleConfiguration $gradle_configuration"
  fi
fi

bash <(curl -u $artifactory_user:$artifactory_password -s -L $url) \
--projectType $project_type \
--projectName $project_name \
--version $project_version \
--scanArtifacts $deliverable_path \
$options 