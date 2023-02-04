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

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    // sut = system under test
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test(
    'Should call HttpClient with correct values',
    () async {
      final params = AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
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
}
