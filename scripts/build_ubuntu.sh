#!/bin/bash

set -exuo pipefail

# configure test.sh
export GITREPO_ROOT=${1:-$(readlink -f "$(dirname "$0")/..")}
export TEST_INSTALL_DESTDIR=${TEST_INSTALL_DESTDIR:-/persistent}
export TEST_BUILD_DIR=${TEST_BUILD_DIR:-build-ubuntu}
export TEST_CMAKE_BUILD_TYPE=Release
export TEST_WITH_INSTALL_DEB_PACKAGES=1
export TEST_WITH_OSTREE=0
export TEST_WITH_TESTSUITE=0

# build and copy aktualizr.deb and garage_deploy.deb to $TEST_INSTALL_DESTDIR
mkdir -p "$TEST_INSTALL_DESTDIR"
# note: executables are stripped, following common conventions in .deb packages
LDFLAGS="-s" "$GITREPO_ROOT/scripts/test.sh"

# copy provisioning data and scripts
cp -rf "$GITREPO_ROOT/tests/test_data/prov_testupdate" "$TEST_INSTALL_DESTDIR"
cp -rf "$GITREPO_ROOT/tests/config/testupdate.toml" "$TEST_INSTALL_DESTDIR"
cp -rf "$GITREPO_ROOT/scripts/testupdate_server.py" "$TEST_INSTALL_DESTDIR"
cp -rf "$GITREPO_ROOT/tests/test_data/testupdate_2.0" "$TEST_INSTALL_DESTDIR"
cp -rf "$GITREPO_ROOT/src/uptane_generator/run/create_repo.sh" "$TEST_INSTALL_DESTDIR"
cp -rf "$GITREPO_ROOT/src/uptane_generator/run/serve_repo.py" "$TEST_INSTALL_DESTDIR"

git -C "$GITREPO_ROOT" fetch --tags --unshallow || true
git -C "$GITREPO_ROOT" describe > "$TEST_INSTALL_DESTDIR/aktualizr-version"
