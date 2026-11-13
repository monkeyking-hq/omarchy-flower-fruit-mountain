# Flower-Fruit Mountain (Omarchy Theme)

A dark, atmospheric theme inspired by the legendary Flower-Fruit Mountain (*Huāguǒ Shān*) and the visual identity of [MonkeyKing.dev](https://monkeyking.dev). Features animated blossom petals blown by random wind, deep obsidian backgrounds, vibrant amber and peach blossom accents, high-contrast typography, and custom desktop artwork.

![Flower-Fruit Mountain Live Preview](preview.gif)

Animated blossom petals drift across the desktop, blown by random wind, alongside a pulsing summit glow and an animated waterfall. The live preview above showcases the animation and wallpaper cycling. Install both the theme and the live plugin below to enable the animation.

## Palette Highlights

- **Background**: Deep Obsidian (`#0d0a1a`, `#050308`, `#020203`)
- **Accent**: Sunburst Amber (`#f5a524`)
- **Highlights**: Dawn Peach (`#f4a48a`) and Golden Staff (`#f8d28a`)
- **Foreground**: Natural Rice Ink (`#e7e5dd`) with 15.5:1 WCAG contrast ratio

## Installation

Install the palette and static artwork using the official [Omarchy](https://omarchy.org) theme command:

```bash
omarchy theme install https://github.com/monkeyking-hq/omarchy-flower-fruit-mountain-theme.git
```

Omarchy will clone and activate the theme automatically. Theme installation alone does not enable the live animation.

### Live animation

Install and enable the companion plugin from the same repository:

If you already have `nate.flower-fruit-mountain` or `blowing-flower-petal-plugin`, follow [the migration instructions](#migrating-from-an-old-plugin-id) first to avoid running two overlays.

```bash
omarchy plugin add https://github.com/monkeyking-hq/omarchy-flower-fruit-mountain-theme.git --enable
```

The plugin requires Omarchy's Quickshell-based shell with native plugin support, the `QtQuick.Particles` and `QtQuick.Shapes` QML modules, and Omarchy's `qs.Ui.ScreenMoveRemap` component. Validated on Omarchy 4.5.0-3. Omarchy installations missing these components, including desktops running Waybar without the Omarchy shell, cannot run this overlay.

The overlay follows the resolved wallpaper path at `~/.local/state/omarchy/current/background`. It appears only when that path contains `flower-fruit-mountain`, and hides when you switch to another wallpaper path. It creates an overlay for each monitor, shares the random wind across screens, and scales the scene to match the wallpaper's crop. The summit glow and waterfall are positioned for the Flower-Fruit Mountain artwork.

Control the animation independently of the palette:

```bash
omarchy plugin disable mkd-blowing-flower-petal-plugin
omarchy plugin enable mkd-blowing-flower-petal-plugin
```

Update the installed plugin from this repository:

```bash
omarchy plugin update mkd-blowing-flower-petal-plugin
```

Updates require a Git-managed installation that can fast-forward; local edits or a diverged checkout can prevent an update. The command shows the changes and asks for confirmation before applying them.

### Migrating from an old plugin ID

Version 3.0.0 uses the plugin ID `mkd-blowing-flower-petal-plugin`. Both predecessor IDs, `nate.flower-fruit-mountain` and `blowing-flower-petal-plugin`, require migration, whether installed by copying files or using Git. Do not use `omarchy plugin update` to migrate an old ID: it updates files in place without renaming the installation directory.

Back up the complete old plugin outside Omarchy's plugin discovery directory before removing it. `omarchy plugin remove` deletes Git-managed installations; manually copied installations are moved to a hidden backup automatically. Set `old_id` to the predecessor you have installed. The explicit backup below preserves either kind, including local edits:

```bash
old_id=blowing-flower-petal-plugin
# For the original installation instead, use: old_id=nate.flower-fruit-mountain
backup_dir=$(mktemp -d "$HOME/flower-fruit-mountain-backup.XXXXXXXX")
cp -a "$HOME/.config/omarchy/plugins/$old_id" "$backup_dir/"
printf 'Original plugin backed up to: %s\n' "$backup_dir"
```

After the copy succeeds, remove the old plugin to disable and unload it, then install the new ID from Git:

```bash
omarchy plugin remove "$old_id"
omarchy plugin add https://github.com/monkeyking-hq/omarchy-flower-fruit-mountain-theme.git --enable
```

If both predecessor IDs are installed, back up and remove each before adding the new plugin. Keep the backups until the new plugin works. If installation fails after removal, retry the `omarchy plugin add` command once the cause is resolved.

To roll back, remove `mkd-blowing-flower-petal-plugin` if installed, copy the backed-up directory for your selected predecessor into `~/.config/omarchy/plugins/`, run `omarchy-shell shell rescanPlugins`, and enable that predecessor ID. Restore your files from the backup, not by updating an old ID from this repository. Keep only one plugin ID installed and enabled to avoid duplicate overlays.

## Applying the Theme Manually

If already installed, switch to this theme anytime via:

```bash
omarchy theme set flower-fruit-mountain
```

Or open the interactive theme switcher:

```bash
omarchy theme switcher
```

## Cycling Backgrounds

This theme includes custom backgrounds in 4K resolution:
1. Flower-Fruit Mountain at Dawn
2. Dawn Ridges
3. Peach Blossom Grove
4. The Golden Staff
5. The Circlet

Cycle to the next background:
```bash
omarchy theme bg next
```
Or open the background switcher:
```bash
omarchy theme bg-switcher
```

## Universal Code

This project follows the [Universal Code v1.0.0](https://github.com/monkeyking-hq/universal-code).

## License

Released under the [MIT License](LICENSE).
