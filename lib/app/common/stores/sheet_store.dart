import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class SheetStore {
  Future<void> inicializar() async {
    AuthStore store = Modular.get<AuthStore>();

    GoogleSignIn signIn = await store.googleLogin();

    await signIn.signIn();

    AuthClient? auth = await signIn.authenticatedClient();

    SheetsApi planilha = SheetsApi(auth!);

    await planilha.spreadsheets.values.update(
        ValueRange(range: 'Página1!A1', values: [
          ['Teste']
        ]),
        store.getIdPlanilha(),
        'Página1!A1',
        valueInputOption: 'USER_ENTERED');
  }
}
