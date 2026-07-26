//
// Haywire Tackle DGH-250 Trolling Head - Version 1.0
// Traditional Rounded Bullet Trolling Head
// Specifications: 1.0" total length, smooth ogive, two grooves, constant rear body
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Overall length
totalLength = 25.4;        // 1.0 inch

// Tip section
tipLength = 3.175;         // 0.125 inch
tipDiameter = 3.18;        // 0.125 inch
tipRadius = tipDiameter / 2;  // 1.59 mm

// Ogive (expanding) section
ogiveLength = 12.4;        // ~0.475-0.500 inch (average 12.4mm)
ogiveStartRadius = tipRadius;  // Starts at tip radius
ogiveEndRadius = 9.525;    // 0.375 inch (half of 0.750")

// Main body (constant diameter)
mainBodyLength = totalLength - tipLength - ogiveLength;  // ~9.8mm remaining
mainBodyRadius = 9.525;    // 0.375 inch (half of 0.750")

// Leader hole
leaderHoleRadius = 2.0;    // 4 mm diameter

// Grooves (hydrodynamic, on ogive section)
groove1Pos = 4.5;          // Position along total length
groove2Pos = 8.0;          // Position along total length
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 6.0;
eyeDepth = 2.0;
eyePos = 18.0;             // Position along body


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        // Rounded bullet tip
        bullet_tip();
        
        // Smooth ogive (expanding) section
        translate([0, 0, tipLength])
            ogive_section();
        
        // Main body cylinder (constant diameter)
        translate([0, 0, tipLength + ogiveLength])
            cylinder(h = mainBodyLength, r = mainBodyRadius, $fn = 120);
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
// Rounded Bullet Tip
// Hemispherical dome with slight extension
//----------------------------

module bullet_tip()
{
    // Create a domed hemisphere at the tip
    sphere(r = tipRadius, $fn = 100);
    
    // Extend tip backward with cylinder to blend into ogive
    translate([0, 0, -tipRadius])
        cylinder(h = tipRadius + 0.5, r = tipRadius, $fn = 100);
}


//----------------------------
// Smooth Ogive Section
// Progressive expanding cone from tip radius to main body radius
//----------------------------

module ogive_section()
{
    // Smooth expanding taper from ogive start to ogive end
    cylinder(h = ogiveLength, r1 = ogiveStartRadius, r2 = ogiveEndRadius, $fn = 120);
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
