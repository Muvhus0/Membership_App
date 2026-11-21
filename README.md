# Membership Management App

The application allows users to register, sign in, select a membership tier, view membership-specific features, and upgrade their membership.

## Features

- **User Registration:** Register with a name, email address, and selected membership tier.
- **Simulated Authentication:** Sign in using an email address.
- **Preloaded Profiles:** Automatically load the five supplied mock user profiles on the first launch.
- **Membership Management:** View the current membership and its associated features.
- **Membership Upgrades:** Upgrade from Starter to Plus or Premium, or from Plus to Premium.
- **Persistent Storage:** Save user profiles, membership changes, and session information locally.
- **Profile Management:** Delete the currently signed in user's profile.
- **Independent User Profiles:** Each user's membership is maintained separately.

## Technology Stack

| Technology        | Purpose                                |
|-------------------|----------------------------------------|
| Flutter           | Cross-platform application development |
| Dart              | Application programming language       |
| Provider          | State management                       |
| SharedPreferences | Local data persistence                 |
| UUID              | Unique user ID generation              |
| Google Fonts      | Custom fonts                           |

## Membership Tiers

The application loads membership options and their associated features from `memberships.json`.

| Membership | Features |
|---|---|
| Starter | Browse Catalogue, Starter Guides |
| Plus | Browse Catalogue, Member Offers |
| Premium | Browse Catalogue, Priority Support |

## Project Setup

### Prerequisites

Ensure that the following are installed:

- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code
- An Android emulator, web emulator or physical device

### 1. Clone the repository

```bash
git clone https://github.com/Muvhus0/Membership_App.git
```

### 2. Navigate to the project directory

```bash
cd Membership_App
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

## Test Accounts

The following accounts are preloaded from the supplied `users.json` file.

| Name | Email | Membership |
|---|---|---|
| Naledi Mokoena | naledi.mokoena@example.com | Starter |
| Thabo Dlamini | thabo.dlamini@example.com | Plus |
| Aisha Jacobs | aisha.jacobs@example.com | Premium |
| Lerato Nkosi | lerato.nkosi@example.com | Starter |
| Sipho Khumalo | sipho.khumalo@example.com | Plus |

**Note:** Authentication is simulated locally.

## Application Navigation

The authenticated application contains three main sections:

### Home
Displays the features available under the signed-in user's current membership.

### Membership
Displays the current membership tier and its associated features.

### Upgrade Membership
Displays eligible higher membership tiers and their features. Users can select an upgrade and confirm the change before it is applied.

## Verification Guide

The following scenarios can be used to verify the application's functionality.

### 1. Sign-in
- Launch the application.
- Sign in using one of the supplied test account email addresses.
- Verify that the correct user and membership are displayed.

### 2. Membership Features
- Sign in using accounts from different membership tiers.
- Verify that each account displays the correct membership-specific features.

### 3. New Registration
- Register a new user using a name, email address, and membership selection.
- Verify that the new profile is saved.
- Attempt to register with an existing email address and verify that duplicate registration is prevented.

### 4. Membership Upgrade
- Sign in using a Starter account.
- Upgrade to Plus or Premium.
- Confirm the upgrade.
- Verify that the updated membership and features are reflected across all three sections.
- Sign in using a Plus account and verify that only Premium is available as an upgrade.
- Sign in using a Premium account and verify that the highest-tier message is displayed.

### 5. Persistence
- Upgrade a user's membership.
- Sign out and restart the application.
- Sign in again using the same email address.
- Verify that the upgraded membership is retained.

### 6. Profile Deletion
- Sign in using an existing account.
- Delete the profile.
- Restart the application.
- Verify that the deleted account can no longer sign in.
- Verify that other user profiles remain available.

## Data and Persistence

The application uses the supplied JSON files as its initial data source:

- `users.json` – Contains the five initial user profiles.
- `memberships.json` – Contains membership tiers and their associated features.

User data and membership changes are persisted locally using SharedPreferences.

Initial user seeding is performed only once. Deleting all preloaded users does not cause them to be automatically restored on subsequent launches.

## Running Tests

The application includes automated tests to verify authentication, user registration, membership management, and local data persistence.

### Run all tests
From the project root directory, run:
```bash
flutter test
```
### Run a specific test file

To run the authentication and user management tests:
```bash
flutter test test/auth_provider_test.dart
```

### Test Coverage

The automated tests verify:

Initial user profiles are loaded correctly.
Users can sign in with valid email addresses.
Sign-in fails for unknown email addresses.
New users can register and are automatically signed in.
Duplicate email registration is rejected.
Membership upgrades update the user's membership and persist locally.
Profile deletion removes the selected user and signs them out.

## Implementation Notes

- Membership features are derived from the selected membership data.
- Membership upgrades are restricted to higher tiers.
- Each user's membership changes are stored independently.
- Profile deletion affects only the currently signed-in user.
- Authentication and persistence are implemented locally for assessment purposes.

## Author

**Muvhuso Mutshinye**