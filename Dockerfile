FROM node:latest as base

ARG GROUPNAME=chillers
ARG USERNAME=forkman
ARG BASE_DIR=/usr/src/womb

# Create the main user
RUN groupadd $GROUPNAME && \
    useradd -g $GROUPNAME -m $USERNAME
# Grant the main user "sudo" access
RUN apt-get update --yes && \
    apt-get install -y sudo && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR $BASE_DIR

# Install system dependencies
RUN sudo apt-get -qq install --yes --quiet --no-install-recommends \
    git

# Install server dependencies
COPY --chown=$USERNAME:$GROUPNAME package.json .
RUN npm i

# Copy project files
COPY --chown=$USERNAME:$GROUPNAME . .

FROM base AS dev
CMD ["/bin/sh", "-c", "while sleep 1000; do :; done"]