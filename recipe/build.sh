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

mkdir -p $PREFIX/lib/vega-cli
cd $PREFIX/lib/vega-cli
yarn add vega-cli@$PKG_VERSION

cd $PREFIX/bin
for cmd in vg2pdf vg2png vg2svg
do
    ln -s ../lib/vega-cli/node_modules/vega-cli/bin/$cmd .
done

cp $PREFIX/lib/vega-cli/node_modules/vega-cli/LICENSE $SRC_DIR

# Remove faulty files
find ${PREFIX} -name node_gyp_bins | xargs --no-run-if-empty rm -r
