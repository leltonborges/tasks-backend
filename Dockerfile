FROM tomcat:9.0.52-jdk11-openjdk-buster
#FROM tomcat:8.5.50-jdk8-openjdk

ARG PATH_WAR_FILE
ARG CONTEXT_NAME

COPY ${PATH_WAR_FILE} /usr/local/tomcat/webapps/${CONTEXT_NAME}.war
