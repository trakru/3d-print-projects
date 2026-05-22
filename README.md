# 3D Print Projects

Personal repository of OpenSCAD designs for 3D-printed parts. Each subproject
under `src/` is self-contained — its own SCAD files and a `PROJECT.md`
documenting purpose, dimensions, install steps, and print settings. STLs build
automatically on push via GitHub Actions.

## Projects

| Project | Preview | Status | Description |
|---|---|---|---|
| [outdoor-lighting](src/outdoor-lighting/PROJECT.md) | <img src="src/outdoor-lighting/govee-enclosure.png" width="120"> | Active | Govee outdoor light enclosure |
| [outdoor-planter](src/outdoor-planter/PROJECT.md) | <img src="src/outdoor-planter/4x4-post-cap.png" width="120"> | Test print | Stepped-pyramid cap for 4x4 wooden planter posts |
| [patio-venting-project](src/patio-venting-project/PROJECT.md) | <img src="src/patio-venting-project/connector.png" width="120"> | Design complete | Portable AC vent connector through exterior patio wall |

## Building

OpenSCAD must be installed and on `PATH`. Build a single file:

```bash
openscad -o flange.stl src/patio-venting-project/flange.scad
```

GitHub Actions builds every `.scad` on PR and push to `main`. Download STLs from
Actions → latest run → Artifacts (90-day expiry).

## Releases

To pin a design as a permanent, downloadable release, tag the commit on `main`:

```bash
git tag -a v1-patio-final -m "Patio venting: design complete, v3 connector + flange"
git push origin v1-patio-final
```

The tag push triggers the workflow, which builds the STLs at that commit and
attaches them to a GitHub Release at the tag name.

## Adding a new project

1. Create `src/<project-name>/`
2. Add `.scad` files for each printable part (one part per file)
3. Add `PROJECT.md` covering purpose, key dimensions, install sequence, print
   settings, and design history
4. Push — CI builds automatically, no workflow edits needed

## Conventions

- **Parameters at the top of each file** with units in inline comments.
- **Derived values** (`base_id = base_od - 2 * wall_thickness`) computed in a
  dedicated block, not inlined into geometry — makes intent explicit and
  changes propagate cleanly.
- **No CSG hacks for inner overlap.** When two solids in a `union()` need to
  meet cleanly, give them at least 0.1mm Z-overlap; when subtracting an inner
  bore, extend the cutter 0.1mm beyond both faces. Never rely on coincident
  surfaces — the slicer will create artifacts.

## License

[Apache 2.0](LICENSE)
