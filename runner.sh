#! /usr/bin/env bash
#
# Copyright © 2020 Maestro Creativescape
#
# SPDX-License-Identifier: GPL-3.0
#
# Script to use uupdump.ml and build the latest windows ISO

echo "**MaestroCI UUP Dumper**"
rclone config file
resp="$(curl -sL --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://gitlab.com/api/v4/projects/19953649/repository/files/rclone-onedrive.conf?ref=master")"
echo $(base64 -di <<< $(echo $resp | jq 'content')) > /root/.config/rclone/rclone.conf
echo "**Pulled Rclone Config for OneDrive (Amrita)**"

if [[ -n "$BUILD_ID" ]]; then
    python3 uupdump.py $EDITION $BUILD_ID
    RESULT=$?
    if [ "$RESULT" -eq 0 ]; then
        mkdir windows && unzip windows.zip -d windows
        cd windows
        while true; do echo "Building Windows ISO....."; sleep 120; done &
        bash uup_download_linux.sh
        RESULT2=$?
        if [ "$RESULT2" -eq 0 ]; then
            FILE_NAME=$(ls | grep *.ISO)
            OLD_FILE_NAME=$FILE_NAME
            FILE_NAME=$(echo $FILE_NAME | awk -F'.ISO' '{print $1}')
            FILE_NAME=$(echo $FILE_NAME | sed "s/$FILE_NAME/$FILE_NAME-$(date +"%m%d%y+%H%M")/g")
            FILE_NAME="$FILE_NAME.ISO"
            mv $OLD_FILE_NAME $FILE_NAME
            rclone copy $FILE_NAME onedrive-amrita:/Windows/$edition
            echo '**I have pushed the file to https://amritavishwavidyapeetham-my.sharepoint.com/:f:/g/personal/cb_en_u4cse17613_cb_students_amrita_edu/EgisFNe7q_pHm2vhia3D5SgBmDMzC38b_CprVjC90qBSLg?e=Dvvtye**'
        fi
    fi
    jobs
    kill %1
else
    for edition in x64 x86 arm64; do
    echo "I am dumping $edition edition!"
    cd /app
    python3 uupdump.py $edition
    RESULT=$?
    if [ "$RESULT" -eq 0 ]; then
        mkdir windows && unzip windows.zip -d windows
        cd windows
        while true; do echo "Building Windows ISO....."; sleep 120; done &
        bash uup_download_linux.sh
        RESULT2=$?
        if [ "$RESULT2" -eq 0 ]; then
            FILE_NAME=$(ls | grep *.ISO)
            OLD_FILE_NAME=$FILE_NAME
            FILE_NAME=$(echo $FILE_NAME | awk -F'.ISO' '{print $1}')
            FILE_NAME=$(echo $FILE_NAME | sed "s/$FILE_NAME/$FILE_NAME-$(date +"%m%d%y+%H%M")/g")
            FILE_NAME="$FILE_NAME.ISO"
            mv $OLD_FILE_NAME $FILE_NAME
            rclone copy $FILE_NAME onedrive-amrita:/Windows/$edition
            echo '**I have pushed the file to https://amritavishwavidyapeetham-my.sharepoint.com/:f:/g/personal/cb_en_u4cse17613_cb_students_amrita_edu/EgisFNe7q_pHm2vhia3D5SgBmDMzC38b_CprVjC90qBSLg?e=Dvvtye**'
            cd ..
            rm -rf windows windows.zip
            git add .
            git commit -m "[MaestroCI]: UUP Dumped on $(date +"%m-%d-%y")" --signoff
            git remote rm origin
            git remote add origin https://baalajimaestro:${GITLAB_TOKEN}@gitlab.com/baalajimaestro/uupdumper.git/
            git push origin master
            jobs
            kill %1
            # Exit and let the next build take over!
            exit 0
        else
            jobs
            kill %1
            echo "Building Edition $edition has failed!"
        fi
    else
        echo "Not attempting to dump $edition, maybe the newest edition is already dumped?"
    fi
    done
fi