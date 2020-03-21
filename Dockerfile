FROM openjdk:8-jdk

ARG FLUTTER_VERSION="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.8-stable.tar.xz"
ARG ANDROID_COMPILE_SDK="28"
ARG ANDROID_BUILD_TOOLS="28.0.2"
ARG ANDROID_SDK_TOOLS="4333796"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -d android-sdk-linux android-sdk.zip
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null
RUN export ANDROID_HOME=$PWD/android-sdk-linux
RUN export PATH=$PATH:$PWD/android-sdk-linux/platform-tools/
RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses
RUN wget -nv --output-document=flutter-sdk.tar.xz $FLUTTER_VERSION
RUN mv flutter-sdk.tar.xz /opt && cd /opt && tar xf flutter-sdk.tar.xz
RUN chmod -R +x /opt/flutter/
RUN export PATH=$PATH:/opt/flutter/bin
