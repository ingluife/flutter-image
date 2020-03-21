
[![Build Status](https://travis-ci.org/ingluife/flutter-image.svg?branch=master)](https://travis-ci.org/ingluife/flutter-image)
# Flutter image

This is a docker image for flutter.

This image is useful for pipelines build on CI.

# How to use it

- Run a docker container with this image:
   
   Eg.
`docker run -ti --name flutter-container ingluife/flutter:latest`

- Add the tag image on a pipeline file setting:

Gitlab example: `.gitlab-ci.yml`
```javascript

image: ingluife/flutter:latest

before_script:
  - flutter pub get
  - echo sdk.dir=/opt/android-sdk/ > android/local.properties
  - echo flutter.sdk=/opt/flutter >> android/local.properties
  - cd android && gradle wrapper && cd -
  - chmod +x ./gradlew

stages:
  - test
  - build

test:android:
  stage: test
  script:
    - cd android
    - ./gradlew -Pci --console=plain :app:testDebug

build:apk:
  stage: build
  script:
    - flutter build apk
  artifacts:
    paths:
      - build/app/outputs/apk

build:bundle:
  stage: build
  script:
    - flutter build appbundle
  artifacts:
    paths:
      - build/app/outputs/bundle

test:flutter:
  stage: test
  script:
    - flutter test


``` 

# Components
This image has these components installed and configured: 

* [Flutter](https://flutter.dev/docs)
  * Path: `/opt/flutter`
* [Android SDK](https://developer.android.com/studio/releases/sdk-tools)
  * Path: `/opt/android-sdk`
* [Gradle](https://docs.gradle.org/current/userguide/userguide.html)
  * Path: `/opt/gradle`
