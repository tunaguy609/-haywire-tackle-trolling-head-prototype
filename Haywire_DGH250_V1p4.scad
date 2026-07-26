//
// Haywire Tackle DGH-250 Trolling Head - Version 1.4
// Traditional Rounded Bullet Trolling Head
// Specifications: 1.0" + 25mm extended body, 5mm tip diameter, smooth domed bullet profile, smooth blended transition, two grooves
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Overall length
baseTotalLength = 25.4;    // 1.0 inch base
bodyExtension = 25.0;      // Added 25mm to main body
totalLength = baseTotalLength + bodyExtension;  // ~50.4 mm total

// Tip section
tipLength = 3.175;         // 0.125 inch
tipDiameter = 5.0;         // 5 mm
tipRadius = tipDiameter / 2;  // 2.5 mm

// Domed bullet section (tip to widest) - SMOOTH CURVE
bulletLength = 12.4;       // ~0.475-0.500 inch (average 12.4mm)
bulletStartRadius = tipRadius;  // Starts at tip radius
bulletEndRadius = 9.525;   // 0.375 inch (half of 0.750")

// Main body (constant diameter) - NOW EXTENDED
mainBodyLength = totalLength - tipLength - bulletLength;  // ~35.8mm (original ~9.8mm + 25mm extension)
mainBodyRadius = 9.525;    // 0.375 inch (half of 0.750")

// Leader hole
leaderHoleRadius = 2.0;    // 4 mm diameter

// Grooves (hydrodynamic, on bullet section)
groove1Pos = 4.5;          // Position along total length
groove2Pos = 8.0;          // Position along total length
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 6.0;
eyeDepth = 2.0;
eyePos = 30.0;             // Position along body (adjusted for longer body)

// Transition blend parameters
transitionBlendRadius = 3.0;  // Smooth blend radius at transition


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        // Rounded bullet tip with smooth domed profile
        bullet_tip();
        
        // Smooth domed bullet section using hull (continuous curve)
        translate([0, 0, tipLength])
            domed_bullet_section();
        
        // Smooth blended transition + main body
        translate([0, 0, tipLength + bulletLength])
            blended_body_transition();
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
    
    // Extend tip backward with cylinder to blend into bullet section
    translate([0, 0, -tipRadius])
        cylinder(h = tipRadius + 0.5, r = tipRadius, $fn = 100);
}


//----------------------------
// Smooth Domed Bullet Section
// Creates a smooth, continuous curve from tip radius to max radius
// Using hull() for smooth interpolation (like a real bullet dome)
//----------------------------

module domed_bullet_section()
{
    // Hull creates smooth shape between the two cylinders
    // This gives the smooth, rounded dome profile
    hull()
    {
        // Start: small cylinder at tip end
        cylinder(h = 0.1, r = bulletStartRadius, $fn = 120);
        
        // End: large cylinder at max diameter end
        translate([0, 0, bulletLength - 0.1])
            cylinder(h = 0.1, r = bulletEndRadius, $fn = 120);
    }
}


//----------------------------
// Blended Body Transition + Main Body
// Smooth rounded blend where taper meets main body
//----------------------------

module blended_body_transition()
{
    // Use hull to create smooth transition from bullet end to main body
    hull()
    {
        // Start at bullet end (max radius)
        cylinder(h = 0.1, r = bulletEndRadius, $fn = 120);
        
        // Transition zone: slightly extended for smooth blend
        translate([0, 0, transitionBlendRadius * 0.5])
            cylinder(h = 0.1, r = bulletEndRadius + transitionBlendRadius * 0.3, $fn = 120);
        
        // End: full main body radius
        translate([0, 0, transitionBlendRadius])
            cylinder(h = 0.1, r = mainBodyRadius, $fn = 120);
    }
    
    // Main body cylinder (constant diameter)
    translate([0, 0, transitionBlendRadius])
        cylinder(h = mainBodyLength - transitionBlendRadius, r = mainBodyRadius, $fn = 120);
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
