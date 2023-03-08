import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:clean_arch/domain/entities/entities.dart';
import 'package:clean_arch/data/usecases/usecases.dart';
import 'package:clean_arch/domain/helpers/helpers.dart';

import 'package:clean_arch/data/cache/cache.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  SaveSecureCacheStorageSpy cacheStorage;
  LocalSaveCurrentAccount sut;
  AccountEntity account;

  setUp(() {
    cacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError() {
    when(
      cacheStorage.saveSecure(key: anyNamed('key'), value: anyNamed('value')),
    ).thenThrow(Exception());
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    // Temos que garantir que quando chamar o save ele vai chamar internamente o save cache storage
    await sut.save(account);

    verify(cacheStorage.saveSecure(key: 'token', value: account.token));
  });
  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    mockError();
    // Temos que garantir que quando chamar o save ele vai chamar internamente o save cache storage
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
