// ==============================================================================
//              CMP170HX/A100 GPU to 1x 120mm Fan Adapter
FILE_VERSION = 1.40; // "CMP170HX-GPU-to-120mm-Fan-Adapter.scad"
// Versioning: bump in 0.01 steps until significant releases.

// Designer placard - Customize as desired but keep the primary designer
PRIMARY_DESIGNER = "-K.CRISAFULLI"; // first & primary design creator.
//
// IMPORTANT: If you revise the design you may add your name as 2nd designer.
// Contributing designers revise 2ND_DESIGNER do not remove primary.
2ND_DESIGNER = "-"; 

// ==== IMPORTANT: SELECT LEFT, CENTER, or RIGHT =======================
// FACEPLATE POSITION
// Selects which PCIe slot the faceplate/shroud occupies in the chassis.
// POS_M0_8: Place fan to the left of the GPU for slot 1 with GPU nearest CPU.
// POS_C: Place fan in center of GPU good for slots 2 or higher
// POS_P0_8: Place fan to the right of the GPU good for slots 3 or higher.
// POS_P1_6: Place fan to the right of the GPU good for slots 3 or higher.
FACEPLATE_POS_M0_8_X = -0.8 * 25.4;     // minus 1.0 PC slot widths (for GPU near CPU)
FACEPLATE_POS_C_X = 0.0;             // GPU centered over fan 
FACEPLATE_POS_P0_8_X = +0.8 * 25.4;     // plus 1.0 PC slot widths
FACEPLATE_POS_P1_6_X = +1.6 * 25.4;  // plus 2.0 PC slot widths
FACEPLATE_POS_P2_0_X = +2.0 * 25.4;  // plus 2.5 PC slot widths
FACEPLATE_OFFSET_X = FACEPLATE_POS_P1_6_X;

// 3D PRINTING RECOMMENDATIONS
// Rotate 180 degrees on Y axis and print with fan plate down.
// Use "ORGANIC" style supports, supports required for CMP170 faceplate.
// Use "Support on build plate only" (reduces cleanup and makes cleaner print).
// Use 20% infill; appeared adequate for strength.

// GPU SCREWS:
// use 3.0mm x 15mm pan head or cap head screws (length = 15mm or 16mm ok).
// the mounting plate is 10mm thick to carry the load of the adapter.abs
// Requires 5mm of thread engagement to carry this load vertically.

// FAN SCREWS:
// Place "PC fan screws" into adapter's screw tubes.
// The fan screw creates threads in fan housing (not the adapter).
// Large head fan screws are preferred, stardard fan screws will work.

// ============== FAN DUCT GAP (sets the length of the duct portion) ================
FAN_Z_GAP = 50.0;   //Z spacing fan-plate to CMP170-adapter-plate
// FAN_Z_GAP sets the duct portion length also useful to adjust Z height of assembly.

// ========= 120mm CMP170HX/A100 FAN ADAPTER ===============================
// This adapter is designed for precision fit to A100 or CMP170HX GPUs
// This adapter fits many computers with long enough PCIe slots.
//
// 120mm fans that that could be used with this duct:
//  - Bequiet "Silent Wings PRO 4", 120mm, PWM, 3000 RPM, 70C at 175W GPU power
//    NOTICE: set "nvidia-smi -PL 175" power limit during start up
//    Lower noise but does not provide enough pressure to cool at full 250-300W. 
//  - ARCTIC S12038-4K, 4000 RPM (better cooling, more noise).
//  - ARCTIC S12038-8K, 8000 RPM (best cooling, even more noise).
// Tested in Thermaltake chassis: CTE E600MX, Tower 300, & Tower 600
// all of these chassis provide vertical airflow and "hang" the GPU mass
// from the the PCIe mounting screw rack.
//
// CONSTRUCTION: composed of three separate design sections which are merged
//   Part 1) "CMP170HX faceplate06.scad" designed by K. Crisafulli
//      - GPU air intake faceplate + precision fit shroud for Nvidia CMP 170HX
//   Part 2) "120mm-Fan-Plate.scad" designed by K. Crisafulli
//      AI assistant, 2026-09) - 120 x 120 mm fan mounting plate, plain Ø4 holes
//   Part 3) Air duct linking the two plates designed by K. Crisafulli
//
// ====================== REVISION HISTORY ===============================
// V1.30 - 2026-09-19 : Adjust slope and position of cap for cable channel.
//                      Increase fan plate screw hole size 4.8mm -> 5.0mm based on feedback.
// V1.20 - 2026-09-18 : Adjust screw access-tube cutters for POS 2
// V1.15 - 2026-09-18 : 45-degree chamfer around the placard proud-face
// V1.12 - 2026-09-17 : Placard text revisions and rotated 180 deg.
// V1.10 - 2026-09-17 : Increase plate screw holes Ø4.0 -> Ø4.8.
// V1.00 - 2026-09-17 : Increase DUCT_WALL_THK 2.0mm -> 3.0 mm (strengthen long walls).
// V0.78 - 2026-09-17 : Adjust wall cutters to remove stick-out.
// V0.77 - 2026-09-17 : Adjust cable duct walls
// V0.76 - 2026-09-17 : Change cable duct cap from flat to sloped adjust wall cutters.
// V0.71 - 2026-09-17 : Increase placard text from 2.0 -> 2.75 mm for min. legibility.
// V0.70 - 2026-09-17 : Placard size set to 40mm x 15mm
// V0.60 - 2026-09-17 : Placard repositioned onto wall 6R's outer face
// V0.50 - 2026-09-16 : Wall 6 split into 6L + 6M + 6R for cable routing
//                      Power cable goes through CMP170HX connector then bends out.
// V0.40 - 2026-09-16 : Wall 5 cutter adjust for wall 6R.
// V0.30 - 2026-09-16 : Cable wall cap adjusted
// V0.20 - 2026-09-16 : Faceplate POS 1 & POS 2 added & adjust fan screw hole cutters.
// V0.10 - 2026-09-16 : Initial version
// ==============================================================================

// ============== OpenSCAD function to trim float to 2 decimal digits ===========
// Converts float to whole integer plus fraction strings with 2 decimal digits.
// Returns combined string
function format_float_d2(val) =
    let(
        scaled = round(val * 100),
        whole  = floor(scaled / 100),
        frac   = scaled % 100
    )
    str(
        whole,
        ".",
        frac < 10 ? "0" : "",
        frac
    );

// =====================================================================
// Part 1 - CMP 170HX intake faceplate
// Design by K. Crisafulli 2026-09
// =====================================================================
CMP_SHROUD_HEIGHT   = 10.0;  //GPU Faceplate thickness, thicken for cantilever load (V1.00: 9 -> 15)
MOUNT_HOLE_DIAMETER = 3.50; //GPU mounting screws loose fit for 3.0mm screws
HOLE_BRACE = 2.00; // bracing for mounting hole flanges
INTAKE_FIN_THK = 1.00; // Air Intake brace fin thickness

