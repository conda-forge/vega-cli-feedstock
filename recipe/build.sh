#!/bin/sh

set -exuo pipefail

if [[ "${target_platform}" == "osx-arm64" ]]; then
  export npm_config_arch="arm64"
fi
# Don't use pre-built gyp packages
export npm_config_build_from_source=true

if [[ "${target_platform}" == linux-* ]]; then
  # We need to be more permissive to get the code compiling
  export CFLAGS="${CFLAGS} -fpermissive"
  export CXXFLAGS="${CXXFLAGS} -fpermissive"
fi

rm $PREFIX/bin/node
ln -s $BUILD_PREFIX/bin/node $PREFIX/bin/node

yarn install
pushd packages/vega-cli
npm pack
npm install -g vega-cli-*.tgz

# Remove faulty files
if [[ "${target_platform}" == linux-* ]]; then
    find ${PREFIX} -name node_gyp_bins | xargs --no-run-if-empty rm -r
else
    find ${PREFIX} -name node_gyp_bins | xargs rm -r
fi
