FROM python:3.6

ARG pip_installer="https://bootstrap.pypa.io/get-pip.py"
ARG awscli_version="1.16.168"

# install aws-cli
RUN pip install awscli==${awscli_version}

# install sam
RUN pip install --user --upgrade aws-sam-cli
ENV PATH $PATH:/root/.local/bin

# install command.
RUN apt-get update && apt-get install -y less vim

# copy aws command.
COPY ./docker/aws-cli/cmd/code.sh /root/code.sh
COPY ./docker/aws-cli/cmd/bucket.sh /root/bucket.sh
COPY ./docker/aws-cli/cmd/cdn.sh /root/cdn.sh

# copy source code.
COPY ./src /src

WORKDIR /root