// New faceplate / shroud parameters
// V0.15: margins split into X/Y so the width (X) can be reduced for a two-slot
// fit without changing the Y extent. X values reduced 2.0 -> 1.0 per side.
FACEPLATE_MARGIN_X = 1.0; // widen faceplate by this amount on left/right (X)
FACEPLATE_MARGIN_Y = 2.0; // widen faceplate by this amount on top/bottom (Y, unchanged)
// Shroud long sides (left/right walls running along Y) may go to 1.0 mm for the
// two-slot width fix; short sides (top/bottom walls running along X) stay 2.0 mm
// to retain as much bending-moment strength as possible.
SHROUD_WALL_THK_X  = 1.0; // long-side wall thickness in X (reduced from 2.0)
SHROUD_WALL_THK_Y  = 2.0; // short-side wall thickness in Y (kept for stiffness)
SHROUD_PROTRUDE  = 10.0; // distance from faceplate front outward, -Z
SHROUD_EMBED     = 0.5; // overlap into faceplate for bonding

// ===== walls (X), left -> right. Shared lines = ONE variable. =====
// GPU's inside dimensions of the outside walls 
X_OUTER_L = 0.00;   // GPU outer left wall
X_OUTER_R = 39.10;  // GPU outer right wall, measures 38.6 use 39.0 for tight fit
Y_OUTER_T = 98.20;  // GPU outer top wall
Y_OUTER_B = 0.00;   // GPU outer bottom wall

Y_SLOT_T  = 95.25;  // Left side Slot Air Intake, Top, slot_top_left [MEASURED]
Y_SLOT_B  = 91.75+HOLE_BRACE;  // Left side Slot Air Intake, Bottom, slot_top_left [MEASURED]

// Upper Left & Right Air Intake inside dimensions 
X_COL_L   = 2.33;   // Left side Air Intakes Left wall: slot_top_left + port_upper_left + port_lower_left [MEASURED]
X_COL_R   = 11.80;  // Left side Air Intakes Right wall: slot_top_left + port_upper_left + port_lower_left [MEASURED]
Y_PU_T    = 87.40-HOLE_BRACE;  // Left side, Upper Air Intake, Top, port_upper_left [MEASURED]
Y_PU_B    = 63.30+HOLE_BRACE;  // Left side, Upper Air Intake, Bottom, port_upper_left [MEASURED]
Y_PL_T    = 58.80-HOLE_BRACE;  // Left side, Lower Air Intake, Top, port_lower_left [MEASURED]
Y_PL_B    = 24.50;  // Left side, Lower Air Intake, Bottom, port_lower_left [MEASURED]

// Power Connector's inside dimensions of walls 
X_PC_L    = -2.10;  // power_connector left wall, [MEASURED]
X_PC_R    = 12.80; // power_connector right wall, [MEASURED]
Y_PC_T    = 22.30; // power_connector top [MEASURED]
Y_PC_B    = -2.10;  // power_connector & main_intake bottom [MEASURED]

// Power Connector latch notch Inside dimensions
X_PC_LAT_L  = X_PC_R; // Power Connector latch left [MEASURED]
X_PC_LAT_R  = X_PC_R+4.25;   // Power Connector latch right [MEASURED]
Y_PC_LAT_T  = 15.70;  // Power Connector latch top [MEASURED]
Y_PC_LAT_B  = 8.40;   // Power Connector latch bottom [MEASURED]

// Main Air Intake Ports Inside dimensions
// Support Fin 1
X_INTAKE_1_L  = 13.25; // main_intake 1 left [MEASURED]
X_INTAKE_1_R  = 37.05; // main_intake 1 right [MEASURED]FACEPLATE_POS_C_X
Y_INTAKE_1_T  = 95.00; // main_intake 1 top [MEASURED]
Y_INTAKE_1_B  = 84.40; // main_intake 1 bottom [MEASURED]

// Support Fin 2
X_INTAKE_2_L  = X_INTAKE_1_L; // main_intake 2 left [MEASURED]
X_INTAKE_2_R  = X_INTAKE_1_R; // main_intake 2 right [MEASURED]
Y_INTAKE_2_T  = Y_INTAKE_1_B-INTAKE_FIN_THK; // main_intake 2 top [MEASURED]
Y_INTAKE_2_B  = 64.50;        // main_intake 2 bottom [MEASURED]

// Support Fin 3
X_INTAKE_3_L  = X_INTAKE_1_L; // main_intake 3 left [MEASURED]
X_INTAKE_3_R  = X_INTAKE_1_R; // main_intake 3 right [MEASURED]
Y_INTAKE_3_T  = Y_INTAKE_2_B-INTAKE_FIN_THK; // main_intake 3 top [MEASURED]
Y_INTAKE_3_B  = 60.00;        // main_intake 3 bottom [MEASURED]

// Support Fin 4
X_INTAKE_4_L  = X_INTAKE_1_L; // main_intake 4 left [MEASURED]
X_INTAKE_4_R  = X_INTAKE_1_R; // main_intake 4 right [MEASURED]
Y_INTAKE_4_T  = Y_INTAKE_3_B-INTAKE_FIN_THK; // main_intake 4 top [MEASURED]
Y_INTAKE_4_B  = Y_PL_B+0.5;       // main_intake 4 bottom [MEASURED]

// Middle Main Air Intake Inside dimensions, jogs over for power conn latch
X_L_MAIN_L  = 20.00;          // main_intake left [MEASURED]
X_L_MAIN_R  = X_INTAKE_1_R;   // main_intake right [MEASURED]
Y_L_MAIN_T  = Y_PC_T+0.50;         // main_intake top [MEASURED]
Y_L_MAIN_B  = 3.00;           // main_intake bottom [MEASURED]

// opening areas to remove from Outer dimensions as [x_min, y_min, x_max, y_max]
rects = [
    ["slot_top_left",   [X_COL_L, Y_SLOT_B, X_COL_R, Y_SLOT_T]],
    ["port_upper_left", [X_COL_L, Y_PU_B,   X_COL_R, Y_PU_T]],
    ["port_lower_left", [X_COL_L, Y_PL_B,   X_COL_R, Y_PL_T]],
    ["power_connector", [X_PC_L,  Y_PC_B, X_PC_R, Y_PC_T]],
    ["main_intake_1", [X_INTAKE_1_L,Y_INTAKE_1_B, X_INTAKE_1_R, Y_INTAKE_1_T]],
    ["main_intake_2", [X_INTAKE_2_L,Y_INTAKE_2_B, X_INTAKE_2_R, Y_INTAKE_2_T]],
    ["main_intake_3", [X_INTAKE_3_L,Y_INTAKE_3_B, X_INTAKE_3_R, Y_INTAKE_3_T]],
    ["main_intake_4", [X_INTAKE_4_L,Y_INTAKE_4_B, X_INTAKE_4_R, Y_INTAKE_4_T]],    
    ["main_lower_intake", [X_L_MAIN_L,Y_L_MAIN_B, X_L_MAIN_R, Y_L_MAIN_T+INTAKE_FIN_THK]],
    ["power_connector_latch", [X_PC_LAT_L,Y_PC_LAT_B, X_PC_LAT_R, Y_PC_LAT_T]],
];

// [MEASURED] 3.0mm mounting holes as [cx, cy, r]  (circles – exempt from the rectangle rule)
holes = [
    ["hole_1", [9.15, 89.50, (MOUNT_HOLE_DIAMETER/2.0)]],
    ["hole_2", [9.15, 61.00, (MOUNT_HOLE_DIAMETER/2.0)]],
];

