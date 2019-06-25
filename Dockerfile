FROM sebastianbergmann/amiga-gcc
MAINTAINER Marlon Beijer "marlon@amigadev.com"

RUN apt-get update && apt-get install -y apt-utils cmake wget git make
RUN echo "root:root" | chpasswd

# Temporary fix
RUN rm /opt/$CROSS_PFX ; ln -s /opt/amiga /opt/$CROSS_PFX

WORKDIR /work
ENTRYPOINT ["/entry/entrypoint.sh"]

COPY imagefiles/cmake.sh /usr/local/bin/cmake
COPY imagefiles/ccmake.sh /usr/local/bin/ccmake
COPY imagefiles/entrypoint.sh /entry/

ENV CROSS_PFX m68k-amigaos
ENV CROSS_ROOT /opt/${CROSS_PFX}

ENV AS=${CROSS_ROOT}/bin/${CROSS_PFX}-as \
	LD=${CROSS_ROOT}/bin/${CROSS_PFX}-ld \
    AR=${CROSS_ROOT}/bin/${CROSS_PFX}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_PFX}-gcc \
    CXX=${CROSS_ROOT}/bin/${CROSS_PFX}-g++ \
	RANLIB=${CROSS_ROOT}/bin/${CROSS_PFX}-ranlib

COPY dependencies/toolchains/${CROSS_PFX}.cmake ${CROSS_ROOT}/lib/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/lib/${CROSS_PFX}.cmake