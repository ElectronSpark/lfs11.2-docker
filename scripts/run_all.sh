#!/bin/bash
#
# run all scripts to build a lfs system.
#


function on_host() {
    echo "now it's under host environment..."
    pushd ~/scripts/prepare_chroot
    sh prepare_pkgs.sh
    sh prepare_chroot.sh
    sudo sh final_prepare.sh
    sudo sh enter_chroot.sh "/scripts/run_all.sh on_chroot"
    sudo sh enter_chroot.sh
    popd
}


function on_chroot() {
    echo "now it's under chroot environment..."
    pushd /scripts/build_chroot
    sh chroot_env_setting.sh
    sh build_tmp_tools.sh
    popd
}


case $1 in
    "on_chroot")
        on_chroot
        ;;
    "on_host")
        on_host
        ;;
    *)
        on_host
        ;;
esac