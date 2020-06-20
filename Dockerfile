FROM httpd
COPY index.html /usr/local/apache2/htdocs/index.html
RUN apt-get -y update
RUN apt-get -y upgrade
