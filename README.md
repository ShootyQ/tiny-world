# tiny-world

A tiny, cleanly-structured Godot 4 project skeleton. It separates assets from scenes and scripts, scales well, and plays nicely with Godot's scene-node model.

## Layout

```
tiny-world/
  .editorconfig
  .gitignore
  README.md
  LICENSE
  project.godot
  addons/
  assets/
    sprites/
      player/
      objects/
      tiles/
      ui/
    fonts/
  scenes/
    main/
      Main.tscn
    world/
      World.tscn
      TileSet.tres
    player/
      Player.tscn
      Player.gd
    objects/
      House.tscn
      House.gd
  scripts/
  autoload/
    Game.gd
  export_presets.cfg
```

Why this structure?

- Clean separation of assets vs scenes/scripts
- Easy to scale without refactors
- Plays nice with Godot’s scene-node model

## Getting started

1. Open the folder in Godot 4.3+.
2. Project should auto-detect `project.godot`.
3. Press Play to run `Main.tscn`.

## Notes

- `autoload/Game.gd` is prepared for AutoLoad. In Godot, Project Settings > AutoLoad: add `autoload/Game.gd` as `Game`.
- `export_presets.cfg` is a placeholder; set your exports in the editor and it will update.
- Replace placeholder scenes/scripts as needed.
