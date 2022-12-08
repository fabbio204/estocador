import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, this.title = 'Login Page'}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Text('Tela de Login'),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await Modular.get<AuthStore>().logar();
                Modular.to.pushNamedAndRemoveUntil('/', (Route rota) => false);
              },
              child: const Text('Logar com Google'),
            ),
          )
        ],
      ),
    );
  }
}
