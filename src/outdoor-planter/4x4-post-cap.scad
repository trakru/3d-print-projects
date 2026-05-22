// ============================================
// 4x4 Post Cap — Stepped Pyramid, No Flange
// v4 — Side screw, 5 steps
// Material: PLA (test fit) → PETG (final)
// ============================================

// ===== CRITICAL FIT DIMENSIONS =====

post_width = 87.3;      // MEASURED: 3-7/16" = 87.3mm
post_depth = 87.3;      // MEASURED: 3-7/16" = 87.3mm
tolerance = 1.5;        // Gap — ADJUST AFTER TEST PRINT
socket_depth = 19;      // 3/4" = 19mm internal depth
wall_thickness = 6;     // Socket wall thickness

// ===== STEPPED PYRAMID PARAMETERS =====

num_steps = 5;          // 5 steps
step_height = 6;        // Height per step (mm)
step_inset = 4;         // Inward step per side (mm)
top_flat_size = 10;     // Flat area at the very top (mm)

// ===== SIDE SCREW HOLE =====
// Screw goes through ONE socket wall into the post
// Position this wall facing away from view

screw_enabled = true;
screw_shaft_dia = 4.2;  // #8 screw shaft
screw_head_dia = 8.5;   // #8 countersink head
screw_countersink = 4;  // Countersink depth into outer wall

// Screw vertical position (center of screw in socket)
screw_z = socket_depth / 2;  // Halfway up the socket

// Which wall gets the screw: "front", "back", "left", "right"
// Orient the cap so this wall faces away from view
screw_wall = "back";

// ===== DRAIN HOLES =====

drain_holes = true;
drain_hole_dia = 5;

// ===== COMPUTED VALUES =====

socket_inner_w = post_width + tolerance;
socket_inner_d = post_depth + tolerance;
socket_outer_w = socket_inner_w + (wall_thickness * 2);
socket_outer_d = socket_inner_d + (wall_thickness * 2);

// NO FLANGE
cap_outer_w = socket_outer_w;
cap_outer_d = socket_outer_d;

base_thickness = 4;

pyramid_height = num_steps * step_height;
total_height = socket_depth + base_thickness + pyramid_height;

echo(str("=== Post Cap v4 — Stepped, Side Screw ==="));
echo(str("Socket inner: ", socket_inner_w, " x ", socket_inner_d, " mm"));
echo(str("Cap outer: ", cap_outer_w, " x ", cap_outer_d, " mm (", cap_outer_w/25.4, " in)"));
echo(str("Socket depth: ", socket_depth, " mm"));
echo(str("Steps: ", num_steps, " x ", step_height, "mm"));
echo(str("Total height: ", total_height, " mm (", total_height/25.4, " in)"));
echo(str("Screw wall: ", screw_wall));

// ===== MODULES =====

module stepped_pyramid(base_w, base_d, steps, s_height, inset) {
    for (i = [0 : steps - 1]) {
        current_inset = inset * i;
        current_w = base_w - (current_inset * 2);
        current_d = base_d - (current_inset * 2);
        
        if (current_w > top_flat_size && current_d > top_flat_size) {
            translate([current_inset, current_inset, i * s_height])
                cube([current_w, current_d, s_height]);
        } else {
            final_inset = (base_w - top_flat_size) / 2;
            translate([final_inset, final_inset, i * s_height])
                cube([top_flat_size, top_flat_size, s_height]);
        }
    }
}

module side_screw_hole() {
    if (screw_enabled) {
        // Position based on chosen wall
        if (screw_wall == "back") {
            // Screw enters from back wall (Y = max)
            translate([cap_outer_w / 2, cap_outer_d + 0.1, screw_z])
                rotate([90, 0, 0]) {
                    // Through-hole (shaft)
                    cylinder(h = wall_thickness + tolerance/2 + 0.2, 
                             d = screw_shaft_dia, $fn = 30);
                    // Countersink on outer face
                    cylinder(h = screw_countersink, 
                             d1 = screw_head_dia, 
                             d2 = screw_shaft_dia, $fn = 30);
                }
        } else if (screw_wall == "front") {
            translate([cap_outer_w / 2, -0.1, screw_z])
                rotate([-90, 0, 0]) {
                    cylinder(h = wall_thickness + tolerance/2 + 0.2, 
                             d = screw_shaft_dia, $fn = 30);
                    cylinder(h = screw_countersink, 
                             d1 = screw_head_dia, 
                             d2 = screw_shaft_dia, $fn = 30);
                }
        } else if (screw_wall == "left") {
            translate([-0.1, cap_outer_d / 2, screw_z])
                rotate([0, 90, 0]) {
                    cylinder(h = wall_thickness + tolerance/2 + 0.2, 
                             d = screw_shaft_dia, $fn = 30);
                    cylinder(h = screw_countersink, 
                             d1 = screw_head_dia, 
                             d2 = screw_shaft_dia, $fn = 30);
                }
        } else if (screw_wall == "right") {
            translate([cap_outer_w + 0.1, cap_outer_d / 2, screw_z])
                rotate([0, -90, 0]) {
                    cylinder(h = wall_thickness + tolerance/2 + 0.2, 
                             d = screw_shaft_dia, $fn = 30);
                    cylinder(h = screw_countersink, 
                             d1 = screw_head_dia, 
                             d2 = screw_shaft_dia, $fn = 30);
                }
        }
    }
}

module post_cap() {
    difference() {
        union() {
            // --- Socket walls ---
            difference() {
                cube([socket_outer_w, socket_outer_d, socket_depth]);
                translate([wall_thickness, wall_thickness, -0.1])
                    cube([socket_inner_w, socket_inner_d, socket_depth + 0.2]);
            }

            // --- Base plate ---
            translate([0, 0, socket_depth])
                cube([cap_outer_w, cap_outer_d, base_thickness]);

            // --- Stepped pyramid ---
            translate([0, 0, socket_depth + base_thickness])
                stepped_pyramid(cap_outer_w, cap_outer_d, 
                               num_steps, step_height, step_inset);
        }

        // --- Side screw hole ---
        side_screw_hole();

        // --- Drain holes through base plate ---
        if (drain_holes) {
            for (x = [cap_outer_w * 0.3, cap_outer_w * 0.7])
                for (y = [cap_outer_d * 0.3, cap_outer_d * 0.7])
                    translate([x, y, socket_depth - 0.1])
                        cylinder(h = base_thickness + 0.2, d = drain_hole_dia, $fn = 20);
        }
    }
}

// ===== RENDER =====
// Print: socket down, pyramid up
// No supports needed
// Screw wall faces AWAY from view when installed
//
// To change which wall: set screw_wall to
// "front", "back", "left", or "right"
//
// PLA test: 0.2mm layers, 3 walls, 20% infill
// PETG final: 0.2mm layers, 4 walls, 30% gyroid

post_cap();
