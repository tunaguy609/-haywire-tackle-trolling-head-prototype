//
// Haywire Tackle DGH-250 Rev B - Version 2.19 EXTENDED CYLINDER
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: Extended widest diameter section by additional 10mm (total 20mm at max dia)
// Enhanced: Visible engraved hydrodynamic grooves on body
// Modified: 50% reduction in maximum diameter (38.1mm → 19.05mm, all dimensions scaled proportionally)
// Added: 2 evenly-spaced circumferential body grooves (2mm depth, 2mm width, sharp angular cut)
//

$fn = 150;

//----------------------------
// Dimensions (mm)
// All dimensions scaled by 50% for smaller profile
//----------------------------

// Bullet body
bodyLength = 35.4;         // Scaled from 70.8 (50% reduction)
bodyMaxDia = 19.05;        // Scaled from 38.1 (50% reduction, 0.75")
bodyMaxRadius = bodyMaxDia / 2;  // 9.525mm
bodyTipRadius = 1.5;       // Scaled from 3.0

// Skirt pocket (attached to rear)
skirtPocketDia = 9.525;    // Scaled from 19.05 (50% reduction, 0.375")
skirtPocketRadius = skirtPocketDia / 2;  // 4.7625mm
skirtPocketDepth = 6.35;   // Scaled from 12.7 (50% reduction, 0.25")

// Tapered transition
transitionLength = 1.5;    // Scaled from 3.0

// Leader hole - tapered
leaderHoleRadius = 1.0;    // Scaled from 2.0 (2mm diameter at start)
leaderHoleTaperRadius = 3.175;  // Scaled from 6.35 (6.35mm diameter at end of pocket)

// Grooves (dual hydrodynamic) - ENGRAVED
groove1Pos = 9;            // Scaled from 18
groove1Height = 2;         // Scaled from 4
groove2Pos = 13.5;         // Scaled from 27
groove2Height = 2;         // Scaled from 4
grooveDepth = 1.25;        // Scaled from 2.5

// Body circumferential grooves - ENGRAVED (new)
bodyGroove1Pos = 11.8;     // First groove - evenly spaced at ~1/3 of body length
bodyGroove2Pos = 23.6;     // Second groove - evenly spaced at ~2/3 of body length
bodyGrooveWidth = 2;       // Width of each groove band
bodyGrooveDepth = 2;       // Depth of groove (recessed from surface)

// Eye sockets (recessed, on sides)
eyeDia = 3.0;              // Scaled from 6.0
eyeDepth = 1.0;            // Scaled from 2.0
eyePos = 17.5;             // Scaled from 35


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

    // Body circumferential grooves - ENGRAVED (NEW)
    body_groove_circumferential(bodyGroove1Pos, bodyGrooveWidth);
    body_groove_circumferential(bodyGroove2Pos, bodyGrooveWidth);

    // Eye sockets (both sides)
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Main Body: Blunt Tapered Cone with Extended Cylinder
//----------------------------

module body_main()
{
    // Tip section: 5mm - tapers from 1.5mm to 4mm radius
    translate([0, 0, 0])
        cylinder(h = 5, r1 = bodyTipRadius, r2 = 4, $fn = 120);
    
    // Middle section: 10mm - tapers from 4mm to 7.5mm radius
    translate([0, 0, 5])
        cylinder(h = 10, r1 = 4, r2 = 7.5, $fn = 120);
    
    // Rear section: 10.4mm - tapers from 7.5mm to full radius (9.525mm)
    translate([0, 0, 15])
        cylinder(h = 10.4, r1 = 7.5, r2 = bodyMaxRadius, $fn = 120);
    
    // Extended cylinder section: 10mm - maintains full radius (9.525mm)
    translate([0, 0, 25.4])
        cylinder(h = 10, r = bodyMaxRadius, $fn = 120);
}


//----------------------------
// Tapered Transition
// Smooth taper from main body (9.525mm) to skirt pocket (4.7625mm)
// Over 1.5mm length
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
    rib_band(0, 2.5);  // Scaled from 5mm

    // Rib 2: Rear band of the pocket (tapers more steeply)
    rib_band(3, 3.35);  // Scaled from 6 and 6.7mm
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
                [skirtPocketRadius + 0.6, zHeight * 0.4],  // Rear outer (tapered) - scaled from 1.2
                [skirtPocketRadius + 0.75, 0],              // Front outer (full height) - scaled from 1.5
                
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
                circle(r = bodyMaxRadius + 1, $fn = 100);  // Scaled from +2
                
                // Inner circle (body surface, slightly smaller)
                circle(r = bodyMaxRadius - 0.1, $fn = 100);
                
                // Groove channel removal (rectangular notch)
                translate([bodyMaxRadius - grooveDepth/2, -0.75])  // Scaled from -1.5
                    square([grooveDepth + 0.5, 1.5], center = false);  // Scaled from +1 and 3
            }
        }
}


//----------------------------
// Body Circumferential Groove - Sharp Angular Cut
// Creates an engraved circumferential groove around the body
// 2mm depth, 2mm width, sharp angular profile
//----------------------------

module body_groove_circumferential(zPos, grooveWidth)
{
    translate([0, 0, zPos])
        linear_extrude(height = grooveWidth, convexity = 10)
        {
            // 2D profile: sharp angular V-groove cutting into the cylinder surface
            difference()
            {
                // Outer circle (larger than body)
                circle(r = bodyMaxRadius + 1, $fn = 100);
                
                // Inner circle (body surface)
                circle(r = bodyMaxRadius, $fn = 100);
                
                // Sharp V-groove channel removal (angular notch)
                // Creates a sharp wedge cut into the surface
                translate([bodyMaxRadius - bodyGrooveDepth/2, -1])
                    square([bodyGrooveDepth + 1, 2], center = false);
            }
        }
}


//----------------------------
// Recessed Eye Socket
//----------------------------

module eye_socket(side)
{
    translate([side * (bodyMaxRadius + 0.5), 0, eyePos])  // Scaled from +1
        rotate([0, 90 * side, 0])
            cylinder(d = eyeDia, h = eyeDepth + 1, $fn = 80);
}


//----------------------------
// Render Quality Settings
//----------------------------

$fa = 1.5;
$fs = 0.2;
