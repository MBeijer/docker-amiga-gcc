#!/bin/bash

# exit when any command fails
set -e

#set compiler params
export TARGET='ppc-amigaos'
export SYSROOT=/opt/${TARGET}/usr
export M68K_CPU="-mhard-float"
export M68K_COMMON="-s -ffast-math -fomit-frame-pointer -I${SYSROOT}/include -L${SYSROOT}/lib"
export M68K_CFLAGS="${CFLAGS} ${M68K_CPU} ${M68K_COMMON}"
export M68K_CXXFLAGS="${CXXFLAGS} ${M68K_CPU} ${M68K_COMMON}"
export CURPATH="${PWD}"
export SUBMODULES="${CURPATH}/dependencies"

# ZLIB
git clone https://github.com/madler/zlib.git "${SUBMODULES}"/zlib
rm -rf "${SUBMODULES}"/zlib/build
mkdir -p "${SUBMODULES}"/zlib/build
cd "${SUBMODULES}"/zlib/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DTOOLCHAIN_COMMON="${M68K_COMMON} -O3 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++14"
cmake --build . --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
cd "${SUBMODULES}"

#MiniGL
rm -rf MiniGL
mkdir -p "${SUBMODULES}"/MiniGL
cd "${SUBMODULES}"/MiniGL
wget http://os4depot.net/share/driver/graphics/minigl.lha -O minigl.lha
lha -x minigl.lha
mkdir -p ${SYSROOT}/usr/include
mkdir -p ${SYSROOT}/usr/lib
cp -fvr MiniGL/SDK/local/common/include/* ${SYSROOT}/include/
cp -fvr MiniGL/SDK/local/newlib/lib/* ${SYSROOT}/lib/
cd "${SUBMODULES}"


# SDL1.2
if [ ! -d "${SUBMODULES}/SDL" ]; then
	git clone https://github.com/AmigaPorts/SDL.git "${SUBMODULES}"/SDL
fi
cd "${SUBMODULES}"/SDL
git checkout SDL-1.2-AmigaOS3
git pull
rm -rf "${SUBMODULES}"/SDL/build
mkdir -p "${SUBMODULES}"/SDL/build
cd "${SUBMODULES}"/SDL/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DTOOLCHAIN_COMMON="${M68K_COMMON} -O3 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++14"
cmake --build . --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
cd "${SUBMODULES}"

# Zziplib
#rm -rf "${SUBMODULES}"/zziplib/build
#mkdir -p "${SUBMODULES}"/zziplib/build
#cd "${SUBMODULES}"/zziplib/build
#cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DM68K_CPU=68040 -DM68K_FPU=hard -DM68K_COMMON="${M68K_COMMON} -O2 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++14"
#cmake --build . --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
#cd "${SUBMODULES}"

# lhasa
#cd ${SUBMODULES}/lhasa
#./autogen.sh --host=${TARGET}
#CFLAGS="${M68K_CFLAGS}" CXXFLAGS="${M68K_CXXFLAGS}" ./configure --disable-sdltest --disable-shared --enable-static --host=${TARGET} --prefix=${SYSROOT}
#make -j$(getconf _NPROCESSORS_ONLN)
#make install
#cd ${SUBMODULES}

cd "${CURPATH}"
