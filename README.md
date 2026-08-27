# Chrome-Style Dino Runner (Android / Godot Engine)

A 2D endless runner game for Android inspired by the classic Google Chrome offline Dinosaur game. This repository is built using the Godot Engine and is fully optimized for GitHub Copilot code generation.

## 🛠️ Tech Stack & Architecture

*   **Game Engine:** Godot Engine 4.x
*   **Target Platform:** Android (Mobile Portrait or Landscape)
*   **Language:** GDScript
*   **Project Structure:**
    *   `/scenes/` - Main, Dino, Cactus, Pterodactyl, Background, HUD
    *   `/assets/` - Sprites (PNG), Audio (WAV)
    *   `/scripts/` - Individual GDScript files attached to scenes

---

## 🕹️ Controls (Android Mobile)

The game relies entirely on touch inputs, mimicking the simplicity of the original web game.

*   **Jump:** Tap anywhere on the upper 70% of the screen.
*   **Duck:** Press and hold down anywhere on the lower 30% of the screen.
*   **Restart Game:** Tap the screen or press the "Retry" button when the Game Over screen is active.

---

## 🎨 Graphics & Visual Elements

The visual style is clean, high-contrast, minimalist 2D pixel art.

### 1. The Screen Environment
*   **Background:** Solid light grey color (`#F7F7F7`) that smoothly shifts to dark charcoal (`#202124`) when night mode triggers every 700 points.
*   **Ground Line:** A static horizontal pixel line placed near the bottom of the screen (e.g., at Y = 80% screen height) that moves left endlessly to simulate running.

### 2. Game Entities & Items
*   **Dino (Player):** 
    *   Located on the left side of the screen.
    *   Possesses three primary states: Running (alternating leg animation), Jumping (static upward pose), and Ducking (lowered head and body frame).
*   **Cactus (Obstacle 1):** 
    *   Spawns randomly off-screen to the right and moves left at the current game speed.
    *   Comes in variations: Small single cactus, large single cactus, and clusters of 2 or 3 grouped cacti.
*   **Pterodactyl (Obstacle 2):** 
    *   Spawns only after the score passes 500 points.
    *   Flies at three distinct heights: low (must jump over), medium (must duck under), and high (can be ignored).
    *   Possesses a 2-frame flapping wing animation.
*   **Clouds (Cosmetic):** 
    *   Drift slowly in the upper background layer from right to left.
    *   Do not interact with the player.

### 3. HUD (Heads-Up Display)
*   **Current Score:** Displayed in the top-right corner using a retro 5-digit digital font, counting up based on time survived.
*   **High Score:** Displayed to the left of the current score, prefixed with "HI". Saved locally to a file using Godot's `ConfigFile` or `FileAccess`.

---

## 🤖 GitHub Copilot Prompt Guidelines

Use this README context to prompt GitHub Copilot for code generation inside Godot script files.

### Base Movement & Physics Script (`dino.gd`)
```gdscript
# Write a CharacterBody2D script for a 2D side-scrolling endless runner.
# The player has a constant X position. Gravity should apply constantly.
# Implement touch screen jump when tapping the top portion of screen.
# Implement ducking when touching the bottom portion of screen.
# Play AnimatedSprite2D animations: "run", "jump", "duck".
```

### Obstacle Spawner Script (`spawner.gd`)
```gdscript
# Write a Node2D script that spawns obstacles from right to left.
# Obstacles are instantiated packages: Cactus scenes or Pterodactyl scenes.
# Spawn timer intervals should decrease slightly as the game speed increases.
# Track a global speed variable that increases over time.
```

### Endless Background Script (`scrolling_ground.gd`)
```gdscript
# Write a script for a ParallaxBackground or a textured line.
# Move the texture offset on the X-axis to the left based on global game speed.
# Reset texture offset seamlessly to create an infinite loop.
```
