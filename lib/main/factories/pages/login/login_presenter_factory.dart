import 'package:clean_arch/main/factories/pages/pages.dart';
import 'package:clean_arch/main/factories/usecases/usecases.dart';
import 'package:clean_arch/presentation/presenters/presenters.dart';
import 'package:clean_arch/ui/pages/login/login.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
