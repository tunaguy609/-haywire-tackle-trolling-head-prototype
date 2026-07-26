//
// Haywire Tackle DGH-250 Rev B - Version 2.19 EXTENDED CYLINDER
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: Extended widest diameter section by additional 10mm (total 20mm at max dia)
// Enhanced: Visible engraved hydrodynamic grooves on body
//

$fn = 150;

//----------------------------
// Dimensions (mm)
//----------------------------

// Bullet body
bodyLength = 70.8;         // Extended from 60.8 to 70.8 (additional 10mm at widest)
bodyMaxDia = 38.1;         // 1.5" (at rear)
bodyMaxRadius = bodyMaxDia / 2;  // 19.05mm
bodyTipRadius = 3.0;       // Blunt tip

// Skirt pocket (attached to rear)
skirtPocketDia = 19.05;    // 0.75"
skirtPocketRadius = skirtPocketDia / 2;  // 9.525mm
skirtPocketDepth = 12.7;   // 0.5"

// Tapered transition
transitionLength = 3.0;    // 3mm taper from body to pocket

// Leader hole - tapered
leaderHoleRadius = 2.0;    // 4mm diameter at start
leaderHoleTaperRadius = 6.35;  // 12.7mm diameter at end of pocket (0.5")

// Grooves (dual hydrodynamic) - ENGRAVED
groove1Pos = 18;
groove1Height = 4;         // Height span of groove 1
groove2Pos = 27;
groove2Height = 4;         // Height span of groove 2
grooveDepth = 2.5;         // Depth of engraved groove (recessed from surface)

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

    // Hydrodynamic grooves - ENGRAVED (cut from surface)
    groove_cut_v2(groove1Pos, groove1Height);
    groove_cut_v2(groove2Pos, groove2Height);

    // Eye sockets (both sides)
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Main Body: Blunt Tapered Cone with Extended Cylinder
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
    
    // Extended cylinder section: 20mm - maintains full radius (19.05mm) - NOW 20MM
    translate([0, 0, 50.8])
        cylinder(h = 20, r = bodyMaxRadius, $fn = 120);
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
// Hydrodynamic Groove Cutter V2
// Creates a visible engraved groove using a rounded rectangular profile
// Positioned at a specific Z location with defined height span
//----------------------------

module groove_cut_v2(zPos, grooveHeight)
{
    translate([0, 0, zPos])
        linear_extrude(height = grooveHeight, convexity = 10)
        {
            // 2D profile: create a groove cutter on the perimeter
            // This creates a wedge that will cut into the cylinder
            
            difference()
            {
                // Outer circle (larger than body)
                circle(r = bodyMaxRadius + 2, $fn = 100);
                
                // Inner circle (body surface, slightly smaller)
                circle(r = bodyMaxRadius - 0.1, $fn = 100);
                
                // Groove channel removal (rectangular notch)
                translate([bodyMaxRadius - grooveDepth/2, -1.5])
                    square([grooveDepth + 1, 3], center = false);
            }
        }
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
