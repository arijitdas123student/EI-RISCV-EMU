#Getting base image for RISC-V emulation
FROM davidburela/riscv-emulator

MAINTAINER Arijit Das (arijitdas18022006@gmail.com)

#Installing dependencies for Edge Impulse Linux 
RUN apt install python3-pip git 

#Installing edge_impulse_linux python packages and example repository
RUN pip3 install edge_impulse_linux
    git clone https://github.com/edgeimpulse/linux-sdk-python
    