import 'package:clean_arch/presentation/protocols/validation.dart';
import 'package:clean_arch/validation/protocols/protocols.dart';
import 'package:clean_arch/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ];
}
