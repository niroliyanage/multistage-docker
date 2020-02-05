FROM openjdk:9-jdk-slim as artifact
RUN apt-get update \
    && apt-get install --no-install-recommends -y -qq ca-certificates-java
COPY certificates /usr/local/share/ca-certificates/certificates.crt 
RUN update-ca-certificates && \
    chmod -R 777 /etc/ssl/certs \
    && chmod 666 /etc/default/cacerts
 

FROM artifact as final
WORKDIR /home/java
COPY --from=artifact /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=artifact  /etc/ssl/certs/java/cacerts /etc/ssl/certs/java/cacerts
RUN groupadd --gid 1000 java &&\
    useradd --uid 1000 --gid java --shell /bin/bash --create-home java && \
    chmod -R a+w /home/java &&
