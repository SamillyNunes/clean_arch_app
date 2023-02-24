import 'package:clean_arch/main/factories/pages/pages.dart';
import 'package:clean_arch/ui/pages/pages.dart';
import 'package:flutter/material.dart';

Widget makeLoginPage() {
  return LoginPage(makeGetxLoginPresenter());
}
