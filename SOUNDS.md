# Adding Custom Sound Files

## Overview
The app uses two sound files for timer execution:
- **bell.mp3**: Plays at the start of each phase (set/rest)
- **beep.mp3**: Plays each second during the final 5 seconds

## Current Status
The app includes placeholder files. For the best experience, replace them with actual audio files.

## Where to Find Sounds

### Free Sound Resources
1. **freesound.org**: Community sound library
2. **zapsplat.com**: Free sound effects
3. **soundbible.com**: Public domain sounds
4. **pixabay.com/sound-effects**: Royalty-free sounds

### Recommended Sounds
- **Bell**: Search for "bell ding", "chime", "notification bell"
- **Beep**: Search for "short beep", "countdown beep", "timer beep"

## How to Replace Sounds

### Step 1: Get Your Sound Files
1. Download or create your sound files
2. Ensure they are in MP3 format
3. Keep them short (bell: ~1-2 seconds, beep: ~0.3-0.5 seconds)

### Step 2: Replace the Files
```bash
# Navigate to the sounds directory
cd d:\Flutter\train\workouts_timer\workouts_timer\assets\sounds

# Replace the files (Windows)
copy /Y your-bell-sound.mp3 bell.mp3
copy /Y your-beep-sound.mp3 beep.mp3
```

Or simply:
1. Open: `d:\Flutter\train\workouts_timer\workouts_timer\assets\sounds`
2. Delete existing `bell.mp3` and `beep.mp3`
3. Copy your new files with the exact names:
   - `bell.mp3`
   - `beep.mp3`

### Step 3: Rebuild the App
```bash
flutter clean
flutter pub get
flutter run
```

## Sound File Requirements

### Technical Specs
- **Format**: MP3 (recommended)
- **Sample Rate**: 44.1 kHz or 48 kHz
- **Bit Rate**: 128 kbps or higher
- **Channels**: Mono or Stereo

### Duration Recommendations
| Sound | Duration | Reason |
|-------|----------|---------|
| Bell | 1-2 seconds | Long enough to be noticed, short enough not to be annoying |
| Beep | 0.3-0.5 seconds | Quick and sharp, plays 5 times in succession |

### Volume Considerations
- Normalize volume across both files
- Not too loud (will play repeatedly)
- Clear and distinct tones

## Alternative Audio Formats

While MP3 is recommended, you can use other formats:

### To use WAV, M4A, or other formats:

1. **Update the file names** in [lib/services/sound_service.dart](lib/services/sound_service.dart):

```dart
// Change from:
await _audioPlayer.play(AssetSource('sounds/bell.mp3'));
await _audioPlayer.play(AssetSource('sounds/beep.mp3'));

// To (for WAV):
await _audioPlayer.play(AssetSource('sounds/bell.wav'));
await _audioPlayer.play(AssetSource('sounds/beep.wav'));
```

2. **Update pubspec.yaml** if needed (currently includes all files in `assets/sounds/`)

## Creating Your Own Sounds

### Using Audacity (Free)
1. Download Audacity: https://www.audacityteam.org/
2. Generate tone: `Generate → Tone...`
3. For bell: Use sine wave, 800-1200 Hz, 1 second
4. For beep: Use sine wave, 1000 Hz, 0.3 seconds
5. Export as MP3: `File → Export → Export as MP3`

### Simple Online Tools
- **onlinetonegenerator.com**: Generate simple tones
- **twistedwave.com/online**: Simple audio editing

## Testing Your Sounds

After adding custom sounds:

1. **Run the app**:
   ```bash
   flutter run
   ```

2. **Create a test timer**:
   - Name: "Sound Test"
   - Sets: 2
   - Set Duration: 0m 10s
   - Rest Duration: 0m 10s

3. **Run the timer**:
   - Listen for bell at start
   - Listen for beeps at final 5 seconds
   - Verify volume and clarity

## Troubleshooting

### Sounds Not Playing?

1. **Check file names** (must be exactly `bell.mp3` and `beep.mp3`)
2. **Verify file location**: `assets/sounds/`
3. **Rebuild app**: `flutter clean && flutter run`
4. **Check device volume**: Ensure not muted
5. **Check file format**: Must be valid MP3 (or update code)

### Sounds Too Loud/Quiet?

1. **Use audio editing software** to adjust volume
2. **Normalize audio** to -3dB to -6dB
3. **Test on actual device** (not just simulator)

### Sounds Cut Off?

1. **Increase file duration** slightly
2. **Add fade-out** at the end
3. **Check for encoding issues**

## Example Sound Characteristics

### Good Bell Sound
- ✅ Clear, pleasant tone
- ✅ 1-2 second duration
- ✅ Gentle attack, natural decay
- ✅ Medium pitch (not too high/low)

### Good Beep Sound
- ✅ Short and sharp
- ✅ 0.3-0.5 second duration
- ✅ Quick attack and release
- ✅ Clear, distinct tone

### Sounds to Avoid
- ❌ Too long (annoying when repeated)
- ❌ Too harsh or jarring
- ❌ Too quiet (hard to hear during workout)
- ❌ Background noise or hiss
- ❌ Stereo effects (can be distracting)

## Advanced: Multiple Sound Sets

To allow users to choose from multiple sound sets:

1. Create sound folders:
   ```
   assets/sounds/classic/
     bell.mp3
     beep.mp3
   assets/sounds/modern/
     bell.mp3
     beep.mp3
   ```

2. Update [lib/services/sound_service.dart](lib/services/sound_service.dart) to accept a sound set parameter

3. Add settings page to let users choose their preferred sound set

## Need Help?

- Check [audioplayers documentation](https://pub.dev/packages/audioplayers)
- Test sounds in isolation before adding to app
- Start with free online resources before creating custom sounds

---

**Pro Tip**: Keep sounds simple and unobtrusive. They'll be played repeatedly during workouts!
