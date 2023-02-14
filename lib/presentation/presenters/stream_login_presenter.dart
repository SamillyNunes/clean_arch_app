import 'dart:async';

import 'package:meta/meta.dart';

import 'package:clean_arch/presentation/protocols/protocols.dart';

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  // Com o broadcast haverá mais de um listener em um mesmo controlador
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);

    _controller.add(_state);
  }
}
