FROM ubuntu
LABEL MAINTAINER="<loryu chinaloryu@gmail.com>"
RUN apt update && apt -qy upgrade && apt -qy install xz-utils openssh-server git openjdk-11-jdk gcc && \
    apt -qy clean all && sed -i 's|session    required     \
    pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && mkdir /app /go && \
    adduser --quiet jenkins && echo "jenkins:jenkins" | chpasswd
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys
COPY .env.sh /home/jenkins/
RUN chmod 600 /home/jenkins/.ssh/authorized_keys && chown -R jenkins.jenkins /home/jenkins && \
    chmod -R 777 /app /go
ADD https://go.dev/dl/go1.19.linux-amd64.tar.gz /tmp/
ADD https://nodejs.org/dist/v18.8.0/node-v18.8.0-linux-x64.tar.xz /tmp/
ADD https://github.com/gobuffalo/cli/releases/download/v0.18.8/buffalo_0.18.8_Linux_x86_64.tar.gz /tmp/
RUN cd /tmp/ && tar zxf go1.19.linux-amd64.tar.gz && tar xf node-v18.8.0-linux-x64.tar.xz && \
    tar zxf buffalo_0.18.8_Linux_x86_64.tar.gz && mv go /usr/local/ && \
    mv node-v18.8.0-linux-x64 /usr/local/node && \
    mv buffalo /usr/local/bin/buffalo
USER jenkins
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV NODE_HOME /usr/local/node
ENV PATH $PATH:$GOPATH/bin:$GOROOT/bin:$NODE_HOME/bin
WORKDIR /app
RUN corepack enable && yarn set version stable && yarn install
USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
