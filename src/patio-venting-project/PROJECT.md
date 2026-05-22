# Patio AC Venting Connector

A 3D-printed system for venting a portable AC unit through an exterior patio
wall to an existing wall-mounted vent hood. The interior end has a snap-on
connection for the AC duct; the exterior end friction-fits into the vent hood
collar.

## Components

| File | Status | Purpose |
|---|---|---|
| `connector.scad` | Final | Single-piece pipe that passes through the wall. ~235mm long. One end has the snap-on lip geometry for the AC duct (136 OD); the other end is plain 145 OD that fits the vent hood collar. |
| `flange.scad` | Final | Square plate that mounts flat against the OSB sheathing inside the siding cutout. Provides a bore for the connector and four corner screw holes. Print two — one for interior, one for exterior. |
| `cover.scad` | Not yet designed | Decorative trim that mounts over the flange to hide screw heads and cut siding edges. Designed after install once actual clearances are measured. |

## Key dimensions

| Parameter | Value | Notes |
|---|---|---|
| Wall depth | 6.5" / 165mm | Lap siding + OSB on both faces (patio wall, no interior drywall) |
| OSB thickness | ~1/2" / 13mm | Verified via snake camera inspection |
| Lap siding thickness | ~5/8" / 16mm | Likely LP SmartSide — confirm before final flange print |
| Wall hole | 6" / 152mm | Cut with hole saw through OSB only |
| Siding cutout | 8" / 205mm square | Cut through siding both sides, exposes OSB for flange mount |
| Connector base OD | 145mm | Friction-fits vent hood collar (exterior end) |
| Connector top OD | 136mm | AC duct snap-on interface (interior end) |
| Wall thickness (all parts) | 3mm | PETG, validated for snap-on fit during PLA tolerance prints |

## Install sequence

1. Measure actual wall depth and siding thickness; update `wall_depth` in `connector.scad` if needed
2. Print one connector and two flanges
3. Cut 8" square pocket through lap siding on both interior and exterior sides, exposing OSB
4. Drill 6" hole through exposed OSB (single hole — both pockets line up)
5. Push connector through wall from outside; exterior end seats ~30mm into the vent hood collar
6. Slide exterior flange onto connector from outside, push flush against OSB, caulk perimeter, drive 4 wood screws into OSB
7. Repeat for interior flange
8. Apply paintable exterior caulk along cut siding edges (both sides) to weatherproof
9. Add metal drip flashing above each exterior siding cutout
10. Snap the AC duct onto the interior lip — done

## Build

Local:
```bash
openscad -o connector.stl connector.scad
openscad -o flange.stl flange.scad
```

CI builds STLs automatically on every push. Download from the GitHub Actions
tab → latest run → Artifacts.

## Print settings

- **Material:** PETG for production. PLA acceptable for tolerance test prints
  only — long-term heat from the AC duct plus UV on the exterior side degrade
  PLA quickly.
- **Layer height:** 0.2mm
- **Orientation:** connector with the wide (145 OD, exterior) end down on the
  bed; flange with countersinks face-down on the bed
- **Supports:** required on the connector lip underside (snap-on geometry) for
  clean tolerance fit. Not needed on the flange.
- **Bed adhesion:** the connector is tall and large-diameter — use a brim
  (5–8mm) on the first print to prevent corner lift

Estimated time and material per part:
- Connector: ~12–15 hours, ~360g PETG
- Flange: ~2 hours, ~150g PETG each (two needed)

## Design history

Current design is v3. Earlier iterations and the reasoning for rejecting them:

- **v1** — short connector spanning only the wall thickness, with the AC duct
  snap-on inside the wall cavity. Rejected: snap-on not accessible for
  maintenance.
- **v2** — conical taper from base (145 OD) to top (136 OD). Rejected:
  constant wall thickness across an OD step left the two cylinders
  structurally disconnected. Also harder to print cleanly.
- **v3 (current)** — stepped cylinder with a 5mm conical transition shoulder
  bridging the OD step. Preserves snap-on fit, structurally solid, prints
  without supports on the transition.

Alternatives considered and rejected:

- **PVC pipe core + 3D-printed adapters** — would have required enlarging the
  6" hole to accommodate PVC's 168mm OD, and adding a second adapter on the
  outer side to step back down to 145mm for the vent hood collar. Net loss.
- **Single-piece top-hat flange (combined flange + trim cover)** — premature
  commitment to a fixed geometry before knowing final cutout dimensions.
  Separating into flange-now + cover-later defers that decision.

## TODO

- [ ] Confirm wall depth and lap siding thickness with calipers
- [ ] Print connector + two flanges
- [ ] Cut siding pockets, install assembly
- [ ] Measure post-install clearances for cover design
- [ ] Design and print `cover.scad`
- [ ] Add drip flashing above siding cutouts
- [ ] Note any fit issues here for future reference