FROM dockcross/base:latest
MAINTAINER Matt McCormick "matt.mccormick@kitware.com"

RUN apt-get update && \
    apt-get -y install \
    libelf-dev \
    libssl-dev \
    && apt-get clean --yes

ENV CROSS_TRIPLE x86_64-linux-gnu
ENV CROSS_ROOT /usr/bin
ENV AS=/usr/bin/${CROSS_TRIPLE}-as \
    AR=/usr/bin/${CROSS_TRIPLE}-ar \
    CC=/usr/bin/${CROSS_TRIPLE}-gcc \
    CPP=/usr/bin/${CROSS_TRIPLE}-cpp \
    CXX=/usr/bin/${CROSS_TRIPLE}-g++ \
    LD=/usr/bin/${CROSS_TRIPLE}-ld \
    FC=/usr/bin/${CROSS_TRIPLE}-gfortran

COPY ${CROSS_TRIPLE}-noop.sh /usr/bin/${CROSS_TRIPLE}-noop

COPY Toolchain.cmake /usr/lib/${CROSS_TRIPLE}/
ENV CMAKE_TOOLCHAIN_FILE /usr/lib/${CROSS_TRIPLE}/Toolchain.cmake

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE=dockcross/linux-x64
ARG VERSION=latest
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
ENV DEFAULT_DOCKCROSS_IMAGE ${IMAGE}:${VERSION}

# https://github.com/lkcamp/lkcamp-kerneltools/blob/master/slim/Dockerfile
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        bc                           \
        flex                         \
        bison                        \
        build-essential              \
        git                          \
        libncurses-dev               \
        libssl-dev                   \
        libelf-dev                   \
        u-boot-tools                 \
        wget                         \
        xz-utils                     \
        qemu-kvm                     \
        iproute2                     \
        python3                      \
        python3-pip                  \
        python3-setuptools           \
        vim                          \
        libmailtools-perl            \
        libauthen-sasl-perl          \
        git-email                    \
        libauthen-sasl-perl          \
        libmime-base64-urlsafe-perl  \
    && apt-get autoremove -y  && apt-get clean -y  && rm -rf /var/lib/apt/lists/* \
    && pip3 install git+https://github.com/ezequielgarcia/virtme.git

# https://github.com/lkcamp/lkcamp-kerneltools/blob/master/slim-v4l/Dockerfile
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        exuberant-ctags    \
        less               \
        cscope             \
        strace             \
        dh-autoreconf      \
        autotools-dev      \
        doxygen            \
        gettext            \
        graphviz           \
        libasound2-dev     \
        libtool            \
        libjpeg-dev        \
        qtbase5-dev        \
        libudev-dev        \
        libx11-dev         \
        qt5-default        \
        meson              \
        kmod               \
        tig                \
        bash-completion    \
        debhelper          \
        dh-autoreconf      \
        autotools-dev      \
        autoconf-archive   \
        doxygen            \
        graphviz           \
        libasound2-dev     \
        libtool            \
        libjpeg-dev        \
        libqt5opengl5-dev  \
        libudev-dev        \
        libx11-dev         \
        pkg-config         \
        udev               \
        make               \
        gcc                \
        git                \
        ninja-build        \
        v4l-utils          \
        strace             \
    && apt-get autoremove -y  && apt-get clean -y  && rm -rf /var/lib/apt/lists/* \
    && pip3 install --user \
        git-pw

# Build-time metadata as defined at http://label-schema.org
ARG IMAGE=local/dockcross-lkcamp
ENV DEFAULT_DOCKCROSS_IMAGE ${IMAGE}:${VERSION}
