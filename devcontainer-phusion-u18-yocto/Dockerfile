FROM ngenetzky/phusion-u18-yocto:20201105-7e3afc3

ENTRYPOINT ["/sbin/my_init", "--quiet", "--skip-startup-files", "--", "/dockcross/entrypoint.sh"]
CMD [ "executable" ]

RUN \
    set -x && \
    # apt packages
    apt-get update --yes && \
    apt-get install --no-install-recommends --yes \
        yadm \
        zsh \
    && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean --yes && \
    rm -rf /var/lib/apt/lists/* && \
    \
    # python3 packages
    python3 -m pip install --no-cache-dir --disable-pip-version-check \
        tmuxp \
        kas

# Configuration for default non-root user.
ARG USER_NAME='user'
ARG USER_UID='1000'
ARG USER_GID="$USER_UID"
ARG USER_SHELL='/bin/bash'
RUN \
    # User configuration
    printf "### Building image for user %s (%s:%s) ###" \
        "${USER_NAME}" \
        "${USER_UID}" \
        "${USER_GID}" && \
    #
    # Create a non-root user.
    groupadd --gid "$USER_GID" \
        "$USER_NAME" && \
    useradd --create-home --shell "${USER_SHELL}" \
        --uid "${USER_UID}" --gid "${USER_GID}" \
        "${USER_NAME}"

ENV BUILDER_USER='user'
ENV BUILDER_UID="$USER_UID"
ENV BUILDER_GID="$USER_UID"
