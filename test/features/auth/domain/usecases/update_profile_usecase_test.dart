import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_profile_usecase_test.mocks.dart';

/// Unit tests for UpdateProfileUseCase.
///
/// Tests profile update business logic in isolation.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([AuthRepository])
void main() {
  late UpdateProfileUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = UpdateProfileUseCase(mockRepository);
  });

  group('UpdateProfileUseCase', () {
    const tUpdatedUser = UserEntity(
      id: '1',
      name: 'Updated Name',
      phone: '1234567890',
    );

    test('should return updated UserEntity when name update succeeds',
        () async {
      // Arrange: Set up mock to return updated user
      when(mockRepository.updateProfile(name: 'Updated Name'))
          .thenAnswer((_) async => tUpdatedUser);

      // Act: Execute the use case
      final result = await useCase(
        const UpdateProfileParams(name: 'Updated Name'),
      );

      // Assert: Verify the result matches updated user
      expect(result.name, 'Updated Name');
      verify(mockRepository.updateProfile(name: 'Updated Name'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return updated UserEntity when password update succeeds',
        () async {
      // Arrange: Set up mock to return updated user
      when(mockRepository.updateProfile(
        currentPassword: 'oldPass',
        newPassword: 'newPass',
      )).thenAnswer((_) async => tUpdatedUser);

      // Act: Execute the use case
      final result = await useCase(
        const UpdateProfileParams(
          currentPassword: 'oldPass',
          newPassword: 'newPass',
        ),
      );

      // Assert: Verify the result
      expect(result, tUpdatedUser);
      verify(mockRepository.updateProfile(
        currentPassword: 'oldPass',
        newPassword: 'newPass',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception (e.g., wrong password)
      when(mockRepository.updateProfile(name: 'Updated Name'))
          .thenThrow(Exception('Update failed'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const UpdateProfileParams(name: 'Updated Name')),
        throwsException,
      );
      verify(mockRepository.updateProfile(name: 'Updated Name'));
    });
  });
}
