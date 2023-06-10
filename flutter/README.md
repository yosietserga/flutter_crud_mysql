# ToDo List CRUD con Firebase

Login con CRUD Basico en firebase 
Se permite el acceso a traves de:
- Correo/password
- Cuenta de google


## Se requieren los siguientes pasos
3. Generar el proyecto en firebase 
2. Configuracion inicial de Firebase
 * Instalación del CLI Firebase -> https://firebase.google.com/docs/cli?hl=es-419#install_the_firebase_cli
    * curl -sL https://firebase.tools | bash
    * firebase login
 * Instala las herramientas de línea de comandos obligatorias -> https://firebase.google.com/docs/flutter/setup?hl=es-419&platform=web
    * firebase login
    * dart pub global activate flutterfire_cli
    * flutterfire configure
 * Inicializa Firebase en tu app
    * flutter pub add firebase_core
    * flutterfire configure
3. Configuración necesaria para los paquetes de auth con google y firebase
    * google_sign_in 5.4.1
        * https://pub.dev/packages/google_sign_in
    * firebase_auth: ^3.6.3
        * https://pub.dev/packages/firebase_auth/install
4. Se debe agregar la fima de la aplicación en la configuración de Firebase
Generamos la firma debug para desarrollo, la cual se puede realizar a traves de la consola con
```
/android/./gradlew signingReport 
```
