import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_entity.dart';
import 'package:canteen_mangement/features/cart/domain/entities/cart_item_entity.dart';
import 'package:canteen_mangement/features/cart/domain/repositories/cart_repository.dart';
import 'package:canteen_mangement/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:canteen_mangement/features/menu/domain/entities/menu_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_cart_usecase_test.mocks.dart';

/// Unit tests for GetCartUseCase.
///
/// Tests fetching cart business logic in isolation.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([CartRepository])
void main() {
  late GetCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartUseCase(mockRepository);
  });

  group('GetCartUseCase', () {
    const tMenuItem = MenuItemEntity(
      id: 'menu_item_123',
      name: 'Test Burger',
      price: 9.99,
      category: 'Main',
      imageUrl: 'https://example.com/burger.jpg',
      isAvailable: true,
    );
    const tCartItem = CartItemEntity(
      menuItem: tMenuItem,
      quantity: 2,
    );
    const tCart = CartEntity(
      id: 'cart_123',
      items: [tCartItem],
      totalPrice: 19.98,
    );

    test('should return CartEntity when cart fetch is successful', () async {
      // Arrange: Set up mock to return cart
      when(mockRepository.getCart()).thenAnswer((_) async => tCart);

      // Act: Execute the use case
      final result = await useCase(const NoParams());

      // Assert: Verify the cart data
      expect(result.id, 'cart_123');
      expect(result.items.length, 1);
      expect(result.totalPrice, 19.98);
      verify(mockRepository.getCart());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty cart when no items exist', () async {
      // Arrange: Set up mock to return empty cart
      const emptyCart = CartEntity(
        id: 'cart_123',
        items: [],
        totalPrice: 0.0,
      );
      when(mockRepository.getCart()).thenAnswer((_) async => emptyCart);

      // Act: Execute the use case
      final result = await useCase(const NoParams());

      // Assert: Verify empty cart
      expect(result.items.isEmpty, true);
      expect(result.totalPrice, 0.0);
      verify(mockRepository.getCart());
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception
      when(mockRepository.getCart()).thenThrow(Exception('Network error'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const NoParams()),
        throwsException,
      );
      verify(mockRepository.getCart());
    });
  });
}