module rect_at(r) {
    translate([r[0], r[1]])
        square([r[2]-r[0], r[3]-r[1]]);
}

//adds FACEPLATE_MARGIN_X/_Y outside the original GPU outer rectangle.
module gpu_faceplate_profile() {
    difference() {
        translate([X_OUTER_L - FACEPLATE_MARGIN_X, Y_OUTER_B - FACEPLATE_MARGIN_Y])
            square([(X_OUTER_R - X_OUTER_L) + 2 * FACEPLATE_MARGIN_X,
                    (Y_OUTER_T - Y_OUTER_B) + 2 * FACEPLATE_MARGIN_Y]);

        for (f = rects) rect_at(f[1]);
        for (h = holes) translate([h[1][0], h[1][1]]) circle(d = 2 * h[1][2]);
    }
}

// GPU Shroud cross-section:
// rectangular wrap around the GPU outer walls.
// Inner opening is at the GPU outer walls.
// Outer rectangle is expanded by SHROUD_WALL_THK_X/_Y in X/Y.
module gpu_shroud_profile() {
    difference() {
        translate([X_OUTER_L - SHROUD_WALL_THK_X, Y_OUTER_B - SHROUD_WALL_THK_Y])
            square([(X_OUTER_R - X_OUTER_L) + 2 * SHROUD_WALL_THK_X,
                    (Y_OUTER_T - Y_OUTER_B) + 2 * SHROUD_WALL_THK_Y]);

        translate([X_OUTER_L, Y_OUTER_B])
            square([X_OUTER_R - X_OUTER_L, Y_OUTER_T - Y_OUTER_B]);
    }
}

// Extruded shroud:
// protrudes from the faceplate front by SHROUD_PROTRUDE in -Z,
// and overlaps/embeds into the faceplate by SHROUD_EMBED for bonding.
module gpu_shroud() {
    translate([0, 0, -SHROUD_PROTRUDE]) {
        linear_extrude(height = SHROUD_PROTRUDE + SHROUD_EMBED)
            gpu_shroud_profile();
    }
}

// Faceplate as one part at its native origin (intake face z=0).
module cmp170hx_faceplate() {
    $fn = 48;   // from source file's global setting
    union() 
    {
    //extrude the GPU faceplate    
    linear_extrude(height = CMP_SHROUD_HEIGHT) gpu_faceplate_profile();
    //create the GPU shroud wrap    
    gpu_shroud();
    }
}

// =====================================================================
// Part 2 - 120 mm fan mounting plate
// Designed by K. Crisafulli
// =====================================================================
plate_w    = 120;   // outer width (X)
plate_h    = 120;   // outer height (Y)
plate_t    = 3.5;   // thickness (Z)
corner_r   = 0.5;   // outside corner radius
fan_open_d = 113;   // central fan opening diameter [MEASURED on SWP4 120 frame]
// Screw hole pattern: 105 x 105 mm center-to-center [MEASURED + standard].
hole_pitch   = 105;
screw_hole_d = 4.8; // standard fan screws (ID ~4.0 / OD ~4.9): lightly catches the screw to hold it in place before the fan is attached; when the plate is fitted, the screw cuts its own thread into the fan's hole (intentional light strip-out)

module rounded_plate() {
    // Outer plate is 120 x 120 with R0.5 corners.
    linear_extrude(height=plate_t)
        offset(r=corner_r)
            square([plate_w - 2*corner_r, plate_h - 2*corner_r], center=true);
}

module through_hole(diameter, fn) {
    // Cutter extends beyond both faces of the plate so it cuts fully through.
    translate([0, 0, plate_t / 2])
        cylinder(
            h = plate_t + 2,
            d = diameter,
            center = true,
            $fn = fn
        );
}

module mounting_holes() {
    for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx * hole_pitch / 2, sy * hole_pitch / 2])
                through_hole(screw_hole_d, 32);
}

// Fan plate as one part: centered on its own XY origin, z from 0 to plate_t.
module fan_plate_120mm() {
    difference() {
        rounded_plate();

        // Central fan airflow opening, fully through the plate.
        through_hole(fan_open_d, 96);

        // Four plain Ø4.8 mounting holes at the 105 x 105 pattern, fully through.
        mounting_holes();
    }
}

// =====================================================================
// Part 3 - Air duct CMP170HX faceplate to fan faceplate
// Designed by K. Crisafulli
// =====================================================================
// Fan plate center in assembly coordinates. Default: centered on the GPU outer
// walls, exactly like the 40mm adapter. Shift these for off-center variations.
FAN_CX = (X_OUTER_L + X_OUTER_R) / 2;   // 19.55 mm
// Y-shifted so the fan plate's max-Y edge aligns with the shroud's max-Y outer
// face (chassis clearance — the centered position overhung the chassis):
FAN_CY = Y_OUTER_T + SHROUD_WALL_THK_Y - plate_h / 2;   // 40.20 mm (centered would be 49.10)

// FACEPLATE_OFFSET_X (which faceplate position is active) is set at the TOP of
// this file, directly under FILE_VERSION. The FAN PLATE STAYS PUT when switching;
// every duct constant below re-derives to bridge the new gap.

DUCT_WALL_THK = 3.0;   // duct wall thickness (all walls) — V1.00: raised from 2.0 for print strength at this fan size (user FDM test: 3.0 minimal restriction, 4.0 restricts airflow at the faceplate)
DUCT_SLAB_T   = 0.1;   // thin-slab height used to build tapered panels via hull()

// Local-frame edge data (origin = fan center, z=0 at faceplate back):
SHROUD_XL = X_OUTER_L + FACEPLATE_OFFSET_X - SHROUD_WALL_THK_X - FAN_CX;  // shroud outer face, -X side (-40.87)
SHROUD_XR = X_OUTER_R + FACEPLATE_OFFSET_X + SHROUD_WALL_THK_X - FAN_CX;  // shroud outer face, +X side (+0.23)
SHROUD_YB = Y_OUTER_B - SHROUD_WALL_THK_Y - FAN_CY;  // shroud outer face, -Y side (-42.20)
SHROUD_YT = Y_OUTER_T + SHROUD_WALL_THK_Y - FAN_CY;  // shroud outer face, +Y side (+60.00)
FAN_XH    = plate_w / 2;   // fan plate half-width (60)
FAN_YH    = plate_h / 2;   // fan plate half-height (60)

// V1.20 (POS_2 fix): length of the W3 trim cutter along its own axis for tube_1/tube_3.
// At FACEPLATE_POS_P0_8_X wall 3's flare is gentler (shroud face near x=0), so the fixed-
// length cutters run out of height before reaching the tube tops and the tubes stick up
// above wall 3. This sizes a longer cutter to reach FAN_Z_GAP + margin; used only when
// FACEPLATE_OFFSET_X == FACEPLATE_POS_P0_8_X (see access_tube_1 / access_tube_3).
W3_CUT_LEN = (FAN_Z_GAP + 5) * sqrt(FAN_Z_GAP^2 + (FAN_XH + SHROUD_XL)^2) / FAN_Z_GAP;   // ~85.7 at POS 2, ~58.9 at POS 1

