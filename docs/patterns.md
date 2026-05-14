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