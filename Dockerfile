FROM openjdk:8-jdk

ARG FLUTTER_VERSION="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.8-stable.tar.xz"
ARG ANDROID_COMPILE_SDK="28"
ARG ANDROID_BUILD_TOOLS="28.0.2"
ARG ANDROID_SDK_TOOLS="4333796"
ARG GRADLE_VERSION="4.10.2"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -d /opt/android-sdk android-sdk.zip
RUN echo y | /opt/android-sdk/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null
RUN (echo y; echo y; echo y; echo y; echo y; echo y) | /opt/android-sdk/tools/bin/sdkmanager --licenses
RUN wget -nv https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
RUN unzip -d /opt/gradle gradle-*.zip

RUN echo export ANDROID_HOME=/opt/android-sdk >> ~/.bashrc
RUN echo export PATH=$PATH:/opt/android-sdk/platform-tools/ >> ~/.bashrc
RUN echo export GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION} >> ~/.bashrc

RUN wget -nv --output-document=flutter-sdk.tar.xz $FLUTTER_VERSION
RUN mv flutter-sdk.tar.xz /opt && cd /opt && tar xf flutter-sdk.tar.xz
RUN chmod -R +x /opt/flutter/
RUN ln -s /opt/flutter/bin/flutter /usr/local/bin
RUN ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/local/bin
RUN flutter config --android-sdk /opt/android-sdk
RUN flutter doctor --android-licenses
