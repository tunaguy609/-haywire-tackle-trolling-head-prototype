//
// Haywire Tackle DGH-250 Rev B - Version 2.11 SIMPLIFIED GEOMETRY
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Built from basic primitives for reliable rendering
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Bullet body
bodyLength = 50.8;         // 2.0"
bodyMaxDia = 38.1;         // 1.5" (at rear)
bodyMaxRadius = bodyMaxDia / 2;  // 19.05mm
bodyTipRadius = 3.0;       // Blunt tip

// Skirt pocket (attached to rear)
skirtPocketDia = 25.4;     // 1.0"
skirtPocketRadius = skirtPocketDia / 2;  // 12.7mm
skirtPocketDepth = 12.7;   // 0.5"

// Leader hole
leaderHoleRadius = 1.0;

// Grooves (dual hydrodynamic)
groove1Pos = 18;
groove2Pos = 27;
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 6.0;
eyeDepth = 2.0;
eyePos = 35;


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        // Blunt tapered body (cone + cylinder blend)
        body_main();
        
        // Skirt pocket cylinder
        translate([0, 0, bodyLength])
            cylinder(h = skirtPocketDepth, r = skirtPocketRadius, $fn = 100);
        
        // Two tapered ribs inside pocket
        translate([0, 0, bodyLength])
            rib_pair();
    }

    // Leader hole
    cylinder(h = bodyLength + skirtPocketDepth + 10, r = leaderHoleRadius, center = true);

    // Hydrodynamic grooves
    groove_cut(groove1Pos);
    groove_cut(groove2Pos);

    // Eye sockets (both sides)
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Main Body: Blunt Tapered Cone
//----------------------------

module body_main()
{
    // Use a combination of cylinder and cone for smooth bullet shape
    // Tip section: 10mm - tapers from 3mm to 8mm radius
    translate([0, 0, 0])
        cylinder(h = 10, r1 = bodyTipRadius, r2 = 8, $fn = 120);
    
    // Middle section: 20mm - tapers from 8mm to 15mm radius
    translate([0, 0, 10])
        cylinder(h = 20, r1 = 8, r2 = 15, $fn = 120);
    
    // Rear section: 20.8mm - tapers from 15mm to full radius (19.05mm)
    translate([0, 0, 30])
        cylinder(h = 20.8, r1 = 15, r2 = bodyMaxRadius, $fn = 120);
}


//----------------------------
// Tapered Rib Pair (Two Circumferential Ribs)
//----------------------------

module rib_pair()
{
    // Rib 1 at 0 degrees
    rotate([0, 0, 0])
        rib_single();
    
    // Rib 2 at 180 degrees
    rotate([0, 0, 180])
        rib_single();
}


//----------------------------
// Single Tapered Rib
//----------------------------

module rib_single()
{
    // Wedge-shaped rib that rises from pocket floor and tapers toward rear
    linear_extrude(height = skirtPocketDepth, twist = 0, scale = 0.3)
        polygon(points=[
            [skirtPocketRadius, 0],           // Inner pocket edge
            [skirtPocketRadius + 1.5, 0],     // Outer edge at base
            [skirtPocketRadius + 1.0, 1],     // Taper point
            [skirtPocketRadius, 1]            // Back to inner edge
        ]);
}


//----------------------------
// Hydrodynamic Groove Cutter
//----------------------------

module groove_cut(zPos)
{
    translate([0, 0, zPos])
        rotate_extrude(convexity = 10, $fn = 100)
            translate([bodyMaxRadius - grooveDepth/2, 0])
                circle(r = grooveDepth/2);
}


//----------------------------
// Recessed Eye Socket
//----------------------------

module eye_socket(side)
{
    translate([side * (bodyMaxRadius + 1), 0, eyePos])
        rotate([0, 90 * side, 0])
            cylinder(d = eyeDia, h = eyeDepth + 1, $fn = 80);
}


//----------------------------
// Render Quality Settings
//----------------------------

$fa = 1.5;
$fs = 0.2;
