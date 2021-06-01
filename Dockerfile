#Getting base image for RISC-V emulation
FROM davidburela/riscv-emulator

MAINTAINER Arijit Das (arijitdas18022006@gmail.com)

#Basic apt-get's
RUN apt-get update && apt-get upgrade -y

#Installing dependencies for Edge Impulse Linux Python SDK 
RUN apt-get install -y python3-pip\
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