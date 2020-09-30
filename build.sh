#!/bin/sh
mkdir -p ./build
if [ -d ./build ]
then
    cd ./build
    cmake -DCMAKE_INSTALL_PREFIX=/Volumes/Ramdisk/keepassxc \
          -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
          -DCMAKE_VERBOSE_MAKEFILE=OFF \
          -DCMAKE_CXX_STANDARD=17 \
          -DCMAKE_BUILD_TYPE=Release \
          -DWITH_XC_BROWSER=ON \
          -DWITH_XC_UPDATECHECK=OFF \
          -DWITH_TESTS=OFF \
          -DKEEPASSXC_BUILD_TYPE=Snapshot \
          -DKEEPASSXC_DIST_TYPE=AppImage \
          -DOVERRIDE_VERSION=$(git describe --tags | cut -f 1 -d '-') \
          -DGIT_HEAD_OVERRIDE=$(git rev-parse HEAD | cut -c1-7) \
          ..

    make
    cd ..

    if [ -f ./build/compile_commands.json -a ! -f ./compile_commands.json -a ! -h ./compile_commands.json ]
    then
        echo "symlinking compile_commands.json."
        ln -sf ./build/compile_commands.json .
    elif [ ! -f /build/compile_commands.json -a -h ./compile_commands.json ]
    then
        echo "remove symlink compile_commands.json.: there's no such file exits in ./build directory."
        rm compile_commands.json
    fi
else
    echo "creating ./build directory failed."
fi
