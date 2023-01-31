FROM ubuntu:22.04

# group name, user name, and password of the user where LFS is built.
ENV LFS_USER_NAME=lfs
ENV LFS_GROUP_NAME=lfs
ENV LFS_USER_PASSWORD=lfs
ENV LFS_HOME=/home/${LFS_USER_NAME}

# environment variables for building LFS
ENV LFS=${LFS_HOME}/lfs_root
ENV LFS_MOUNT_POINT=/mnt/lfs
ENV LFS_TGT=x86_64-lfs-linux-gnu
ENV PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin
# I have a CPU with 8 cores and 16 threads
ENV JOB_COUNT=16
ENV MAKEFLAGS="-j ${JOB_COUNT}"
ENV LC_ALL=POSIX
ENV PATH=/usr/bin:/bin:/usr/sbin:/sbin:${LFS}/tools/bin
ENV CONFIG_SITE=${LFS}/usr/share/config.site

# We use bash instead of dash as sh
RUN rm -f /bin/sh && ln -sv /bin/bash /bin/sh 

# install required packages
RUN apt-get update && apt-get install -y    \
    build-essential \
    coreutils   \
    bison   \
    file    \
    gawk    \
    texinfo    \
    wget    \
    libssl-dev  \
    libelf-dev  \
    python3

# create user with "lfs" as its name and password
RUN groupadd ${LFS_GROUP_NAME}
RUN useradd -s /bin/bash -g ${LFS_GROUP_NAME} -m -k /dev/null \
    ${LFS_USER_NAME} -p ${LFS_USER_PASSWORD} 

# build basic root structure of lfs
WORKDIR ${LFS}
RUN for i in etc var tools; do                  \
        mkdir -pv ${LFS}/$i;                    \
        chown -v ${LFS_USER_NAME} ${LFS}/$i;    \
    done
RUN mkdir -pv ${LFS}/usr && chown -v ${LFS_USER_NAME} ${LFS}/usr 
RUN for i in bin lib sbin; do       \
        mkdir -pv ${LFS}/usr/$i;    \
        chown -v ${LFS_USER_NAME} ${LFS}/usr/$i;\
        ln -sv usr/$i ${LFS}/$i;    \
        chown -v ${LFS_USER_NAME} ${LFS}/$i;    \
    done

# my computer is 64 bits
RUN mkdir -pv ${LFS}/lib64 && chown -v ${LFS_USER_NAME} ${LFS}/lib64

# create a directory to store packages and make it sticky
RUN mkdir -v ${LFS_HOME}/sources && chmod -v a+wt ${LFS_HOME}/sources

# copy scripts to be running in user "lfs"
COPY [ "scripts/*", "${LFS_HOME}/" ]
RUN chmod 775 ${LFS_HOME}/env_setting.sh && \
    chown -v ${LFS_USER_NAME} ${LFS_HOME}/env_setting.sh && \
    sh ${LFS_HOME}/env_setting.sh

# enter user "lfs"
USER ${LFS_USER_NAME}
WORKDIR ${LFS_HOME}

# copy source files or list of urls to download them
COPY [ "sources/pkgs/*", "${LFS_HOME}/pkgs/" ]

# create a directory as the base dir for building packages.
RUN mkdir -pv ${LFS_HOME}/build


# Enter the bash
ENTRYPOINT [ "/bin/bash" ]