// Power connector notch (local): the cutout opens through both shroud edges at
// the -X/-Y corner; the duct jogs around it so cables can exit.
NOTCH_Y   = Y_PC_T - FAN_CY;        // connector cutout top edge (-17.90)
NOTCH_XR  = X_PC_LAT_R + FACEPLATE_OFFSET_X - FAN_CX;    // latch right edge (-22.82, V0.6 widened connector)
CABLE_CLR     = 2.0;  // margin past the notch for cable exit / clearance
WALL5_X   = NOTCH_XR + CABLE_CLR;   // wall 5 face position (-20.82)

// Access tubes for the four FAN mounting screws
FAN_HOLES = [   // fan screw hole centers, duct-local frame (fan plate centered on origin)
    [-hole_pitch / 2, -hole_pitch / 2],   // tube_1 target (-52.5, -52.5)
    [+hole_pitch / 2, -hole_pitch / 2],   // tube_2 target (+52.5, -52.5)
    [-hole_pitch / 2, +hole_pitch / 2],   // tube_3 target (-52.5, +52.5)
    [+hole_pitch / 2, +hole_pitch / 2]    // tube_4 target (+52.5, +52.5)
];
TUBE_OD        = 10.5;   // access tube outside diameter [trial size, user-specified]
TUBE_ID        = 8.5;    // access tube inside diameter (driver clearance) [measured vs fan screws]
TUBE_EMBED     = 0.50;   // bottom-end OD embed into the faceplate back for bonding (V1.10: was 0.05)

//========================= DUCT WALL 1 =====================================
// Wall 1: +X long side (opposite the connector). Flares outward +X going up.
module duct_wall_1() {
    hull() {
        translate([SHROUD_XR - DUCT_WALL_THK, SHROUD_YB, 0])                 // bottom edge slab
            cube([DUCT_WALL_THK, SHROUD_YT - SHROUD_YB, DUCT_SLAB_T]);
        translate([FAN_XH - DUCT_WALL_THK, -FAN_YH, FAN_Z_GAP - DUCT_SLAB_T]) // top edge slab
            cube([DUCT_WALL_THK, 2 * FAN_YH, DUCT_SLAB_T]);
    }
}

//========================= DUCT WALL 2 =====================================
// Wall 2: +Y short end (opposite the connector end). Full-length on both ends
// -> continuous corner overlap with walls 1 and 3. Flares outward +Y going up.
module duct_wall_2() {
    hull() {
        translate([SHROUD_XL, SHROUD_YT - DUCT_WALL_THK, 0])                 // bottom edge slab
            cube([SHROUD_XR - SHROUD_XL, DUCT_WALL_THK, DUCT_SLAB_T]);
        translate([-FAN_XH, FAN_YH - DUCT_WALL_THK, FAN_Z_GAP - DUCT_SLAB_T]) // top edge slab
            cube([2 * FAN_XH, DUCT_WALL_THK, DUCT_SLAB_T]);
    }
}

//========================= DUCT WALL 3 =====================================
// Wall 3: -X long side, from the +Y corner down to the connector notch edge.
// Bottom end stops at NOTCH_Y (cutout top edge). A third "cap" slab at the
// bottom-left corner keeps the bottom-end face vertical in Y (constant y =
// NOTCH_Y) instead of receding with height, which closes the air-leak gap
// between wall 3's base end and wall 4 (same as the 40mm design). Flares
// outward -X going up.
module duct_wall_3() {
    hull() {
        translate([SHROUD_XL, NOTCH_Y, 0])                                   // bottom edge slab
            cube([DUCT_WALL_THK, SHROUD_YT - NOTCH_Y, DUCT_SLAB_T]);
        translate([-FAN_XH, -FAN_YH, FAN_Z_GAP - DUCT_SLAB_T])               // top edge slab
            cube([DUCT_WALL_THK, 2 * FAN_YH, DUCT_SLAB_T]);
        translate([-FAN_XH, NOTCH_Y, FAN_Z_GAP - DUCT_SLAB_T])               // cap: vertical bottom end (closes leak gap)
            cube([DUCT_WALL_THK, -NOTCH_Y - FAN_YH, DUCT_SLAB_T]);
    }
}

//========================= DUCT WALL 4 =====================================
// Wall 4: vertical jog wall in the X-Z plane at constant y = NOTCH_Y
// (aligned with the connector cutout edge). Thickness on the duct-interior
// side so the notch stays fully open for the cable. Runs from the shroud
// outer face to 0.5 mm into wall 5's strip, and UP in Z until it hits wall 7:
// height WALL7_Z + DUCT_WALL_THK/2 embeds its top edge half-way into wall 7's
// slab for a watertight union. V0.78: top edge trimmed along the cap's TOP face
// plane (the tilted ramp) so it no longer pokes up through the ramp into the fan
// airflow — above the plane nothing of this wall remains in the cap's X span;
// below it the full T-thick band stays, still embedded in the cap slab. Wall 3
// flares away to the -X side (its outer face never crosses this wall's band), so
// the left end stands free above z~2.5 as an internal baffle; the notch bay stays
// sealed along y = NOTCH_Y by the continuous overlap of wall 4 + wall 3's cap face.
module duct_wall_4() {
    difference() {
        translate([SHROUD_XL, NOTCH_Y, 0])
            cube([WALL5_X - SHROUD_XL + 0.5, DUCT_WALL_THK, WALL7_Z + DUCT_WALL_THK / 2]);
        // V0.78: cut above the cap TOP face plane z(y) = CAP_TOP_ZC - tan(CAP_A)*(y-CAP_Y0).
        // Rotated-box idiom (verified): one face exactly on the plane, body entirely
        // above it; anchored at y = CAP_Y1 where the plane sits at z = CAP_TOP_ZC-CAP_DROP.
        translate([SHROUD_XL - 5, CAP_Y1, CAP_TOP_ZC - CAP_DROP])
            rotate([-CAP_A, 0, 0])
                translate([0, -(CAP_Y1 - CAP_Y0) - 30, 0])
                    cube([(WALL5_X + 0.5) - SHROUD_XL + 10, (CAP_Y1 - CAP_Y0) + 55, 40]);
    }
}
//========================= DUCT WALL 5 =====================================
// Wall 5: vertical jog wall in the Y-Z plane at constant x = WALL5_X
// (+CABLE_CLR past the notch on X for cable clearance). Thickness on the
// interior side. Runs from y = -FAN_YH (the fan plate's minimum-Y edge) up to
// y = NOTCH_Y + T, and UP in Z to FAN_Z_GAP + FAN_PLATE_EMBED so its top edge
// embeds 0.5 mm into the fan plate bottom face — attaching directly to the
// plate instead of stopping short (which left a big air opening). V0.78: that
// top edge is trimmed along the cap's TOP face plane where it crosses the ramp,
// so nothing pokes up through the ramp into the fan airflow; the -Y portion
// (y < ~-55.6, ahead of the ramp) keeps its full height to the fan plate. Crosses wall
// 7 on the way up; below y = SHROUD_YB it is a free-standing fin bonded via the
// top embed and the wall 7 crossing. Trimmed flush with wall 6R's OUTER face
// plane (V0.40, same treatment as the 40mm design): that face flares outward -Y
// going up from y = SHROUD_YB at z=0 to y = -FAN_YH at z=FAN_Z_GAP, so wall 5's
// bottom edge now continues wall 6R's outer silhouette with no groove and the
// two interpenetrate along the whole junction (watertight). Above the plane
// (y > SHROUD_YB) wall 5 stays full T-thick — its joints with walls 4/7/8 are
// unchanged.
module duct_wall_5() {
    difference() {
        translate([WALL5_X, -FAN_YH, 0])
            cube([DUCT_WALL_THK, NOTCH_Y + DUCT_WALL_THK + FAN_YH, FAN_Z_GAP + FAN_PLATE_EMBED]);
        // Trim flush with wall 6R's OUTER face plane: y = SHROUD_YB - s*z where
        // s = (FAN_YH + SHROUD_YB)/FAN_Z_GAP. Cutter box has one face exactly on
        // that plane, body entirely to its -Y side (outside); same rotated-box
        // idiom as the access-tube W6R cutter (see AGENTS.md trim pattern).
        translate([WALL5_X - 1, SHROUD_YB, 0])
            rotate([-atan(FAN_Z_GAP / (FAN_YH + SHROUD_YB)), 0, 0])
                translate([0, -130, -70])
                    cube([DUCT_WALL_THK + 2, 130, 70]);
        // V0.78: trim above the cap's TOP face plane so this wall no longer pokes up
        // through the ramp into the fan airflow (same cutter form as walls 4/8).
        // The cut follows the extended ramp line across the whole wall — including
        // the T-wide strip past the cap's +X end, which keeps the top edge a single
        // continuous silhouette from the fan's view.
        translate([WALL5_X - 5, CAP_Y1, CAP_TOP_ZC - CAP_DROP])
            rotate([-CAP_A, 0, 0])
                translate([0, -(CAP_Y1 - CAP_Y0) - 30, 0])
                    cube([DUCT_WALL_THK + 10, (CAP_Y1 - CAP_Y0) + 55, 40]);
    }
}

