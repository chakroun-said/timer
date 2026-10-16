# Workouts Timer App - Quick Start Guide

## 📱 App Overview

A complete Flutter workout timer application with the following workflow:

```
Home Page (List of Workouts)
  ↓
  ├─→ [+] Button → Add New Workout
  ├─→ Tap Workout → View Timers
  │    ↓
  │    ├─→ [Add Timer] → Create New Timer
  │    └─→ [Run] → Execute Timer
  │         ↓
  │         Start → Countdown → Bell/Beeps → Transitions → Complete
  │
  └─→ Menu (⋮) → Edit/Delete Workout
```

## 🚀 Quick Start

### 1. Install and Run
```bash
cd d:\Flutter\train\workouts_timer\workouts_timer
flutter pub get
flutter run
```

### 2. Create Your First Workout
1. Tap the **+** button on home page
2. Enter workout name (e.g., "HIIT Workout")
3. Tap **Add Timer**
4. Configure a timer:
   - **Name**: "Burpees"
   - **Sets**: 10
   - **Set Duration**: 0 min 30 sec
   - **Rest Duration**: 0 min 15 sec
5. Save and run!

## 🎯 Key Features

| Feature | Location | Details |
|---------|----------|---------|
| **Add Workout** | Home Page | Floating action button (+) |
| **Add Timer** | Workout Edit Page | Create timers within a workout |
| **Run Timer** | Workout Details | Start countdown with sounds |
| **Bell Sound** | Timer Execution | Plays when phase starts |
| **Beep Sound** | Timer Execution | Plays last 5 seconds |
| **Data Save** | All Operations | Automatic via SharedPreferences |

## 📂 File Organization

```
lib/
├── main.dart .......................... App entry
├── models/
│   ├── timer_model.dart .............. Timer data
│   └── workout_model.dart ............ Workout container
├── services/
│   ├── storage_service.dart .......... SharedPreferences
│   └── sound_service.dart ............ Audio playback
└── pages/
    ├── home_page.dart ................ Workout list
    ├── add_edit_workout_page.dart .... Create/Edit workouts & timers
    ├── workout_detail_page.dart ...... View timers
    └── timer_execution_page.dart ..... Run timer with countdown
```

## 🔧 Configuration

### Time Durations
- Set duration: Configurable minutes + seconds
- Rest duration: Configurable minutes + seconds
- Displayed as MM:SS format

### Number of Sets
- Each timer can have 1 to N sets
- Automatic transitions between sets and rest

### Sounds
- **Bell**: Plays at start of each phase
- **Beep**: Plays once per second for final 5 seconds

## 💾 Data Persistence

All data is saved automatically:
- ✅ Workouts
- ✅ Timers within workouts
- ✅ All configuration
- ✅ Survives app restarts

## 🎮 Timer Controls

| Button | Action |
|--------|--------|
| **Start** | Begin countdown (plays bell) |
| **Pause** | Pause current countdown |
| **Reset** | Return to beginning |

## 📝 Example Workout Structure

```
Workout: "Morning Cardio"
├── Timer: "Jumping Jacks"
│   ├── Sets: 3
│   ├── Set Duration: 1m 0s
│   └── Rest Duration: 0m 30s
├── Timer: "Burpees"
│   ├── Sets: 3
│   ├── Set Duration: 0m 45s
│   └── Rest Duration: 1m 0s
└── Timer: "Mountain Climbers"
    ├── Sets: 3
    ├── Set Duration: 1m 0s
    └── Rest Duration: 0m 45s
```

## 🐛 Troubleshooting

### Sounds not playing?
- Ensure device volume is not muted
- Check `assets/sounds/` has bell.mp3 and beep.mp3
- Replace with your own audio files if needed

### Data not saving?
- App requires phone's storage permissions
- Data is saved to SharedPreferences
- No internet connection required

### Timer not working?
- Ensure timer has valid durations
- At least one timer required per workout
- Check "Start" button is tapped

## 📱 Supported Platforms

- ✅ Windows
- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Linux

## 📚 Dependencies

- **shared_preferences**: Data persistence
- **audioplayers**: Sound playback
- **uuid**: Unique ID generation

Run `flutter pub get` to install all dependencies.

## 🎨 UI Highlights

- **Material Design 3**: Modern Material UI
- **Large Countdown**: Easy-to-read timer display
- **Intuitive Navigation**: Clear flow between screens
- **Modal Pages**: Full-screen add/edit forms
- **Popup Menus**: Edit/Delete options

---

**Ready to get started? Run `flutter run` and create your first workout!**
