# Impariamo 🇮🇹

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

"Impariamo" is an open-source educational Flutter mobile application designed to help users learn foundational math and reading skills through interactive gameplay. Built with Clean Architecture, BLoC, and Local Storage (Hive), this project aims to be highly modular and maintainable.

---

## 🚀 Features

The application is structured into domain-specific modules for progressive learning:

*   **01_core**: (coming soon)
*   **02_leggiamo**: Reading learning modules (coming soon)
*   **03_contiamo**: Math concepts, focusing primarily on multiplication tables with three core modes:
    *   **Table Choice (Falling Bubbles):** A visual matching game where users tap correct answers before they disappear.
    *   **Table Input:** A fast-paced typed input game testing recall speed.
    *   **Guess Table:** A rapid-fire multiple-choice game with interactive sound feedback.

---

## 🛠 Tech Stack & Architecture

-   **Framework:** Flutter (Dart)
-   **Architecture:** Clean Architecture
-   **State Management:** BLoC (`flutter_bloc`)
-   **Routing:** `go_router`
-   **Dependency Injection:** `get_it`
-   **Local Storage:** `hive`, `hive_flutter`
-   **Value Equality:** `equatable`

### Clean Architecture Approach

Our project breaks features down by layer to decouple the UI from business rules and data models:
-   **Domain Layer:** Enterprise logic and interfaces (`entities`, `repositories` contracts).
-   **Data Layer:** Concrete implementations (`models`, `datasources`, repository implementations).
-   **Presentation Layer:** Visual representation (`pages`, `widgets`) mapping to state (`bloc`).

---

## 💻 Getting Started

### Prerequisites
-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (Ensure versions matched in `pubspec.yaml` environment sdk)
-   Your preferred IDE (VS Code, Android Studio)

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/your-username/impariamo.git
    cd impariamo
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the application**
    ```bash
    flutter run
    ```

---

## 🤝 Contributing

We welcome contributions from the community! Whether you find a bug, want to add a new game mode, or improve our documentation, please read our [CONTRIBUTING.md](CONTRIBUTING.md) to get started on rules and conventions.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
