# Agents Rules — Database Tables (Core)

## 📌 Table Class Naming Convention

All database table classes **must follow a strict naming rule**:

### ❌ Do NOT use suffix `Table`
Do not append `Table` to class names.

### ✅ Use only the entity name in PascalCase

The class name must represent only the entity, without any suffix.

---

## 📚 Examples

| Entity     | ❌ Incorrect     | ✅ Correct |
|------------|------------------|------------|
| Product    | ProductTable     | Product    |
| Category   | CategoryTable    | Category   |
| Unit       | UnitTable        | Unit       |
| Expiration | ExpirationTable  | Expiration |

---

## 📁 File Structure Rule

Even if the file is inside `table/`, the class name must remain the entity name:
```
core/
└── database/
└── table/
├── product.dart -> class Product
├── category.dart -> class Category
└── unit.dart -> class Unit
```

---

## 🧠 Rationale

- Avoid redundant naming (`Table`)
- Keep Drift definitions aligned with domain entities
- Improve readability and maintainability
- Maintain a clean mapping between:
  - Domain entity
  - Database table

---

## ⚠️ Enforcement Rules

Agents MUST:

- Always generate table classes using only the entity name
- Never append suffixes such as `Table`, `Entity`, or `Model` in database layer
- Keep naming consistent across:
  - Drift tables
  - Repositories
  - Mappers

---

## 🚫 Forbidden Patterns

- ProductTable
- CategoryTable
- UnitTable
- Any `*Table` suffix in class names

---

## ✅ Expected Pattern

- Product
- Category
- Unit
- Expiration