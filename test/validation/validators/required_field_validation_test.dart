import 'package:clean_arch/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Shoud return null if value is not empty', () {
    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('Shoud return error if value is empty', () {
    final error = sut.validate('');

    expect(error, 'Campo obrigatório');
  });

  test('Shoud return error if value is empty', () {
    final error = sut.validate(null);

    expect(error, 'Campo obrigatório');
  });
}
