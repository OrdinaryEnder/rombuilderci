echo "Build Started."
cd ~/
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
cat > ~/.profile << EOF
# add Android SDK platform tools to path
if [ -d "$HOME/platform-tools" ] ; then
    PATH="$HOME/platform-tools:$PATH"
fi
EOF
cd ~/
git clone https://github.com/akhilnarang/scripts
cd scripts
./setup/android_build_env.sh
mkdir -p ~/android
if [ -d "$HOME/.local/bin" ] ; then
   mkdir -p ~/.local/bin
fi
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.local/bin/repo
chmod a+x ~/.local/bin/repo
git config --global user.email "root@localhost"
git config --global user.name "Who am i?"
git config --global color.ui true
cd ~/android
repo init -u https://github.com/Gofaraway71/android_manifest -b 13 --git-lfs
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
git clone https://github.com/Task-Force-Team/device_xiaomi_camellia/ -b thirteen ~/android/device/xiaomi/camellia
git clone https://github.com/dm700-devs/device_xiaomi_camellia-kernel -b thirteen ~/android/kernel/xiaomi/camellia
git clone https://github.com/dm700-devs/vendor_xiaomi_camellia -b thirteen ~/android/vendor/xiaomi/camellia
source build/envsetup.sh
breakfast camellia
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G
croot
brunch camellia | tee log.txt
