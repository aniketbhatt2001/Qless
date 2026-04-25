# QuickerQ - Smart Food Ordering System

Skip the queue and order your meals ahead of time. QuickerQ lets you browse menus, place orders, and track preparation in real-time. No more waiting in line - just order, relax, and pick up when ready.

## What It Does

- Browse full menu with photos, descriptions, and prices
- Build your order and checkout seamlessly
- Track order status from preparation to ready
- Get instant notifications when your food is ready
- Scan QR codes for express ordering
- View complete order history and manage your profile

## Why QuickerQ?

**Save Time**: Order ahead and skip the queue entirely. Your food starts being prepared the moment you confirm.

**Stay Informed**: Real-time order tracking keeps you updated. Know exactly when to pick up.

**Easy Ordering**: Intuitive interface makes browsing and ordering quick and hassle-free.

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **GetX** - State management and navigation
- **Clean Architecture** - Organized by features with presentation, domain, and data layers
- **Firebase** - Backend and hosting

## Project Structure

```
lib/
├── core/              # Shared utilities, constants, themes
├── features/          # Feature modules
│   ├── auth/         # Login, registration, profile
│   ├── cart/         # Shopping cart
│   ├── dashboard/    # Main navigation
│   ├── home/         # Browse menu
│   ├── menu/         # Menu details
│   └── order/        # Order tracking
└── main.dart         # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.29.2)
- Dart SDK
- Android Studio / Xcode for mobile development

### Installation

```bash
# Clone the repo
git clone <repository-url>

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Generate mocks (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Code Standards

This project follows the Flutter Development Playbook:

- Clean architecture with clear separation of concerns
- All files under 300 lines
- Comprehensive Dart doc comments
- Proper error handling and logging

- No hardcoded strings or values

## Development

### Adding a New Feature

1. Create feature folder under `lib/features/`
2. Organize into `data/`, `domain/`, and `presentation/` layers
3. Add tests in `test/features/`
4. Update documentation

### Code Review Checklist

- [ ] Follows clean architecture
- [ ] Files under 300 lines
- [ ] Has Dart doc comments
- [ ] Includes tests
- [ ] No hardcoded values
- [ ] Proper error handling




