FROM cybersecnatlab/challenge-jail:ubuntu-noble@sha256:245f0de5bf5f9e9030dca9d9450672eea8d39474ea78a7902b93dff60f9060ad

RUN apt-get update

RUN apt install python3 python3-pip ffmpeg libsm6 libxext6 gfortran libzbar-dev -y

RUN pip3 install pyzbar opencv-python pillow --break-system-packages
