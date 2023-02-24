import 'package:clean_arch/main/builders/builders.dart';
import 'package:clean_arch/presentation/protocols/validation.dart';
import 'package:clean_arch/validation/protocols/protocols.dart';
import 'package:clean_arch/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  // Design Pattern do builder
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().build(),
  ];
}
