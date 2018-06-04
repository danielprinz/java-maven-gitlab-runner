FROM gitlab/gitlab-runner:ubuntu-v10.8.0

# Install the latest jdk8 version
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install Maven 3.5.3
RUN curl --create-dirs --location --fail --show-error --silent --output /tmp/maven.tar.gz --url http://www-eu.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
  && tar -xv -C /tmp -f /tmp/maven.tar.gz \
  && mv /tmp/apache-maven-3.5.3 /opt/maven \
  && rm -f /tmp/maven.tar.gz
ENV M3_HOME=/opt/maven
ENV PATH=${M3_HOME}/bin:${PATH}

# Export variables so that gitlab-runner user can use them
ADD --chown=gitlab-runner:gitlab-runner data/.bash_profile /home/gitlab-runner/.bash_profile

# Setup Docker Client
RUN curl --create-dirs --location --fail --show-error --silent --output /tmp/docker.tgz --url https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/docker /usr/bin \
  && rm -rf /tmp/docker /tmp/docker

RUN curl --create-dirs --location --fail --show-error --silent --output /usr/bin/docker-compose --url https://github.com/docker/compose/releases/download/1.21.2/docker-compose-Linux-x86_64 \
  && chmod +x /usr/bin/docker-compose
