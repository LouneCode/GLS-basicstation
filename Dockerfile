ARG REMOTE_TAG=2.0.6.1
ARG VARIANT=std

FROM ubuntu:18.04 as builder

ARG REMOTE_TAG
ARG VARIANT

ENV container=docker TERM=xterm LC_ALL=en_US LANGUAGE=en_US LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# locale
RUN apt-get update -q > /dev/null && \
        apt-get install --no-install-recommends -yq apt-utils locales language-pack-en dialog \
        > /dev/null && \
        locale-gen $LANGUAGE $LANG && \
        apt-get install --no-install-recommends -yq \
        git curl psmisc build-essential manpages-dev ca-certificates && \
        update-ca-certificates

# Work dir for GLS Basic Station
WORKDIR /app

# Checkout and compile remote code
COPY builder/* ./
RUN chmod +x *.sh
RUN REMOTE_TAG=${REMOTE_TAG} VARIANT=${VARIANT} ./build.sh

FROM ubuntu:18.04 as runner
ARG REMOTE_TAG
ARG VARIANT

ENV container=docker TERM=xterm LC_ALL=en_US LANGUAGE=en_US LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# locale
# sudo commmand
# non-privileged user
# remove apt cache
RUN apt-get update -q > /dev/null && \
        apt-get install --no-install-recommends -yq jq apt-utils locales language-pack-en dialog \
        > /dev/null && \
        locale-gen $LANGUAGE $LANG && \
        apt-get -yq install sudo > /dev/null && \
        echo "nonprivuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
        useradd --no-log-init --home-dir /home/nonprivuser --create-home --shell /bin/bash -u 1000 \
        nonprivuser && adduser nonprivuser sudo && \
        rm -rf /var/lib/apt/lists/*

# Work dir for GLS Basic Station
WORKDIR /app

# Copy fles from builder and repo
COPY --from=builder /app/basicstation/build-corecell-${VARIANT}/bin/* ./design-corecell/bin/
COPY runner/* ./

# Set nonpriv user env
RUN chmod +x *.sh && \
    chown -R nonprivuser /app && \
    usermod -a -G dialout nonprivuser

USER nonprivuser

# Launch our binary on container startup.
ENTRYPOINT ["/app/start.sh"]