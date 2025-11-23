# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2025-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="meson-vdec"
PKG_VERSION="efac5cfcd73e049c8b3470bd0b63981ebfd610c4"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/chewitt/meson-vdec"
WGET_OPT="--auth-no-challenge --header='Accept:application/octet-stream'"
PKG_URL="https://${TOKEN}:@github.com/chewitt/meson-vdec/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="An experimental meson-vdec driver"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  make V=1 KBUILD_MODPOST_WARN=1 \
       ARCH=${TARGET_KERNEL_ARCH} \
       CROSS_COMPILE=${TARGET_KERNEL_PREFIX} \
       -C $(kernel_path) \
       M=${PKG_BUILD}/drivers/media/platform/amlogic/meson-vdec \
       CONFIG_VIDEO_MESON_VDEC=m

  # hack to avoid missing symbols with out-of-tree module
  make V=1 KBUILD_MODPOST_WARN=1 \
       ARCH=${TARGET_KERNEL_ARCH} \
       CROSS_COMPILE=${TARGET_KERNEL_PREFIX} \
       -C $(kernel_path) \
       M=$(kernel_path)/drivers/media/v4l2-core \
       CONFIG_V4L2_H264=m
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
    cp drivers/media/platform/amlogic/meson-vdec/*.ko ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
    cp $(kernel_path)/drivers/media/v4l2-core/v4l2-h264.ko ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
}
