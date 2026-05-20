# 🌌 Celestia — NASA Space Explorer App

Celestia is a cross-platform mobile application built with Flutter, designed for both Android and iOS. It taps into NASA's open APIs to bring live space content directly to your fingertips.

## ✨ Features

- 🔭 **Astronomy Picture of the Day (APOD)** — Daily stunning space imagery with descriptions
- 🪐 **Planet Information** — Explore details about planets in our solar system
- ☄️ **Asteroid Tracking** — Real-time asteroid proximity and hazard data via NASA's NeoWS API
- ❤️ **Favorites** — Save and revisit your favorite space content
- 🌙 **Dark/Light Mode** — Theme toggle for visual comfort
- 🔔 **Notification Settings** — Manage alerts and preferences
- 🌐 **Language Support** — Multi-language accessibility options

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android  | ✅ Supported |
| iOS      | ✅ Supported |

## 🎨 Design Philosophy

Celestia follows platform-specific design guidelines:
- **Android**: Material Design — CardViews, bottom navigation bar, grid layouts
- **iOS**: Apple Human Interface Guidelines — tab bars, rounded inputs, layered interface depth

HCI principles applied throughout (Norman, 1983 & Nielsen, 1990):
- Visibility of system status
- Recognition over recall
- Aesthetic and minimalist design
- User control and freedom

## ♿ Accessibility

- WCAG AA compliant contrast ratios
- VoiceOver / TalkBack screen reader support
- Alt text on all image components
- Minimum 44×44pt touch targets
- Adjustable font sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- NASA API Key — get one free at [https://api.nasa.gov](https://api.nasa.gov)

### Installation

```bash
git clone https://github.com/YOUR_USERNAME/celestia-flutter-app.git
cd celestia-flutter-app
flutter pub get
flutter run
```

Add your NASA API key in `lib/constants.dart` or a `.env` file:
```dart
const String nasaApiKey = 'YOUR_API_KEY_HERE';
```

## 📡 APIs Used

- [NASA APOD API](https://api.nasa.gov/#apod)
- [NASA NeoWS (Asteroid) API](https://api.nasa.gov/#NeoWS)
- [NASA Planetary API](https://api.nasa.gov/#planetary)

## 🛠️ Built With

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [NASA Open APIs](https://api.nasa.gov/)

## 📄 License

MIT License — feel free to use and modify.
