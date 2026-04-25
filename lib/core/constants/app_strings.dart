/// Application-wide string constants.
///
/// Centralizes all UI strings to avoid hardcoding and prepare for localization.
/// Follows Flutter Playbook standards: no hardcoded values.
///
/// TODO: Replace with AppLocalizations for multi-language support.
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // Common
  static const String appName = 'Canteen Management';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';

  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String phone = 'Phone';
  static const String password = 'Password';
  static const String name = 'Name';
  static const String loginSuccess = 'Login successful';
  static const String loginFailed = 'Login failed';
  static const String registerSuccess = 'Registration successful';
  static const String registerFailed = 'Registration failed';
  static const String logoutSuccess = 'Logged out successfully';
  static const String invalidCredentials = 'Invalid credentials';

  // Profile
  static const String profile = 'Profile';
  static const String updateProfile = 'Update Profile';
  static const String profileUpdated = 'Profile updated successfully';
  static const String deleteAccount = 'Delete Account';
  static const String deleteAccountConfirm =
      'Are you sure you want to delete your account? This action cannot be undone.';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  static const String changePassword = 'Change Password';

  // Menu
  static const String menu = 'Menu';
  static const String menuItems = 'Menu Items';
  static const String addToCart = 'Add to Cart';
  static const String itemAdded = 'Item added to cart';
  static const String itemRemoved = 'Item removed from cart';
  static const String outOfStock = 'Out of Stock';
  static const String available = 'Available';

  // Cart
  static const String cart = 'Cart';
  static const String emptyCart = 'Your cart is empty';
  static const String cartCleared = 'Cart cleared';
  static const String checkout = 'Checkout';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String quantity = 'Quantity';

  // Order
  static const String orders = 'Orders';
  static const String myOrders = 'My Orders';
  static const String orderPlaced = 'Order placed successfully';
  static const String orderFailed = 'Failed to place order';
  static const String orderStatus = 'Order Status';
  static const String orderReady = 'Order Ready';
  static const String orderPending = 'Pending';
  static const String orderPreparing = 'Preparing';
  static const String orderCompleted = 'Completed';
  static const String noOrders = 'No orders found';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String home = 'Home';
  static const String scanQR = 'Scan QR';
  static const String qrScanner = 'QR Scanner';

  // Search
  static const String search = 'Search';
  static const String searchMeals = 'Search meals...';
  static const String noResults = 'No results found';

  // Errors
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred';
  static const String validationError = 'Please check your input';
  static const String timeoutError = 'Request timeout. Please try again.';

  // Validation
  static const String fieldRequired = 'This field is required';
  static const String invalidPhone = 'Invalid phone number';
  static const String invalidEmail = 'Invalid email address';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
}
