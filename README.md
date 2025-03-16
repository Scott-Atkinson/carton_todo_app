![App Logo](https://cdn.prod.website-files.com/64c2a942390de869d73c144c/652ff485558d6fef7814a40b_CartonCloud_Logo_white_text%201.svg) <!-- Replace with your app logo URL -->

[![License](https://img.shields.io/github/license/username/repository)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)]()
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-brightgreen)]()

This Flutter Todo application demonstrates a modern, modular approach to mobile development using the Feature Slice Design pattern. The app allows users to manage todos with different priority levels, types, and deadlines. It features a clean, intuitive UI (kinda) with color-coded todo items, filtering and searching capabilities, and infinite scroll pagination. The architecture employs BLoC for state management, providing a clear separation of concerns between UI, business logic, and data layers. Data persistence is implemented using Hive for offline capability, allowing the app to function even without network connectivity. The app showcases best practices, efficient API usage through local-first data fetching, and responsive design principles.

---

## 🚀 Features

- ⭐ **Feature 1**: Display all TODOS in a list view with inifinite scroll.
- ⭐ **Feature 2**: Colour code the TODO based on its TYPE.
- ⭐ **Feature 3**: Search TODOs based on title.
- ⭐ **Feature 4**: Ability to complete a TODO.
- ⭐ **Feature 5**: Supports offline mode, utilizing HIVE for Local Storage.
- ⭐ **Feature 6**: Optimized performance to check Local Storage for data before going to the server.


---

## 🛠️ Technologies and Libraries used

- 🔷 Flutter - UI framework for cross-platform development
- 🧩 Feature Slice Design - Architectural pattern for organizing code
- 📦 Hive - Fast, lightweight local database for Flutter
- 🔄 BLoC Pattern - State management solution
- 📱 flutter_bloc - Implementation of the BLoC pattern
- 🌐 HTTP - For API calls and data fetching
- 🎨 Material Design - UI design language and component library
- 🔍 Equatable - Simplifies equality comparisons in Dart
- 💻 Build Runner - Code generation tool
- 📊 Hive Generator - For generating Hive type adapters
- 🎯 Dart - Programming language used for Flutter development

---

## 🖼️ Screenshots

### Home Screen
<img src="https://github.com/user-attachments/assets/d0601367-caa4-4550-8379-67826606783a" alt="Home Screen" width="300"/>

### Home Screen Search
<img src="https://github.com/user-attachments/assets/b7c459e1-22a2-4ec3-b200-535e79c938ea" alt="Home Screen" width="300"/>

### Todo Detail - Urgent Todo
<img src="https://github.com/user-attachments/assets/26b72c54-5966-402d-ac3d-7cd835e2f0ed" alt="Home Screen" width="300"/>

---

## 🛠️ Enhancements and Fixes

- 🖌️ **1**: Introduce Theming.
- 🎨 **2**: Implement UI Feedback to the User when a Save or Error has occured
- 🧪 **3**: Make the tests more meaningful.


---


## 📦 Installation

### Prerequisites
- Flutter: `^3.7.2`
- Dart: `3.5.3`

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/Scott-Atkinson/coin_gecko
   run flutter clean
   run flutter pub get
   run flutter run
