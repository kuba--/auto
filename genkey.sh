#!/bin/bash
keytool -v -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 10000 -deststoretype pkcs12
keytool -v -keyalg RSA -genkey  -alias auto -keystore auto.keystore -validity 10000

