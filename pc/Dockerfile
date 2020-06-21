FROM centos:latest
#RUN yum -y update
RUN yum -y install java-1.8.0-openjdk bash mariadb
EXPOSE 8080
ENV VERSION 2.1.0
ENV PASSWORD petclinic
ENV USER root
RUN mkdir -p /app/target
COPY target /app/target
COPY scripts/runpc /app/runpc
RUN chmod 755 /app/runpc
COPY application.properties /app
COPY application.properties /app/target
ENTRYPOINT /app/runpc
