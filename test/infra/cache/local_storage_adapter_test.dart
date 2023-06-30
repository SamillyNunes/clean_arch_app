import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_arch/infra/cache/cache.dart';

// A gente utiliza o spy para capturar valores e mockar resultados, e o
// mock para capturar mas não quer mockar nada
class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  void mockSaveSecureError() {
    when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  // Não sabemos como a biblioteca vai funcionar, ela pode falhar, e se ela falhar devemos
  // retornar essa excecao, nao trata-la (?)
  test('Should throw if save secure throws', () async {
    mockSaveSecureError();
    final future = sut.saveSecure(key: key, value: value);

    // Garantindo que esta retornando uma excecao qualquer
    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}
