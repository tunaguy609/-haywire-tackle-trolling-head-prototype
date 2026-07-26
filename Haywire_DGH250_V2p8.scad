//
// Haywire Tackle DGH-250 Rev B - Version 2.8 FIXED
// Smooth Elongated Bullet Fishing Lure with Skirt Pocket
// Fixed tapered ramp ribs geometry
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

// Tapered ramp ribs (circumferential)
ribCount = 2;
ribHeight = 1.0;           // Height of rib at base
ribTaperEnd = 0.2;         // Height at rear tip


//----------------------------
// Main Model Assembly
//----------------------------

union()
{
    difference()
    {
        union()
        {
            // Main bullet body
            bullet_body();
            
            // Skirt pocket (straight cylinder)
            skirt_pocket();
            
            // Tapered ramp ribs (added as separate geometry)
            for (i = [0:ribCount-1])
            {
                angle = i * 180 / ribCount;  // 2 ribs at 0° and 180°
                rotate([0, 0, angle])
                    tapered_ramp_rib();
            }
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
}


//----------------------------
// Bullet Body: Smooth Profile
// Blunt front, widest (38.1mm dia) at rear
//----------------------------

module bullet_body()
{
    rotate_extrude(convexity = 20)
        polygon(points=[
            // Front (nose/tip) - BLUNT
            [3.0, 0],       // Start at 3mm radius for blunt tip
            [4.5, 2],       
            [6.0, 4],       
            [7.5, 6],
            [9.0, 8],
            [10.5, 10],
            [12.0, 12],
            [13.3, 14],
            [14.6, 16],
            [15.7, 18],
            [16.6, 20],
            [17.3, 22],
            [17.8, 24],
            [18.1, 26],
            [18.3, 28],
            [18.4, 30],
            [18.5, 33],
            [18.7, 36],
            [18.85, 40],
            [18.95, 48],
            [19.05, 50.8],  // Full diameter (38.1mm) at rear of body
            [0, 50.8]       // Return to axis
        ]);
}


//----------------------------
// Skirt Pocket: Straight Cylinder
// Attached to rear of body, 1" diameter, 0.5" deep
//----------------------------

module skirt_pocket()
{
    translate([0, 0, bodyLength])
        cylinder(
            h = skirtPocketDepth,
            d = skirtPocketDia,
            $fn = 120
        );
}


//----------------------------
// Tapered Ramp Rib (Circumferential)
// Runs around the skirt pocket, tapers toward rear
//----------------------------

module tapered_ramp_rib()
{
    translate([0, 0, bodyLength])
        rotate_extrude(convexity = 10, $fn = 120)
        {
            // Rib profile: trapezoid that tapers from base to tip
            polygon(points=[
                // Inner wall (at pocket center)
                [skirtPocketRadius, 0],
                [skirtPocketRadius, skirtPocketDepth],
                
                // Outer wall (tapers from high at front to low at rear)
                [skirtPocketRadius + 1.5, skirtPocketDepth - 1.0],  // Rear outer edge (tapered down)
                [skirtPocketRadius + 1.5, 0.3],                     // Front outer edge (full height)
                
                // Close the shape
                [skirtPocketRadius, 0]
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
