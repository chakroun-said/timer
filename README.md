# Workouts Timer App

A Flutter application for managing and executing workout timer sessions with multiple timed sets and rest periods.

## Features

✅ **Homepage with Workout Management**
- Add new workouts with a floating action button
- View all saved workouts
- Edit or delete existing workouts
- Workouts are persisted using SharedPreferences

✅ **Timer Configuration**
- Each workout contains multiple timers
- Each timer has:
  - Name
  - Number of sets
  - Set duration (minutes and seconds)
  - Rest duration (minutes and seconds)
- Add/Edit timers as full pages (not dialogs)

✅ **Timer Execution**
- Run individual timers with a visual countdown
- Bell sound plays at the start of each phase
- Beep sound plays each second during the final 5 seconds
- Automatic transitions between set and rest phases
- Manual pause/resume and reset controls
- Progress display (current set / total sets)

✅ **Data Persistence**
- All workout data is saved and persisted using SharedPreferences
- Changes are automatically saved when you create or edit workouts

✅ **Progressive Web App**
- Installable on desktop and mobile browsers (see [Web / Progressive Web App](#web--progressive-web-app))
- Works offline after the first load, using the service worker in `web/sw.js`

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── timer_model.dart              # TimerModel with serialization
│   └── workout_model.dart            # WorkoutModel with serialization
├── services/
│   ├── storage_service.dart          # SharedPreferences integration
│   └── sound_service.dart            # Audio playback for timer sounds
└── pages/
    ├── home_page.dart                # Main workout list and management
    ├── add_edit_workout_page.dart     # Add/Edit workout and timers
    ├── workout_detail_page.dart       # View timers in a workout
    └── timer_execution_page.dart      # Run timer with countdown
```

## Dependencies

- `flutter` - UI framework
- `shared_preferences` - Local data persistence
- `audioplayers` - Sound playback
- `uuid` - Unique ID generation

## Getting Started

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

## Web / Progressive Web App

The app also builds as an installable PWA (Chrome, Edge, Safari on iOS 16.4+,
and desktop).

```bash
flutter run -d chrome                                        # develop in the browser
flutter build web --release --no-web-resources-cdn           # build the PWA
```

`--no-web-resources-cdn` is required for the app to work offline: without it
Flutter loads its CanvasKit engine from a third-party CDN, which the service
worker cannot cache.

Serve the `build/web` output over HTTPS (localhost counts as a secure context)
so the browser offers to install the app. To try it locally:

```bash
flutter build web --release --no-web-resources-cdn
python -m http.server 8099 --directory build/web
# open http://localhost:8099
```

Then check:

1. DevTools → **Application → Service Workers**: `sw.js` is *activated*.
2. DevTools → **Application → Manifest**: the name, colours and icons are picked up.
3. DevTools → **Network → Offline**, then reload: the app still loads.
4. Install it via the address bar install icon (Chrome/Edge) or **Share → Add to
   Home Screen** (iOS 16.4+).

Because the service worker serves cached responses, a browser that already ran
the app may keep showing an older build. While developing, enable DevTools →
**Application → Service Workers → Update on reload** (or bump `CACHE_VERSION` in
`web/sw.js`) to force the new build.

| PWA file | Purpose |
| --- | --- |
| `web/manifest.json` | App name, icons, standalone display, theme colours |
| `web/index.html` | Web meta tags and service worker registration |
| `web/sw.js` | Offline-first service worker (see below) |
| `web/flutter_bootstrap.js` | Custom loader start-up (see below) |
| `web/icons/`, `web/favicon.png` | App icons generated from `assets/icon/appicon.png` |

Caching strategy in `web/sw.js`:

- The app shell is precached on install, so the first load after install works offline.
- Engine, font and asset files are served from cache and refreshed in the
  background (stale-while-revalidate) as they are first requested.
- Page loads go to the network first and fall back to the cached shell, so a
  new deployment is picked up as soon as the user is online.
- `CACHE_VERSION` in `web/sw.js` must be bumped when the strategy changes; the
  old cache is deleted on activation.

`web/flutter_bootstrap.js` deliberately starts the Flutter loader without
`serviceWorkerSettings`. Flutter's generated bootstrap otherwise registers a
deprecated no-op service worker that unregisters itself and force-reloads every
open window, which would interrupt a running workout.

### Deploying to GitHub Pages

`.github/workflows/deploy-web.yml` builds and publishes the app on every push to
`main` (and on demand from the Actions tab). The app ends up at
`https://<owner>.github.io/<repo>/`.

1. Create an empty repository on GitHub — do **not** let it add a README or
   `.gitignore`, the project already has one.
2. Push this project to it:

   ```bash
   git init -b main
   git add .
   git commit -m "Add web PWA support and Pages deployment"
   git remote add origin https://github.com/<owner>/<repo>.git
   git push -u origin main
   ```

3. In the repository: **Settings → Pages → Build and deployment → Source →
   GitHub Actions**. This is required, otherwise the deploy job fails.
4. Watch the run under the **Actions** tab, then open
   `https://<owner>.github.io/<repo>/`.

The workflow runs `flutter analyze` and `flutter test` before building, so a
failing check blocks the deployment.

The base href is derived from the repository name rather than hard-coded: a
project site is served from `/<repo>/`, and a user site (repo named
`<owner>.github.io`) is served from `/`. Building a project site without
`--base-href "/<repo>/"` makes every asset 404 and the page stay blank.

## Usage Guide

### Creating a Workout
1. Tap the **+** button on the home page
2. Enter a workout name
3. Tap "Add Timer" to create timers for this workout
4. For each timer:
   - Enter a name (e.g., "Burpees")
   - Set the number of sets
   - Set the duration for each set (minutes + seconds)
   - Set the rest duration (minutes + seconds)
5. Tap "Save Workout"

### Running a Timer
1. Navigate to a workout
2. Tap the "Run" button on any timer
3. On the execution page:
   - **Start** - Begin the timer (bell sound plays)
   - **Pause** - Pause the current countdown
   - **Reset** - Go back to the beginning
4. The app automatically:
   - Plays beeps during the final 5 seconds
   - Transitions from set to rest
   - Notifies you when the workout is complete

### Editing/Deleting
- Tap the menu (⋮) on a workout to edit or delete it
- Tap the menu on any timer to edit or delete it

## Audio Sounds

- **Bell Sound** - Plays at the start of each phase (set or rest)
- **Beep Sound** - Plays each second during the final 5 seconds

To use custom sound files:
1. Replace the audio files in `assets/sounds/`:
   - `bell.mp3` - Bell/start sound
   - `beep.mp3` - Countdown beep sound
2. Ensure the files are MP3 format

## Notes

- All data is stored locally on the device
- The app will continue to work even if audio files are not found
- Timer durations can be set in minutes and seconds for precise control
- Rest durations are optional (set to 0:00 if not needed)

A new Flutter project.
