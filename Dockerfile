ARG GOLANG_VERSION=alpine

FROM golang:${GOLANG_VERSION}

LABEL maintainer="Tony Huynh <mr.tonyhuynh@gmail.com>"

ARG VIPSVERSION="8.10.2"

# build-essential => build-base
# pkg-config => pkgconfig
# glib2.0-dev => glib-dev
# libexpat1-dev => expat-dev

# libjpeg-turbo8-dev => libjpeg-turbo-dev
# libexif => libexif-dev
# giflib => giflib-dev
# librsvg => librsvg
# libgsf-1-dev => libgsf-dev
# libtiff5-dev => tiff-dev
# lcms2 => lcms2-dev
# *libimagequant
# libpng => libpng-dev
# ?ImageMagick
# !pangoft2
# orc-0.4 => orc-dev
# !matio
# !cfitsio
# libwebp => libwebp-dev
# libheif => libheif-dev

RUN apk update \
    && apk upgrade \
    && apk add --no-cache build-base \
                          pkgconfig \
                          glib-dev \
                          gobject-introspection-dev \
                          expat-dev \
                          tiff-dev \
                          libjpeg-turbo-dev \
                          libgsf-dev \
                          libexif-dev \
                          giflib-dev \
                          librsvg-dev \
                          lcms2-dev \
                          libpng-dev \
                          orc-dev \
                          libwebp-dev \
                          libheif-dev

RUN apk add --no-cache libimagequant-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN \
  # Build libvips
  cd /tmp && \
  wget https://github.com/libvips/libvips/releases/download/v$VIPSVERSION/vips-$VIPSVERSION.tar.gz && \
  tar zxvf vips-$VIPSVERSION.tar.gz && \
  cd /tmp/vips-$VIPSVERSION && \
  ./configure --enable-debug=no --without-python $1 && \
  make && \
  make install

RUN ldconfig /

ENTRYPOINT vips
