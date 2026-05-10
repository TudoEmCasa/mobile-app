# Arquitetura

O projeto utiliza:

- MVVM
- Riverpod
- Drift
- SQLite
- modularização por funcionalidade

Fluxo:

UI -> ViewModel -> Repositório -> Banco

Regras:
- Views não acessam banco diretamente
- ViewModels não renderizam UI
- Repositórios centralizam persistência