//========================= DUCT WALL 6 LEFT ===============================
// Wall 6 is split into 6L (left of wall 8), 6m (middle, right of wall 8) and
// 6R (right of wall 5), all flaring outward -Y going up. The 6L/6m boundary is
// wall 8's strip: 6L ends 0.5 mm embedded inside wall 8 from its OUTER face
// (x = SHROUD_XL + 0.5) and 6m starts 0.5 mm embedded from the INNER face
// (x = SHROUD_XL + T - 0.5), so both panels bond into wall 8 on opposite sides
// (V0.50). The 6m/6R split line is x = WALL5_X (wall 5's most-negative X); each
// side embeds exactly 0.5 mm PAST that line into wall 5's strip — 6m from the
// left, 6R from the right (V0.40: 6R used to start at WALL5_X-0.5) — so all
// panels and walls 5/8 mutually interpenetrate by >= 0.5 mm (watertight rule).
//
// Wall 6L: -Y short end, LEFT portion — from wall 3's corner to wall 8. Its
// bottom edge slab sits at y = NOTCH_Y (the connector cutout's maximum Y / top
// edge), NOT at SHROUD_YB: this steps the -Y end up above the cable channel,
// closing in the left side of the duct while leaving the channel below it fully
// open for cables to exit away from the duct. Top slab reaches x = -FAN_XH and
// overlaps wall 3's top strip (2 x 2 mm corner joint). Left edge ends 0.5 mm
// inside wall 8 (V0.50: was flush with wall 8's outer face at SHROUD_XL).
// V0.74: trimmed AT WALL 8 — right edge now stops with a 0.5 mm embed on the
// INNER (+X) side of wall 8 (x = SHROUD_XL + T - 0.5), same as 6m's left edge.
// Previously its flared band extended all the way to the 6m/6R split line and
// swept diagonally across the cable channel, covering it from the outside view;
// everything right of wall 8 is eliminated (user: "eliminate all that is
// possible"). The -Y boundary above the cap is now carried by 6m alone.
module duct_wall_6L() {
    hull() {
        translate([SHROUD_XL + 0.5, NOTCH_Y, 0])                             // bottom edge slab: at the notch line
            cube([(SHROUD_XL + DUCT_WALL_THK - 0.5) - (SHROUD_XL + 0.5), DUCT_WALL_THK, DUCT_SLAB_T]);
        translate([-FAN_XH, -FAN_YH, FAN_Z_GAP - DUCT_SLAB_T])               // top edge slab: to the fan corner
            cube([(SHROUD_XL + DUCT_WALL_THK - 0.5) + FAN_XH, DUCT_WALL_THK, DUCT_SLAB_T]);
    }
}

//========================= DUCT WALL 6 RIGHT ===============================
// Wall 6R: -Y short end, RIGHT portion — from wall 5 to the +X corner. Bottom
// edge slab at y = SHROUD_YB (shroud bottom face) spanning x from WALL5_X+0.5 to
// SHROUD_XR; top slab at fan level from WALL5_X+0.5 to FAN_XH. Left edge embeds
// exactly 0.5 mm into wall 5's strip on BOTH slabs (V0.40: was WALL5_X-0.5, which
// only interpenetrated the bottom band and left a gap at fan level), so the joint
// is watertight at every height; meets 6L along the split line.
module duct_wall_6R() {
    hull() {
        translate([WALL5_X + 0.5, SHROUD_YB, 0])                             // bottom edge slab: at the shroud face
            cube([SHROUD_XR - (WALL5_X + 0.5), DUCT_WALL_THK, DUCT_SLAB_T]);
        translate([WALL5_X + 0.5, -FAN_YH, FAN_Z_GAP - DUCT_SLAB_T])         // top slab: to the +X fan corner
            cube([FAN_XH - (WALL5_X + 0.5), DUCT_WALL_THK, DUCT_SLAB_T]);
    }
}

