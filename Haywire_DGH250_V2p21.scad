//
// Haywire Tackle DGH-250 Rev B - Version 2.19 EXTENDED CYLINDER
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Updated: Extended widest diameter section by additional 10mm (total 20mm at max dia)
// Enhanced: Visible engraved hydrodynamic grooves on body
// Modified: 50% reduction in maximum diameter (38.1mm → 19.05mm, all dimensions scaled proportionally)
// Added: 2 evenly-spaced circumferential body grooves (2mm depth, 2mm width, sharp angular cut)
// Fixed: Eye sockets now flat-bottomed recessed pockets (2mm depth, 3mm diameter, opposite sides)
// Updated: Skirt pocket length increased to 15mm with proportionally scaled ribs
// Added: Flat sides on main body (4mm width, 1mm depth, full length, opposite sides at eye socket axis)
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
skirtPocketDepth = 15;     // Increased from 6.35mm to 15mm

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

// Body circumferential grooves - ENGRAVED
bodyGroove1Pos = 11.8;     // First groove - evenly spaced at ~1/3 of body length
bodyGroove2Pos = 23.6;     // Second groove - evenly spaced at ~2/3 of body length
bodyGrooveWidth = 2;       // Width of each groove band
bodyGrooveDepth = 2;       // Depth of groove (recessed from surface)

// Eye sockets (recessed, flat-bottomed, on sides)
eyeDia = 3.0;              // Diameter of eye pocket
eyeRadius = eyeDia / 2;    // 1.5mm radius
eyeDepth = 2.0;            // Depth of flat-bottomed pocket
eyePos = 17.5;             // Position along body from tip

// Flat sides on body (opposite sides at eye socket axis)
flatWidth = 4.0;           // Width of each flat
flatDepth = 1.0;           // Depth of flat recess


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

    // Body circumferential grooves - ENGRAVED
    body_groove_circumferential(bodyGroove1Pos, bodyGrooveWidth);
    body_groove_circumferential(bodyGroove2Pos, bodyGrooveWidth);

    // Eye sockets - flat-bottomed recessed pockets (both sides)
    eye_socket_flat(1);
    eye_socket_flat(-1);

    // Flat sides on body (opposite sides at eye socket axis)
    body_flat_side(1);
    body_flat_side(-1);
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
// Proportionally scaled to the longer skirt pocket (15mm total)
//----------------------------

module ribs_circumferential()
{
    // Rib 1: Front band of the pocket (proportionally scaled)
    // Original: 5mm, now scaled proportionally to 15mm pocket
    rib_band(0, 6.5);  // Scaled proportionally from 2.5mm

    // Rib 2: Rear band of the pocket (proportionally scaled)
    // Original: 6.7mm, now scaled proportionally to 15mm pocket
    rib_band(7, 7.1);  // Scaled proportionally from 3.35mm
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
                [skirtPocketRadius + 0.6, zHeight * 0.4],  // Rear outer (tapered)
                [skirtPocketRadius + 0.75, 0],              // Front outer (full height)
                
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
// Recessed Eye Socket - Flat Bottomed
// Creates a flat-bottomed circular pocket recessed into the body surface
// Positioned on opposite sides of the body
//----------------------------

module eye_socket_flat(side)
{
    // Position the eye pocket on the side of the body at eyePos along the Z-axis
    translate([side * bodyMaxRadius, 0, eyePos])
        rotate([0, 90 * side, 0])
            // Flat-bottomed cylinder pocket
            cylinder(h = eyeDepth, r = eyeRadius, $fn = 80);
}


//----------------------------
// Flat Side on Body
// Creates a flat recessed surface along the entire body length
// Positioned on opposite sides at the eye socket axis
//----------------------------

module body_flat_side(side)
{
    // Create a rectangular flat by extruding along the body length
    translate([side * (bodyMaxRadius - flatDepth/2), -flatWidth/2, 0])
        cube([flatDepth, flatWidth, bodyLength]);
}


//----------------------------
// Render Quality Settings
//----------------------------

$fa = 1.5;
$fs = 0.2;
