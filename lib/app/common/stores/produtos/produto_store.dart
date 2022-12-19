import 'dart:async';

import 'package:estocador/app/common/entidades/produto.dart';
import 'package:estocador/app/common/repository/repositorio_base.dart';
import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:estocador/app/common/stores/sheet_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:googleapis/sheets/v4.dart';

class ProdutoStore implements RepositorioBase<Produto> {
  final SheetStore sheetStore;
  late SheetsApi? _planilha;
  late String? _idPlanilha;

  ProdutoStore(this.sheetStore);

  FutureOr<SheetsApi> iniciar() async {
    if (_planilha == null) {
      _planilha = await sheetStore.conectar();
    }

    if (_idPlanilha == null) {
      _idPlanilha = Modular.get<AuthStore>().getPlanilhaId();
    }

    return _planilha!;
  }

  @override
  Future<List<Produto>> listar(String intervalo) async {
    SheetsApi planilha = await iniciar();
    ValueRange objetos =
        await planilha.spreadsheets.values.get(_idPlanilha!, intervalo);

    if (objetos.values == null) {
      return [];
    }

    return objetos.values!
        .asMap()
        .entries
        .map((MapEntry<int, List<Object?>> e) {
      List<Object?> item = e.value;

      return Produto(
        nome: item[0].toString(),
        quantidade: int.parse(item[1].toString()),
        valor: double.parse(item[2].toString()),
      );
    }).toList();
  }

  @override
  Future<void> salvar(String intervalo, String valor) async {
    SheetsApi planilha = await iniciar();

    await planilha.spreadsheets.values.update(
        ValueRange(range: intervalo, values: [
          [valor]
        ]),
        _idPlanilha!,
        intervalo,
        valueInputOption: 'USER_ENTERED');
  }

  @override
  Future<void> salvarConjunto(
      String intervalo, List<List<Object>> valor) async {
    SheetsApi planilha = await iniciar();

    await planilha.spreadsheets.values.update(
      ValueRange(range: intervalo, values: valor),
      _idPlanilha!,
      intervalo,
      valueInputOption: 'USER_ENTERED',
    );
  }
}
