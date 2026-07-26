//
// Haywire Tackle DGH-250 Rev B - Version 2.27 FULL BULLET SHAPE
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: More exaggerated, fuller bullet curve - true classic bullet profile
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
        // Full bullet body with exaggerated curve
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
// Main Body: Full Exaggerated Bullet Shape
// More pronounced, rounder curve with smoother progression
// Uses spline-like curve simulation with smaller cone segments
//----------------------------

module body_main()
{
    // Flat tip section: 1.5mm cylinder
    translate([0, 0, 0])
        cylinder(h = 1.5, r = bodyTipRadius, $fn = 120);
    
    // Bullet curve segment 1: Very gradual initial curve
    translate([0, 0, 1.5])
        cylinder(h = 6, r1 = bodyTipRadius, r2 = 7.5, $fn = 120);
    
    // Bullet curve segment 2: Smooth rounding continues
    translate([0, 0, 7.5])
        cylinder(h = 7, r1 = 7.5, r2 = 11, $fn = 120);
    
    // Bullet curve segment 3: Fuller curve acceleration
    translate([0, 0, 14.5])
        cylinder(h = 8, r1 = 11, r2 = 15.5, $fn = 120);
    
    // Bullet curve segment 4: Final rounding to widest point
    translate([0, 0, 22.5])
        cylinder(h = 7, r1 = 15.5, r2 = bodyMaxRadius, $fn = 120);
    
    // Extended cylinder section: 18mm - maintains full radius (19.05mm)
    translate([0, 0, 29.5])
        cylinder(h = 25.5, r = bodyMaxRadius, $fn = 120);
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
