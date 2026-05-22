// =============================================================
// Outdoor Waterproof Enclosures - Parametric (OpenSCAD)
// =============================================================
// Two enclosures:
//   - Govee outdoor lights controller (~4 x 2.5 x 0.75 in)
//   - Power connector / extension cord junction (~4 x 2 x 2 in)
//
// Design summary:
//   - Single-piece body with U-notch cable entries (foam-sealed)
//   - Flat lid with counterbored M2.5 pan-head screw holes
//   - 5.0mm AF hex pockets for M2.5 x 6mm brass spacers (epoxy bonded)
//   - Perimeter silicone-cord gasket groove (interrupted by U-notches)
//   - 2mm weep hole on bottom
//   - Govee box has rear mounting flange; power box does not
//
// Hardware per box:
//   - 4x M2.5 x 6mm female-female brass spacers (from your kit)
//   - 4x M2.5 x 6mm pan-head Phillips screws (from your kit)
//   - 2-part epoxy to bond spacers into hex pockets
//   - ~500mm of 2mm silicone O-ring cord stock
//   - Weatherstrip foam (for U-notch sealing around cables)
// =============================================================

/* [Render Selection] */
// Which part to render
which = "govee_body"; // [govee_body, govee_lid, power_body, power_lid]

/* [Common Parameters] */
$fn = 80;

WALL          = 3.0;
LID_THK       = 3.0;
CORNER_R      = 5.0;

// Hex pocket for M2.5 brass spacer
HEX_AF        = 4.9;   // across-flats (epoxy bond fills the ~0.5mm gap)
POCKET_DEPTH  = 6.0;   // matches the 6mm spacer length
BOSS_OD       = 9.0;   // boss outer diameter (gives ~2mm wall around hex)
// Distance from cavity wall to boss center. Slightly less than BOSS_OD/2
// so the boss overlaps the wall by 0.1mm — visually integrated, but no
// zero-thickness kissing edge that breaks CSG manifold-ness.
BOSS_INSET    = BOSS_OD / 2 - 0.1;

// Lid screw
COUNTERBORE_D = 5.0;   // for M2.5 pan-head (~4.7mm OD)
COUNTERBORE_H = 1.6;   // pan-head height
SCREW_CLEAR   = 2.8;   // M2.5 shaft clearance

// Other
WEEP          = 2.0;   // weep hole diameter
MOUNT_FLG_W   = 12.0;  // mounting flange width
MOUNT_FLG_H   = 4.0;   // mounting flange thickness
MOUNT_HOLE    = 4.5;   // for #8 or #10 wood screw

/* [Govee Controller - Cavity Dimensions] */
G_CAV_L      = 108;  // 4" + clearance
G_CAV_W      = 70;   // 2.5" + clearance
G_CAV_H      = 24;   // 0.75" + clearance
// Keyhole cable entry: narrow slot + round cradle near the floor
G_CRADLE_DIA = 7;    // cable channel diameter (~5mm cable + foam wrap)
G_SLOT_W     = 5.5;  // narrow slot for cable to drop through
G_CABLE_GAP  = 5;    // gap between cavity floor and the BOTTOM of the cradle
                     // (raises the cable up so the device sits flat on the floor)

/* [Power Connector - Cavity Dimensions] */
P_CAV_L      = 110;  // 4" + clearance
P_CAV_W      = 58;   // 2" + clearance
P_CAV_H      = 58;   // 2" + clearance
P_CRADLE_DIA = 14;   // ~11mm extension cord + foam wrap
P_SLOT_W     = 12;   // wider slot for the fat cord

// =============================================================
// Helpers
// =============================================================

// 2D rounded rectangle, centered at origin
module rounded_rect(L, W, r) {
    offset(r=r) square([L - 2*r, W - 2*r], center=true);
}

// 3D rounded box, base at Z=0, centered in XY
module rounded_box(L, W, H, r) {
    linear_extrude(H) rounded_rect(L, W, r);
}

// Hexagonal prism, AF = across-flats
module hex_prism(af, h) {
    // circle($fn=6) creates a hex. Circumscribed radius = AF / sqrt(3)
    linear_extrude(h) circle(r = af / sqrt(3), $fn=6);
}

// =============================================================
// Body
// =============================================================

