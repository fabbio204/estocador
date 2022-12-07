import 'dart:async';

import 'package:estocador/app/common/stores/auth_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/login/');

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    return Modular.get<AuthState>().isLogado();
  }
}
