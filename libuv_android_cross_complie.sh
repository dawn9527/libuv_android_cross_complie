#!/bin/bash

# 创建编译目录
if [ -d "libuv_android_cross_compile" ]; then
  rm -rf libuv_android_cross_compile 
  echo 清空编译目录  libuv_android_cross_compile 
fi

mkdir  libuv_android_cross_compile
cd libuv_android_cross_compile
ROOT_DIR=`pwd -P`
echo 创建Android交叉编译根目录 $ROOT_DIR

OUTPUT_DIR=$ROOT_DIR/output
mkdir $OUTPUT_DIR



# NDK 配置
export NDK_ROOT=/home/dawn/android/ndk-r13b/android-ndk-r13b
export PATH=$PATH:$NDK_ROOT

# 创建交叉编译标准工具链
$NDK_ROOT/build/tools/make_standalone_toolchain.py --arch=arm --api=16 --install-dir=ndk-standalone-toolchain
TOOLCHAIN=$ROOT_DIR/ndk-standalone-toolchain

# 设置交叉编译环境
export PATH=$PATH:$TOOLCHAIN/bin
export SYSROOT=$TOOLCHAIN/sysroot
export ARCH=armv7
export TOOL=arm-linux-androideabi
export CC=arm-linux-androideabi-gcc
export CXX=arm-linux-androideabi-g++
export AR=arm-linux-androideabi-ar
export AS=arm-linux-androideabi-as
export LD=arm-linux-androideabi-ld
export RANLIB=arm-linux-androideabi-ranlib
export NM=arm-linux-androideabi-nm
export STRIP=arm-linux-androideabi-strip
export CHOST=arm-linux-androideabi
export ARCH_FLAGS="-mthumb"
export CFLAGS="${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64"
export CXXFLAGS="${CFLAGS} -frtti -fexceptions"
export PLATFORM=android

OUTPUT_DIR=$ROOT_DIR/libuv-android
mkdir $OUTPUT_DIR

# 下载编译libuv
LIBUV_OUTPUT = $OUTPUT_DIR/libuv/lib/armeabi-v7a
mkdir -p $LIBUV_OUTPUT
mkdir $OUTPUT_DIR/libuv/include
LIBUV_DIR=$ROOT_DIR/libuv-1.28.0
wget https://github.com/libuv/libuv/archive/v1.28.0.tar.gz
tar -xvzf v1.28.0.tar.gz
cd $LIBUV_DIR
./autogen.sh
./configure --prefix=$LIBUV_OUTPUT --host=arm --with-sysroot=$TOOLCHAIN/sysroot --enable-static --disable-shared
make -j4
make install 

echo "编译完成"










