# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-11-13

### Breaking
- Prefix the plugin ID with `mkd-`, changing `blowing-flower-petal-plugin` to `mkd-blowing-flower-petal-plugin`. Both this predecessor and `nate.flower-fruit-mountain` must migrate through backup, native removal, and native installation; see the README for migration and rollback instructions.

### Changed
- Update current enable, disable, and update commands to the prefixed ID. The display name, animation runtime, and artwork remain unchanged.

## [2.0.0] - 2026-11-13

### Breaking
- Rename the plugin ID from `nate.flower-fruit-mountain` to `blowing-flower-petal-plugin`. Existing manual and Git-managed installations must back up the old plugin outside the plugin directory, remove the old ID, and install the new ID using `omarchy plugin add`; updating the old ID in place does not migrate it. See the README for migration and rollback instructions.

### Changed
- Attribute the public plugin to MonkeyKing.dev and use the new namespace in enable, disable, and update commands. The overlay runtime and petal artwork remain unchanged.

## [1.1.0] - 2026-11-13

### Added
- Ship the existing Flower-Fruit Mountain live overlay as a native Omarchy service plugin, including its QML runtime, petal texture, and root manifest.
- Include windblown blossom petals, summit glow, animated waterfall, wallpaper-aware activation, and per-monitor overlays with the existing `nate.flower-fruit-mountain` plugin identity.
- Document separate theme and plugin installation, runtime requirements, animation controls, updates, and migration from a manually installed plugin.

## [1.0.3] - 2026-11-12

### Changed
- Describe the animated blossom petals blown by random wind in the README introduction and live preview description.

## [1.0.2] - 2026-11-09

### Fixed
- Format `keyboard.rgb` as 6 hex digits without leading `#` per Omarchy theme registry validator specification.
- Align repository name and install command with Omarchy convention (`omarchy-flower-fruit-mountain-theme`).

## [1.0.1] - 2026-11-08

### Added
- Added Universal Code v1.0.0 reference to `README.md`.
- Added `AGENTS.md` specifying ethical foundation and repository corollaries under the Universal Code.

## [1.0.0] - 2026-11-08

### Added
- Initial release of the Flower-Fruit Mountain theme for Omarchy.
- Deep obsidian dark palette (`#0d0a1a`, `#050308`, `#020203`) with sunburst amber (`#f5a524`) and dawn peach (`#f4a48a`) accents.
- 5 high-resolution 4K theme wallpapers:
  1. Flower-Fruit Mountain at Dawn
  2. Dawn Ridges
  3. Peach Blossom Grove
  4. The Golden Staff
  5. The Circlet
- Custom wordmark and flower-fruit-mountain vector SVGs.
- Lock screen (`unlock.png`) and preview assets (`preview.png`, `preview-unlock.png`).
- Animated preview showcase (`preview.gif`) demonstrating live desktop particle animation and wallpaper cycling.
- Full compatibility with the Omarchy theme installer (`omarchy theme install`).
