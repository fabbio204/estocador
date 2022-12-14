# estocador

Projeto Flutter 3.3.7



# Configurando a API no Google Cloud

1. Crie um projeto em [https://console.cloud.google.com/getting-started](https://console.cloud.google.com/getting-started)

1. Em "Credenciais" crie um cliente na opção ***ID do cliente OAuth***
    ### Gerando a keystore para obter o código SHA1

    [https://docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android)

    keytool -genkey -v -keystore C:\Users\fabbio204\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

    ```
    storePassword: android
    keyPassword: estocador
    keyAlias: upload
    ```

1. Na seção de "2 Escopos" Adicione os escopos
    * https://www.googleapis.com/auth/drive
    * https://www.googleapis.com/auth/drive.appdata

1. Em "APIs e serviços ativados" ative as APIs
    * Google Drive API
    * Google Sheets API