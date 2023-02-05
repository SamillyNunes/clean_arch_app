import 'package:clean_arch/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_arch/domain/usecases/usecases.dart';

import 'package:clean_arch/data/http/http.dart';
import 'package:clean_arch/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    // sut = system under test
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
  });
  test(
    'Should call HttpClient with correct values',
    () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenAnswer(
        (_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        },
      );
      // acao
      await sut.auth(params);

      verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret},
      ));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 400',
    () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.badRequest);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 404',
    () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.notFound);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 500',
    () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.serverError);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw InvalidCredentialsError if HttpClient returns 401',
    () async {
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenThrow(HttpError.unauthorized);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'Should return an Account if HttpCLient returns 200',
    () async {
      final accessToken = faker.guid.guid();
      when(httpClient.request(
              url: anyNamed('url'),
              method: anyNamed('method'),
              body: anyNamed('body')))
          .thenAnswer(
        (_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        },
      );

      // acao
      final account = await sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(account.token, accessToken);
    },
  );
}
