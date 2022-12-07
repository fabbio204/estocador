import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthState {
  static const _nome = 'nome';
  static const _email = 'email';
  static const _id = 'id';
  static const chaveDb = 'dados';

  late Box box;

  AuthState() {
    box = Hive.box(chaveDb);
  }

  Future<void> logar() async {
    GoogleSignIn signIn = GoogleSignIn();

    GoogleSignInAccount? resultado = await signIn.signIn();
    box.put(_nome, resultado?.displayName);
    box.put(_email, resultado?.email);
    box.put(_id, resultado?.id);
  }

  void sair() {
    box.deleteAll([_id, _email, _nome]);
  }

  bool isLogado() {
    return box.get(_id) != null;
  }
}
