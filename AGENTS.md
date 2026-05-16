# Tudo em Casa — Project Context

## Overview

Tudo em Casa is an offline-first mobile application for household inventory management.

The application allows users to:
- register products
- track expiration dates
- manage household stock
- receive local notifications
- organize items by categories

The system must work fully offline.

Do not use:
- authentication
- cloud synchronization
- external APIs
- remote servers
- multi-user support

---

## Technology Stack

- Flutter 3.41.9 (stable)
- Dart
- SQLite
- Drift ORM
- Riverpod
- MVVM Architecture

Use APIs compatible with Flutter 3.41.9 stable.

Avoid:
- deprecated APIs
- outdated examples
- legacy code

---

## Architectural Principles

- Prioritize simplicity
- Avoid overengineering
- Use separation of concerns
- Follow Clean Code principles
- Maintain low coupling
- Use feature-based modular structure

---

## State Management

Use Riverpod for:
- dependency injection
- reactive state management

Do not use:
- Provider
- GetX
- BloC

---

## Data Persistence

Use Drift + SQLite.

Rules:
- use strongly typed queries
- avoid raw SQL whenever possible
- access the database through repositories

---

## Language Rules

The entire codebase must use English.

Use English for:
- classes
- variables
- methods
- files
- folders
- database tables
- database fields
- comments
- commits
- technical documentation

Avoid mixing languages.

Correct examples:
- ProductRepository
- ProductViewModel
- fetchProducts()
- expiration_date

Incorrect examples:
- ProdutoRepositorio
- buscarProdutos()
- data_validade

Exceptions:
- Flutter APIs
- external libraries
- official package names

The academic article (TCC) must remain in Brazilian Portuguese.

---

## UI Guidelines

- Clean and minimalist interface
- Prioritize readability
- Avoid excessive animations
- Use Material 3

---

## Code Style

- Small widgets
- Small methods
- Explicit naming
- Prefer composition over inheritance
- Avoid unnecessary abbreviations

Avoid:
- qty
- cat
- prod

Prefer:
- quantity
- category
- product

---

## Project Constraints

This project is an academic final graduation project (TCC).

Priorities:
1. readability
2. architectural organization
3. maintainability
4. offline reliability
5. simplicity

Do not introduce:
- unnecessary abstractions
- excessive complexity
- premature optimizations

---

## Current Scope (MVP)

Implemented or planned:
- categories
- product types
- units
- products
- expiration tracking
- local notifications
- export/import

Not planned:
- backend
- login
- synchronization
- online features
- AI features

---

## Commit Convention

Use Conventional Commits for all commits.

Format:

<type>: <short description>

Examples:
- feat: add product registration
- fix: correct expiration date validation
- refactor: simplify product repository
- docs: update architecture documentation

---

## Allowed Commit Types

### feat

Use for:
- new features
- new screens
- new business logic
- new functionality

Example:
- feat: add category creation

---

### fix

Use for:
- bug fixes
- incorrect behaviors
- validation corrections
- crashes

Example:
- fix: prevent invalid expiration date

---

### refactor

Use for:
- code improvements
- internal restructuring
- readability improvements
- architectural cleanup

Do not use for new features.

Example:
- refactor: reorganize database providers

---

### docs

Use for:
- documentation updates
- markdown files
- architecture notes
- comments

Example:
- docs: update database structure

---

### style

Use for:
- formatting
- spacing
- lint cleanup
- non-functional visual code changes

Do not use for UI features.

Example:
- style: format product page

---

### chore

Use for:
- project setup
- dependency updates
- configuration changes
- tooling
- build configuration

Example:
- chore: add drift dependencies

---

### test

Use for:
- unit tests
- widget tests
- integration tests

Example:
- test: add product repository tests

---

## Commit Rules

- Use English
- Keep messages short and objective
- Use lowercase commit types
- Do not end commit messages with a period
- Prefer one logical change per commit

Avoid:
- generic messages
- large mixed commits
- unclear descriptions

Avoid examples:
- update stuff
- fixes
- changes

Prefer:
- feat: add product list page
- fix: correct unit selection validation

---

## Comments Guidelines

Prefer self-explanatory code over excessive comments.

Code should be understandable through:
- explicit naming
- small methods
- small widgets
- clear responsibilities
- clean architecture

Avoid:
- redundant comments
- obvious comments
- line-by-line explanations
- comments that describe what the code is already clearly expressing

Bad examples:

```dart
// Create category
final category = Category();
```

```dart
// Return categories list
return categories;
```

Prefer:

```dart
final category = Category();
```

```dart
return categories;
```

Comments are allowed only for:
- complex business rules
- important architectural decisions
- technical limitations
- temporary workarounds with clear justification

The project should prioritize:
- readability
- maintainability
- explicit naming
- clean structure

Prefer clean code over commented code.

---

## Testing

The project uses automated tests.

Official testing guidelines:
- docs/testing.md
- test/AGENTS.md

Tests must:
- mirror lib/ structure
- follow architecture rules
- prioritize readability and maintainability

---

## Relational Modeling

Prefer relational entities with optional related objects.

Example:

```dart
final CategoryModel? category;
```

Avoid:
- duplicated relational models
- flattened relationship fields
- relationship-specific entity variants

---

## Selection UX Pattern

Avoid large dropdown selectors for relational entities.

Prefer dedicated selection pages instead of dropdowns when selecting:
- categories
- product types
- units
- relational entities

Preferred flow:

Form Page
→ Navigate to Selection Page
→ User selects item
→ Return selected entity
→ Populate form field

Reasons:
- better mobile UX
- better scalability
- cleaner forms
- easier future search/filter implementation
- more consistent navigation behavior

Requirements:
- selection pages must support reactive lists
- selection mode must not break existing CRUD flows
- avoid duplicated selection pages
- prefer reusable list/select behavior

Avoid:
- giant dropdowns
- deeply nested selectors
- modal-based relational selection