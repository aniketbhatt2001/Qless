import 'package:canteen_mangement/features/cart/domain/entities/cart_entity.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_item_entity.dart';
import 'package:canteen_mangement/features/cart/domain/repositories/cart_repository.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_to_cart_usecase_test.mocks.dart';

/// Unit tests for AddToCartUseCase.
///
/// Tests adding items to cart business logic in isolation.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([CartRepository])
void main() {
  late AddToCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCartUseCase(mockRepository);
  });

  group('AddToCartUseCase', () {
    const tMenuItemId = 'menu_item_123';
    const tQuantity = 2;
    const tMenuItem = MenuItemEntity(
      id: tMenuItemId,
      name: 'Test Burger',
      price: 9.99,
      category: 'Main',
      imageUrl: 'https://example.com/burger.jpg',
      isAvailable: true,
    );
    const tCartItem = CartItemEntity(
      menuItem: tMenuItem,
      quantity: tQuantity,
    );
    const tCart = CartEntity(
      id: 'cart_123',
      items: [tCartItem],
      totalPrice: 19.98,
    );

    test('should return updated CartEntity when item is added successfully',
        () async {
      // Arrange: Set up mock to return cart with added item
      when(mockRepository.addToCart(tMenuItemId, tQuantity))
          .thenAnswer((_) async => tCart);

      // Act: Execute the use case
      final result = await useCase(
        const AddToCartParams(menuItemId: tMenuItemId, quantity: tQuantity),
      );

      // Assert: Verify the cart contains the item
      expect(result.items.length, 1);
      expect(result.items.first.menuItem.id, tMenuItemId);
      expect(result.items.first.quantity, tQuantity);
      expect(result.totalPrice, 19.98);
      verify(mockRepository.addToCart(tMenuItemId, tQuantity));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception (e.g., item not available)
      when(mockRepository.addToCart(tMenuItemId, tQuantity))
          .thenThrow(Exception('Item not available'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(
          const AddToCartParams(menuItemId: tMenuItemId, quantity: tQuantity),
        ),
        throwsException,
      );
      verify(mockRepository.addToCart(tMenuItemId, tQuantity));
    });

    test('should handle adding multiple quantities', () async {
      // Arrange: Adding 5 items
      const largeQuantity = 5;
      const largeCart = CartEntity(
        id: 'cart_123',
        items: [
          CartItemEntity(menuItem: tMenuItem, quantity: largeQuantity),
        ],
        totalPrice: 49.95,
      );
      when(mockRepository.addToCart(tMenuItemId, largeQuantity))
          .thenAnswer((_) async => largeCart);

      // Act: Execute the use case
      final result = await useCase(
        const AddToCartParams(
          menuItemId: tMenuItemId,
          quantity: largeQuantity,
        ),
      );

      // Assert: Verify correct quantity and total
      expect(result.items.first.quantity, largeQuantity);
      expect(result.totalPrice, 49.95);
      verify(mockRepository.addToCart(tMenuItemId, largeQuantity));
    });
  });
}
