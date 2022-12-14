import 'package:estocador/app/common/stores/auth_store.dart';
import 'package:estocador/app/common/stores/drive_store.dart';
import 'package:estocador/app/common/stores/sheet_store.dart';
import 'package:estocador/app/modules/login/login_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'common/auth_guard.dart';
import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => AuthStore()),
    Bind((i) => DriveStore()),
    Bind((i) => SheetStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: HomeModule(), guards: [AuthGuard()]),
    ModuleRoute('/login/', module: LoginModule()),
  ];
}
