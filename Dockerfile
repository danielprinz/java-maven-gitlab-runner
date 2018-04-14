# Use slim version without ui related stuff
FROM gitlab/gitlab-runner:ubuntu-v10.6.0

# Install add-apt-repository - this is needed because gitlab-runner still uses 14.04 and we want to get the latest jdk8 version
RUN  apt-get update && apt-get install -y software-properties-common python-software-properties

# Install latest Jdk 8
RUN add-apt-repository ppa:openjdk-r/ppa && \
  apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Fix certificate issues, found as of
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
RUN apt-get update && \
  apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

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
RUN curl --create-dirs --location --fail --show-error --silent --output /tmp/docker.tgz --url https://download.docker.com/linux/static/stable/x86_64/docker-17.12.0-ce.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/docker /usr/bin \
  && rm -rf /tmp/docker /tmp/docker

RUN curl --create-dirs --location --fail --show-error --silent --output /usr/bin/docker-compose --url https://github.com/docker/compose/releases/download/1.18.0/docker-compose-Linux-x86_64 \
  && chmod +x /usr/bin/docker-compose
