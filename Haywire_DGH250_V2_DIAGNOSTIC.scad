//
// Haywire Tackle DGH-250 Rev B - Version 2.0 DIAGNOSTIC
// Testing individual features
//

$fn = 200;

//----------------------------
// Dimensions (mm)
//----------------------------

L = 63.5;
D = 38.1;
R = D/2;

leaderHole = 2.0;
rearPocketDia = 25.4;
rearPocketDepth = 25.4;
rearPocketRadius = 1.587;

spigotOD = 22.225;
spigotLength = 12.7;
spigotTaper = 2.0;

collarOD = 24.892;
collarThickness = 2.032;
collarHeight = 1.524;

ribHeight = 0.508;
ribCount = 3;

groove1Pos = 18;
groove2Pos = 27;
grooveWidth = 2.2;
grooveDepth = 1.4;

eyeDia = 8.0;
eyeDepth = 2.2;


//----------------------------
// DIAGNOSTIC: Show just the solid parts first
//----------------------------

// Uncomment ONE section below to test:

// TEST 1: Just the body
body();

// TEST 2: Just the spigot
// translate([0,0,L-spigotLength])
//     spigot();

// TEST 3: Body + Spigot (no cuts)
// union()
// {
//     body();
//     translate([0,0,L-spigotLength])
//         spigot();
// }


//----------------------------
// Bullet Body
//----------------------------

module body()
{
    rotate_extrude(convexity = 20)
        polygon(points=[
            [0,0],
            [0,3],
            [0.8,6],
            [1.6,9],
            [2.8,12],
            [4.3,15],
            [6.0,18],
            [8.3,22],
            [10.7,26],
            [13.2,31],
            [15.7,36],
            [17.8,41],
            [18.7,46],
            [19.05,52],
            [19.05,L],
            [0,L]
        ]);
}


//----------------------------
// Improved Spigot
//----------------------------

module spigot()
{
    union()
    {
        // Main tapered spigot
        cylinder(
            h = spigotLength,
            d1 = spigotOD,
            d2 = spigotOD - (spigotLength * tan(spigotTaper))
        );

        // Retaining collar
        translate([0,0,collarThickness])
            cylinder(
                h = collarHeight,
                d = collarOD
            );

        // Three retention ribs
        for (i = [0:ribCount-1])
        {
            angle = i * 360 / ribCount;
            rotate([0,0,angle])
                translate([spigotOD/2 + 0.5, 0, 4.0])
                    cube([0.5, 1.0, 1.0], center=true);
        }
    }
}

$fa = 1.5;
$fs = 0.2;
