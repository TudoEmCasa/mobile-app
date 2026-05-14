# Testing Context

This directory contains all automated tests for the project.

---

# Main Goals

Tests should:
- validate business behavior
- validate architecture consistency
- reduce regression risks
- support safe refactoring

---

# Current Testing Strategy

Focus on:
- repository tests
- ViewModel tests
- critical widget tests

Avoid:
- excessive mocking
- unnecessary complexity
- testing Flutter internals

---

# Folder Structure

Tests must mirror the production structure from lib/.

Example:

```text
lib/features/categories/data/repositories/
↓
test/features/categories/data/repositories/
```

---

# Naming Rules

Use:

```text
*_test.dart
```

Examples:

```text
category_repository_test.dart
product_type_repository_test.dart
```

---

# Test Writing Rules

Prefer:
- small tests
- isolated tests
- explicit names
- predictable assertions

Avoid:
- giant test files
- unrelated assertions
- duplicated setup

---

# Comments Guidelines

Avoid excessive comments.

Tests should be self-explanatory through:
- explicit naming
- clean structure
- readable assertions

---

# Riverpod Testing

Prefer:
- ProviderContainer
- provider overrides
- isolated provider tests

Avoid:
- unnecessary global state

---

# Mocking

Use:
- mocktail

Prefer:
- lightweight mocks
- minimal mocking

Avoid:
- overmocking
- mocking everything

---

# Architecture Rules

Tests must respect the official architecture:

UI -> ViewModel -> Repository -> Database

Do not bypass layers during tests unless explicitly necessary.