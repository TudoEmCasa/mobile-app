# Project Patterns

## Architecture

The project uses:
- MVVM
- feature-based modularization
- repository pattern

Flow:

UI -> ViewModel -> Repository -> Database

---

## State Management

Riverpod is responsible for:
- dependency injection
- reactive state management
- provider lifecycle

---

## Repository Pattern

Repositories centralize:
- database access
- data persistence
- query abstraction

UI and ViewModels must not directly access the database.

---

## ViewModels

ViewModels are responsible for:
- UI state
- business rules
- communication with repositories

ViewModels must not contain UI rendering logic.

---

## Widgets

Guidelines:
- keep widgets small
- avoid large build methods
- extract reusable components

---

## Code Organization

Use:
- explicit naming
- separation of responsibilities
- feature-based structure

Avoid:
- god classes
- large files
- unnecessary abstractions
- premature optimization


---

## Providers

Riverpod providers are responsible for:
- dependency injection
- exposing repositories
- exposing services
- exposing database instances

Guidelines:
- keep providers small
- avoid business logic inside providers
- repositories must be exposed through providers
- UI must access dependencies through Riverpod only

Naming conventions:
- appDatabaseProvider
- categoryRepositoryProvider
- notificationServiceProvider

Avoid:
- direct dependency instantiation inside UI
- global mutable state
- manual singleton implementations

---

# Form Navigation Pattern

## Overview

The application follows a mobile-first navigation approach.

Creation and editing flows must use dedicated pages instead of dialogs or modal-based forms.

This improves:
- mobile usability
- keyboard handling
- scalability
- accessibility
- future maintainability

---

# Preferred Pattern

Use:

```text
List Page
↓
Push Navigation
↓
Form Page
```

Examples:

```text
CategoryListPage
↓
CategoryFormPage
```

```text
ProductTypeListPage
↓
ProductTypeFormPage
```

---

# Form Page Responsibilities

Dedicated form pages should:
- handle creation flows
- support future editing flows
- contain validation logic
- provide proper spacing
- support mobile keyboard behavior

---

# Avoid

Avoid using:
- dialogs for forms
- modal bottom sheets for forms
- inline form expansion inside lists

These patterns are discouraged because they:
- reduce usability on mobile
- complicate validation flows
- limit scalability
- worsen keyboard handling

---

# Allowed Modal Usage

Dialogs/modals are allowed only for:
- confirmations
- alerts
- destructive action confirmation
- simple informational messages

Examples:
- delete confirmation
- unsaved changes warning
- error alerts

---

# Architecture Rules

Form pages must:
- use ViewModels/providers
- avoid direct database access
- avoid direct repository access

Forms should remain:
- simple
- reusable
- maintainable
- mobile-friendly

---

# UI Guidelines

Prefer:
- dedicated pages
- clear actions
- explicit save/cancel actions
- clean Material 3 layouts

Avoid:
- crowded forms
- nested modals
- complex dialog flows

---

# CRUD Interaction Pattern

## Overview

The application follows a mobile-first CRUD interaction pattern.

For simple entity management screens:
- actions should be explicit
- interactions should minimize taps
- primary actions should be easily discoverable

---

# List Item Actions

List items should expose explicit actions when the number of actions is small.

Preferred actions:
- edit
- delete

Preferred UI pattern:

```text
[ Entity Information ]

                [edit] [delete]
```

Avoid:
- hidden actions
- long press interactions
- overflow menus for simple CRUD flows
- swipe actions as primary interaction

These approaches reduce discoverability and worsen mobile usability.

---

# Edit Flow

Edit actions must:
- navigate to a dedicated form page
- prefill current entity values
- reuse the same form structure used for creation

Example:

```text
CategoryListPage
↓
CategoryFormPage(existingCategory)
```

---

# Delete Flow

Delete actions must:
- request confirmation before deletion
- use confirmation dialogs only for destructive actions

Deletion should:
- update lists reactively
- avoid manual refreshes

---

# Confirmation Dialog Rules

Dialogs are allowed only for:
- destructive action confirmation
- alerts
- warnings

Examples:
- delete confirmation
- unsaved changes warning

Avoid:
- form dialogs
- CRUD creation modals
- complex dialog flows

---

# Architecture Rules

CRUD actions must respect the official architecture:

UI -> ViewModel -> Repository -> Database

UI must never:
- access database directly
- perform persistence logic directly

---

# Reactive Behavior

Lists should update automatically using:
- Drift watch queries
- Riverpod reactive state

Avoid:
- manual refresh buttons
- imperative reload logic

---

# Relational Model Pattern

## Overview

The project follows a relational entity modeling strategy.

Entities should support optional relational objects instead of creating duplicated relational models.

---

# Preferred Approach

Prefer:

```dart
class ProductTypeModel {
  final int id;
  final String name;
  final int categoryId;
  final CategoryModel? category;
}
```

Instead of:

```dart
ProductTypeModel
ProductTypeWithCategoryModel
```

---

# Goals

This approach improves:
- scalability
- maintainability
- consistency
- relational modeling quality
- type safety

---

# Relationship Rules

Relationships should:
- be optional
- support nullable relational loading
- support queries with and without joins

Example:

```dart
final CategoryModel? category;
```

---

# Avoid

Avoid:
- duplicated entity models
- flattened relationship fields
- relationship-specific entity variants

Examples to avoid:

```dart
ProductTypeWithCategoryModel
ProductWithCategoryModel
ProductWithUnitModel
```

Also avoid:

```dart
categoryName
unitName
productTypeName
```

inside unrelated entities.

---

# Preferred Access Pattern

Prefer:

```dart
productType.category?.name
```

Instead of:

```dart
productType.categoryName
```

---

# Repository Rules

Repositories should:
- map joins into relational objects
- populate optional relationships when necessary
- keep entities consistent across all query types

---

# Scalability Goals

This pattern must be used across the entire project to support future relational growth while avoiding duplicated models and maintenance complexity.

---

# Selection Page Pattern

## Overview

This project adopts a mobile-first selection pattern for relational entities.

Instead of using dropdown selectors, the application uses dedicated selection pages.

---

## Motivation

Dropdowns become difficult to use when:
- datasets grow
- mobile screens are small
- keyboards are open
- users need fast navigation

Dedicated selection pages provide:
- better scalability
- better readability
- easier future search support
- cleaner forms
- more consistent mobile UX

---

## Preferred Flow

Form Page
→ Open Selection Page
→ User selects entity
→ Return selected entity
→ Populate form field

---

## Examples

Used for:
- Units selection
- Product Types selection
- Categories selection

Future reusable pattern:
- filters
- export options
- notification targets

---

## Implementation Guidelines

Requirements:
- reuse existing list pages when possible
- support selection mode
- preserve CRUD behavior
- avoid duplicated list implementations
- use Navigator push/pop flows
- return selected models explicitly

Avoid:
- large dropdowns
- modal selectors
- duplicated selection screens
- hidden selection behavior