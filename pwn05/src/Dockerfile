FROM cybersecnatlab/challenge-jail@sha256:c6ca5b83f35e1c3bc63b08db1ceecd8d10e4a1a46d4f24ee45e9f12bdbac990b

# Update and install packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y \
    --no-install-recommends --no-install-suggests \
    qemu-system-x86 python3
