import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_arch/validation/protocols/protocols.dart';
import 'package:clean_arch/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;

  void mockValidation1(String error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(String error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    // Porque no teste abaixo foi mockada a resposta das validações:
    // Porque FieldValidation é uma classe abstrata e não retornará nada, o correto
    // em produção seria utilizar sua implementação para retornar algo.

    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('other_field');
    mockValidation1(null);
    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('any_field');
    mockValidation3(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validations returns null or empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test(
      'Should return first error if all validations of the specific field returns error',
      () {
    mockValidation1('error 1');
    mockValidation2('error 2');
    mockValidation3('error 3');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'error 2');
  });
}
