#!/bin/bash
ulimit -n 1024

JAVA_UPDATE_VERSION="2.1"
JAVA_BUILD_NUMBER="b35"

export FULL_DEBUG_SYMBOLS=0
export ENABLE_FULL_DEBUG_SYMBOLS=0

export STRIP_POLICY=max_strip

export BUILD_FLAVOR=product

BOOT_JDK=$JAVA_HOME

GCC_FLAGS="-Wno-error -Ofast -g0 -march=westmere -mtune=ivybridge -funroll-loops -fomit-frame-pointer -mfpmath=sse -ftree-vectorize -fno-semantic-interposition -pipe -mfsgsbase -mxsave -mxsaveopt -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"

C_FLAGS="-std=gnu23"
CXX_FLAGS="-std=gnu++23"

bash configure --with-boot-jdk=$BOOT_JDK --with-vendor-bug-url=https://bugreport.java.com/bugreport/ --with-vendor-name="Oracle Corporation" --with-vendor-url=https://java.oracle.com/ --with-update-version=$JAVA_UPDATE_VERSION --with-build-number=$JAVA_BUILD_NUMBER --with-milestone="fcs" --enable-jfr --with-jvm-variants=server --with-extra-cflags="$GCC_FLAGS $C_FLAGS" --with-extra-cxxflags="$GCC_FLAGS $CXX_FLAGS" --with-debug-level="release" --with-native-debug-symbols=none --with-jvm-features=link-time-opt

make clean

make images CONF=linux-x86_64-normal-server-release DEBUG_BINARIES=false && cd build/linux-x86_64-normal-server-release/images/j2re-image/bin && strip java && ./java -version

rm -rf *.diz
