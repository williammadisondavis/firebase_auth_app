# Firebase Authentication App — In-Class 13

A Flutter Android app using Firebase Authentication with email and password.

## Features

- Register a new account
- Sign in and sign out
- Show the signed-in user's email on a protected profile screen
- Watch `authStateChanges()` to switch between login and profile screens
- Validate email and password input
- Change a password, with reauthentication if Firebase requires a recent sign-in
- Show helpful loading and error feedback

## Setup

1. Install Flutter, an Android emulator, and the Firebase CLI / FlutterFire CLI.
2. Run `flutter pub get`.
3. Create/select a Firebase project and enable **Authentication > Sign-in method > Email/Password**.
4. From the project root, run `flutterfire configure --platforms=android` to generate `lib/firebase_options.dart` for your own project.
5. Run `flutter run` with an Android device or emulator.

## Testing

Run `flutter analyze` and `flutter test`. Manually check: register, profile email, sign out, sign in again, invalid email, short password, wrong password, app restart/session restoration, password update, old-password rejection, and signed-out access. Tests in `test/validation_test.dart` cover input validation; Firebase actions require manual tests in the configured project.

## Release APK

Run `flutter build apk --release`. The APK will be at `build/app/outputs/flutter-apk/app-release.apk`. Make sure AndroidManifest.xml includes the INTERNET permission for release builds and install the APK to test authentication before submitting.

## Security note

Firebase Authentication manages account credentials. The app does not save passwords in Firestore. Auth-based UI routing is not a replacement for server-side authorization rules when accessing protected data.
