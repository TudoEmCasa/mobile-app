# Categories Feature - Refactored Architecture

## Directory Structure

```
lib/features/categories/
├── data/
│   ├── models/
│   │   ├── category_model.dart
│   │   └── index.dart
│   ├── providers/                    ← NEW: Provider layer
│   │   ├── category_repository_provider.dart
│   │   └── index.dart
│   ├── repositories/
│   │   ├── category_repository.dart  (clean, no providers)
│   │   └── index.dart
│   └── ...
├── presentation/
│   ├── pages/
│   │   ├── category_list_page.dart   (updated: uses ViewModel)
│   │   └── index.dart
│   ├── viewmodels/
│   │   ├── category_list_viewmodel.dart (refactored: proper MVVM)
│   │   └── index.dart
│   ├── widgets/
│   │   ├── category_item_widget.dart
│   │   ├── empty_categories_widget.dart
│   │   └── index.dart
│   └── ...
└── AGENTS.md
```

## Architecture Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  CategoryListPage (ConsumerWidget)                       │  │
│  │  • Watches watchAllCategoriesProvider for data           │  │
│  │  • Reads categoryListViewModelProvider for actions       │  │
│  │  • Renders UI                                            │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ consumes providers
┌──────────────────────────▼──────────────────────────────────────┐
│                    VIEWMODEL LAYER                              │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  categoryListViewModelProvider (Provider)                │  │
│  │  • Provides CategoryListViewModel instance              │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐ │  │
│  │  │ CategoryListViewModel                              │ │  │
│  │  │ • createCategory(name)                             │ │  │
│  │  │ • deleteCategory(id)                               │ │  │
│  │  │ • Business logic encapsulation                     │ │  │
│  │  └────────────────────────────────────────────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ consumes providers
┌──────────────────────────▼──────────────────────────────────────┐
│                    PROVIDER LAYER                               │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  categoryRepositoryProvider (Provider)                   │  │
│  │  • Location: data/providers/                            │  │
│  │  • Creates CategoryRepository singleton                  │  │
│  │  • Injects AppDatabase via appDatabaseProvider          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  watchAllCategoriesProvider (StreamProvider)            │  │
│  │  • Location: data/providers/                            │  │
│  │  • Streams reactive list of categories                  │  │
│  │  • Sorted alphabetically by name                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ uses
┌──────────────────────────▼──────────────────────────────────────┐
│                   REPOSITORY LAYER                              │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  CategoryRepository                                       │  │
│  │  Location: data/repositories/                            │  │
│  │                                                          │  │
│  │  Methods:                                                │  │
│  │  • createCategory(name): Future<int>                     │  │
│  │  • getCategoryById(id): Future<CategoryModel?>           │  │
│  │  • watchCategoryById(id): Stream<CategoryModel?>         │  │
│  │  • watchCategories(): Stream<List<CategoryModel>>        │  │
│  │  • updateCategory(category): Future<bool>                │  │
│  │  • deleteCategory(id): Future<bool>                      │  │
│  │                                                          │  │
│  │  Encapsulates:                                           │  │
│  │  • Database queries                                      │  │
│  │  • Drift queries with type safety                        │  │
│  │  • Sorting and filtering                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ uses
┌──────────────────────────▼──────────────────────────────────────┐
│                   DATABASE LAYER                                │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  AppDatabase (Drift ORM)                                │  │
│  │  • Manages SQLite connection                            │  │
│  │  • Provides strongly-typed queries                      │  │
│  │  • Reactive streams via watch()                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                          │                                      │
│                          ▼                                      │
│                   SQLite Database                              │
└─────────────────────────────────────────────────────────────────┘
```

## Key Principles Applied

### 1. **Separation of Concerns**
- UI only handles presentation
- ViewModel handles business logic
- Repository handles data persistence
- Providers handle dependency injection

### 2. **Dependency Injection via Riverpod**
- AppDatabase injected into Repository via `appDatabaseProvider`
- Repository injected into ViewModel via `categoryRepositoryProvider`
- Single instance pattern ensures consistency

### 3. **Reactive Programming**
- `watchAllCategoriesProvider` provides reactive stream
- UI rebuilds when categories change
- Powered by Drift's reactive watch() API

### 4. **Type Safety**
- Full Dart type system usage
- Drift provides SQL type safety
- No raw SQL queries

### 5. **MVVM Pattern**
```
View (UI) ←→ ViewModel ←→ Repository ←→ Database
  (passive)    (logic)   (persistence)  (data)
```

## Data Flow Examples

### Creating a Category

1. User types name and presses "Create"
2. Page calls `viewModel.createCategory(name)`
3. ViewModel reads `categoryRepositoryProvider`
4. Repository calls `_db.into(_db.categories).insert(...)`
5. Drift creates category in SQLite
6. `watchAllCategoriesProvider` emits new list
7. Page rebuilds with new category

### Watching All Categories

1. Page watches `watchAllCategoriesProvider`
2. Provider watches `categoryRepositoryProvider.watchCategories()`
3. Repository returns stream from `_db.select(_db.categories)...`
4. Drift watches database table
5. Any category change emits new list
6. Page updates automatically

## Compliance Checklist

✅ **MVVM Architecture**
- Clear separation between UI, ViewModel, Repository, Database
- UI delegates to ViewModel
- ViewModel delegates to Repository

✅ **Riverpod Integration**
- Provider pattern for dependency injection
- StreamProvider for reactive data
- Single instance management

✅ **Clean Architecture**
- No circular dependencies
- Single responsibility per layer
- Testable design

✅ **Drift ORM**
- No raw SQL
- Type-safe queries
- Reactive streams

✅ **Offline-First**
- All data persisted locally
- No external APIs
- Full functionality without internet

✅ **Code Quality**
- No analyzer warnings
- Consistent naming
- Well-documented
- Production-ready
