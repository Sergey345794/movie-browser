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

**Dark Theme** - Sticking with Material 3 light theme to keep things simple.

**Advanced Filters** - No genre/year filters because OMDb's free API is pretty limited there.

**Pull-to-Refresh** - You can retry manually with the error screen button, but no swipe-down refresh.

**Cache Expiration** - Cache is infinite. Once you view a movie, it stays cached forever (or until you clear app data).

**Share Functionality** - No social sharing buttons.

**Offline-First Sync** - Cache is fallback-only, not a full offline mode with sync queues.

## Tech Stack

- **flutter_bloc** (^9.0.0) - State management
- **hive** (^2.2.3) - Local NoSQL database
- **dio** (^5.4.0) - HTTP client for API calls
- **flutter_hooks** (^0.20.3) - Local UI state (controllers, timers)
- **intl** (^0.20.2) - Localization
- **equatable** (^2.0.5) - Value equality for BLoC states
- **flutter_dotenv** (^6.0.0) - Environment variables
- **bloc_test** (^10.0.0) - Testing BLoCs
- **mocktail** (^1.0.1) - Mocking dependencies

## Local Storage

Three Hive boxes: Box, Purpose, Max Items
| `favorites_box` | Saved movies | Unlimited |
| `details_cache_box` | Movie details for offline | Unlimited |
| `search_history_box` | Recent searches | 20 (FIFO) |

## Performance Notes

- **Debouncing** - 500ms delay on search input reduces API calls
- **ListView.builder** - Lazy loading for all lists
- **Const constructors** - 45+ const keywords throughout
- **ValueKey on list items** - Prevents unnecessary rebuilds during pagination
- **Pagination trigger** - Loads next page at 90% scroll, not at the very end

## Known Issues

- **OMDb Free Tier** - Limited to 1,000 requests/day
- **Some posters missing** - API returns "N/A" for poster URL on some movies (we show a fallback icon)
- **RTL Layout** - Hebrew translation works but some UI elements could use more polish for proper RTL
