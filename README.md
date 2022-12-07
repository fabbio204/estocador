# estocador

Projeto Flutter 3.3.7

# Gerando a keystore para obter o código SHA1

[https://docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android)

1. keytool -genkey -v -keystore C:\Users\fabbio204\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

storePassword: android
keyPassword: estocador
keyAlias: upload