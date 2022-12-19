import 'package:estocador/app/common/stores/produtos/produto_store.dart';
import 'package:estocador/app/modules/produtos/produtos_cadastro_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosModule extends Module {
  static const rotaCadastro = '/cadastro/';

  @override
  final List<Bind> binds = [
    Bind((i) => ProdutoStore(i.get()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(rotaCadastro, child: (i, args) => const ProdutosCadastroPage())
  ];
}
