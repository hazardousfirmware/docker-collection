FROM fedora:42

ARG USER_ID=1000

RUN dnf update -y && \
    dnf install -y gcc gcc-c++ cmake git make patch \
                   intel-igc intel-igc-devel intel-igc-libs \
                   intel-gmmlib intel-gmmlib-devel && \
    useradd -m -s /bin/bash -u ${USER_ID} user && \
    dnf clean all && \
    mkdir -p /project
COPY compile-application.sh /opt/
RUN chmod 0755 /opt/compile-application.sh
ENV TERM=xterm-256color
USER user
RUN echo "export PS1='\[\033[01;32m\][\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;32m\]]\[\033[01;34m\]\$\[\033[00m\] '" >> $HOME/.bashrc && \
    echo "alias ls='ls --color=auto'" >> $HOME/.bashrc && \
    echo "alias grep='grep --color=auto'" >> $HOME/.bashrc
WORKDIR /project
CMD ["/opt/compile-application.sh"]
