import 'dart:async';

import 'package:angular/core.dart';
import 'package:firebase/firebase.dart' as fb;

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class AutenticacaoService  {
  static bool autenticado = false;
  static String token;

  static List<Map> entidades = new List();
  static String erro;

  static void inicializarFireBase() {

    fb.initializeApp(
        apiKey: "AIzaSyAxACUypjTqQTjqQk2zO9hWbguq7x_z2Uc",
        authDomain: "precomi-e8d99.firebaseapp.com",
        databaseURL: "https://precomi-e8d99.firebaseio.com",
        storageBucket: "precomi-e8d99.appspot.com");
  }

  static autenticarComEmail(String email, String password) async {
    try {

       await fb.auth().signInWithEmailAndPassword(email, password);

       token = await fb.auth().currentUser.getToken();

       AutenticacaoService.autenticado = true;

    } catch (e) {
      erro = "Não foi possível autenticar usuário. " + e.toString();
    }
  }

  static sairAutenticacao() {
    fb.auth().signOut();
    AutenticacaoService.autenticado = false;
  }

  static salvar() async {
     fb.database().ref('teste').set('{nome: s@s.com}');
  }


}
