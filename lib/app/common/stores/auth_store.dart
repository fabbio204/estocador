import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class AuthStore {
  static const _nome = 'nome';
  static const _email = 'email';
  static const _id = 'id';
  static const _planilhaId = 'planilhaId';
  static const _accessToken = 'accessToken';
  static const _expirationDate = 'expirationDate';
  static const chaveDb = 'dados';

  late Box box;

  AuthStore() {
    box = Hive.box(chaveDb);
  }

  Future<GoogleSignIn> googleLogin() async {
    GoogleSignIn signIn = GoogleSignIn(
      scopes: [
        drive.DriveApi.driveFileScope,
        drive.DriveApi.driveAppdataScope,
      ],
    );

    return signIn;
  }

  Future<void> logar() async {
    GoogleSignIn signIn = await googleLogin();

    GoogleSignInAccount? resultado = await signIn.signIn();

    if (resultado == null) {
      return;
    }

    final Map<String, String> authHeaders = await resultado.authHeaders;

    setAccessToken(authHeaders);

    box.put(_nome, resultado.displayName);
    box.put(_email, resultado.email);
    box.put(_id, resultado.id);
  }

  void setIdPlanilha(String id) {
    box.put(_planilhaId, id);
  }

  String getPlanilhaId() {
    return box.get(_planilhaId);
  }

  void setAccessToken(Map<String, String> accessToken) {
    box.put(_accessToken, accessToken);
  }

  String getAccessToken() {
    return box.get(_accessToken);
  }

  void setExpirationDate(String expirationDate) {
    box.put(_expirationDate, expirationDate);
  }

  void sair() {
    box.deleteAll([_id, _email, _nome]);
  }

  bool isLogado() {
    return box.get(_id) != null;
  }
}
