FROM tirasmuturi/sample-docker-php-nginx:base

# Environment variables for website
ENV CONSUL_HTTP_ADDR ${CONSUL_HTTP_ADDR}
ENV BUILD_ENVIRONMENT ${BUILD_ENVIRONMENT}
ENV BUILD_PATH ${BUILD_PATH}


# SET THE WORK DIRECTORY.
WORKDIR /var/www
COPY . /var/www

# KICKSTART!
CMD ["/start.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/ping