module body(cav_L, cav_W, cav_H, cradle_dia, slot_w, add_flange,
            cable_gap = 0) {
    out_L = cav_L + 2 * WALL;
    out_W = cav_W + 2 * WALL;
    out_H = cav_H + WALL;

    // Corner-boss positions (uses global BOSS_INSET so body and lid match)
    bx          = cav_L / 2 - BOSS_INSET;
    by          = cav_W / 2 - BOSS_INSET;
    boss_centers = [[bx, by], [-bx, by], [bx, -by], [-bx, -by]];

    union() {
        // === Part 1: Hollow shell with all perimeter cuts ===
        // (Cavity cut happens here; bosses are NOT in this part yet,
        //  otherwise the cavity cut would erase them.)
        difference() {
            // Additive: outer shell + optional flange
            union() {
                rounded_box(out_L, out_W, out_H, CORNER_R);

                if (add_flange) {
                    fl_L = out_L - 2 * CORNER_R;
                    translate([-fl_L / 2, out_W / 2 - 0.1, 0])
                        cube([fl_L, MOUNT_FLG_W, MOUNT_FLG_H]);
                }
            }

            // Cavity (open top)
            translate([0, 0, WALL])
                linear_extrude(cav_H + 1)
                    square([cav_L, cav_W], center = true);

            // Keyhole cable entries on the two short walls.
            // Round cradle near the floor (where the cable actually sits)
            // plus a narrow vertical slot up to the rim (just wide enough
            // for the cable to drop through during assembly).
            for (sx = [-1, 1])
                translate([sx * out_L / 2, 0, 0])
                    cable_entry(cradle_dia, slot_w, WALL, out_H, cable_gap);

            // Weep hole on bottom (off-center, not under the device)
            translate([out_L / 2 - 10, 0, -0.5])
                cylinder(d = WEEP, h = WALL + 1);

            // Flange screw holes
            if (add_flange) {
                fl_L = out_L - 2 * CORNER_R;
                hx   = fl_L / 2 - 6;
                for (sx = [-1, 1])
                    translate([sx * hx, out_W / 2 + MOUNT_FLG_W / 2, -0.5])
                        cylinder(d = MOUNT_HOLE, h = MOUNT_FLG_H + 1);
            }
        }

        // === Part 2: Corner bosses with hex pockets ===
        // Tangent to both walls, so they look like rounded corner pillars
        // continuous with the wall rather than separate columns.
        difference() {
            // Full-height corner bosses (cavity floor to rim level)
            for (c = boss_centers)
                translate([c[0], c[1], WALL])
                    cylinder(d = BOSS_OD, h = cav_H);

            // Hex pockets cut from boss top down
            for (c = boss_centers)
                translate([c[0], c[1], out_H - POCKET_DEPTH])
                    hex_prism(HEX_AF, POCKET_DEPTH + 0.1);
        }
    }
}

// =============================================================
// Keyhole cable entry — narrow slot + low round cradle
// =============================================================
// Centered at x=0 (caller translates to wall position). Cuts straight
// through in X. The cradle sits with its bottom at the cavity floor,
// so the cable exits the box near floor level and leaves the rest of
// the cavity clear for the device to sit flush.
//
// Caller is responsible for unioning two of these inside a difference().
module cable_entry(cradle_dia, slot_w, floor_z, rim_z, cable_gap = 0) {
    assert(cable_gap >= 0,
           "cable_gap must be >= 0 (cradle bottom can't dip below floor)");

    cradle_bottom = floor_z + cable_gap;        // bottom of round cradle
    cradle_z      = cradle_bottom + cradle_dia / 2;   // cable axis
    cut_length    = 2 * WALL + 4;               // generous overshoot through wall

    union() {
        // Round cradle (horizontal half-cylinder along X)
        translate([0, 0, cradle_z])
            rotate([0, 90, 0])
                cylinder(d = cradle_dia, h = cut_length, center = true);

        // Vertical slot from cradle center up past the rim
        slot_h = rim_z - cradle_z + 1;
        translate([0, 0, cradle_z + slot_h / 2])
            cube([cut_length, slot_w, slot_h], center = true);
    }
}

// =============================================================
// Lid (flat, with counterbored screw holes)
// =============================================================

module lid(cav_L, cav_W) {
    out_L = cav_L + 2 * WALL;
    out_W = cav_W + 2 * WALL;

    // Use the same BOSS_INSET as the body — keeps screw holes aligned
    // with the body's hex pockets even if either side is edited later.
    bx         = cav_L / 2 - BOSS_INSET;
    by         = cav_W / 2 - BOSS_INSET;
    boss_centers = [[bx, by], [-bx, by], [bx, -by], [-bx, -by]];

    difference() {
        rounded_box(out_L, out_W, LID_THK, CORNER_R);

        // Counterbore + clearance hole at each screw location
        for (c = boss_centers) {
            translate([c[0], c[1], -0.1])
                cylinder(d = SCREW_CLEAR, h = LID_THK + 0.2);

            // Counterbore is on TOP face (print this side up)
            translate([c[0], c[1], LID_THK - COUNTERBORE_H])
                cylinder(d = COUNTERBORE_D, h = COUNTERBORE_H + 0.1);
        }
    }
}

// =============================================================
// Dispatcher
// =============================================================

if (which == "govee_body")
    body(G_CAV_L, G_CAV_W, G_CAV_H, G_CRADLE_DIA, G_SLOT_W, true,
         cable_gap = G_CABLE_GAP);
if (which == "govee_lid")
    lid(G_CAV_L, G_CAV_W);
if (which == "power_body")
    body(P_CAV_L, P_CAV_W, P_CAV_H, P_CRADLE_DIA, P_SLOT_W, false);
if (which == "power_lid")
    lid(P_CAV_L, P_CAV_W);
