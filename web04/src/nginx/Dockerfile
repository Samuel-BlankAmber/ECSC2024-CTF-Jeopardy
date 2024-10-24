FROM cache.ecsc2024.it/library/nginx:1.27

RUN apt-get update && apt-get install -y apache2-utils

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
