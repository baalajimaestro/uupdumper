#! /usr/bin/env bash

ssh_keys() {
  echo "**MaestroCI UUP Dumper**"
  mkdir -p /root/.ssh
  curl -sL -u baalajimaestro:$GH_PERSONAL_TOKEN -o /root/.ssh/id_ed25519 https://raw.githubusercontent.com/baalajimaestro/keys/master/id_ed25519
  chmod 600 ~/.ssh/id_ed25519
  echo "SSH Keys Set!"
}

for edition in x64,x86,arm64; do
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
          scp  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r *.ISO baalaji20@storage.osdn.net:/storage/groups/b/ba/baalajimaestrobuilds/windows/$edition
          cd ..
          rm -rf windows windows.zip
          git add .
          git commit -m "[MaestroCI]: UUP Dumped on $(date +"%m-%d-%y")" --signoff
          git remote rm origin
          git remote add origin git@github.com:baalajimaestro/uupdumper
          git push origin master
          # Exit and let the next build take over!
          exit 0
    else
        echo "Building Edition $edition has failed!"
    fi
else
    echo "Not attempting to dump $edition, maybe the newest edition is already dumped?"
fi
done