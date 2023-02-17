import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  String validate(String value) {
    return value.isEmpty ? 'Campo obrigatório' : null;
  }
}

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Shoud return null if value is not empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('Shoud return error if value is empty', () {
    final sut = RequiredFieldValidation('any_field');

    final error = sut.validate('');

    expect(error, 'Campo obrigatório');
  });
}
