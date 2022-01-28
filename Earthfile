VERSION 0.6
FROM alpine:3.12
RUN  \
  # sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
  apk update \
  && apk upgrade \
  && apk add ca-certificates \
  && update-ca-certificates \
  && apk add --update openjdk8-jre tzdata curl unzip bash \
  && apk add --no-cache nss \
  && rm -rf /var/cache/apk/* \

WORKDIR /jmeter

# build jmeter image with given JMETER_VERSION argument
build:
  # TODO: update this ARG accordingly
  ARG IMAGE_NAME="railflow/jmeter"
  ARG TEMP_DIR="/tmp/dependencies"
  # In order to leverage the cache, moved those unchanging directions ahead
  ARG TZ="Europe/Amsterdam"
  ENV TZ ${TZ}
  # Entrypoint has same signature as "jmeter" command
  COPY entrypoint.sh /
  
  # TODO: update this 
  ENV CUSTOM_JAR_URL https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.2.1.tgz.asc
  # download the customer jar file
  RUN mkdir -p ${TEMP_DIR}  \
  && curl -L --silent ${CUSTOM_JAR_URL} > ${TEMP_DIR}/customer.jar

  ARG JMETER_VERSION="5.4.3"
  ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
  ENV	JMETER_BIN	${JMETER_HOME}/bin
  ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
  RUN curl -L --silent ${JMETER_DOWNLOAD_URL} >  ${TEMP_DIR}/apache-jmeter-${JMETER_VERSION}.tgz  \
    && mkdir -p /opt  \
    && tar -xzf ${TEMP_DIR}/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
    && cp ${TEMP_DIR}/customer.jar ${JMETER_HOME}/lib/ext/
  RUN rm -rf ${TEMP_DIR}
  COPY boot/plugins/* ${JMETER_HOME}/lib/ext/
  COPY boot/data ${JMETER_HOME}/
  COPY boot/scripts ${JMETER_HOME}/
  COPY boot/license ${JMETER_HOME}/
  # Set global PATH such that "jmeter" command is found
  ENV PATH $PATH:$JMETER_BIN
  EXPOSE 1099
  ENTRYPOINT ["/entrypoint.sh"]
  # Save the image
  SAVE IMAGE --push ${IMAGE_NAME}:${JMETER_VERSION}

# Build jmeter images with given JMETER_VERSION_LIST, calls 'build' target for each version
buildAll:
  # TODO: add versions here
  ARG JMETER_VERSION_LIST="5.2 5.2.1 5.3 5.4 5.4.1 5.4.2 5.4.3"
  FOR v IN ${JMETER_VERSION_LIST}
    BUILD +build --JMETER_VERSION=${v}
  END