#!/bin/bash
#
# run all scripts to build a lfs system.
#


function on_host() {
    echo "now it's under host environment..."
    pushd ${LFS_HOME}/scripts/prepare_chroot
    sh ${LFS_HOME}/scripts/prepare_chroot/prepare_pkgs.sh
    sh ${LFS_HOME}/scripts/prepare_chroot/prepare_chroot.sh
    sudo sh ${LFS_HOME}/scripts/prepare_chroot/final_prepare.sh
    # the following commands don't work
    # sh ${LFS_HOME}/scripts/prepare_chroot/enter_chroot.sh   \
    #     "/scripts/run_all.sh on_chroot_env_setting"
    # sh ${LFS_HOME}/scripts/prepare_chroot/enter_chroot.sh   \
    #     "/scripts/run_all.sh on_chroot"
    sudo chroot "${LFS}" /usr/bin/env -i    \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$'  \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS="${MAKEFLAGS}"    \
        /bin/bash --login -c "/scripts/run_all.sh on_chroot_env_setting"
    sudo chroot "${LFS}" /usr/bin/env -i    \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$'  \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS="${MAKEFLAGS}"    \
        /bin/bash --login -c "/scripts/run_all.sh on_chroot"
    sudo sh ${LFS_HOME}/scripts/prepare_chroot/enter_chroot.sh
    popd
}


function on_chroot() {
    echo "now it's under chroot environment..."
    pushd /scripts/build_chroot
    sh build_tmp_tools.sh
    popd
}


function on_chroot_env_setting() {
    cho "now it's under chroot environment setting..."
    pushd /scripts/build_chroot
    sh chroot_env_setting.sh
    popd
}


case $1 in
    on_chroot_env_setting)
        on_chroot_env_setting
        ;;
    on_chroot)
        on_chroot
        ;;
    on_host)
        on_host
        ;;
    *)
        on_host
        ;;
esac