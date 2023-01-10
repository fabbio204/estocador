import 'dart:async';

import 'package:estocador/app/common/entidades/produto.dart';
import 'package:estocador/app/common/repository/repositorio_base.dart';
import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:estocador/app/common/stores/sheet_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:intl/intl.dart' as intl;

class ProdutoStore implements RepositorioBase<Produto> {
  final SheetStore sheetStore;
  SheetsApi? _planilha;
  String? _idPlanilha;

  ProdutoStore(this.sheetStore);

  FutureOr<SheetsApi> iniciar() async {
    _planilha ??= await sheetStore.conectar();

    _idPlanilha ??= Modular.get<AuthStore>().getPlanilhaId();

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

    intl.NumberFormat format = intl.NumberFormat('000,00');

    List<Produto> lista = objetos.values!.asMap().entries.map((e) {
      List<Object?> item = e.value;

      return Produto(
        nome: item[0].toString(),
        quantidade: int.parse(item[1].toString()),
        valor: format.parse(item[2].toString()).toDouble(),
      );
    }).toList();

    lista.sort((a, b) => a.nome.compareTo(b.nome));

    return lista;
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

  Future<List<String>> listarProdutos() async {
    List<Produto> produtos = await listar('${SheetStore.abaProdutos}!A1:C');

    List<String> nomes = produtos.map((e) => e.nome).toList();

    return nomes;
  }

  Future<int> quantidadeLinhas() async {
    int linhaInicial = 1;
    SheetsApi planilha = await iniciar();
    ValueRange linhas = await planilha.spreadsheets.values
        .get(_idPlanilha!, '${SheetStore.abaProdutos}!A1:A');
    return linhaInicial - 1 + linhas.values!.length;
  }

  Future<void> cadastrar(Produto produto) async {
    int proximaLinha = await quantidadeLinhas();
    proximaLinha++;

    await salvarConjunto('${SheetStore.abaProdutos}!A$proximaLinha:C$proximaLinha', [
      [
        produto.nome,
        produto.quantidade,
        produto.valor,
      ],
    ]);
  }
}
