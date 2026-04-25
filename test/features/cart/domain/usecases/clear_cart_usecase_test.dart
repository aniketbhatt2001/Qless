import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/features/cart/domain/repositories/cart_repository.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clear_cart_usecase_test.mocks.dart';

/// Unit tests for ClearCartUseCase.
///
/// Tests clearing cart business logic in isolation.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([CartRepository])
void main() {
  late ClearCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = ClearCartUseCase(mockRepository);
  });

  group('ClearCartUseCase', () {
    test('should complete successfully when cart is cleared', () async {
      // Arrange: Set up mock to complete successfully
      when(mockRepository.clearCart()).thenAnswer((_) async => Future.value());

      // Act: Execute the use case
      await useCase(const NoParams());

      // Assert: Verify clearCart was called
      verify(mockRepository.clearCart());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception
      when(mockRepository.clearCart()).thenThrow(Exception('Clear failed'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const NoParams()),
        throwsException,
      );
      verify(mockRepository.clearCart());
    });
  });
}
