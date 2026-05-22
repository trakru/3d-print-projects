# 4x4 Post Cap

![Preview](./4x4-post-cap.png)

A stepped-pyramid cap that slips over the top of a nominal 4x4 wooden
planter post and is secured by a single side screw driven through one
socket wall into the post.

Current revision: v4 — 5 steps, side-screw mount, no flange.

## Components

| File | Purpose |
|---|---|
| `4x4-post-cap.scad` | Single-piece cap. Socket + base plate + 5-step pyramid + countersunk side-screw hole + drain holes through the base plate. |

## Key dimensions

| Parameter | Value | Notes |
|---|---|---|
| Measured post | 87.3 × 87.3 mm | 3-7/16" — confirm per-post with calipers |
| Socket tolerance | 1.5 mm | Per side gap; tune after PLA test print |
| Socket depth | 19 mm | 3/4" engagement |
| Wall thickness | 6 mm | Socket walls |
| Steps | 5 × 6 mm | Each step insets 4 mm per side |
| Top flat | 10 mm square | Final cap of the pyramid |
| Base plate | 4 mm | Between socket and pyramid |
| Side screw | #8 | 4.2 mm shaft, 8.5 mm countersink head, 4 mm countersink depth |
| Screw position | Mid-socket (z = 9.5 mm) | Center of the 19 mm socket depth |
| Drain holes | 5 mm × 4 | Through the base plate, 30%/70% grid in plan |

Set `screw_wall` to `front`, `back`, `left`, or `right` to choose which
wall the screw goes through. Orient the cap so the screw faces away
from view at install time.

## Install sequence

1. Measure the actual post; update `post_width` / `post_depth` if it
   isn't exactly 87.3 mm
2. Print a PLA test cap; check fit. Adjust `tolerance` and reprint until
   the cap slides on snug but seats fully
3. Print final cap in PETG (UV + outdoor durability)
4. Slide cap onto post; drive #8 screw through the chosen wall into the
   post — countersink seats the head flush

## Print settings

- **Test (PLA):** 0.2 mm layers, 3 walls, 20% infill
- **Final (PETG):** 0.2 mm layers, 4 walls, 30% gyroid
- **Orientation:** socket-down, pyramid-up (no supports needed; drain
  holes bridge cleanly through the base plate)
