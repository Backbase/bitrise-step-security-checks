#!/bin/bash

set -e

url=$artifactory_url/security-tools/pipeline/0.0.3/securityScan.sh

options=''

if [[ -z "$artifactory_user" ]] || [[ -z "$artifactory_password" ]]; then
  echo "Missing artifactory credentials"
  exit 1
fi

export BD_HUB_TOKEN=$blackduck_token

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

if [[ ! -z "$search_depth" ]]; then
  options="$options --detectSearchDepth $search_depth"
fi
if [[ ! -z "$source_path" ]]; then
  options="$options --sourcePath $source_path"
fi
if [[ ! -z "$sonar_properties" ]]; then
  options="$options --sonarProperties $sonar_properties"
fi

curl -u $artifactory_user:$artifactory_password -s -L -O $url
chmod +x securityScan.sh

./securityScan.sh \
  --fail \
  --projectType $project_type \
  --projectName $project_name \
  --version $project_version \
  --scanArtifacts $deliverable_path \
  $options
