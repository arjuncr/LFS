#!/bin/bash

int_build_env()
{

export SCRIPT_NAME="LFS BUILD SCRIPT"
export SCRIPT_VERSION="1.0.0.0"
export LINUX_NAME="LFS"
export DISTRIBUTION_VERSION="1.0.0"
export ISO_FILENAME="LFS-${SCRIPT_VERSION}.iso"

# BASE
export KERNEL_BRANCH="4.x" 

export BASEDIR=`realpath --no-symlinks $PWD`
export WORKDIR=${BASEDIR}/workspace
export SOURCEDIR=${WORKDIR}/source
export ROOTFSDIR=${WORKDIR}/rootfs
export BUILDDIR=${WORKDIR}/build
export OUTDIR=${WORKDIR}/output
export ISODIR=${OUTDIR}/iso

#cross compile
export CROSS_COMPILE64=$BASEDIR/cross_gcc/x86_64-linux/bin/x86_64-linux-
export ARCH64="x86_64"
export CROSS_COMPILEi386=$BASEDIR/cross_gcc/i386-linux/bin/i386-linux-
export ARCHi386="i386"

#Dir and mode
export ETCDIR="etc"
export MODE="754"
export DIRMODE="755"
export CONFMODE="644"

#cflags
export CFLAGS=-m64
export CXXFLAGS=-m64

#setting JFLAG
if [ -z "$2"  ]
then	
	export JFLAG=4
else
	export JFLAG=$2
fi

}

prepare_dirs () {

    cd ${BASEDIR}

    if [ ! -d ${WORKDIR} ]
    then
	mkdir -p ${WORKDIR}
    fi    
    if [ ! -d ${SOURCEDIR} ];
    then
        mkdir -p ${SOURCEDIR}
    fi
    if [ ! -d ${ROOTFSDIR} ];
    then
        mkdir -p ${ROOTFSDIR}
    fi
    if [ ! -d ${BUILDDIR} ];
    then
        mkdir -p ${BUILDDIR}
    fi
    if [ ! -d ${OUTDIR} ];
    then
        mkdir -p ${OUTDIR}
    fi
    if [ ! -d ${ISODIR} ];
    then
        mkdir -p ${ISODIR}
    fi
}

build_kernel () {

}

build_busybox () {

}

build_extras () {
    #Build extra soft
    cd ${BASEDIR}/${BUILD_OTHER_DIR}
    if [ "$1" == "-c" ]
    then
    	./build_other_main.sh --clean
    elif [ "$1" == "-b" ]
    then
    	./build_other_main.sh --build	    
    fi	    
}

generate_rootfs () {	
   
}

generate_image () {
  
}

test_qemu () {
  cd ${BASEDIR}
    if [ -f ${ISO_FILENAME} ];
    then
       qemu-system-x86_64 -m 128M -cdrom ${ISO_FILENAME} -boot d -vga std
    fi
}

clean_files () {
   rm -rf ${WORKDIR}
}

init_work_dir()
{
prepare_dirs
}

clean_work_dir()
{
clean_files
}

build_all()
{
build_kernel  -b
build_busybox -b
build_extras   -b
}

rebuild_all()
{
clean_all
build_all
}

clean_all()
{
build_kernel  -c
build_busybox -c
build_extras   -c
}

wipe_rebuild()
{
clean_work_dir
init_work_dir
rebuild_all
}

help_msg()
{
echo -e "#################################################################################\n"

echo -e "############################Utility to Build LFS ###########################\n"

echo -e "#################################################################################\n"

echo -e "Help message --help\n"

echo -e "Build All: --build-all\n"

echo -e "Rebuild All: --rebuild-all\n"

echo -e "Clean All: --clean-all\n"

echo -e "Wipe and rebuild --wipe-rebuild\n" 

echo -e "Building kernel: --build-kernel --rebuild-kernel --clean-kernel\n"

echo -e "Building other soft: --build-other --rebuild-other --clean-other\n"

echo -e "Creating root-fs: --create-rootfs\n"

echo -e "Create ISO Image: --create-img\n"

echo -e "Cleaning work dir: --clean-work-dir\n"

echo -e "Test with Qemu --Run-qemu\n"

echo "###################################################################################"

}

option()
{

if [ -z "$1" ]
then
help_msg
exit 1
fi

if [ "$1" == "--build-all" ]
then
build_all
fi

if [ "$1" == "--rebuild-all" ]
then
rebuild_all
fi

if [ "$1" == "--clean-all" ]
then
clean_all
fi

if [ "$1" == "--wipe-rebuild" ]
then
wipe_rebuild
fi

if [ "$1" == "--build-kernel" ]
then
build_kernel -b
elif [ "$1" == "--rebuild-kernel" ]
then
build_kernel -c
build_kernel -b
elif [ "$1" == "--clean-kernel" ]
then
build_kernel -c
fi

if [ "$1" == "--build-busybox" ]
then
build_busybox -b
elif [ "$1" == "--rebuild-busybox" ]
then
build_busybox -c
build_busybox -b
elif [ "$1" == "--clean-busybox" ]
then
build_busybox -c
fi

if [ "$1" == "--build-uboot" ]
then
build_uboot -b
elif [ "$1" == "--rebuild-uboot" ]
then
build_uboot -c
build_uboot -b
elif [ "$1" == "--clean-uboot" ]
then
build_uboot -c
fi

if [ "$1" == "--build-other" ]
then
build_extras -b
elif [ "$1" == "--rebuild-other" ]
then
build_extras -c
build_extras -b
elif [ "$1" == "--clean-other" ]
then
build_extras -c
fi

if [ "$1" == "--create-rootfs" ]
then
generate_rootfs
fi

if [ "$1" == "--create-img" ]
then
generate_image
fi

if [ "$1" == "--clean-work-dir" ]
then
clean_work_dir
fi

if [ "$1" == "--Run-qemu" ]
then
test_qemu
fi

}

main()
{
int_build_env
init_work_dir
option $1
}

#starting of script
main $1 
