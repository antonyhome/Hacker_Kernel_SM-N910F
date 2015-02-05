#!/bin/bash

BUILD_WHERE=$(pwd)
BUILD_KERNEL_DIR=$BUILD_WHERE
BOARD_KERNEL_BASE=0x00000000
BOARD_KERNEL_PAGESIZE=4096
BOARD_KERNEL_TAGS_OFFSET=0x01E00000
BOARD_RAMDISK_OFFSET=0x02000000
BOARD_KERNEL_CMDLINE="console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3"
BOOTIMG=$BUILD_KERNEL_DIR/build_image/boot.img
DTBTOOL=$BUILD_KERNEL_DIR/tools/dtbTool
FLASH_ZIP_FILES=zip_files
FLASH_ZIP_DIR=$FLASH_ZIP_FILES/$KERNEL_NAME
KERNEL_NAME=hacker_kernel_sm-n910f_v4
KERNEL_ZIMG=$BUILD_KERNEL_DIR/arch/arm/boot/zImage
MKBOOTIMGTOOL=$BUILD_KERNEL_DIR/tools/mkbootimg
OUTPUT_DIR=$BUILD_KERNEL_DIR/build_image/output_kernel

cp -r $KERNEL_ZIMG build_image

find . -name "*.ko" -exec cp {} $BUILD_KERNEL_DIR/build_image/zip_files/system/lib/modules/ \;

cd build_image
echo "Making dt.img ..."
$DTBTOOL -o dt.img -s $BOARD_KERNEL_PAGESIZE -p ../scripts/dtc/ ../arch/arm/boot/dts/

chmod a+r dt.img


echo "Making boot.img ..."
$MKBOOTIMGTOOL --cmdline "$BOARD_KERNEL_CMDLINE" --kernel zImage --ramdisk ramdisk-new.cpio.gz -o boot.img --base $BOARD_KERNEL_BASE --pagesize $BOARD_KERNEL_PAGESIZE --ramdisk_offset $BOARD_RAMDISK_OFFSET --tags_offset $BOARD_KERNEL_TAGS_OFFSET --dt dt.img

echo "Making zip ..."
cp $BOOTIMG $FLASH_ZIP_FILES/boot.img
cd $FLASH_ZIP_FILES
zip -r $KERNEL_NAME.zip META-INF system boot.img
mv $KERNEL_NAME.zip $OUTPUT_DIR

echo "Making cleaning ..."
find . -name "*.ko" -exec rm {} \;
rm boot.img
cd ..
rm dt.img
rm boot.img
rm zImage
echo "All Done!"
