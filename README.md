# Shopeasy 🛍️

**A scalable Flutter Ecommerce App showcasing Clean Architecture, MVVM, and Bloc State Management.**

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)
![State Management](https://img.shields.io/badge/State_Management-Bloc-red)
![Architecture](https://img.shields.io/badge/Architecture-Clean_MVVM-green)

---

## 🎯 Motivation & Learning Goals

This project was built primarily as a **learning initiative** to master the industry-standard tools and architectural patterns used in large-scale Flutter applications. 

Coming from a background with other state management solutions (like MobX), the goal of *Shopeasy* was to deeply understand and implement:
*   **Flutter Bloc:** Managing complex state flows and events.
*   **Dio:** Handling advanced networking, interceptors, and robust API calls.
*   **Clean Layered Architecture:** Structuring code to separate business logic, data, and UI for maximum scalability and testability.

---

## 📖 About The Project

**Shopeasy** is a concept ecommerce application. Unlike typical tutorials, this project simulates a real-world enterprise environment by strictly adhering to the **Repository Pattern** and **Dependency Injection**.

### 💡 The "Hybrid" Data Approach
To make the app feel "real" without a dedicated backend team, the app uses a hybrid data strategy:
1.  **Real-Time Data:** Products, Categories, and Search results are fetched via HTTP (`Dio`) from [DummyJSON](https://dummyjson.com/).
2.  **Mock Data:** The Cart and Wishlist features use a simulated backend service (Mock Repository) with artificial network delays to mimic asynchronous server interactions.

---

## 🎥 App Demo

https://github.com/user-attachments/assets/e13f70e1-9b9f-48b8-aa75-c96e09e5bbdd

---

## 📂 Architecture & Folder Structure

The project follows a **Clean Layered Architecture**. This structure ensures that the UI code doesn't know *how* data is fetched, only that it *has* data.

```text
lib/
├── core/                  # Generic code (Constants, Errors, DI Setup)
├── domain/                # Pure Dart layer (Entities & Repository Interfaces)
│   ├── models/            # Product & Cart data models
│   └── repositories/      # Contracts defining what data the app needs
├── data/                  # Implementation layer
│   ├── repositories/      # Concrete implementation of Repositories (API & Mock)
│   └── services/          # Dio Client & Local Mock Database
├── presentation/          # UI & State Management layer
│   ├── home/              # Home Feature (Bloc, Page, Widgets)
│   ├── cart/              # Cart Feature (Global Bloc)
│   ├── search/            # Search Feature (Cubit)
│   └── widgets/           # Shared UI components
└── main.dart              # App Entry point & Global Providers
```

---

## ✨ Key Features implemented

*   **Advanced State Management:**
    *   **HomeBloc:** Handles complex logic like Pagination (Infinite Scroll) and Category Filtering.
    *   **CartBloc:** A Global Bloc accessible throughout the app to manage cart state across screens.
    *   **SearchCubit:** A lightweight state manager for the search delegate.
*   **Reactive UI:** Adding an item to the cart updates icons across the Home, Search, and Detail screens instantly.
*   **Robust Networking:** Using **Dio** for API requests with proper error handling and interceptors.
*   **Dependency Injection:** Using **GetIt** to manage dependencies, allowing for easy swapping of Real vs. Mock repositories.
*   **UX Polish:** Hero animations for product images and native swipe-to-dismiss interactions in the cart.

---

## 🛠️ Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Language:** Dart
*   **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc)
*   **Architecture:** Clean Architecture + MVVM + Repository Pattern
*   **Networking:** [Dio](https://pub.dev/packages/dio)
*   **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
*   **Equality:** [Equatable](https://pub.dev/packages/equatable)

---

## 🚀 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/shopeasy.git
    cd shopeasy
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 🔮 Future Roadmap

*   [ ] Implement Persistent Storage (Hive or Shared Preferences) for the Cart.
*   [ ] Add Unit Tests for Blocs and Repositories.
*   [ ] Implement a "Checkout" flow with form validation.
