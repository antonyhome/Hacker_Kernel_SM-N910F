#!/system/bin/sh
# thanks to ausdim

mkdir -p /data/media/0/hacker-kernel-data
HACKER_DATA_PATH="/data/media/0/hacker-kernel-data"
HACKER_LOGFILE="$HACKER_DATA_PATH/hacker-kernel.log"
# Maintain log files history
{
    if [ -f "$HACKER_LOGFILE.3" ] 
    then mv "$HACKER_LOGFILE.3" "$HACKER_LOGFILE.4"
    fi

    if [ -f "$HACKER_LOGFILE.2" ] 
    then mv "$HACKER_LOGFILE.2" "$HACKER_LOGFILE.3"
    fi

    if [ -f "$HACKER_LOGFILE.1" ] 
    then mv "$HACKER_LOGFILE.1" "$HACKER_LOGFILE.2"
    fi

    if [ -f "$HACKER_LOGFILE" ] 
    then mv "$HACKER_LOGFILE" "$HACKER_LOGFILE.1"
    fi
}

# Initialize the log file (chmod to make it readable also via /sdcard link)
echo $(date) "Hacker-Kernel initialisation started" >> $HACKER_LOGFILE
/sbin/busybox chmod 775 $HACKER_LOGFILE
/sbin/busybox chmod 775 $HACKER_DATA_PATH
/sbin/busybox cat /proc/version >> $HACKER_LOGFILE
echo "=========================" >> $HACKER_LOGFILE
# Include version information about firmware in log file
echo "version information" >> $HACKER_LOGFILE
/sbin/busybox grep ro.build.display.id /system/build.prop >> $HACKER_LOGFILE
/sbin/busybox grep ro.product.model /system/build.prop >> $HACKER_LOGFILE
/sbin/busybox grep ro.build.version /system/build.prop >> $HACKER_LOGFILE
echo "=========================" >> $HACKER_LOGFILE

#Mounting system
mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs
echo "System and rootfs mounted successful." >> $HACKER_LOGFILE

#Symlink busybox parts
cd /sbin

for i in $(./busybox --list)
do
	./busybox ln -s busybox $i
done
echo "Busybox symlinks created successful." >> $HACKER_LOGFILE

cd /

#Unmounting system
/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
echo "System and rootfs unmounted successful." >> $HACKER_LOGFILE
echo $(date) "Hacker-Kernel initialisation ended successful" >> $HACKER_LOGFILE
echo "=========================" >> $HACKER_LOGFILE
