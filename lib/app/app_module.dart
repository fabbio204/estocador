import 'package:estocador/app/common/stores/auth_state.dart';
import 'package:estocador/app/modules/login/login_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'common/auth_guard.dart';
import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [Bind((i) => AuthState())];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: HomeModule(), guards: [AuthGuard()]),
    ModuleRoute('/login/', module: LoginModule()),
  ];
}
