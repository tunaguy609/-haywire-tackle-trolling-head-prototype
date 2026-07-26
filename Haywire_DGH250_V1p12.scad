//
// Haywire Tackle DGH-250 Trolling Head - Version 1.12
// Traditional Rounded Bullet Trolling Head with Skirt Pocket
// Specifications: 1.0" + 15mm extended body, 6mm tip radius, 3mm tip length, 4mm leader hole through entire length
// Skirt Pocket: 8.0mm ID, 0.500" depth (12.70mm), 0.125" wall (3.18mm)
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Overall length
baseTotalLength = 25.4;    // 1.0 inch base
bodyExtension = 15.0;      // 15mm extended body
totalLength = baseTotalLength + bodyExtension;  // ~40.4 mm total

// Tip section - MORE DOMED but SHORTER
tipLength = 3.0;           // 3mm
tipDiameter = 12.0;        // 6 mm radius = 12 mm diameter
tipRadius = tipDiameter / 2;  // 6 mm

// Domed bullet section (tip to widest) - SMOOTH CURVE
bulletLength = 12.4;       // ~0.475-0.500 inch (average 12.4mm)
bulletStartRadius = tipRadius;  // Starts at tip radius (6 mm)
bulletEndRadius = 9.525;   // 0.375 inch (half of 0.750")

// Main body (constant diameter)
mainBodyLength = totalLength - tipLength - bulletLength;  // ~25.0mm
mainBodyRadius = 9.525;    // 0.375 inch (half of 0.750")

// Leader hole
leaderHoleRadius = 2.0;    // 4 mm diameter

// Grooves (hydrodynamic, on bullet section)
groove1Pos = 4.5;          // Position along total length (adjusted for shorter tip)
groove2Pos = 8.0;          // Position along total length (adjusted for shorter tip)
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 6.0;
eyeDepth = 2.0;
eyePos = 25.0;             // Position along body

// Transition blend parameters
transitionBlendRadius = 3.0;  // Smooth blend radius at transition

// Skirt pocket parameters
skirtPocketID = 8.0;       // Inside diameter (reduced)
skirtPocketRadius = skirtPocketID / 2;  // 4.0 mm
skirtPocketDepth = 12.70;  // Depth (0.500")
skirtWallThickness = 3.18; // Wall thickness (0.125")
skirtPocketOD = skirtPocketID + (2 * skirtWallThickness);  // Outside diameter of pocket
skirtPocketODRadius = skirtPocketOD / 2;  // Outside radius


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        // Single seamless shape: domed tip + bullet taper + main body + skirt pocket boss
        full_body_with_skirt();
    }

    // Leader hole - 4 mm through ENTIRE length from front to back
    translate([0, 0, -tipRadius - 1])
        cylinder(h = totalLength + tipRadius * 2 + 2, r = leaderHoleRadius, $fn = 80);

    // Hydrodynamic grooves
    groove_cut(groove1Pos);
    groove_cut(groove2Pos);

    // Eye sockets (both sides)
    eye_socket(1);
    eye_socket(-1);
    
    // Skirt pocket cavity - cuts into the back end
    skirt_pocket_cut();
}


//----------------------------
// Full Body Shape with Skirt Pocket Boss
// Uses hull() to create continuous blend from tip through body with skirt pocket extension
//----------------------------

module full_body_with_skirt()
{
    hull()
    {
        // Tip: hemispherical dome at the very front
        sphere(r = tipRadius, $fn = 100);
        
        // Transition point 1: maintain tip radius for smooth start
        translate([0, 0, tipLength * 0.25])
            cylinder(h = 0.1, r = tipRadius, $fn = 120);
        
        // Transition point 2: halfway through bullet section, gradient radius
        midBulletRadius = tipRadius + (bulletEndRadius - tipRadius) * 0.5;
        translate([0, 0, tipLength + bulletLength * 0.5])
            cylinder(h = 0.1, r = midBulletRadius, $fn = 120);
        
        // Transition point 3: end of bullet section at max radius
        translate([0, 0, tipLength + bulletLength])
            cylinder(h = 0.1, r = bulletEndRadius, $fn = 120);
        
        // Transition point 4: blended transition zone
        translate([0, 0, tipLength + bulletLength + transitionBlendRadius * 0.5])
            cylinder(h = 0.1, r = bulletEndRadius + transitionBlendRadius * 0.3, $fn = 120);
        
        // Main body: full constant radius
        translate([0, 0, tipLength + bulletLength + transitionBlendRadius])
            cylinder(h = mainBodyLength - transitionBlendRadius + 0.1, r = mainBodyRadius, $fn = 120);
        
        // Skirt pocket boss - extends to back with pocket OD radius
        skirtBossStart = tipLength + bulletLength + mainBodyLength;
        translate([0, 0, skirtBossStart])
            cylinder(h = skirtPocketDepth, r = skirtPocketODRadius, $fn = 120);
        
        // Back end of skirt boss - tapered to point
        translate([0, 0, skirtBossStart + skirtPocketDepth])
            sphere(r = skirtPocketODRadius * 0.3, $fn = 100);
    }
}


//----------------------------
// Skirt Pocket Cavity Cutter
// Creates the cylindrical pocket opening at the back end
//----------------------------

module skirt_pocket_cut()
{
    skirtPocketStart = tipLength + bulletLength + mainBodyLength;
    translate([0, 0, skirtPocketStart])
        cylinder(h = skirtPocketDepth + 1, r = skirtPocketRadius, $fn = 100);
}


//----------------------------
// Hydrodynamic Groove Cutter
// Creates circular groove running around the body
//----------------------------

module groove_cut(zPos)
{
    translate([0, 0, zPos])
        rotate_extrude(convexity = 10, $fn = 100)
            translate([mainBodyRadius - grooveDepth/2, 0])
                circle(r = grooveDepth/2, $fn = 80);
}


//----------------------------
// Recessed Eye Socket
// Circular hole on each side of the body
//----------------------------

module eye_socket(side)
{
    translate([side * (mainBodyRadius + 1), 0, eyePos])
        rotate([0, 90 * side, 0])
            cylinder(d = eyeDia, h = eyeDepth + 1, $fn = 80);
}


//----------------------------
// Render Quality Settings
//----------------------------

$fa = 1.5;
$fs = 0.2;
