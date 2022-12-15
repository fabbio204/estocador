import 'package:flutter/material.dart';

class ProdutosListaPage extends StatefulWidget {
  final String title;
  const ProdutosListaPage({Key? key, this.title = 'ProdutosListaPage'}) : super(key: key);
  @override
  ProdutosListaPageState createState() => ProdutosListaPageState();
}
class ProdutosListaPageState extends State<ProdutosListaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}