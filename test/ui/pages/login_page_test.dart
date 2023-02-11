import 'dart:async';

import 'package:clean_arch/ui/pages/login/login.dart';
import 'package:clean_arch/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<String> mainErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();

    // Toda vez que nos testes for chamado o 'emailErrorStream' do presenter será respondido o
    // 'emailErrorStreamController.stream'
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter));

    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

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
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
  testWidgets(
    'Should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);

      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);

      verify(presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Should presents error if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'Should presents no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should presents no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('');

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should presents error if password is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'Should presents no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should presents no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should enable form button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Should disable form button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);

      // pra forcar os componentes que precisam ser renderizados novamente, como o caso de um setstate
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, null);
    },
  );

  testWidgets(
    'Should call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);

      await tester.pump();

      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      // called(1) = chamado apenas uma vez
      verify(presenter.auth()).called(1);
    },
  );

  testWidgets(
    'Should present loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should hide loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      // Explicação: Manda mostrar primeiro e esconder depois pois simula o loading
      // Já que no inicio ele estará falso e isso deixaria o teste tendencioso
      isLoadingController.add(true);
      await tester.pump();
      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
  testWidgets(
    'Should presents error messahe if auth fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      // Explicação: Manda mostrar primeiro e esconder depois pois simula o loading
      // Já que no inicio ele estará falso e isso deixaria o teste tendencioso
      mainErrorController.add('main error');
      await tester.pump();

      expect(find.text('main error'), findsOneWidget);
    },
  );
}
