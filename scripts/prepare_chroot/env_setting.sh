#!/bin/bash
# This program sets .bashrc and .bash_profile of user "lfs".

# .bash_profile
echo "exec env -i HOME=${LFS_HOME} TERM=$TERM PS1='\u:\w\$ ' /bin/bash" \
    >> ${LFS_HOME}/.bash_profile

# .bashrc
echo "set +h" >> ${LFS_HOME}/.bashrc
echo "umask 022" >> ${LFS_HOME}/.bashrc
echo "LFS=${LFS}" >> ${LFS_HOME}/.bashrc
echo "LC_ALL=${LC_ALL}" >> ${LFS_HOME}/.bashrc
echo "LFS_TGT=${LFS_TGT}" >> ${LFS_HOME}/.bashrc
echo "PATH=${PATH}" >> ${LFS_HOME}/.bashrc
echo "CONFIG_SITE=${CONFIG_SITE}" >> ${LFS_HOME}/.bashrc
echo "export LFS LC_ALL LFS_TGT PATH CONFIG_SITE" >> ${LFS_HOME}/.bashrc
echo "" >> ${LFS_HOME}/.bashrc
echo "alias ls=\"ls --color\"" >> ${LFS_HOME}/.bashrc
