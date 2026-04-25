class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://qless-be.onrender.com/api';
  static const String socketUrl = 'ws://qless-be.onrender.com';

  // User Endpoints
  static const String register = '/users/register';
  static const String login = '/users/login';
  static const String getProfile = '/users/me';
  static const String updateProfile = '/users/me';
  static const String deleteAccount = '/users/me';

  // Menu Endpoints
  static const String getMenuItems = '/menu';
  static String getMenuItem(String id) => '/menu/$id';

  // Cart Endpoints
  static const String getCart = '/cart';
  static const String addToCart = '/cart/items';
  static String updateCartItem(String menuItemId) => '/cart/items/$menuItemId';
  static String removeCartItem(String menuItemId) => '/cart/items/$menuItemId';
  static const String clearCart = '/cart';

  // Order Endpoints
  static const String placeOrder = '/orders';
  static String getOrderStatus(String id) => '/orders/$id';
  static String markOrderReady(String id) => '/orders/$id/ready';
  static const String getMyOrders = '/orders/my';
}
