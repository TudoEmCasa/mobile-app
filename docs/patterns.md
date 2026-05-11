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
