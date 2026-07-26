//
// Haywire Tackle DGH-250 Rev B - Version 2.17 ROUNDED OUTER EDGE
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: Rounded outer edge where main body meets skirt pocket
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
skirtPocketDia = 19.05;    // 0.75"
skirtPocketRadius = skirtPocketDia / 2;  // 9.525mm
skirtPocketDepth = 12.7;   // 0.5"

// Rounded edge transition
edgeRoundRadius = 2.0;     // Smooth rounding on outer edge

// Leader hole - tapered
leaderHoleRadius = 2.0;    // 4mm diameter at start
leaderHoleTaperRadius = 6.35;  // 12.7mm diameter at end of pocket (0.5")

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
        
        // Circumferential ribs (run around the pocket)
        translate([0, 0, bodyLength])
            ribs_circumferential();
        
        // Rounded edge transition
        translate([0, 0, bodyLength])
            rounded_edge_transition();
    }

    // Leader hole - narrow portion through body
    cylinder(h = bodyLength, r = leaderHoleRadius, center = false);
    
    // Leader hole - tapered portion through skirt pocket
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
// Main Body: Blunt Tapered Cone
//----------------------------

module body_main()
{
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
// Rounded Edge Transition
// Smooth rounding on the outer edge where body meets pocket
//----------------------------

module rounded_edge_transition()
{
    rotate_extrude(convexity = 5, $fn = 100)
    {
        // Create a smooth rounded profile for the edge
        polygon(points=[
            // Start at the inner diameter of the pocket
            [skirtPocketRadius, 0],
            [skirtPocketRadius, edgeRoundRadius * 0.3],
            
            // Curve out to the outer diameter with smooth rounding
            [bodyMaxRadius - edgeRoundRadius * 0.5, edgeRoundRadius * 0.7],
            [bodyMaxRadius, edgeRoundRadius],
            
            // Back to start
            [skirtPocketRadius, 0]
        ]);
    }
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
