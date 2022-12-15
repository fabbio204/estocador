import 'package:brasil_fields/brasil_fields.dart';
import 'package:estocador/app/common/widgets/form_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProdutosCadastroPage extends StatefulWidget {
  final String title;
  const ProdutosCadastroPage({Key? key, this.title = 'Cadastro de produto'})
      : super(key: key);
  @override
  ProdutosCadastroPageState createState() => ProdutosCadastroPageState();
}

class ProdutosCadastroPageState extends State<ProdutosCadastroPage> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  late ValueNotifier<String> nomeProduto;
  final String _outro = 'Outro';

  @override
  void initState() {
    nomeProduto = ValueNotifier('');

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
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
                          'Arroz',
                          'Feijão',
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
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: nomeProduto,
                      builder: (context, value, child) {
                        if (nomeProduto.value == _outro) {
                          return const FormInputWidget(
                            placeholder: 'Digite o nome do produto',
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    FormInputWidget(
                      placeholder: 'Quantidade comprada',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    FormInputWidget(
                      placeholder: 'Valor por unidade',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter()
                      ],
                    ),
                    ElevatedButton(
                      onPressed: (() {}),
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
