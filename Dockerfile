FROM jhipster/jhipster:v6.10.5 AS runner

RUN cd /home/jhipster && \
    git clone https://github.com/Synqcom/generator-jhipster-quarkus.git && \
    cd generator-jhipster-quarkus && \
    git checkout develop

RUN cd /home/jhipster/generator-jhipster-quarkus && \
    echo jhipster | sudo -S npm link

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/jhipster"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN echo jhipster | sudo -S mkdir -p /usr/share/maven /usr/share/maven/ref
RUN echo jhipster | sudo -S chmod 777 /usr/share/maven
RUN echo jhipster | sudo -S chmod 777 /usr/share/maven/ref

RUN curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && echo jhipster | sudo -S ln -s /usr/share/maven/bin/mvn /usr/bin/mvn



ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mvn", "--version"]

ADD ./dep-stuff /home/jhipster/prefetch
RUN cd /home/jhipster/prefetch && mvn dependency:go-offline

RUN echo jhipster | sudo -S chmod 777 ~/.config -R
