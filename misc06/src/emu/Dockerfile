# Copyright 2021 - The Android Open Source Project
#
# Licensed under the Apache License, Version 2_0 (the "License");
# you may not use this file except in compliance with the License_
# You may obtain a copy of the License at
#
#     http://www_apache_org/licenses/LICENSE-2_0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied_
# See the License for the specific language governing permissions and
# limitations under the License_
FROM alpine:3.18 AS unzipper
RUN apk add --update unzip wget

WORKDIR /tmp

RUN wget https://dl.google.com/android/repository/sys-img/android/x86_64-34_r03.zip
RUN unzip -u -o /tmp/x86_64-34_r03.zip -d /sysimg/

RUN wget https://dl.google.com/android/repository/emulator-linux_x64-12325540.zip
RUN unzip -u -o /tmp/emulator-linux_x64-12325540.zip -d /

RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
RUN unzip -u -o /tmp/platform-tools-latest-linux.zip -d /

FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu20.04
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

# Now we configure the user account under which we will be running the emulator
RUN mkdir -p /android/sdk/platforms && \
    mkdir -p /android/sdk/platform-tools && \
    mkdir -p /android/sdk/system-images

COPY --from=unzipper /platform-tools/adb /android/sdk/platform-tools/adb

ENV ANDROID_SDK_ROOT /android/sdk
WORKDIR /android/sdk
COPY --from=unzipper /sysimg/ /android/sdk/system-images/android/
RUN chmod +x /android/sdk/platform-tools/adb

# Install all the required emulator dependencies.
# pulse audio is needed due to some webrtc dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends \
# Emulator & video bridge dependencies
    libc6 libdbus-1-3 libfontconfig1 libgcc1 \
    libpulse0 libtinfo5 libx11-6 libxcb1 libxdamage1 \
    libnss3 libxcomposite1 libxcursor1 libxi6 \
    libxext6 libxfixes3 zlib1g libgl1 pulseaudio socat \
    iputils-ping \
# Enable turncfg through usage of curl
    curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  mkdir -p /android-home

COPY launch-emulator.sh /android/sdk/
COPY default.pa /etc/pulse/default.pa

RUN gpasswd -a root audio && \
    chmod +x /android/sdk/launch-emulator.sh

COPY --from=unzipper /emulator /android/sdk/emulator
COPY avd/ /android-home

EXPOSE 5554
EXPOSE 5555
EXPOSE 8554

WORKDIR /android/sdk

CMD ["/android/sdk/launch-emulator.sh"]

HEALTHCHECK --interval=30s \
            --timeout=30s \
            --start-period=30s \
            --retries=3 \
            CMD /android/sdk/platform-tools/adb shell getprop dev.bootcomplete | grep "1"
