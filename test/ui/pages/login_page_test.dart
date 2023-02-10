import 'package:clean_arch/ui/pages/login/login.dart';
import 'package:clean_arch/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(home: LoginPage(presenter));

    await tester.pumpWidget(loginPage);
  }

  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);
      // Encontra um descendente do campo email do tipo texto
      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'Quando um TextFormField tem apenas um filho do tipo texto, significa que não há erros, já que um deles sempre será a "dica" do que colocar naquele campo.',
      );

      // Encontra um descendente do campo email do tipo texto
      final passwTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        passwTextChildren,
        findsOneWidget,
        reason:
            'Quando um TextFormField tem apenas um filho do tipo texto, significa que não há erros, já que um deles sempre será a "dica" do que colocar naquele campo.',
      );

      // Vai procurar um wiget do tipo raisedbutton na tela
      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, null);
    },
  );
  testWidgets(
    'Should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);

      verify(presenter.validateEmail(email));
    },
  );
}
