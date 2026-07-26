//
// Haywire Tackle DGH-250 Rev B - Version 2.6 DIAGNOSTIC
// Smooth Elongated Bullet Fishing Lure
// Fixed eye socket sizing - eyes should not cut away body
//

$fn = 200;

//----------------------------
// Dimensions (mm)
//----------------------------

L = 63.5;              // Overall length (2.5")
D = 38.1;              // Maximum diameter at rear (1.5")
R = D/2;               // Radius = 19.05mm

leaderHole = 2.0;

// Rear skirt cavity
rearPocketDia = 25.4;        // 1.0" ID
rearPocketDepth = 25.4;      // 1.0" deep
rearPocketRadius = 1.587;    // 1/16" radius entrance

// Tapered skirt spigot
spigotOD = 22.225;           // 0.875" OD
spigotLength = 12.7;         // 0.5" length
spigotTaper = 1.5;           // 1.5° taper (GENTLE)

// Retention collar
collarOD = 24.892;           // 0.980" OD
collarThickness = 2.032;     // 0.080"
collarHeight = 1.524;        // 0.060"

// Retention ribs
ribRadius = 0.4;
ribCount = 3;

// Grooves (dual hydrodynamic)
groove1Pos = 18;
groove2Pos = 27;
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides) - SMALLER, won't cut body away
eyeDia = 6.0;        // REDUCED from 8.0
eyeDepth = 2.0;      // REDUCED from 3.0
eyePos = 35;         // Distance from front


//----------------------------
// Main Model Assembly
//----------------------------

union()
{
    // Main bullet body with spigot
    difference()
    {
        union()
        {
            // Main bullet body
            body();
            
            // Spigot with collar and ribs (INTEGRATED)
            spigot_assembly();
        }

        // Leader hole (through entire length and spigot)
        cylinder(
            h = L + spigotLength + 5,
            d = leaderHole,
            center = false
        );

        // Rear skirt cavity with entrance radius
        union()
        {
            // Main pocket
            translate([0, 0, L - rearPocketDepth])
                cylinder(
                    h = rearPocketDepth + 5,
                    d = rearPocketDia,
                    $fn = 150
                );

            // Entrance chamfer (1/16" radius)
            translate([0, 0, L - rearPocketDepth])
                difference()
                {
                    cylinder(
                        h = rearPocketRadius * 2,
                        d1 = rearPocketDia + rearPocketRadius * 3,
                        d2 = rearPocketDia
                    );
                    translate([0, 0, -1])
                        cylinder(
                            h = rearPocketRadius * 3,
                            d = rearPocketDia
                        );
                }

            // Interior taper for easier removal
            translate([0, 0, L - rearPocketDepth + rearPocketRadius * 2])
                cylinder(
                    h = rearPocketDepth - rearPocketRadius * 2,
                    d1 = rearPocketDia,
                    d2 = rearPocketDia - 1.2,
                    $fn = 150
                );
        }

        // Hydrodynamic grooves - BOTH
        groove_cut(groove1Pos);
        groove_cut(groove2Pos);

        // Recessed eye sockets - both sides (PROPERLY SIZED - WON'T CUT BODY)
        eye_socket(1);
        eye_socket(-1);
    }
}


//----------------------------
// Body: Smooth Bullet Profile
// Blunt front, widest at rear
//----------------------------

module body()
{
    rotate_extrude(convexity = 20)
        polygon(points=[
            // Front (nose/tip) - BLUNT
            [3.0, 0],       // Start at 3mm radius for blunt bullet tip
            [4.5, 2],       // Round, gradual widening
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
            [18.95, 50],
            [19.05, 63.5],  // Full diameter at rear
            [0, 63.5]       // Return to axis
        ]);
}


//----------------------------
// Spigot Assembly (Attached to rear, NOT floating)
//----------------------------

module spigot_assembly()
{
    translate([0, 0, L])
        union()
        {
            //---- Main tapered spigot cylinder ----
            cylinder(
                h = spigotLength,
                d1 = spigotOD,
                d2 = spigotOD - (spigotLength * tan(spigotTaper)),
                $fn = 100
            );

            //---- Retention collar (attached to spigot base) ----
            translate([0, 0, collarThickness])
                cylinder(
                    h = collarHeight,
                    d = collarOD,
                    $fn = 100
                );

            //---- Rounded front edge of collar ----
            translate([0, 0, collarThickness - 0.4])
                cylinder(
                    h = 0.4,
                    d1 = collarOD + 0.6,
                    d2 = collarOD,
                    $fn = 80
                );

            //---- Three retention ribs (on collar) ----
            for (i = [0:ribCount-1])
            {
                angle = i * 360 / ribCount;
                rotate([0, 0, angle])
                    translate([spigotOD/2 + 0.6, 0, 1.5])
                        sphere(r = ribRadius);
            }
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
            translate([R - grooveDepth, 0])
                groove_profile(grooveDepth, grooveWidth);
}


//----------------------------
// Recessed Eye Sockets (both sides, SMALLER - won't remove body)
//----------------------------

module eye_socket(side=1)
{
    // Positioned on the side surface of the body
    // Cut from the outside in, so eyes are recessed into the lure
    // SMALLER diameter and depth so they don't cut away the entire body
    translate([side * (R + 0.5), 0, eyePos])
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

// Uncomment for cutaway inspection view:
// %translate([0, -30, 0])
//     cube([60, 60, 80]);
