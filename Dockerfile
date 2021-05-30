FROM davidburela/riscv-emulator

MAINTAINER Arijit Das (arijitdas18022006@gmail.com)

RUN apt install python3-pip git 

RUN git clone https://v8-riscv/node.git
    cd node
    git checkout riscv64-dev

