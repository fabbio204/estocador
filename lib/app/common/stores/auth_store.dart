import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:http/http.dart' as http;

class AuthStore {
  static const _nome = 'nome';
  static const _email = 'email';
  static const _id = 'id';
  static const _planilhaId = 'planilhaId';
  static const _accessToken = 'accessToken';
  static const _expirationDate = 'expirationDate';
  static const chaveDb = 'dados';

  static const List<String> _scopes = [
    drive.DriveApi.driveFileScope,
    drive.DriveApi.driveAppdataScope,
  ];

  late Box box;

  AuthStore() {
    box = Hive.box(chaveDb);
  }

  Future<GoogleSignIn> googleLogin() async {
    GoogleSignIn signIn = GoogleSignIn(
      scopes: _scopes,
    );

    return signIn;
  }

  Future<void> logar() async {
    GoogleSignIn signIn = await googleLogin();

    GoogleSignInAccount? resultado = await signIn.signIn();

    if (resultado == null) {
      return;
    }

    GoogleSignInAuthentication? authentication =
        await signIn.currentUser?.authentication;

    String? accessToken = authentication?.accessToken;

    AuthClient auth = autenticar(accessToken!);

    setClient(auth);

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

  void setClient(AuthClient client) {
    String accessToken = client.credentials.accessToken.data;
    DateTime expirationDate = client.credentials.accessToken.expiry;
    box.put(_accessToken, accessToken);
    box.put(_expirationDate, expirationDate);
  }

  Future<AuthClient> getClient() async {
    if (!isLogado()) {
      await logar();
    }

    String accessToken = box.get(_accessToken);

    return autenticar(accessToken);
  }

  void setExpirationDate(String expirationDate) {
    box.put(_expirationDate, expirationDate);
  }

  void sair() {
    box.deleteAll([_id, _email, _nome, _accessToken, _planilhaId]);
  }

  bool isLogado() {
    DateTime? expirationDate = box.get(_expirationDate);

    if (expirationDate == null) {
      return false;
    }

    DateTime agora = DateTime.now().toUtc().add(const Duration(seconds: 60));

    var logado = box.get(_id) != null && agora.isBefore(expirationDate);
    return logado;
  }

  AuthClient autenticar(String accessToken) {
    final gapis.AccessCredentials credentials = gapis.AccessCredentials(
      gapis.AccessToken(
        'Bearer',
        accessToken,
        DateTime.now().toUtc().add(const Duration(days: 30)),
      ),
      null, // We don't have a refreshToken
      _scopes,
    );

    return gapis.authenticatedClient(http.Client(), credentials);
  }
}
