# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Falling Blocks is a Flutter mobile game built with the Flame game engine. Players control a square that moves left/right by tapping, avoiding falling obstacles while collecting coins and hearts. The game features Firebase integration for anonymous authentication and Firestore for data persistence.

## Build and Run Commands

```bash
# Get dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run on specific device
flutter run -d <device-id>

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Analyze code
flutter analyze

# Clean build artifacts
flutter clean
```

## Architecture

### Game Engine Structure

The game uses Flame's Entity Component System (ECS) architecture:

- **UghGame** (lib/game/game.dart): Main game class extending FlameGame with TapCallbacks and HasCollisionDetection
  - Manages game state, speed, and player score
  - Handles tap events for player movement
  - Coordinates all game components through controllers

### Core Components

**Player** (lib/game/player/player.dart)
- Moves horizontally based on tap input (toggles between left/right)
- Uses physics-based movement with acceleration and rotation
- Manages collision detection with obstacles, hearts, and coins
- Handles death animation with particle effects

**Controller Pattern**
The game uses dedicated controller components to spawn and manage entities:

- **ObstacleController** (lib/game/obstacle/obstacle_controller.dart)
  - Spawns obstacles using Timer at increasing difficulty intervals
  - Adjusts spawn rate based on elapsed time (15s, 30s, 60s, etc.)
  - Progressively increases obstacle speed
  - Spawns from three positions: left, center, right

- **CoinsController** (lib/game/coins/coins_controller.dart)
  - Spawns collectible coins with different point values (1k-10k)
  - Uses Timer-based spawning system
  - Coins have different visual colors based on value

- **HeartsController** (lib/game/hearts/hearts_controller.dart)
  - Spawns heart power-ups to restore player health

### Game State Management

**Screens** (lib/screens/)
- main_menu.dart: Entry point screen
- game_play.dart: Wraps UghGame in GameWidget with overlay system
- select_avatar.dart: Avatar selection screen

**Overlays** (lib/widgets/)
- pause_btn.dart: Pause button overlay (shown during gameplay)
- pause_menu.dart: Pause menu overlay
- game_over_menu.dart: Game over overlay (shown when player dies)

The overlay system in game_play.dart:8 uses Flutter widgets rendered on top of the Flame game. Overlays are added/removed dynamically based on game state.

### Collision System

Collisions are handled in Player.onCollisionStart (lib/game/player/player.dart:111):
- ObstacleRect/ObstacleCircle: Reduces health by 25, triggers death if health < 25
- Heart: Restores health to maximum
- Coins: Adds points based on coin type (1k-10k)

### Firebase Integration

**Authentication** (lib/services/auth.dart)
- Anonymous sign-in on app startup (main.dart:15)
- FirebaseAuth instance available for future email/password auth

The app initializes Firebase before running (main.dart:11) and signs in anonymously before showing the main menu.

## Key Implementation Details

**Movement Physics** (lib/game/player/player.dart:97-108)
- Player toggles between left/right movement on tap
- Uses time-based acceleration for smooth movement
- Applies rotation angle during movement
- Boundary checking prevents player from leaving screen

**Progressive Difficulty** (lib/game/obstacle/obstacle_controller.dart:28-62)
- Difficulty increases at fixed time intervals
- Timer duration decreases (1.0s → 0.20s)
- Speed multiplier increases continuously in update loop

**Game Loop**
- UghGame.update runs every frame, updating playerScore text
- Player position/rotation updated based on movement physics
- Controllers use Timer components to spawn entities periodically
- Flame's collision detection runs automatically each frame

## Important Patterns

1. **Component Lifecycle**: Components override onLoad, onMount, onRemove, update, and render
2. **HasGameRef Mixin**: Provides access to UghGame instance via gameRef property
3. **Reset Pattern**: Controllers implement reset() to clear entities and restart timers
4. **Overlay Management**: Game state changes trigger overlay.add/remove calls

## Development Notes

- The game is locked to portrait mode and fullscreen (main.dart:12-13)
- Uses custom font "AmaticSC" loaded from fonts/ directory
- Assets stored in assets/images/ directory
- No test suite currently exists
