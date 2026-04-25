import 'package:canteen_mangement/features/cart/domain/entities/cart_entity.dart';
import 'package:canteen_mangement/features/cart/domain/repositories/cart_repository.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_cart_item_usecase_test.mocks.dart';

/// Unit tests for RemoveCartItemUseCase.
///
/// Tests removing items from cart business logic in isolation.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([CartRepository])
void main() {
  late RemoveCartItemUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = RemoveCartItemUseCase(mockRepository);
  });

  group('RemoveCartItemUseCase', () {
    const tMenuItemId = 'menu_item_123';
    const tEmptyCart = CartEntity(
      id: 'cart_123',
      items: [],
      totalPrice: 0.0,
    );

    test('should return updated CartEntity when item is removed successfully',
        () async {
      // Arrange: Set up mock to return cart without the item
      when(mockRepository.removeCartItem(tMenuItemId))
          .thenAnswer((_) async => tEmptyCart);

      // Act: Execute the use case
      final result = await useCase(
        const RemoveCartItemParams(tMenuItemId),
      );

      // Assert: Verify the item was removed
      expect(result.items.isEmpty, true);
      expect(result.totalPrice, 0.0);
      verify(mockRepository.removeCartItem(tMenuItemId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception (e.g., item not found)
      when(mockRepository.removeCartItem(tMenuItemId))
          .thenThrow(Exception('Item not found in cart'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const RemoveCartItemParams(tMenuItemId)),
        throwsException,
      );
      verify(mockRepository.removeCartItem(tMenuItemId));
    });
  });
}
