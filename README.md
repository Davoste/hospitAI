# HospitAI - Hospital Management System

A Flutter-based hospital management application designed for production environments with comprehensive patient management, reporting, and administrative features.

## 📋 Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)

## ✨ Features

### Core Features
- **Patient Management**: Add, update, and view patient records
- **Dashboard**: Real-time hospital statistics and analytics
- **Report Generation**: Daily, weekly, and monthly reports
- **Multi-Platform Support**: iOS, Android, Windows, macOS, Linux, Web
- **Authentication**: Secure user authentication (in development)
- **Role-Based Access Control**: Admin, doctor, nurse, staff roles

### Reports
- Daily Patient Summary
- Weekly Performance Metrics
- Monthly Hospital Statistics
- Custom Report Generation
- PDF/Excel Export

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.7+, Dart 3.7+
- **State Management**: Provider
- **Local Storage**: Hive
- **Networking**: Dio
- **Database**: Hive (local), Firebase/Custom Backend (remote)
- **Testing**: Flutter Test, Mocktail
- **CI/CD**: GitHub Actions

## 📁 Project Structure

```
lib/
├── core/
│   ├── exceptions/
│   │   └── app_exceptions.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── patient_model.dart
│   │   └── report_model.dart
│   ├── repositories/
│   │   ├── patient_repository.dart
│   │   └── report_repository.dart
│   └── datasources/
│       ├── local/
│       │   └── patient_local_datasource.dart
│       └── remote/
│           └── patient_remote_datasource.dart
├── domain/
│   ├── entities/
│   │   ├── patient_entity.dart
│   │   └── report_entity.dart
│   └── usecases/
│       ├── add_patient_usecase.dart
│       └── generate_report_usecase.dart
├── presentation/
│   ├── screens/
│   │   ├── dashboard/
│   │   ├── patients/
│   │   ├── reports/
│   │   └── settings/
│   ├── widgets/
│   ├── providers/
│   │   ├── patient_provider.dart
│   │   └── report_provider.dart
│   └── utils/
│       └── navigation.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.7 or higher
- Dart 3.7 or higher
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Davoste/hospitAI.git
cd hospitAI
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Environment Setup

Create `.env` file in the root directory:
```
API_URL=https://api.hospitai.dev
API_KEY=your_api_key_here
ENVIRONMENT=development
```

## 💻 Development

### Code Style

Follow Dart style guide:
```bash
# Format code
flutter format lib/

# Analyze code
flutter analyze
```

### Making Changes

1. Create a feature branch: `git checkout -b feature/feature-name`
2. Make your changes
3. Run tests: `flutter test`
4. Commit: `git commit -m 'feat: add feature'`
5. Push: `git push origin feature/feature-name`
6. Create Pull Request

### Branch Naming Conventions
- Feature: `feature/description`
- Bug Fix: `bugfix/description`
- Hotfix: `hotfix/description`
- Release: `release/version`

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/models/patient_model_test.dart
```

### Test Coverage Goal
- Unit Tests: 80%+
- Widget Tests: 50%+
- Integration Tests: 30%+

## 📊 Report Generation

The application includes comprehensive reporting features:

### Daily Reports
- Patient admission/discharge summary
- Bed occupancy status
- Emergency cases handled

### Weekly Reports
- Patient statistics
- Doctor performance metrics
- Resource utilization

### Monthly Reports
- Hospital KPIs
- Financial summary
- Department performance

## 🔐 Security

- HTTPS for all API calls
- JWT token-based authentication
- Role-based access control
- Data encryption at rest (Hive)
- Secure credential storage

## 📦 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support, email amungai37@gmail.com or open an issue on GitHub.

## 📈 Roadmap

- [ ] Advanced analytics dashboard
- [ ] Mobile app notification system
- [ ] Telemedicine features
- [ ] Integration with hospital systems
- [ ] AI-powered diagnostics assistant
