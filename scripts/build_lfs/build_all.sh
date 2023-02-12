#!/bin/bash

case $1 in
    before_bash)
        PKGS_LIST=$(cat pkgs-list1.sh)
        ;;
    after_bash)
        PKGS_LIST=$(cat pkgs-list2.sh)
        ;;
    *)
        PKGS_LIST=$(cat pkgs-list1.sh)
        ;;
esac

for each in $PKGS_LIST; do
    sh $each.sh
done
