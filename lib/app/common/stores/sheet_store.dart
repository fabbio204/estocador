import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class SheetStore {
  final String _abaProdutos = "Produtos";
  final String _abaRelatorios = "Relatorios";
  Future<void> inicializar() async {
    AuthStore store = Modular.get<AuthStore>();

    AuthClient auth = await store.getClient();

    SheetsApi planilha = SheetsApi(auth);

    String planilhaId = store.getPlanilhaId();

    await criarAba(planilha, planilhaId, _abaProdutos);
    await criarAba(planilha, planilhaId, _abaRelatorios);
  }

  Future<void> criarAba(
      SheetsApi planilhaApi, String planilhaId, String nomeAba) async {
    Spreadsheet planilha = await planilhaApi.spreadsheets.get(planilhaId);

    if (planilha.sheets!.any((x) => x.properties?.title == nomeAba)) {
      return;
    }

    await planilhaApi.spreadsheets.batchUpdate(
        BatchUpdateSpreadsheetRequest(
          requests: [
            Request(
              addSheet: AddSheetRequest(
                properties: SheetProperties(title: nomeAba),
              ),
            ),
          ],
        ),
        planilhaId);
  }
}
