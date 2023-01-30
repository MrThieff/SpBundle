#!/usr/bin/env bash

MAGENTA="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[34m\]"
LIGHT_GRAY="\[\033[0;37m\]"
GREEN="\[\033[0;32m\]"

_YELLOW="\[\033[38;5;11m\]"
_GREEN="\[\033[38;5;34m\]"
_LIGHT_GRAY="\[\033[0;37m\]"

export PS1=$BLUE"\u"$YELLOW"@"$BLUE"\h"$YELLOW"["$GREEN"\w"$YELLOW"]"'[docker]'$GREEN": "$_LIGHT_GRAY

# We mount folder "/ssh-keys" to use SSH keys for access to private git repositories
# Env "DOCKER_PHP__SSH_IDENTITY_FILE" is used to run SSH agent in container
SSH_IDENTITY_FILE_SOURCE=/ssh-keys/${DOCKER_PHP__SSH_IDENTITY_FILE}
SSH_IDENTITY_DIR_DIST=${HOME}/.ssh
SSH_IDENTITY_FILE_DIST=${SSH_IDENTITY_DIR_DIST}/id_rsa

mkdir -p ${SSH_IDENTITY_DIR_DIST} \
    && cp ${SSH_IDENTITY_FILE_SOURCE} ${SSH_IDENTITY_FILE_DIST} \
    && chmod -R 600 ${SSH_IDENTITY_FILE_DIST} \
    && cp /root/ssh.config /root/.ssh/config && chmod 600 /root/.ssh/config \
    && eval $("ssh-agent") \
    && ssh-add ${SSH_IDENTITY_FILE_DIST}
