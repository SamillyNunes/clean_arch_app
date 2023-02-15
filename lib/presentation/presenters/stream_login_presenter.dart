import 'dart:async';

import 'package:meta/meta.dart';

import 'package:clean_arch/presentation/protocols/protocols.dart';

class LoginState {
  String emailError;

  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  // Com o broadcast haverá mais de um listener em um mesmo controlador
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  // O distinct soh emite valor se for diferente
  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);

    _controller.add(_state);
  }

  void validatePassword(String password) {
    validation.validate(field: 'password', value: password);
  }
}
