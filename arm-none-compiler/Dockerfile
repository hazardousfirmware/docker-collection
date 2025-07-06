FROM debian:sid-slim

ARG USER_ID=1000

RUN apt update && \
    apt upgrade -y && \
    apt install -y gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    cmake \
    make \
    bash bash-completion \
    python3 \
    openocd && \
    useradd -m -s /bin/bash -u ${USER_ID} user && \
    apt clean all && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /project
ENV TERM=xterm-256color
USER user
RUN echo "export PS1='\[\033[01;32m\][\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;32m\]]\[\033[01;34m\]\$\[\033[00m\] '" >> $HOME/.bashrc && \
    echo "alias ls='ls --color=auto'" >> $HOME/.bashrc && \
    echo "alias grep='grep --color=auto'" >> $HOME/.bashrc
WORKDIR /project
CMD ["/bin/bash"]
