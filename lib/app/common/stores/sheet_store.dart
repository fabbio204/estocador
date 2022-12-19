import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class SheetStore {
  final String _abaProdutos = "Produtos";
  final String _abaRelatorios = "Relatorios";

  Future<void> inicializar() async {
    SheetsApi api = await conectar();

    await criarAba(api, _abaProdutos);
    await criarAba(api, _abaRelatorios);
  }

  Future<SheetsApi> conectar() async {
    AuthStore store = Modular.get<AuthStore>();

    AuthClient auth = await store.getClient();

    SheetsApi api = SheetsApi(auth);   

    return api;
  }

  Future<void> criarAba(SheetsApi api, String nomeAba) async {
    AuthStore store = Modular.get<AuthStore>();
    String planilhaId = store.getPlanilhaId();

    Spreadsheet planilha = await api.spreadsheets.get(planilhaId);

    if (planilha.sheets!.any((x) => x.properties?.title == nomeAba)) {
      return;
    }

    await api.spreadsheets.batchUpdate(
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
