#! /usr/bin/env bash

echo "**MaestroCI UUP Dumper**"
mkdir -p /root/.ssh
curl -sL -u baalajimaestro:$GH_PERSONAL_TOKEN -o /root/.ssh/id_ed25519 https://raw.githubusercontent.com/baalajimaestro/keys/master/id_ed25519
chmod 600 ~/.ssh/id_ed25519
echo "SSH Keys Set!"

while true; do echo "Building Windows ISO....."; sleep 120; done &
for edition in x64 x86 arm64; do
echo "I am dumping $edition edition!"
cd /app
python3 uupdump.py $edition
RESULT=$?
if [ "$RESULT" -eq 0 ]; then
    mkdir windows && unzip windows.zip -d windows
    cd windows
    bash aria2_download_linux.sh
    RESULT2=$?
    if [ "$RESULT2" -eq 0 ]; then
          FILE_NAME=$(ls | grep *.ISO)
          OLD_FILE_NAME=$FILE_NAME
          FILE_NAME=$(echo $FILE_NAME | awk -F'.ISO' '{print $1}')
          FILE_NAME=$(echo $FILE_NAME | sed "s/$FILE_NAME/$FILE_NAME-$(date +"%m%d%y+%H%M")/g")
          FILE_NAME="$FILE_NAME.ISO"
          mv $OLD_FILE_NAME $FILE_NAME
          scp  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r $FILE_NAME baalaji20@storage.osdn.net:/storage/groups/b/ba/baalajimaestrobuilds/windows/$edition
          cd ..
          rm -rf windows windows.zip
          git add .
          git commit -m "[MaestroCI]: UUP Dumped on $(date +"%m-%d-%y")" --signoff
          git remote rm origin
          git remote add origin https://baalajimaestro:${GH_PERSONAL_TOKEN}@github.com/baalajimaestro/uupdumper
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