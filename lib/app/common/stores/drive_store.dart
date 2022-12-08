import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

class DriveStore {
  static const nomeArquivo = 'EstocadorApp';
  static const diretorio = 'Estocador';

  Future<void> inicializar() async {
    AuthStore store = Modular.get<AuthStore>();
    GoogleSignIn signIn = await store.googleLogin();

    await signIn.signIn();

    AuthClient? auth = await signIn.authenticatedClient();

    drive.DriveApi driveApi = drive.DriveApi(auth!);

    drive.FileList arquivos =
        await driveApi.files.list(q: "name = '$nomeArquivo'");

    if (arquivos.files == null || arquivos.files!.isEmpty) {
      drive.File planilha = drive.File(
        name: nomeArquivo,
        mimeType: "application/vnd.google-apps.spreadsheet",
      );

      drive.File arquivo = await driveApi.files.create(planilha);
      store.setIdPlanilha(arquivo.id!);
    }
  }
}
