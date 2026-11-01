# MinusCal

[![Status: Work in Progress](https://img.shields.io/badge/status-work_in_progress-amber)](#disclaimer)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Smart culinary recipe and nutrition planner built with Flutter for Android and Web, powered by Google Gemini 2.0 Flash.

> [!WARNING]
> **Work in progress**: MinusCal is in active development. Features, user interfaces, and nutritional calculation outputs are subject to change. Estimated nutrition values are generated for general planning and should not be treated as medical or dietary advice.

---

## Overview

MinusCal calculates recipes based on the ingredients and appliances in your kitchen.

Specify what you have:
- Appliances: Oven, Microwave, Gas Cooker, Rice Cooker, Air Fryer, Blender, Toaster
- Ingredients: Proteins, Vegetables, Carbs, Dairy, Spices, Sweets
- Parameters: Meal type (Breakfast, Lunch, Dinner, Snack, Post-Workout), cooking time, and nutritional goal

MinusCal estimates caloric totals and macronutrient breakdowns (Protein, Carbohydrates, Fat) for each recipe.

---

## Design Principles

Built following the **Oxfords** design ruleset:
- **Palette**: Poppy (Lead `#075431`, Support `#F63434`, Pop `#FCF4D2`) on neutral black ground (`#000000`).
- **Typography**: Platform system font stack with tabular figures for measurements and numbers.
- **Navigation**: Floating Liquid Glass navigation capsule inset from the display edges.
- **Structure**: Content-first hierarchy. No decorative background filler or buzzwords.

---

## Features

- **Kitchen Inventory**:
  - Direct selection of available equipment and ingredients.
  - Search filter and custom item creation.
  - Local persistence across sessions.
- **Nutrition Display**:
  - Caloric total per serving.
  - Tabular macronutrient breakdown (Protein, Carbohydrates, Fat).
- **Preparation Mode**:
  - Step-by-step checklist with completion tracking.
  - Built-in step timer with remaining countdown.
  - Saved recipes storage.
- **Cloud and Offline Dual Mode**:
  - Google Gemini 2.0 Flash with structured JSON schema.
  - Local rule engine for offline development.

---

## Running the Application

### 1. Web Server (Local Testing)
Run:
```bash
python -m http.server 8080 --directory build/web
```
Or execute `serve_web.bat`. Open `http://localhost:8080`.

### 2. Live Development
Run:
```bash
flutter run -d chrome
```
Or execute `start_dev.bat`.

### 3. Android APK
To run on a connected device:
```bash
flutter run -d android
```
To build a release APK:
```bash
flutter build apk --release
```
Or execute `build_apk.bat`.

---

## Google Gemini API Configuration

1. Obtain a free key from Google AI Studio (`aistudio.google.com`).
2. Open Settings in MinusCal.
3. Paste the key and select Test connection, then Save key.

---

## Disclaimer

MinusCal is an experimental application under active development. Nutritional metrics, caloric values, and recipe instructions are model-generated approximations and should be evaluated before dietary implementation.

---

## License

This project is distributed under the terms of the [MIT License](LICENSE).
