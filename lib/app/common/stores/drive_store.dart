import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

class DriveStore {
  static const nomeArquivo = 'EstocadorApp';
  static const diretorio = 'Estocador';

  Future<void> inicializar() async {
    AuthStore store = Modular.get<AuthStore>();

    AuthClient auth = await store.getClient();

    drive.DriveApi driveApi = drive.DriveApi(auth);

    drive.FileList arquivos =
        await driveApi.files.list(q: "name = '$nomeArquivo'");

    late drive.File arquivo;
    if (arquivos.files == null || arquivos.files!.isEmpty) {
      drive.File planilha = drive.File(
        name: nomeArquivo,
        mimeType: "application/vnd.google-apps.spreadsheet",
      );

      arquivo = await driveApi.files.create(planilha);
    } else {
      arquivo = arquivos.files![0];
    }
    store.setIdPlanilha(arquivo.id!);
  }
}
