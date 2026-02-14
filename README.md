## How to Run the Project

### Prerequisites

You'll need:

- Flutter SDK 3.0+
- An OMDb API key (free at [omdbapi.com](https://www.omdbapi.com/apikey.aspx))

### Setup

1. Clone and install dependencies:

```bash
git clone <repo-url>
cd movie-browser
flutter pub get
```

2. Create a `.env` file in the project root with your OMDb API key:

```
OMDB_API_KEY=your_api_key_here
```

3. Generate code (for Hive adapters and JSON serialization):

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```bash
flutter run
```

That's it! The app should launch on your connected device or emulator.

### Running Tests

```bash
flutter test
```

All 15 unit tests should pass (7 for MovieSearchBloc + 7 for MovieDetailsBloc + 1 for FavoritesBloc).

## Architecture Decisions

The project uses **Clean Architecture** to keep code organized and testable. Here's why:

### Three-Layer Structure

```
Domain (business logic)

Data (implementation)

Presentation (UI)
```

**Domain Layer** - Pure Dart entities and repository interfaces. No Flutter imports, so it's easy to test and reuse.

**Data Layer** - Implements repositories with real API calls (Dio) and local storage (Hive). Handles caching logic and error mapping.

**Presentation Layer** - BLoC for state management, screens built with flutter_hooks. UI reacts to state changes, nothing more.

### Cache Fallback Strategy

When you open movie details, the app tries to fetch from the API first. If that fails (no internet, API down, etc.), it checks the local cache and shows that instead with a yellow banner. This way users can still see movies they viewed before even when offline.

## What Was Not Implemented

A few things I didn't include:

**iOS Testing** - The project has full iOS support (icons, Info.plist configured, etc.) but I didn't actually test it on iOS devices or simulators since that wasn't required for the assignment. It should work fine though based on the standard Flutter setup.

**Pull-to-Refresh** - You can retry manually with the error screen button, but no swipe-down refresh.


## Performance Notes

- **Debouncing** - 500ms delay on search input reduces API calls
- **ListView.builder** - Lazy loading for all lists
- **Const constructors** - 45+ const keywords throughout
- **ValueKey on list items** - Prevents unnecessary rebuilds during pagination
- **Pagination trigger** - Loads next page at 90% scroll, not at the very end

