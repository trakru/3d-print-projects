// ===== Spacer-flange combo =====
// Sleeve fills the wall-hole gap AND grips the connector.
// Plate + ears mount to OSB with screws.

// ---- Wall hole ----
hole_diameter    = 152.4;     // 6" hole saw
hole_clearance   = 1;         // radial clearance per side in the hole

// ---- Connector ----
connector_od     = 145;
slip_clearance   = 0.5;       // sleeve ID vs connector OD

// ---- Plate body ----
plate_thickness  = 5;
main_dia         = 175;       // central disc — covers hole + screw retention zone

// ---- Screw ears ----
ear_dia          = 24;
ear_distance     = 90;        // bolt circle radius (180mm BCD)

// ---- Sleeve (spacer body) ----
sleeve_height    = 40;        // through wall depth on this side + grip on connector
                              // increase if your wall is asymmetric

// ---- Screws into OSB ----
screw_hole_dia   = 4.5;       // #8 wood screw clearance

// ---- Detail ----
chamfer          = 1;

$fn = 360;

// --- Derived ---
sleeve_od        = hole_diameter - 2 * hole_clearance;   // 150.4
sleeve_id        = connector_od + 2 * slip_clearance;    // 146
sleeve_wall      = (sleeve_od - sleeve_id) / 2;
total_height     = plate_thickness + sleeve_height;
total_od         = 2 * (ear_distance + ear_dia/2);

echo("Sleeve OD (into hole):", sleeve_od);
echo("Sleeve ID (over connector):", sleeve_id);
echo("Sleeve wall thickness:", sleeve_wall);
echo("Total flange OD (across ears):", total_od);
echo("Bolt circle diameter:", 2 * ear_distance);
echo("Total height:", total_height);

module flange_shape() {
    union() {
        circle(d = main_dia);
        for (angle = [0, 90, 180, 270]) {
            rotate([0, 0, angle])
                hull() {
                    circle(d = ear_dia * 0.6);
                    translate([ear_distance, 0])
                        circle(d = ear_dia);
                }
        }
    }
}

module spacer_flange() {
    difference() {
        union() {
            // plate with ears (flat face on bed)
            linear_extrude(plate_thickness)
                flange_shape();
            // sleeve going into the wall hole — fills the radial gap
            translate([0, 0, plate_thickness])
                cylinder(h = sleeve_height, d = sleeve_od);
        }
        
        // bore through plate and sleeve
        translate([0, 0, -0.1])
            cylinder(h = total_height + 0.2, d = sleeve_id);
        
        // chamfer bottom of bore (plate-side, connector entry)
        translate([0, 0, -0.01])
            cylinder(h = chamfer, d1 = sleeve_id + 2*chamfer, d2 = sleeve_id);
        
        // chamfer top of bore (sleeve-side)
        translate([0, 0, total_height - chamfer + 0.01])
            cylinder(h = chamfer, d1 = sleeve_id, d2 = sleeve_id + 2*chamfer);
        
        // chamfer top OD of sleeve (lead-in into the wall hole)
        translate([0, 0, total_height - chamfer + 0.01])
            difference() {
                cylinder(h = chamfer, d = sleeve_od + 2*chamfer);
                cylinder(h = chamfer, d1 = sleeve_od, d2 = sleeve_od - 2*chamfer);
            }
        
        // simple through-holes for #8 screws
        for (angle = [0, 90, 180, 270]) {
            rotate([0, 0, angle]) translate([ear_distance, 0, 0])
                translate([0, 0, -0.1])
                    cylinder(h = plate_thickness + 0.2, d = screw_hole_dia);
        }
    }
}

spacer_flange();