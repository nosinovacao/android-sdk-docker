FROM anapsix/alpine-java:8_jdk

RUN mkdir opt cd /opt

RUN mkdir android-sdk-linux && cd android-sdk-linux/

RUN apk update \
  openjdk-8-jdk \
  wget \
  expect \
  zip \
  unzip \
  git \
  curl \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
RUN wget https://dl.google.com/android/repository/tools_r25.2.5-linux.zip

RUN unzip tools_r25.2.5-linux.zip -d /opt/android-sdk-linux

RUN rm -rf tools_r25.2.5-linux.zip

ENV ANDROID_HOME /opt/android-sdk-linux
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'

# SDKs
RUN echo y | android update sdk --no-ui --all --filter android-29 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-28 | grep 'package installed'


# build tools
RUN echo y | android update sdk --no-ui --all --filter build-tools-29.0.0 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-28.0.3 | grep 'package installed'

RUN android list sdk --all

# Accept the license agreements
RUN mkdir "$ANDROID_HOME/licenses" || true
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

RUN apk clean

RUN chown -R 1000:1000 $ANDROID_HOME

VOLUME ["/opt/android-sdk-linux"]

WORKDIR /

ADD ./ /
