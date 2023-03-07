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

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    // sut = system under test
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );

    mockHttpData(mockValidData());
  });
  test(
    'Should call HttpClient with correct values',
    () async {
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
      mockHttpError(HttpError.badRequest);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 404',
    () async {
      mockHttpError(HttpError.notFound);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 500',
    () async {
      mockHttpError(HttpError.serverError);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw InvalidCredentialsError if HttpClient returns 401',
    () async {
      mockHttpError(HttpError.unauthorized);

      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'Should return an Account if HttpCLient returns 200',
    () async {
      final validData = mockValidData();
      mockHttpData(validData);

      // acao
      final account = await sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(account.token, validData['accessToken']);
    },
  );

  test(
    'Should  throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      mockHttpData({'invalid_key': 'invalid_value'});
      // acao
      final future = sut.auth(params);

      // thwrousA = comparar o erro q acontece dentro dela
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}