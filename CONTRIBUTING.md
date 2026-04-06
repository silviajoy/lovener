# Contributing to Impariamo

First off, thank you for considering contributing to Impariamo! 

This educational Flutter project is built with Clean Architecture, and we ask that you adhere to our structure and conventions when making changes.

## Clean Architecture Principles

We structure each feature module using Clean Architecture. You'll see directories like:
- **01_data**: Models, data sources (Hive, REST APIs), and repository implementations.
- **02_domain**: Core business logic, Entities, Use Cases, and repository interfaces.
- **03_presentation**: UI layer, pages, widgets, and BLoC (State Management).

**Key Rules:**
1. **Domain Isolation**: Code in the `02_domain` directory cannot depend on anything from `01_data` or `03_presentation`.
2. **Dependency Injection**: Use `GetIt` for obtaining dependencies. Register your services/repositories in `lib/src/di/injection.dart`.
3. **State Management**: Use `flutter_bloc` for state. Presentational widgets should try to remain stateless, delegating logic to the BLoCs.
4. **DartDoc Comments**: Include comprehensive DartDoc (`///`) for every public class, method, and variable. Explain not just what code does, but its purpose in the architecture.

## How to Contribute

### 1. Branch Naming
Create a clean branch for your work:
- `feature/description` (e.g. `feature/addition-game`)
- `fix/description` (e.g. `fix/score-calculation`)
- `docs/description` (e.g. `docs/update-readme`)

### 2. Commit Messages
Use [Conventional Commits](https://www.conventionalcommits.org/):
- `feat: add new division game`
- `fix: correct layout overflow on small screens`
- `docs: update entity documentation`

### 3. Submission Protocol
1. Open an issue first to discuss planned changes if they're architectural or significantly large.
2. Ensure your code is properly formatted (`dart format .`).
3. Ensure the project builds successfully.
4. Open a Pull Request on GitHub to the `develop` (or `main`) branch and link the corresponding issue.

Thank you for helping build an open-source educational platform!