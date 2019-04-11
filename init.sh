#!/bin/sh
git submodule init
git submodule update

cd src/loki
git submodule init
git submodule update
# attempt a build to set up some basics
DUSE_SINGLE_BUILDDIR=1 make
cd ../..

cd src/loki-storage-server
git submodule init
git submodule update 
git checkout master 
git pull
cd ../..

cd src/loki-network
git submodule init
git submodule update

