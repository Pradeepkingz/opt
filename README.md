# Optz

Optz is a Flutter mobile application that aggregates ride-hailing providers (Ola, Uber, Rapido, ONDC) and lets riders compare fares before handing off to the provider to complete the booking.

## Getting started

1. Ensure Flutter (stable channel) is installed.
2. Fetch packages and generate code:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. Run the mobile app (Android/iOS simulator):
   ```bash
   flutter run
   ```

## Core flows

### Compare rides
* Launch the app and enter origin, destination, and when you want to travel (Now/Later).
* Tap **Compare rides** to see normalized quotes from Ola, Uber, Rapido, and ONDC.
* Use the sort chips (Total, ETA, Rating) to reorder results.
* Tap **Book on provider** to open the in-app handoff sheet and simulate a deep-link.

### History & offline recall
* Every search is saved locally. Visit **History** from the home app bar to reopen previous quotes.
* When offline, cached quotes surface with a “stale” banner.

### Role switching & admin
* Open the role switcher (person icon in the app bar) to toggle between **User** and **Admin** roles (stored in shared preferences).
* When in the Admin role, an **Admin** floating action button appears on the home screen.
* Admin controls include:
  * Toggle **Happy Hour** (applies a 5% discount on new quotes).
  * **Reseed data** to restore starter searches and reset settings.
  * Analytics tiles for installs, searches, average quotes per search, and happy hour state.
  * Adapter log viewer with the 50 latest mock adapter executions.

### Testing Happy Hour
1. Run a search as a user and note totals.
2. Switch to Admin, enable Happy Hour, then run the same search again – totals will drop by ~5%.

## Architecture highlights
* Riverpod for state management and DI.
* go_router for navigation.
* Drift-backed persistence with deterministic mock adapters.
* Freezed/JSON serializable data models ready for build_runner generation.
* Shared preferences for role flag and lightweight settings.

## Project structure
Refer to `lib/` for feature modules, common widgets, data layer, and adapters. The architecture is layered to enable future reverse-bidding features without heavy refactors.
