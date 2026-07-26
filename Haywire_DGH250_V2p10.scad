//
// Haywire Tackle DGH-250 Rev B - Version 2.10 BODY FIX
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Corrected body profile extending full length
//

$fn = 200;

//----------------------------
// Dimensions (mm)
//----------------------------

// Bullet body
bodyLength = 50.8;         // 2.0"
bodyMaxDia = 38.1;         // 1.5" (at rear)
bodyMaxRadius = bodyMaxDia / 2;  // 19.05mm

// Skirt pocket (attached to rear)
skirtPocketDia = 25.4;     // 1.0"
skirtPocketRadius = skirtPocketDia / 2;  // 12.7mm
skirtPocketDepth = 12.7;   // 0.5"

// Leader hole
leaderHole = 2.0;

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
        // Main bullet body
        bullet_body();
        
        // Skirt pocket with ribs (integrated)
        skirt_pocket_with_ribs();
    }

    // Leader hole (through entire length)
    cylinder(
        h = bodyLength + skirtPocketDepth + 5,
        d = leaderHole,
        center = false
    );

    // Hydrodynamic grooves - BOTH
    groove_cut(groove1Pos);
    groove_cut(groove2Pos);

    // Recessed eye sockets - both sides
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Bullet Body: Smooth Profile
// Blunt front, widest (38.1mm dia) at rear
// CORRECTED: Full length 50.8mm with smooth taper
//----------------------------

module bullet_body()
{
    rotate_extrude(convexity = 20)
        polygon(points=[
            // Front (nose/tip) - BLUNT
            [3.0, 0],
            [3.5, 1],
            [4.5, 2],
            [5.5, 3],
            [6.5, 4],
            [7.5, 5],
            [8.5, 7],
            [9.5, 9],
            [10.5, 11],
            [11.5, 13],
            [12.5, 15],
            [13.5, 17],
            [14.5, 19],
            [15.3, 21],
            [16.0, 23],
            [16.6, 25],
            [17.1, 27],
            [17.5, 29],
            [17.8, 31],
            [18.0, 33],
            [18.1, 35],
            [18.2, 37],
            [18.3, 39],
            [18.35, 41],
            [18.4, 43],
            [18.45, 45],
            [18.5, 47],
            [18.75, 48],
            [18.95, 49.4],
            [19.05, 50.8],  // Full diameter (38.1mm) at rear - Z position 50.8mm
            [0, 50.8]       // Return to axis
        ]);
}


//----------------------------
// Skirt Pocket with Tapered Ramp Ribs
// Straight cylinder with two ribs that taper toward rear
//----------------------------

module skirt_pocket_with_ribs()
{
    translate([0, 0, bodyLength])
    {
        // Main pocket cylinder
        cylinder(
            h = skirtPocketDepth,
            d = skirtPocketDia,
            $fn = 120
        );
        
        // Two tapered ramp ribs
        for (i = [0:1])
        {
            angle = i * 180;  // 0° and 180°
            rotate([0, 0, angle])
                rib_wedge();
        }
    }
}


//----------------------------
// Rib Wedge: Tapered ramp shape
// Rises from pocket floor, tapers toward rear
//----------------------------

module rib_wedge()
{
    translate([0, 0, 0])
        rotate_extrude(angle = 8, convexity = 5, $fn = 60)
        {
            // Wedge profile in cross-section
            polygon(points=[
                // Base of rib (at pocket floor)
                [skirtPocketRadius - 0.5, 0],
                [skirtPocketRadius + 1.2, 0],
                
                // Rib tapers up and back
                [skirtPocketRadius + 1.2, 2],         // Front edge, full height
                [skirtPocketRadius + 0.6, skirtPocketDepth - 1.5],  // Rear edge, tapered down
                [skirtPocketRadius - 0.5, skirtPocketDepth],  // Back at inner edge
                
                // Close polygon
                [skirtPocketRadius - 0.5, 0]
            ]);
        }
}


//----------------------------
// Hydrodynamic Groove Cutter
//----------------------------

module groove_profile(depth=1.4, width=2.2)
{
    // Rounded groove profile
    hull()
    {
        translate([0, 0]) circle(r=0.3);
        translate([depth, 0]) circle(r=0.3);
        translate([depth, width]) circle(r=0.3);
        translate([0, width]) circle(r=0.3);
    }
}

module groove_cut(zPos)
{
    translate([0, 0, zPos])
        rotate_extrude(convexity=10)
            translate([bodyMaxRadius - grooveDepth, 0])
                groove_profile(grooveDepth, grooveWidth);
}


//----------------------------
// Recessed Eye Sockets (both sides)
//----------------------------

module eye_socket(side=1)
{
    // Positioned on the side surface of the body
    // Cut from the outside in, so eyes are recessed into the lure
    translate([side * (bodyMaxRadius + 0.5), 0, eyePos])
        rotate([0, 90 * side, 0])
            cylinder(
                d = eyeDia,
                h = eyeDepth + 1,
                $fn = 80
            );
}


//----------------------------
// Render Quality
//----------------------------

$fa = 1.5;
$fs = 0.2;
