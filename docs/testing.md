# Testing Strategy

## Overview

The project uses automated tests to ensure:
- maintainability
- architectural consistency
- predictable behavior
- safer refactoring

The testing strategy focuses on:
- unit tests
- ViewModel tests
- repository tests
- essential widget tests

Avoid excessive or unnecessary tests.

---

# Testing Principles

Prefer:
- small focused tests
- predictable tests
- isolated tests
- readable tests

Avoid:
- giant test files
- unnecessary mocks
- testing framework internals
- overly coupled tests

---

# Testing Types

## Unit Tests

Used for:
- repositories
- services
- business logic
- ViewModels

Unit tests should:
- be fast
- be isolated
- avoid real external dependencies

---

## Widget Tests

Used for:
- reusable widgets
- UI interactions
- visual state validation

Prefer testing:
- important user interactions
- conditional rendering
- loading/error states

Avoid testing:
- trivial UI
- framework behavior

---

# Folder Structure

Tests must mirror the lib/ structure.

Example:

```text
test/
├── features/
│   ├── categories/
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   ├── category_repository_test.dart
│   │   ├── presentation/
│   │   │   ├── viewmodels/
│   │   │   │   ├── category_list_viewmodel_test.dart
```

---

# Tools

## flutter_test

Official Flutter testing framework.

---

## mocktail

Used for:
- mocks
- stubs
- fake implementations

---

## riverpod_test

Used for:
- provider testing
- Riverpod integration testing

---

# Naming Conventions

Use:

```text
*_test.dart
```

Examples:

```text
category_repository_test.dart
product_type_viewmodel_test.dart
```

---

# Test Structure

Prefer:
- Given / When / Then
- Arrange / Act / Assert

Example:

```dart
test(
  'should create category successfully',
)
```

---

# Architectural Rules

Tests must respect the same architecture as production code.

UI must not:
- access database directly
- access repositories directly

Repositories must:
- focus on persistence only

ViewModels must:
- contain business logic

---

# Current Testing Priorities

Priority order:

1. Repository tests
2. ViewModel tests
3. Critical widget tests

Integration tests are not a priority at the current project stage.