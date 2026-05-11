# Database Structure

## Database Technology

The application uses:
- SQLite
- Drift ORM

The database is fully local and offline-first.

---

## Main Entities

### Category

Represents high-level product organization.

Examples:
- Food
- Cleaning
- Hygiene

---

### ProductType

Represents generic product types associated with a category.

Examples:
- Rice
- Beans
- Soap

---

### Unit

Represents quantity measurement units.

Examples:
- kg
- L
- package
- unit

---

### Product

Represents the actual registered product.

Examples:
- White Rice
- Black Beans
- Liquid Soap

---

## Relationships

- Product belongs to ProductType
- Product belongs to Unit
- ProductType belongs to Category

---

## Rules

- Use Drift typed queries
- Avoid raw SQL when possible
- Access database through repositories
- Keep entities normalized
