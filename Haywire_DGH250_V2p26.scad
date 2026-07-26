//
// Haywire Tackle DGH-250 Rev B - Version 2.26 SMOOTH BULLET TRANSITION
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: Smoother, more rounded bullet shape from tip to widest point
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Bullet body
bodyLength = 55.0;         // Compact profile
bodyMaxDia = 38.1;         // 1.5" (at rear)
bodyMaxRadius = bodyMaxDia / 2;  // 19.05mm
bodyTipRadius = 5.5;       // Broader flat tip radius

// Skirt pocket (attached to rear)
skirtPocketDia = 19.05;    // 0.75"
skirtPocketRadius = skirtPocketDia / 2;  // 9.525mm
skirtPocketDepth = 12.7;   // 0.5"

// Tapered transition
transitionLength = 3.0;    // 3mm taper from body to pocket

// Leader hole - tapered
leaderHoleRadius = 2.0;    // 4mm diameter at start
leaderHoleTaperRadius = 6.35;  // 12.7mm diameter at end of pocket (0.5")

// Grooves (dual hydrodynamic)
groove1Pos = 14;
groove2Pos = 22;
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 6.0;
eyeDepth = 2.0;
eyePos = 28;


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        // Smooth bullet body with rounded transition
        body_main();
        
        // Tapered transition from body to pocket
        translate([0, 0, bodyLength])
            transition_taper();
        
        // Skirt pocket cylinder
        translate([0, 0, bodyLength + transitionLength])
            cylinder(h = skirtPocketDepth - transitionLength, r = skirtPocketRadius, $fn = 100);
        
        // Circumferential ribs (run around the pocket)
        translate([0, 0, bodyLength + transitionLength])
            ribs_circumferential();
    }

    // Leader hole - narrow portion through body
    cylinder(h = bodyLength, r = leaderHoleRadius, center = false);
    
    // Leader hole - tapered portion through transition and skirt pocket
    translate([0, 0, bodyLength])
        cylinder(h = skirtPocketDepth, r1 = leaderHoleRadius, r2 = leaderHoleTaperRadius, $fn = 100);

    // Hydrodynamic grooves
    groove_cut(groove1Pos);
    groove_cut(groove2Pos);

    // Eye sockets (both sides)
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Main Body: True Bullet Shape
// Smooth, continuous rounded curve from tip to widest point
// Uses fewer, larger taper segments for classic bullet profile
//----------------------------

module body_main()
{
    // Flat tip section: 2mm cylinder (flat top)
    translate([0, 0, 0])
        cylinder(h = 2, r = bodyTipRadius, $fn = 120);
    
    // Main bullet taper section: 30mm from tip to widest point
    // Smooth, continuous taper from 5.5mm to 19.05mm radius
    translate([0, 0, 2])
        cylinder(h = 30, r1 = bodyTipRadius, r2 = bodyMaxRadius, $fn = 120);
    
    // Extended cylinder section: 23mm - maintains full radius (19.05mm)
    translate([0, 0, 32])
        cylinder(h = 23, r = bodyMaxRadius, $fn = 120);
}


//----------------------------
// Tapered Transition
// Smooth taper from main body (19.05mm) to skirt pocket (9.525mm)
// Over 3mm length
//----------------------------

module transition_taper()
{
    cylinder(h = transitionLength, r1 = bodyMaxRadius, r2 = skirtPocketRadius, $fn = 120);
}


//----------------------------
// Circumferential Ribs
// Two tapered bands that run around the full circumference
//----------------------------

module ribs_circumferential()
{
    // Rib 1: Front band of the pocket (tapers from front to back)
    rib_band(0, 5);  // Starts at z=0, height 5mm
    
    // Rib 2: Rear band of the pocket (tapers more steeply)
    rib_band(6, 6.7);  // Starts at z=6, height 6.7mm
}


//----------------------------
// Single Rib Band (runs circumferentially)
// Uses rotate_extrude to create a band around the pocket
//----------------------------

module rib_band(zStart, zHeight)
{
    translate([0, 0, zStart])
        rotate_extrude(convexity = 5, $fn = 100)
        {
            // Profile of the rib band (in 2D, revolved around Z-axis)
            polygon(points=[
                // Inner wall (at pocket radius)
                [skirtPocketRadius, 0],
                [skirtPocketRadius, zHeight],
                
                // Outer wall - tapers from front to back
                [skirtPocketRadius + 1.2, zHeight * 0.4],  // Rear outer (tapered)
                [skirtPocketRadius + 1.5, 0],              // Front outer (full height)
                
                // Close the polygon
                [skirtPocketRadius, 0]
            ]);
        }
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