// ================ CABLE CHANNEL DUCT WALL CAP =============================
//         horizontal cap plate over the connector/cable area
WALL7_Z     = 45.0;   // distance above the fan-duct bottom
CAP_DROP    = 30.0;   // inner rear edge drop of the tilted cap
W6_IN_Y     = SHROUD_YB+DUCT_WALL_THK-(FAN_YH+SHROUD_YB)*WALL7_Z / FAN_Z_GAP;  
CAP_Y0      = W6_IN_Y-9.0; // cap -Y edge line y (anchored at z = WALL7_Z)
CAP_Y1      = NOTCH_Y + DUCT_WALL_THK; //wall 4's inner face
CAP_A       = atan(CAP_DROP/(CAP_Y1 - CAP_Y0)); // tilt from horizontal degrees
FAN_PLATE_EMBED = 0.5; //embed distance into fan-plate bottom face
CAP_H       = (FAN_Z_GAP - WALL7_Z + FAN_PLATE_EMBED) / cos(CAP_A); // slab thickness along its normal (~6.74 at CAP_DROP=30; vertical extent 5.5 incl. fan-plate embed)
// Cap TOP face plane in the Y-Z section: z(y) = CAP_TOP_ZC - tan(CAP_A)*(y - CAP_Y0),
// where CAP_TOP_ZC is that plane's z at y = CAP_Y0 (the plane extended past the slab's
// front edge; the actual front-top edge sits at (CAP_Y0+CAP_H*sin(CAP_A), FAN_Z_GAP+FAN_PLATE_EMBED)).
CAP_TOP_ZC  = WALL7_Z + CAP_H / cos(CAP_A);   // ~53.26 at CAP_DROP=30
// ======================================================================
module cable_channel_duct_cap() {
    Y_END = CAP_Y1 - CAP_H * sin(CAP_A); // rear end face top corner on wall 4's inner face (~z 23.3 at CAP_DROP=30)
    CAP_LENGTH = (Y_END - CAP_Y0) / cos(CAP_A); // slab length along the slope from anchor
    EXT_TOP_Z = FAN_Z_GAP + plate_t; // fan plate TOP face (53.5)—flush surface #1
    H_EXT     = (EXT_TOP_Z - WALL7_Z) / cos(CAP_A);     // thickness along normal: top plane reaches z=EXT_TOP_Z at the anchor line (~10.42 at CAP_DROP=30)
    difference() {
        // start with the rough cube shape
        translate([SHROUD_XL, CAP_Y0+DUCT_WALL_THK, WALL7_Z+4]) //anchor at -Y edge
            rotate([-CAP_A, 0, 0]) // +Y end drops over span (Y_END-CAP_Y0)
                cube([(WALL5_X + DUCT_WALL_THK) - SHROUD_XL,CAP_LENGTH,DUCT_WALL_THK]);
 //KC need to reduce embed to 0.5mm, the cube x value is too large.
        // cutter 1 to remove areas we don't want
        translate([SHROUD_XL - 2, CAP_Y0 - 5, EXT_TOP_Z])
            cube([(WALL5_X + 0.5) - SHROUD_XL + 4, (Y_END - CAP_Y0) + 10, 10]);
        // cutter 2 remove duct interior portions 
        translate([0, 0, FAN_Z_GAP])
            cylinder(h = EXT_TOP_Z - FAN_Z_GAP + 2, d = fan_open_d, $fn = 96);
    }
}

//========================= DUCT WALL 8 LEFT ===============================
//====== Wall 8: vertical panel in the Y-Z plane at x = SHROUD_XL =============
module duct_wall_8() {
    difference() {
        translate([SHROUD_XL, -FAN_YH, 0])
            cube([DUCT_WALL_THK, NOTCH_Y+DUCT_WALL_THK+FAN_YH, WALL7_Z+DUCT_WALL_THK / 2]);
        // cutter 1, Trim flush with outer planes.
        translate([SHROUD_XL - 1, NOTCH_Y, 0])
            rotate([-atan(FAN_Z_GAP / (FAN_YH + NOTCH_Y)), 0, 0])
                translate([0, -130, -70])
                    cube([DUCT_WALL_THK + 2, 130, 70]);
        // cutter 2, trim above the cap's TOP face plane
        translate([SHROUD_XL - 5, CAP_Y1, CAP_TOP_ZC - CAP_DROP])
            rotate([-CAP_A, 0, 0])
                translate([0, -(CAP_Y1 - CAP_Y0) - 30, 0])
                    cube([DUCT_WALL_THK + 10, (CAP_Y1 - CAP_Y0) + 55, 40]);
    }
}

//========================= FAN PLATE SCREW ACCESS TUBES =====================
// Access tubes 1-4: vertical ØTUBE_OD pillars centered on the four fan screw
// holes (FAN_HOLES), from z = -TUBE_EMBED (bonded into the faceplate back) up to
// z = FAN_Z_GAP + FAN_PLATE_EMBED (embedded 0.5 mm into the fan plate bottom face).
// Trim pass (V0.20): every tube's top is trimmed flush with the outer face plane
// of each flared wall it crosses — one rotated-box cutter per crossed plane, all
// derived from the same constants (see AGENTS.md "Access tube trim pattern"):
//   tube_1: walls 3 + 6L | tube_2: walls 1 + 6R | tube_3: wall 3 only |
//   tube_4: wall 1 only. Tubes 3/4 stay 0.25 mm clear of wall 2's vertical face
// (local y = FAN_YH), so no cutter is needed there. Sharp corner at each ridge —
// no fillet. The ØTUBE_ID bores are cut in air_duct() so each channel opens
// through its crossed wall(s).
module access_tube_1() {
    difference() {
        // OD body: from local z=-TUBE_EMBED up to FAN_PLATE_EMBED into the fan plate.
        translate([FAN_HOLES[0][0], FAN_HOLES[0][1], -TUBE_EMBED])
            cylinder(h = FAN_Z_GAP + FAN_PLATE_EMBED + TUBE_EMBED, d = TUBE_OD);

        // Trim flush with wall 3's OUTER face plane (flares outward -X going up):
        // remove everything outside {x < SHROUD_XL - (FAN_XH+SHROUD_XL)*z/FAN_Z_GAP}.
        // Cutter box: one face lies exactly on that plane, the whole body sits on
        // the OUTSIDE of it; anchored at the plane's z=0 line (x = SHROUD_XL).
        translate([SHROUD_XL, FAN_HOLES[0][1] - 25, 0])
            rotate([0, atan(FAN_Z_GAP / (FAN_XH + SHROUD_XL)), 0])
                translate([-60, 0, -70])
                    cube([60, 50, 70]);

        // if offset >= FACEPLATE_POS_P0_8_X wall 3's flare is gentler, so the fixed-
        // length cutter above runs out of height before reaching the tube top and the tube
        // sticks up above wall 3. This longer cutter covers the same plane to past the top.
        if (FACEPLATE_OFFSET_X >= FACEPLATE_POS_P0_8_X) {
            translate([SHROUD_XL, FAN_HOLES[0][1] - 25, 0])
                rotate([0, atan(FAN_Z_GAP / (FAN_XH + SHROUD_XL)), 0])
                    translate([-W3_CUT_LEN, 0, -70])
                        cube([W3_CUT_LEN, 50, 70]);
        }

        // Trim flush with wall 6L's OUTER face plane (flares outward -Y going up):
        // remove everything outside {y < NOTCH_Y - (FAN_YH+NOTCH_Y)*z/FAN_Z_GAP}.
        translate([FAN_HOLES[0][0] - 25, NOTCH_Y, 0])
            rotate([-atan(FAN_Z_GAP / (FAN_YH + NOTCH_Y)), 0, 0])
                translate([0, -80, -80])
                    cube([50, 80, 80]);
    }
}

// tube_2 crosses wall 1 (+X side) and wall 6R (-Y right portion). Same trim
// pattern as tube_1: one cutter per crossed outer face plane.
module access_tube_2() {
    difference() {
        translate([FAN_HOLES[1][0], FAN_HOLES[1][1], -TUBE_EMBED])
            cylinder(h = FAN_Z_GAP + FAN_PLATE_EMBED + TUBE_EMBED, d = TUBE_OD);

        // Trim flush with wall 1's OUTER face plane (flares outward +X going up):
        // remove everything outside {x > SHROUD_XR + (FAN_XH-SHROUD_XR)*z/FAN_Z_GAP}.
        translate([SHROUD_XR, FAN_HOLES[1][1] - 25, 0])
            rotate([0, -atan(FAN_Z_GAP / (FAN_XH - SHROUD_XR)), 0])
                translate([0, 0, -70])
                    cube([80, 50, 70]);

        // Trim flush with wall 6R's OUTER face plane (flares outward -Y going up):
        // remove everything outside {y < SHROUD_YB - (FAN_YH+SHROUD_YB)*z/FAN_Z_GAP}.
        translate([FAN_HOLES[1][0] - 25, SHROUD_YB, 0])
            rotate([-atan(FAN_Z_GAP / (FAN_YH + SHROUD_YB)), 0, 0])
                translate([0, -55, -70])
                    cube([50, 55, 70]);
    }
}

