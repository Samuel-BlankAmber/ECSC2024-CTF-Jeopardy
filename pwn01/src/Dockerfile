FROM cybersecnatlab/challenge-jail@sha256:0cb5904e8920a11f6f9bb5e4f14e35a656dec6d08e2ceca725e0cac1eeb387ae
WORKDIR /app
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev libmpdec-dev
RUN git clone --depth 1 --branch v3.12.6 https://github.com/python/cpython.git
# Why this, you may ask?
# Yes, python is built on debian and ubuntu with ASLR disabled.
RUN cd cpython && ./configure CFLAGS="-fpie -fPIC -fstack-protector-strong"
RUN cd cpython && make -j && make install

COPY setup.py yapmodule.c ./
RUN pip3 install .

