import 'package:brasil_fields/brasil_fields.dart';
import 'package:estocador/app/common/entidades/produto.dart';
import 'package:estocador/app/common/stores/produtos/produto_store.dart';
import 'package:estocador/app/common/widgets/form_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProdutosCadastroPage extends StatefulWidget {
  final String title;
  const ProdutosCadastroPage({Key? key, this.title = 'Cadastro de produto'})
      : super(key: key);
  @override
  ProdutosCadastroPageState createState() => ProdutosCadastroPageState();
}

class ProdutosCadastroPageState extends State<ProdutosCadastroPage> {
  GlobalKey<FormState> formulario = GlobalKey<FormState>();
  late ValueNotifier<String> nomeProduto;
  late ValueNotifier<int> quantidade;
  late ValueNotifier<String> valor;
  late ValueNotifier<List<String>> produtos;

  final String _outro = 'Outro';

  Future carregarProdutos() async {
    ProdutoStore store = Modular.get();

    List<String> nomes = await store.listarProdutos();

    produtos.value = nomes;
  }

  @override
  void initState() {
    nomeProduto = ValueNotifier('');
    quantidade = ValueNotifier(0);
    valor = ValueNotifier('');
    produtos = ValueNotifier([]);

    carregarProdutos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formulario,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder(
                        valueListenable: produtos,
                        builder: (context, resultado, child) {
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }

                              return null;
                            },
                            items: [
                              ...resultado,
                              _outro,
                            ]
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              if (value != null) {
                                nomeProduto.value = value;
                              }
                            },
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: nomeProduto,
                      builder: (context, value, child) {
                        if (nomeProduto.value == _outro) {
                          return FormInputWidget(
                            placeholder: 'Digite o nome do produto',
                            change: (valor) {
                              nomeProduto.value = valor;
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    FormInputWidget(
                      change: (valor) => quantidade.value = int.parse(valor),
                      placeholder: 'Quantidade comprada',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),
                    FormInputWidget(
                      change: (valor) => this.valor.value = valor,
                      placeholder: 'Valor por unidade',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter()
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }

                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: (() {
                        if (formulario.currentState!.validate()) {
                          String nome = nomeProduto.value;

                          double? valorFinal = double.tryParse(valor.value);

                          Produto(
                            nome: nome,
                            valor: valorFinal!,
                            quantidade: quantidade.value,
                          );

                          
                        }
                      }),
                      child: const Text('Cadastrar'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
