import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:estocador/app/common/stores/drive_store.dart';
import 'package:estocador/app/common/stores/sheet_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore store;
  late final DriveStore drive;
  late final SheetStore sheet;

  @override
  void initState() {
    super.initState();
    store = Modular.get<HomeStore>();
    drive = Modular.get<DriveStore>();
    sheet = Modular.get<SheetStore>();

    inicializar();
  }

  Future<void> inicializar() async {
    await drive.inicializar();
    await sheet.inicializar();
  }

  @override
  void dispose() {
    Modular.dispose<HomeStore>();
    Modular.dispose<DriveStore>();
    Modular.dispose<SheetStore>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estocador'),
        actions: [
          IconButton(
              onPressed: () {
                Modular.get<AuthStore>().sair();
                Modular.to.pushNamedAndRemoveUntil('/', (Route rota) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ScopedBuilder<HomeStore, Exception, int>(
        store: store,
        onState: (_, counter) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Text('$counter'),
          );
        },
        onError: (context, error) => Center(
          child: Text(
            'Too many clicks',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
