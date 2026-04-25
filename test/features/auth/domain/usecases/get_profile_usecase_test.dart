import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_usecase_test.mocks.dart';

/// Unit tests for GetProfileUseCase.

@GenerateMocks([AuthRepository])
void main() {
  late GetProfileUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetProfileUseCase(mockRepository);
  });

  group('GetProfileUseCase', () {
    const tUser = UserEntity(
      id: '1',
      name: 'Test User',
      phone: '1234567890',
    );

    test('should return UserEntity when profile fetch is successful',
        () async {
      // Arrange: Set up mock to return user profile
      when(mockRepository.getProfile()).thenAnswer((_) async => tUser);

      // Act: Execute the use case
      final result = await useCase(const NoParams());

      // Assert: Verify the result matches expected user
      expect(result, tUser);
      expect(result.name, 'Test User');
      expect(result.phone, '1234567890');
      verify(mockRepository.getProfile());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception (e.g., invalid token)
      when(mockRepository.getProfile())
          .thenThrow(Exception('Unauthorized'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const NoParams()),
        throwsException,
      );
      verify(mockRepository.getProfile());
    });
  });
}
