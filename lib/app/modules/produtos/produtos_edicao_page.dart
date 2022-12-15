import 'package:flutter/material.dart';

class ProdutosEdicaoPage extends StatefulWidget {
  final String title;
  const ProdutosEdicaoPage({Key? key, this.title = 'ProdutosEdicaoPage'}) : super(key: key);
  @override
  ProdutosEdicaoPageState createState() => ProdutosEdicaoPageState();
}
class ProdutosEdicaoPageState extends State<ProdutosEdicaoPage> {
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