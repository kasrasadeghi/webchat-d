FROM ubuntu

RUN apt-get update && apt-get install -y build-essential git wget
RUN wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EBCF975E5BA24D5E
RUN apt-get update
RUN apt-get install -y dmd-compiler dub libssl1.0-dev libcrypto++ lld

RUN mkdir /home/setup
WORKDIR /home/setup
RUN dub init libapp -t vibe.d -n
WORKDIR /home/setup/libapp
RUN dub build
RUN rm -rf libapp

RUN git config --global user.email "kasra_sadeghi@homedepot.com"
RUN git config --global user.name "Kasra Sadeghi"

RUN bash
