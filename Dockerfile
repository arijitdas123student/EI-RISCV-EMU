#Getting base image for RISC-V emulation
FROM debian:sid
EXPOSE 2222

MAINTAINER Arijit Das (arijitdas18022006@gmail.com)

# Install all needed packages
RUN apt-get update && \
apt-get install -y --no-install-recommends ca-certificates git wget build-essential ninja-build libglib2.0-dev libpixman-1-dev u-boot-qemu unzip && \
# clean up the temp files
apt-get autoremove -y && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Download and configure QEMU
WORKDIR "/root"
RUN git clone https://github.com/qemu/qemu && \ 
mkdir /root/qemu/build  && cd /root/qemu/build && \
# build and install
../configure --target-list=riscv64-softmmu && make -j3 && make install && \
# clean up the git repo and build artifacts after installed
rm /root/qemu -r

# Get RISC-V Debian image
WORKDIR "/root"
RUN wget https://gitlab.com/api/v4/projects/giomasce%2Fdqib/jobs/artifacts/master/download?job=convert_riscv64-virt -O artifacts.zip && \
unzip artifacts.zip && rm artifacts.zip

#Basic apt-get's
RUN apt-get update && apt-get upgrade -y

#Installing dependencies for Edge Impulse Linux Python SDK 
RUN apt-get install -y python3-pip \
    git 

#Installing edge_impulse_linux python example repository
RUN git clone https://github.com/edgeimpulse/linux-sdk-python 

#Installing pyaudio to replace error caused by requirements.txt
RUN apt-get install -y python3-pyaudio

#Into the folder and installing dependencies
RUN cd linux-sdk-python && pip3 install -r requirements.txt
    
#Into the folder and running audio example
RUN cd linux-sdk-python/examples/audio \
    python3 classify.py    
    
CMD qemu-system-riscv64 -smp 2 -m 2G -cpu rv64 -nographic -machine virt -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf -device virtio-blk-device,drive=hd -drive file=artifacts/image.qcow2,if=none,id=hd -device virtio-net-device,netdev=net -netdev user,id=net,hostfwd=tcp::2222-:22 -object rng-random,filename=/dev/urandom,id=rng -device virtio-rng-device,rng=rng -append "root=LABEL=rootfs console=ttyS0"
