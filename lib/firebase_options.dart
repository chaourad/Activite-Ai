// File generated by FlutterFire CLI.

// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;


/// Default [FirebaseOptions] for use with your Firebase apps.

///

/// Example:

/// ```dart

/// import 'firebase_options.dart';

/// // ...

/// await Firebase.initializeApp(

///   options: DefaultFirebaseOptions.currentPlatform,

/// );

/// ```

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {

    if (kIsWeb) {

      return web;

    }

    switch (defaultTargetPlatform) {

      case TargetPlatform.android:

        return android;

      case TargetPlatform.iOS:

        return ios;

      case TargetPlatform.macOS:

        return macos;

      case TargetPlatform.windows:

        throw UnsupportedError(

          'DefaultFirebaseOptions have not been configured for windows - '

          'you can reconfigure this by running the FlutterFire CLI again.',

        );

      case TargetPlatform.linux:

        throw UnsupportedError(

          'DefaultFirebaseOptions have not been configured for linux - '

          'you can reconfigure this by running the FlutterFire CLI again.',

        );

      default:

        throw UnsupportedError(

          'DefaultFirebaseOptions are not supported for this platform.',

        );

    }

  }


  static const FirebaseOptions web = FirebaseOptions(

    apiKey: 'AIzaSyDbSN0AMuba_r_fVOIvQSiSSiHYHQ7LZcU',

    appId: '1:574602646427:web:7aac524bbeb86be7c5073e',

    messagingSenderId: '574602646427',

    projectId: 'projet-86204',

    authDomain: 'projet-86204.firebaseapp.com',

    storageBucket: 'projet-86204.appspot.com',

  );


  static const FirebaseOptions android = FirebaseOptions(

    apiKey: 'AIzaSyBO__nUEG14N0mylwzW1yVSOgqZFj_Qpqg',

    appId: '1:574602646427:android:6827b355710de5f2c5073e',

    messagingSenderId: '574602646427',

    projectId: 'projet-86204',

    storageBucket: 'projet-86204.appspot.com',

  );


  static const FirebaseOptions ios = FirebaseOptions(

    apiKey: 'AIzaSyA8zLu46Otbb3NbZY0ddJiw1vZB8XICf3g',

    appId: '1:574602646427:ios:5cc1fd943af73f0ec5073e',

    messagingSenderId: '574602646427',

    projectId: 'projet-86204',

    storageBucket: 'projet-86204.appspot.com',

    iosBundleId: 'com.example.projet',

  );


  static const FirebaseOptions macos = FirebaseOptions(

    apiKey: 'AIzaSyA8zLu46Otbb3NbZY0ddJiw1vZB8XICf3g',

    appId: '1:574602646427:ios:6c32b1cd53740eccc5073e',

    messagingSenderId: '574602646427',

    projectId: 'projet-86204',

    storageBucket: 'projet-86204.appspot.com',

    iosBundleId: 'com.example.projet.RunnerTests',

  );

}

