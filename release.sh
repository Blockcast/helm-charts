#!/bin/bash
REPO_ROOT=~/src/blockcast/blockcast-magma-plugin
ORC8R_HELM=${REPO_ROOT}/helm/orc8r
OCS_HELM=${REPO_ROOT}/helm/ocs
helm package $ORC8R_HELM
helm package $OCS_HELM
mv *.tgz orc8r
helm repo index .
