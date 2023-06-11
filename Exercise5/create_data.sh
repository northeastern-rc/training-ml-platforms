# Expects DIR imagenet_tar with files ILSVRC2012_img_val.tar and ILSVRC2012_img_train.tar
# https://image-net.org/challenges/LSVRC/2012/2012-downloads.php
# wget https://image-net.org/data/ILSVRC/2012/ILSVRC2012_img_train.tar 
        # 138GB. MD5: 1d675b47d978889d74fa0da5fadfb00e
# wget https://image-net.org/data/ILSVRC/2012/ILSVRC2012_img_val.tar
        # 6.3GB. MD5: 29b22e2961454d5413ddabcf34fc5622
# Prefer to download via download manager like Free Download Manager

if [ ! -d imagenet_tar ]
then
     mkdir -p imagenet_tar
     echo "Creating imagenet_tar"
fi

if [ ! -f imagenet_tar/ILSVRC2012_img_train.tar ]
then
    cd imagenet_tar
    echo "Downloading ILSVRC2012_img_train.tar"
    wget https://image-net.org/data/ILSVRC/2012/ILSVRC2012_img_train.tar
    cd -
fi

if [ ! -f imagenet_tar/ILSVRC2012_img_val.tar ]
then
    cd imagenet_tar
    echo "Downloading ILSVRC2012_img_val.tar"
    wget https://image-net.org/data/ILSVRC/2012/ILSVRC2012_img_val.tar
    cd - 
fi

#Manually verify MD5 with hash given on top
# md5sum ILSVRC2012_img_train.tar 
# md5sum ILSVRC2012_img_val.tar 

#Train
if [ ! -d imagenet_untar/train ]
then
    echo "Creating imagenet_untar/train"
    mkdir -p imagenet_untar/train
    tar -xvf imagenet_tar/ILSVRC2012_img_train.tar -C imagenet_untar/train/
    cd imagenet_untar/train/
    for file in  ls *tar
    do
        dir_name=`echo $file | cut -f 1 -d '.'` 
        mkdir $dir_name
        tar -xvf $file -C $dir_name
        rm -rf $file
    done
    cd -
fi

#Val
if [ ! -d imagenet_untar/val ]
then
    echo "Creating imagenet_untar/val"
    mkdir -p imagenet_untar/val
    tar -xvf imagenet_tar/ILSVRC2012_img_val.tar -C imagenet_untar/val
    cp valprep.sh imagenet_untar/val
    cd imagenet_untar/val
    source valprep.sh
    rm valprep.sh
    cd -
fi





