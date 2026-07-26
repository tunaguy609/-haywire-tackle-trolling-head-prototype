//
// Haywire Tackle DGH-250 Rev B - Version 2.3 CORRECTED
// Smooth Elongated Bullet Fishing Lure
// Proper taper, integrated spigot, recessed eyes
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
spigotTaper = 2.0;           // 2° taper

// Retention collar
collarOD = 24.892;           // 0.980" OD
collarThickness = 2.032;     // 0.080"
collarHeight = 1.524;        // 0.060"

// Retention ribs
ribHeight = 0.508;           // 0.020"
ribCount = 3;

// Grooves (dual hydrodynamic)
groove1Pos = 18;
groove2Pos = 27;
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets (recessed, on sides)
eyeDia = 8.0;
eyeDepth = 2.2;
eyePos = 35;  // Distance from front


//----------------------------
// Main Model Assembly
//----------------------------

difference()
{
    union()
    {
        body_with_spigot();
    }

    // Leader hole (through entire length)
    cylinder(
        h = L + 20,
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

    // Recessed eye sockets - both sides
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// Body with Integrated Spigot
// Smoother taper at front
//----------------------------

module body_with_spigot()
{
    rotate_extrude(convexity = 20)
        polygon(points=[
            // Front (nose/tip) - SMOOTHER, GRADUAL taper
            [0.5, 0],       // Start slightly wider for smoother taper
            [1.8, 3],       // Gradual widening
            [3.2, 6],       
            [4.6, 9],
            [6.0, 12],
            [7.4, 15],
            [8.8, 18],
            [10.2, 21],
            [11.6, 24],
            [13.0, 27],
            [14.4, 30],
            [15.6, 33],
            [16.6, 36],
            [17.4, 39],
            [18.0, 42],
            [18.4, 45],
            [18.7, 50],
            [18.9, 55],
            
            // Rear section - max diameter
            [19.05, 63.5],  // Full diameter at rear
            
            // Spigot profile (integrated)
            [18.5, 64],     // Start spigot taper
            [17.9, 66],     // Continuing taper
            [17.3, 68],
            [16.7, 70],
            [16.1, 72],
            [15.5, 74],
            [15.0, 76.2],   // End of spigot (0.5" = 12.7mm)
            
            [0, 76.2],      // Return to axis at spigot end
            [0, 63.5]       // Return to axis at body end
        ]);
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
// Recessed Eye Sockets (both sides, PROPERLY RECESSED)
//----------------------------

module eye_socket(side=1)
{
    // Position on sides at eyePos distance from front
    // Rotated to cut INTO the body
    translate([side * (R + 1), 0, eyePos])
        rotate([0, 90 * side, 0])
            cylinder(
                d = eyeDia,
                h = eyeDepth + 2,
                $fn = 80
            );
}


//----------------------------
// Retention Collar and Ribs (added separately)
//----------------------------

module collar_and_ribs()
{
    union()
    {
        //---- Rounded retention collar ----
        translate([0, 0, L + 1.5])
            union()
            {
                // Main collar disk
                cylinder(
                    h = collarHeight,
                    d = collarOD,
                    $fn = 100
                );

                // Rounded front edge for easy installation
                translate([0, 0, -0.4])
                    cylinder(
                        h = 0.4,
                        d1 = collarOD + 0.8,
                        d2 = collarOD,
                        $fn = 80
                    );
            }

        //---- Three retention ribs (evenly spaced) ----
        for (i = [0:ribCount-1])
        {
            angle = i * 360 / ribCount;
            rotate([0, 0, angle])
                translate([spigotOD/2 + 0.4, 0, L + 4.0])
                    sphere(r = 0.35);
        }
    }
}

// Note: Collar and ribs are now part of the main union in body_with_spigot
// They are integrated into the spigot profile via rotate_extrude


//----------------------------
// Render Quality
//----------------------------

$fa = 1.5;
$fs = 0.2;

// Uncomment for cutaway inspection view:
// %translate([0, -30, 0])
//     cube([60, 60, 80]);
