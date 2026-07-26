//
// Haywire Tackle DGH-250 Trolling Head - Version 1.7
// Traditional Rounded Bullet Trolling Head
// Specifications: 1.0" + 15mm extended body, 6mm tip radius, 8mm tip length, pronounced domed tip with seamless blend
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Overall length
baseTotalLength = 25.4;    // 1.0 inch base
bodyExtension = 15.0;      // Reduced from 25mm to 15mm (10mm shorter)
totalLength = baseTotalLength + bodyExtension;  // ~40.4 mm total

// Tip section - MORE DOMED
tipLength = 8.0;           // 8 mm
tipDiameter = 12.0;        // 6 mm radius = 12 mm diameter
tipRadius = tipDiameter / 2;  // 6 mm

// Domed bullet section (tip to widest) - SMOOTH CURVE
bulletLength = 12.4;       // ~0.475-0.500 inch (average 12.4mm)
bulletStartRadius = tipRadius;  // Starts at tip radius (6 mm)
bulletEndRadius = 9.525;   // 0.375 inch (half of 0.750")

// Main body (constant diameter) - NOW SHORTER
mainBodyLength = totalLength - tipLength - bulletLength;  // ~20.0mm (reduced by 10mm)
mainBodyRadius = 9.525;    // 0.375 inch (half of 0.750")

// Leader hole
leaderHoleRadius = 2.0;    // 4 mm diameter

// Grooves (hydrodynamic, on bullet section)
groove1Pos = 9.5;          // Position along total length
groove2Pos = 13.0;         // Position along total length
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 6.0;
eyeDepth = 2.0;
eyePos = 25.0;             // Adjusted position for shorter body

// Transition blend parameters
transitionBlendRadius = 3.0;  // Smooth blend radius at transition


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        // Single seamless shape: domed tip + bullet taper + main body
        full_body_shape();
    }

    // Leader hole - 4 mm through entire length
    cylinder(h = totalLength + 1, r = leaderHoleRadius, $fn = 80);

    // Hydrodynamic grooves
    groove_cut(groove1Pos);
    groove_cut(groove2Pos);

    // Eye sockets (both sides)
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Full Body Shape - One Seamless Piece
// Uses hull() to create continuous blend from tip through body
//----------------------------

module full_body_shape()
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
            cylinder(h = mainBodyLength - transitionBlendRadius + 1, r = mainBodyRadius, $fn = 120);
    }
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
