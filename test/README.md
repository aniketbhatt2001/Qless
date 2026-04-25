# Test Directory

This directory contains all automated tests for the canteen management application.

## Structure

```
test/
├── features/           # Feature-specific tests
│   ├── auth/
│   │   ├── data/      # Data layer tests (repositories, data sources, models)
│   │   ├── domain/    # Domain layer tests (use cases, entities)
│   │   └── presentation/ # Presentation tests (controllers, widgets)
│   ├── cart/
│   ├── menu/
│   └── order/
└── core/              # Core utilities tests
    ├── utils/
    └── network/
```

## Testing Guidelines (Flutter Playbook)

### Test Coverage Target
- **Minimum**: 70% code coverage (MANDATORY)
- **Recommended**: 80%+ for critical features

### Test Types

#### 1. Unit Tests
Test individual units of code in isolation.

**What to test:**
- Use cases (business logic)
- Models (serialization/deserialization)
- Helpers and utilities
- Validators

**Example:**
```dart
test('should return user when login is successful', () async {
  // Arrange
  when(mockRepository.login(...)).thenAnswer((_) async => user);
  
  // Act
  final result = await useCase(params);
  
  // Assert
  expect(result, user);
});
```

#### 2. Widget Tests
Test UI components and their interactions.

**What to test:**
- Widget rendering
- User interactions (taps, swipes)
- State changes
- Navigation

**Example:**
```dart
testWidgets('should display error when login fails', (tester) async {
  // Arrange
  await tester.pumpWidget(LoginView());
  
  // Act
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Assert
  expect(find.text('Login failed'), findsOneWidget);
});
```

#### 3. Integration Tests (Future)
Test complete user flows across multiple features.

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/features/auth/domain/usecases/login_usecase_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### View coverage report
```bash
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## Mocking

We use **Mockito** for creating mock objects.

### Generate mocks
```bash
flutter pub run build_runner build
```

### Mock example
```dart
@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
  });
}
```

## Best Practices

### DO:
- ✅ Write tests for all use cases
- ✅ Test edge cases and error scenarios
- ✅ Use descriptive test names
- ✅ Follow AAA pattern (Arrange, Act, Assert)
- ✅ Mock external dependencies
- ✅ Keep tests independent and isolated
- ✅ Test one thing per test

### DON'T:
- ❌ Test implementation details
- ❌ Write tests that depend on other tests
- ❌ Use real network calls in unit tests
- ❌ Ignore failing tests
- ❌ Skip edge cases

## Test Naming Convention

```dart
test('should [expected behavior] when [condition]', () {
  // Test implementation
});
```

**Examples:**
- `should return user when login is successful`
- `should throw exception when credentials are invalid`
- `should display loading indicator when submitting form`

## Current Status

- ✅ Test directory structure created
- ✅ Sample test file added (login_usecase_test.dart)
- ⏳ Need to add tests for all features
- ⏳ Target: 70% coverage

## Next Steps

1. Generate mocks: `flutter pub run build_runner build`
2. Add tests for all use cases
3. Add tests for models
4. Add widget tests for key screens
5. Set up CI/CD to run tests automatically
6. Monitor coverage and maintain 70%+ target
