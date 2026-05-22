// ===== Wall flange =====
// Sits flat against the OSB inside the siding cutout. Screws into OSB.
// Connector slides through the bore.

// ---- Cutout & wall ----
cutout_size      = 205;     // your actual square cutout — measure and update
flange_clearance = 5;       // gap from cutout edge (forgives slightly imperfect cuts)

// ---- Connector ----
connector_od     = 145;
slip_clearance   = 0.5;     // 0.5 = slip; 0.2 = press; 0 = forced

// ---- Plate ----
flange_thickness = 5;
corner_radius    = 8;

// ---- Screws into OSB ----
screw_hole_dia   = 4.5;     // #8 wood screw clearance
screw_csk_dia    = 9;
screw_csk_depth  = 2.5;
screw_inset      = 18;      // from corner

$fn = 360;

flange_size = cutout_size - 2 * flange_clearance;
bore_id     = connector_od + slip_clearance;

module rounded_square(size, r) {
    hull() for (x = [-1, 1], y = [-1, 1])
        translate([x * (size/2 - r), y * (size/2 - r)]) circle(r = r);
}

module flange() {
    difference() {
        linear_extrude(flange_thickness)
            rounded_square(flange_size, corner_radius);
        
        // bore
        translate([0, 0, -0.1])
            cylinder(h = flange_thickness + 0.2, d = bore_id);
        
        // bore chamfers (both faces — easier connector insertion)
        translate([0, 0, -0.01])
            cylinder(h = 0.6, d1 = bore_id + 1.2, d2 = bore_id);
        translate([0, 0, flange_thickness - 0.59])
            cylinder(h = 0.6, d1 = bore_id, d2 = bore_id + 1.2);
        
        // 4 corner screw holes with countersinks (countersinks open toward bed = visible face)
        positions = [
            [ flange_size/2 - screw_inset,  flange_size/2 - screw_inset],
            [-flange_size/2 + screw_inset,  flange_size/2 - screw_inset],
            [ flange_size/2 - screw_inset, -flange_size/2 + screw_inset],
            [-flange_size/2 + screw_inset, -flange_size/2 + screw_inset]
        ];
        for (pos = positions) {
            translate([pos[0], pos[1], -0.1])
                cylinder(h = flange_thickness + 0.2, d = screw_hole_dia);
            translate([pos[0], pos[1], -0.01])
                cylinder(h = screw_csk_depth, d1 = screw_csk_dia, d2 = screw_hole_dia);
        }
    }
}

flange();