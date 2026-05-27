// ===== Full-length connector vent =====
// Single-piece print. Bottom (wide OD) is exterior side, goes into vent hood collar.
// Top (narrow OD with lip) is interior side, AC duct snaps on here.

// ---- Measure and set these ----
wall_depth           = 105;    // 6.5" = 165mm; reduce if your wall is thinner
exterior_protrusion  = 30;     // length sticking out past exterior wall, into vent hood collar
                               // (set this to the hood collar's depth)

// ---- Snap-on geometry (validated, don't change without re-testing fit) ----
base_od              = 145;
top_od               = 136;
wall_thickness       = 3;
lip_od               = 142;
lip_thickness        = 2;
lip_gap_from_top     = 4;
top_section_h        = 25;
taper_h              = 5;
base_section_h       = 10;

$fn = 360;

// ---- Derived ----
base_id              = base_od - 2*wall_thickness;
top_id               = top_od  - 2*wall_thickness;
long_cyl_h           = wall_depth + exterior_protrusion;   // straight 145 OD section
total_height         = long_cyl_h + base_section_h + taper_h + top_section_h;

z_taper_bot          = long_cyl_h + base_section_h;
z_top_bot            = z_taper_bot + taper_h;
z_lip_top            = total_height - lip_gap_from_top;
z_lip_bot            = z_lip_top - lip_thickness;

echo("Total height (mm):", total_height);
echo("Bambu Z headroom (256mm) remaining:", 256 - total_height);

module connector() {
    difference() {
        union() {
            // long straight 145 OD section (through wall + into vent hood)
            cylinder(h = long_cyl_h, d = base_od);
            // 10mm of 145 above wall surface (interior side, before taper)
            translate([0, 0, long_cyl_h])
                cylinder(h = base_section_h, d = base_od);
            // 5mm taper 145->136
            translate([0, 0, z_taper_bot])
                cylinder(h = taper_h, d1 = base_od, d2 = top_od);
            // 25mm of 136 OD (snap-on section)
            translate([0, 0, z_top_bot])
                cylinder(h = top_section_h, d = top_od);
            // lip flange
            translate([0, 0, z_lip_bot])
                cylinder(h = lip_thickness, d = lip_od);
        }
        // bore — straight 139 ID through the wall + base section, then taper to 130, then 130
        translate([0, 0, -0.1])
            cylinder(h = long_cyl_h + base_section_h + 0.1, d = base_id);
        translate([0, 0, z_taper_bot])
            cylinder(h = taper_h, d1 = base_id, d2 = top_id);
        translate([0, 0, z_top_bot])
            cylinder(h = top_section_h + 0.1, d = top_id);
    }
}

connector();