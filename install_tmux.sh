tmux_version=2.5
libevent_version=2.1.8

if [ $# -lt 1 ]; then
    echo "please specify the install path"
    exit
fi


install_path=$1 # 实际安装的地址

# 创建临时目录，用于下载东西
tmp_dir=cwb_install.tmux.tmp.dir
rm -rf $tmp_dir
mkdir -p $tmp_dir
cd $tmp_dir


# 安装libevent
function install_libevent() {
    if [ -f libevent.tar.gz ]; then
        echo "libevent already downloaded"    
    else
    wget https://github.com/libevent/libevent/releases/download/release-$libevent_version-stable/libevent-$libevent_version-stable.tar.gz -O libevent.tar.gz
    fi
    tar xzvf libevent.tar.gz
    cd libevent-$libevent_version-stable/
    ./configure --prefix=$install_path
    make -j4
    make install
    cd -
}


# 安装tmux
function install_tmux() {
    if [ -f tmux.tar.gz ]; then
        echo "tmux already downloaded"
    else
        wget https://github.com/tmux/tmux/releases/download/$tmux_version/tmux-$tmux_version.tar.gz -O tmux.tar.gz
    fi
    tar xzvf tmux.tar.gz
    cd tmux-$tmux_version
    CFLAGS="-I$install_path/include" LDFLAGS="-L$install_path/lib" ./configure --prefix=$install_path
    make -j4
    make install
    cd -
}
cd ..

function cp_configure() {
    cp tmux.conf ~/.tmux.conf
}

install_libevent
install_tmux
cp_configure

echo "
please add following commands to ~/.bashrc and then run source ~/.bashrc
---
alias tmux='LD_LIBRARY_PATH=$install_path/lib $install_path/bin/tmux -2'
"
rm -rf libevent.tar.gz tmux.tar.gz 
