import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({@required String field, @required String value}) {
    String error;
    final specificValidators = validations.where((v) => v.field == field);
    for (final validation in specificValidators) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}
