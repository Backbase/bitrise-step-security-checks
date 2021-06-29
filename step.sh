#!/bin/bash

url=$ARTIFACTORY_URL/security-tools/latest/security-scan.sh

options=''

if [ -z $ARTIFACTORY_USERNAME ] || [ -z $ARTIFACTORY_PASSWORD ]; then
  echo "Missing artifactory credentials"
  exit 1
fi


if [[ $project_type == 'android' ]]; then
  if [ -z $gradle_project]; then
    options="$options --detectGradleProject $gradle_project"
  fi
  if [ -z $gradle_configuration]; then
    options="$options --detectGradleConfiguration $gradle_configuration"
  fi
fi

bash <(curl -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD -s -L $url) \
--projectType $project_type \
--projectName $project_name \
--version $project_version \
--scanArtifacts $deliverable_path \
--signArtifacts $deliverable_path \
$options 