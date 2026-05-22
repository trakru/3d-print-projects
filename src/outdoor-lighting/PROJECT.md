# Outdoor Lighting Enclosures

![Preview](./govee-enclosure.png)

> Auto-generated preview shows the default render selection
> (`which = "govee_body"`). The CI build only renders one part per
> `.scad` file; to preview the lid or power-box variants, open the file
> in OpenSCAD locally and change `which` at the top.

Parametric waterproof enclosures for outdoor low-voltage gear. A single
`.scad` file produces two related boxes via a render-selection parameter:

- **Govee enclosure** — houses the Govee outdoor lights controller
  (~4 × 2.5 × 0.75 in). Has a rear mounting flange.
- **Power enclosure** — houses an extension-cord junction or power
  connector (~4 × 2 × 2 in). No flange; sits free.

Both share the same construction: single-piece body with a flat lid,
M2.5 brass-spacer corner bosses, U-notch cable entries for foam sealing,
a perimeter silicone-cord gasket groove, and a 2 mm weep hole on the
bottom.

## Components

| Render selection | Purpose |
|---|---|
| `govee_body` | Govee enclosure body with rear mounting flange |
| `govee_lid` | Flat lid for the Govee enclosure |
| `power_body` | Power-junction enclosure body, no flange |
| `power_lid` | Flat lid for the power enclosure |

Set `which` at the top of `govee-enclosure.scad` to pick which part to
render.

## Key dimensions

| Parameter | Value | Notes |
|---|---|---|
| Wall thickness | 3.0 mm | `WALL` |
| Lid thickness | 3.0 mm | `LID_THK` |
| Corner radius | 5.0 mm | `CORNER_R` |
| Hex pocket AF | 4.9 mm | For M2.5 × 6 mm brass spacer, epoxy bonded |
| Pocket depth | 6.0 mm | Matches 6 mm spacer length |
| Boss OD | 9.0 mm | ~2 mm wall around hex |
| Lid counterbore | 5.0 mm dia × 1.6 mm | M2.5 pan-head Phillips |
| Screw clearance | 2.8 mm | M2.5 shaft |
| Weep hole | 2.0 mm | Off-center on bottom |
| Govee cavity | 108 × 70 × 24 mm | 4 × 2.5 × 0.75 in + clearance |
| Power cavity | 110 × 58 × 58 mm | 4 × 2 × 2 in + clearance |

## Hardware per box

- 4× M2.5 × 6 mm female-female brass spacers
- 4× M2.5 × 6 mm pan-head Phillips screws
- 2-part epoxy to bond spacers into hex pockets
- ~500 mm of 2 mm silicone O-ring cord stock for the gasket groove
- Weatherstrip foam for U-notch sealing around cables

## Install sequence

1. Print body and lid for the desired box
2. Epoxy a brass spacer into each of the four hex pockets in the body;
   let cure fully before stressing the bond
3. Lay silicone O-ring cord into the lid-mating gasket groove
4. Pass cables through the U-notch entries; wrap each cable in foam
   weatherstrip where it crosses the wall to seal the notch
5. Seat the lid; drive the four M2.5 screws into the bonded spacers
6. Mount: the Govee box screws to a surface through its rear flange;
   the power box sits free or is strapped in place

## Print settings

- **Material:** PETG (UV + temperature stability outdoors)
- **Layer height:** 0.2 mm
- **Orientation:** body open-end up; lid counterbore face up (print
  side down on the bed)
- **Supports:** not needed — all overhangs are bridgeable
