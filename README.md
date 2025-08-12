# FINDOC_Assignment

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


> # Get the access of the app using this link: https://drive.google.com/file/d/1cxf-Rp6V9MpHHP8GeyhglcE5Yt89D4ND/view?usp=sharing

> # Code Architecture

lib/
├── main.dart # Entry point: Initializes the app (MyApp widget)

├── app.dart # Core App widget: Configures MaterialApp, theme, routing

│
├── models/ # Data Models

│ └── image_model.dart # Represents image data structure (id, author, width, height, urls)

│

├── services/ # External Data Interaction

│ └── api_service.dart # Handles HTTP requests to https://picsum.photos/v2/list

│

├── bloc/ # BLoC State Management (Core Logic Layer)

│ ├── login/ # BLoC for Login Screen

│ │ ├── login_event.dart # Defines events: LoginEmailChanged, LoginPasswordChanged, LoginSubmitted

│ │ ├── login_state.dart # Defines states: LoginInitial, LoginLoading, LoginSuccess, LoginFailure

│ │ └── login_bloc.dart # Implements logic: Validates inputs, emits states on events

│ │

│ └── home/ # BLoC for Home Screen

│ ├── home_event.dart # Defines events: HomeFetchImages

│ ├── home_state.dart # Defines states: HomeInitial, HomeLoading, HomeLoaded, HomeError

│ └── home_bloc.dart # Implements logic: Calls ApiService, emits states based on API result

│

├── screens/ # Presentation Layer (UI Screens)

│ ├── login_screen.dart # UI for login form, interacts with LoginBloc

│ └── home_screen.dart # UI for image list, interacts with HomeBloc

│

├── widgets/ # Reusable UI Components

│ ├── animated_moving_object.dart # Widget for animated background elements

│ └── dynamic_background.dart # Widget for dynamic image slideshow background

│

├── utils/ # Utility Functions & Helpers

│ └── validators.dart # Centralized input validation logic (email, password)

│
└── routes/ # Navigation (Named Routes)

└── app_routes.dart # Defines route names and generates routes for MaterialApp