// tube_3 crosses only wall 3 (-X side); its max-Y edge (local y = +57.75) stays
// 0.25 mm clear of wall 2's vertical face at y = FAN_YH, so no second cutter.
module access_tube_3() {
    difference() {
        translate([FAN_HOLES[2][0], FAN_HOLES[2][1], -TUBE_EMBED])
            cylinder(h = FAN_Z_GAP + FAN_PLATE_EMBED + TUBE_EMBED, d = TUBE_OD);

        // Trim flush with wall 3's OUTER face plane (flares outward -X going up):
        // remove everything outside {x < SHROUD_XL - (FAN_XH+SHROUD_XL)*z/FAN_Z_GAP}.
        translate([SHROUD_XL, FAN_HOLES[2][1] - 25, 0])
            rotate([0, atan(FAN_Z_GAP / (FAN_XH + SHROUD_XL)), 0])
                translate([-60, 0, -70])
                    cube([60, 50, 70]);

        // FACEPLATE_OFFSET_X >= FACEPLATE_POS_P0_8_X: fix cutter
        // above runs out of height before the tube top at FACEPLATE_POS_P0_8_X.
        if (FACEPLATE_OFFSET_X >= FACEPLATE_POS_P0_8_X) {
            translate([SHROUD_XL, FAN_HOLES[2][1] - 25, 0])
                rotate([0, atan(FAN_Z_GAP / (FAN_XH + SHROUD_XL)), 0])
                    translate([-W3_CUT_LEN, 0, -70])
                        cube([W3_CUT_LEN, 50, 70]);
        }
    }
}

// tube_4 crosses only wall 1 (+X side); same clearance to wall 2 as tube_3.
module access_tube_4() {
    if (FACEPLATE_OFFSET_X < FACEPLATE_POS_P1_6_X) {
    difference() {
        translate([FAN_HOLES[3][0], FAN_HOLES[3][1], -TUBE_EMBED])
            cylinder(h = FAN_Z_GAP + FAN_PLATE_EMBED + TUBE_EMBED, d = TUBE_OD);

        // Trim flush with wall 1's OUTER face plane (flares outward +X going up):
        // remove everything outside {x > SHROUD_XR + (FAN_XH-SHROUD_XR)*z/FAN_Z_GAP}.
        translate([SHROUD_XR, FAN_HOLES[3][1] - 25, 0])
            rotate([0, -atan(FAN_Z_GAP / (FAN_XH - SHROUD_XR)), 0])
                translate([0, 0, -70])
                    cube([80, 50, 70]);
        }
    }      
}

// =====================================================================
// Designer placard - Customize as desired but keep the primary designer
// PRIMARY_DESIGNER K. Crisafulli as the top most name.
// Contributing designers revise 2ND_DESIGNER with your name
// 2ND_DESIGNER ....
// =====================================================================
PLACARD_W         = 40.0;  // width along X on wall 6R (text direction)
PLACARD_H         = 15.0;  // height up the slanted face
PLACARD_PROUD     = 1.0;   // proud of the outer face
PLACARD_EMBED     = 0.5;   // embedded into wall 6R for a watertight union (V0.60)
PLACARD_T         = PLACARD_PROUD + PLACARD_EMBED; // total plate thickness (1.1)
PLACARD_FONT      = "Liberation Mono:style=Bold";
PLACARD_TEXT_SIZE = 3.0;  // font size in mm (V0.70: up from 2.0 for print legibility — user verified it fits the 40 x 15 plate)
PLACARD_TEXT_OFFSET = -PLACARD_TEXT_SIZE/2.0; // centers the text 
PLACARD_TEXT_SPACE = 0.8;  // space between text lines
PLACARD_CHAMFER   = 1.0;   // V1.15: 45 deg chamfer around the proud-face perimeter — starts this far in from each edge on the top face and runs down to the side faces (removes slicer supports for the overhang)

