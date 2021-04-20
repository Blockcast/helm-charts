#!/bin/bash
REPO_ROOT=~/src/blockcast/blockcast-magma-plugin
ORC8R_HELM=${REPO_ROOT}/helm/orc8r
OCS_HELM=${REPO_ROOT}/helm/ocs
BLOCKCAST_HELM=${REPO_ROOT}/blockcast/cache/cloud/helm/blockcast-orc8r
helm package $ORC8R_HELM
helm package $OCS_HELM
helm package $BLOCKCAST_HELM
helm package $REPO_ROOT/magma/lte/cloud/helm/lte-orc8r
helm package $REPO_ROOT/magma/feg/cloud/helm/feg-orc8r
helm package $REPO_ROOT/magma/cwf/cloud/helm/cwf-orc8r
mv *.tgz orc8r
helm repo index .
