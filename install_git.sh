version=2.14.0
if [ $# -lt 1 ]; then 
    echo "please specify the install path"
    exit
fi
install_path=$1
tmpdir=cwb.installgit.tmp
rm -rf $tmpdir
mkdir -p $tmpdir
cd $tmpdir
wget https://github.com/git/git/archive/v$version.tar.gz -O git.tar.gz
tar xzvf git.tar.gz
cd git-$version
make configure
./configure --prefix=$install_path
make -j4
make install

echo "
    please add following lines to ~/.bashrc and run source ~/.bashrc

    alias git='$install_path/bin/git'
"