module design_placard() {
    // Placement depends on the active faceplate position (V1.20): one x/y/z location
    // per FACEPLATE_POS, both on a flared outer face at mid-slope height.
    // POS 2: wall 6R is too narrow here for the full-size plate (its widest point is
    // only ~39.7 mm), so it moves to wall 1's OUTER face (+X long side, 120 mm wide),
    // centered on the face at y=0 — clears both access-tube bores that cross wall 1
    // (tubes 2/4 sit at y = -52.5 / +52.5). POS 1: original wall 6R placement.
    IS_POS_2   = FACEPLATE_OFFSET_X != FACEPLATE_POS_M0_8_X;
    W_FACE     = IS_POS_2 ? atan((FAN_XH - SHROUD_XR) / FAN_Z_GAP)      // wall 1 face slope from vertical (~20.9 deg at POS 2)
                          : atan((FAN_YH + SHROUD_YB) / FAN_Z_GAP);     // wall 6R face slope from vertical (~19.6 deg)
    Y_C        = IS_POS_2 ? 0.0                                         // center of wall 1's long dimension
                          : (SHROUD_YB - FAN_YH) / 2;                   // wall 6R y-center: [SHROUD_YB .. -FAN_YH]
    Z_C        = IS_POS_2 ? FAN_Z_GAP / 2                               // mid-slope height (25)
                          : (SHROUD_YB - Y_C) * FAN_Z_GAP / (FAN_YH + SHROUD_YB); // outer-face plane at Y_C (= FZG/2 here)
    W6R_LEFT   = WALL5_X + 0.5;                                         // wall 6R face left edge (constant in Z)
    W6R_RIGHT_ZC = SHROUD_XR + (FAN_XH - SHROUD_XR) * Z_C / FAN_Z_GAP;  // wall 6R face right edge at plate-center height
    X_C        = IS_POS_2 ? SHROUD_XR + (FAN_XH - SHROUD_XR) * Z_C / FAN_Z_GAP   // on wall 1's outer-face plane at Z_C (~50.43 at POS 2)
                          : (-10.0 + W6R_LEFT + W6R_RIGHT_ZC) / 2;      // user-tuned V0.70: mid-slope face center shifted -5 mm (render-verified "pretty close"); keeps the whole plate on the face with no overhang
    ROT        = IS_POS_2 ? [-90 - W_FACE, 0, -90]                      // same text-flip convention as wall 6R (V1.12), mirrored for the +X face
                          : [-90 - W_FACE, 0, 180];                     // flip text 180 degrees and correct slope to read when vertically mounted. (V1.12, user render-tested)
    translate([X_C, Y_C, Z_C])
    rotate(ROT)
    difference() {
        // Plate: centered in local x/y via explicit half-size offset (vector
        // `center` on cube() is not honoured by this OpenSCAD build); z from
        // -EMBED (inside wall) to +PROUD.
        translate([-PLACARD_W / 2, -PLACARD_H / 2, -PLACARD_EMBED])
            cube([PLACARD_W, PLACARD_H, PLACARD_T]);
        // V1.15: 45-degree chamfer around the proud-face perimeter (removes slicer
        // supports for the overhang). Four rotated-box cutters, one per side; each has
        // its inner face exactly on the bevel plane that starts PLACARD_CHAMFER in from
        // the edge on the top face and runs down at 45 deg to the side face. With
        // PROUD = CHAMFER = 1.0 the bevel meets each side face exactly at wall-face level
        // (local z=0), so every exposed surface is vertical or <= 45 deg. No center=true:
        // this OpenSCAD build ignores it — explicit half-size offsets instead.
        {
            C      = PLACARD_CHAMFER;
            Z_TOP  = PLACARD_T - PLACARD_EMBED;   // proud face, local z (+1.0)
            XH     = PLACARD_W / 2;               // 20
            YH     = PLACARD_H / 2;               // 7.5
            // Local-z depth of each cutter box below its pivot: the inner (bevel) edge
            // must reach global z=0 (wall-face level). Pivot sits at Z_TOP, so the box's
            // local -z end maps to height Z_TOP - DZ*cos(45); need <= 0 -> DZ >= sqrt(2)*C.
            // Use a little extra for margin; below z=0 there is no plate material on the
            // removed side, so the extra depth cannot cut anything visible.
            DZ     = C * sqrt(2) + 0.5;
            // +X side: bevel from (XH-C, Z_TOP) down to (XH, Z_TOP-C); box inner face on the plane.
            // Rotation pivot MUST sit at Z_TOP (where the bevel meets the top face), and the
            // pre-rotated box must occupy the quadrant that maps onto the corner being removed:
            // +X/+Y use local x/y >= 0 with z <= 0; -X/-Y use local x/y <= 0 AND z <= 0.
            translate([XH - C, -(YH + C), Z_TOP]) rotate([0, -45, 0])
                translate([0, 0, -DZ])
                    cube([2 * C, 2 * (YH + C), DZ + C]);
            // -X side: mirror about X — box extends along local -x AND -z
            translate([-XH + C, -(YH + C), Z_TOP]) rotate([0, 45, 0])
                translate([-2 * C, 0, -DZ])
                    cube([2 * C, 2 * (YH + C), DZ + C]);
            // +Y side: bevel from (0, YH-C, Z_TOP) down to (0, YH, Z_TOP-C) — box extends along local +y AND -z
            translate([-(XH + C), YH - C, Z_TOP]) rotate([45, 0, 0])
                translate([0, 0, -DZ])
                    cube([2 * (XH + C), 2 * C, DZ + C]);
            // -Y side: mirror about Y — box extends along local -y AND -z
            translate([-(XH + C), -YH + C, Z_TOP]) rotate([-45, 0, 0])
                translate([0, -2 * C, -DZ])
                    cube([2 * (XH + C), 2 * C, DZ + C]);
        }
        // Through-recessed text: cutters extend past both faces of the plate.
        translate([0, PLACARD_TEXT_OFFSET +(PLACARD_TEXT_SIZE+PLACARD_TEXT_SPACE), -PLACARD_EMBED - 1])
            linear_extrude(height = PLACARD_T + 2)
                text(str("CMP170HX V", format_float_d2(FILE_VERSION)), size = PLACARD_TEXT_SIZE, font = PLACARD_FONT, halign = "center");
        translate([0, PLACARD_TEXT_OFFSET, -PLACARD_EMBED - 1])
            linear_extrude(height = PLACARD_T + 2)
                text(PRIMARY_DESIGNER, size = PLACARD_TEXT_SIZE, font = PLACARD_FONT, halign = "center");
        translate([0, PLACARD_TEXT_OFFSET-(PLACARD_TEXT_SIZE+PLACARD_TEXT_SPACE), -PLACARD_EMBED - 1])
            linear_extrude(height = PLACARD_T + 2)
                text(2ND_DESIGNER, size = PLACARD_TEXT_SIZE, font = PLACARD_FONT, halign = "center"); // derived //from FILE_VERSION so it can't go stale; forces 2 decimal digits (V1.xx)
    }
}

module air_duct() {
    difference() {
        union() {
            duct_wall_1();   // +X long side (opposite connector)
            duct_wall_2();   // +Y short end (opposite the connector end)
            duct_wall_3();   // -X long side, down to the notch edge
            duct_wall_4();   // vertical jog at constant y = NOTCH_Y
            duct_wall_5();   // vertical jog at constant x = WALL5_X
            duct_wall_6L();  // -Y short end LEFT: ends embedded in wall 8 (V0.50)
            // duct_wall_6m() REMOVED in V0.77 — replaced by the raised wall 7 cap
            // whose -Y face now bonds directly to the fan plate over this X span.
            duct_wall_6R();  // -Y short end RIGHT: from wall 5 to +X corner (shroud-face base)
            cable_channel_duct_cap();   // horizontal cap over the connector/cable area (z=WALL7_Z)
            duct_wall_8();   // left side of the cable channel at x = SHROUD_XL
            access_tube_1(); // fan-screw access pillar, hole 1 (-52.5,-52.5)
            access_tube_2(); // fan-screw access pillar, hole 2 (+52.5,-52.5)
            access_tube_3(); // fan-screw access pillar, hole 3 (-52.5,+52.5)
            access_tube_4(); // fan-screw access pillar, hole 4 (+52.5,+52.5)
            design_placard();   // designer placard, wall 6R OUTER face (V0.60)
        }
        // ØTUBE_ID through-bores at the four fan screw holes: each cuts a true
        // opening through its tube AND any duct wall it crosses (tube_1 also
        // bores through wall 7), from local z=0 up past the top, so a driver can
        // reach each fan screw while the OD keeps the duct sealed around it.
        for (h = FAN_HOLES)
            translate([h[0], h[1], 0])
                cylinder(h = FAN_Z_GAP + FAN_PLATE_EMBED + 2, d = TUBE_ID);
    }
}

// =====================================================================
// Assembly
// ---------------------------------------------------------------------
// Faceplate footprint center in XY. The margins are symmetric per axis
// (equal left/right and top/bottom), so the GPU outer-wall center equals
// the faceplate center; FAN_CX / FAN_CY default to that centered position.

render() {
    // Faceplate shifted FACEPLATE_OFFSET_X in X for the chassis layout
    // (one PCIe slot left of its native position): intake face z=0, body +Z.
    translate([FACEPLATE_OFFSET_X, 0, 0])
        cmp170hx_faceplate();

    // Air duct spanning the gap between the two plates
    // (z = CMP_SHROUD_HEIGHT .. CMP_SHROUD_HEIGHT+FAN_Z_GAP), centered on the fan plate.
    translate([FAN_CX, FAN_CY, CMP_SHROUD_HEIGHT])
        air_duct();

    // Fan plate centered in XY over the faceplate by default, on the +Z side
    // (behind the GPU body). Local z spans [0, plate_t]; shifting by
    // CMP_SHROUD_HEIGHT + FAN_Z_GAP puts its bottom face at z = 60.0 -> 50 mm Z
    // spacing to the faceplate back.
    translate([FAN_CX, FAN_CY, CMP_SHROUD_HEIGHT + FAN_Z_GAP])
        fan_plate_120mm();
}
