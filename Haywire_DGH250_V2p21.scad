//
// Haywire Tackle DGH-250 Rev B - Version 2.20 ENLARGED DOMED TIP
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: Larger domed tip with 6mm radius and 6mm length (2mm sliced off) + 1mm round-over edge blend
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Bullet body
bodyLength = 75.8;         // Extended from 60.8 to 75.8 (additional 15mm added)
bodyMaxDia = 38.1;         // 1.5" (at rear)
bodyMaxRadius = bodyMaxDia / 2;  // 19.05mm
bodyTipRadius = 6.0;       // Enlarged dome tip (6mm radius)
tipHeight = 6.0;           // 8mm - 2mm slice = 6mm
tipRoundoverRadius = 1.0;  // 1mm round-over edge blend

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
        // Enlarged domed tip with round-over edge blend (2mm sliced off)
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
// Main Body: Enlarged Domed Tip (2mm Sliced) with Round-Over Edge Blend
//----------------------------

module body_main()
{
    // Dome tip section: 6mm height (sliced 2mm from 8mm) with round-over edges
    translate([0, 0, 0])
        tip_with_roundover();
    
    // Middle section: 20mm - tapers from 8mm to 15mm radius
    translate([0, 0, tipHeight])
        cylinder(h = 20, r1 = 8, r2 = 15, $fn = 120);
    
    // Rear section: 20.8mm - tapers from 15mm to full radius (19.05mm)
    translate([0, 0, tipHeight + 20])
        cylinder(h = 20.8, r1 = 15, r2 = bodyMaxRadius, $fn = 120);
    
    // Extended cylinder section: 25mm - maintains full radius (19.05mm)
    translate([0, 0, tipHeight + 40.8])
        cylinder(h = 27, r = bodyMaxRadius, $fn = 120);
}


//----------------------------
// Tip Section with 1mm Round-Over Edge Blend (2mm Sliced)
// Creates a tapered dome with rounded edge transition
//----------------------------

module tip_with_roundover()
{
    difference()
    {
        // Base: 6mm height (2mm sliced), tapering from 6mm radius at tip to 8mm radius at base
        cylinder(h = tipHeight, r1 = bodyTipRadius - 1, r2 = 8, $fn = 120);
        
        // Round-over the top edge using a torus segment
        translate([0, 0, tipHeight])
            rotate_extrude(convexity = 5, $fn = 120)
            {
                // Torus profile for 1mm round-over at tapered tip
                translate([bodyTipRadius - tipRoundoverRadius - 0.5, 0])
                    circle(r = tipRoundoverRadius, $fn = 80);
            }
    }
    
    // Add the round-over bulge (inverse operation)
    translate([0, 0, tipHeight])
        rotate_extrude(convexity = 5, $fn = 120)
        {
            // Rounded edge profile: curves smoothly at tapered tip
            polygon(points=[
                [bodyTipRadius - tipRoundoverRadius - 0.5, 0],
                [bodyTipRadius - 0.5, 0],
                [bodyTipRadius - 0.2, tipRoundoverRadius * 0.5],
                [bodyTipRadius - tipRoundoverRadius - 0.8, tipRoundoverRadius]
            ]);
        }
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
