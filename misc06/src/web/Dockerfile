FROM alpine:3.18 AS unzipper
RUN apk add --update unzip wget

WORKDIR /tmp
RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
RUN unzip -u -o /tmp/platform-tools-latest-linux.zip -d /

FROM python:3.12

COPY --from=unzipper /platform-tools/adb /usr/bin/adb

COPY requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /src
COPY . .

CMD ["python3", "app.py"]
