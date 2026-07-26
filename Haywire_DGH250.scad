//
// Haywire Tackle DGH-250 Rev A
// Parametric Trolling Head
// Complete Model - All Parts Combined
//

$fn = 200;

//----------------------------
// Dimensions (mm)
//----------------------------

L = 63.5;            // Overall length (2.5")
D = 38.1;            // Maximum diameter (1.5")
R = D/2;

leaderHole = 2.0;

rearPocketDia = 25.4;
rearPocketDepth = 25.4;

spigotDia = 22.2;
spigotLength = 12.7;

collarDia = 24.9;
collarHeight = 1.6;

groove1Pos = 18;
groove2Pos = 27;

grooveWidth = 2.2;
grooveDepth = 1.4;

eyeDia = 8.0;
eyeDepth = 2.2;


//----------------------------
// Main Model
//----------------------------

difference()
{
    union()
    {
        body();

        translate([0,0,L-spigotLength])
            spigot();
    }

    // Leader hole
    cylinder(
        h=L+5,
        d=leaderHole,
        center=false
    );

    // Rear skirt cavity with chamfer and relief
    union()
    {
        cylinder(
            h=rearPocketDepth,
            d=rearPocketDia,
            $fn=150);

        rear_chamfer();

        rear_relief();
    }

    // Hydrodynamic Grooves
    groove_cut(groove1Pos);
    groove_cut(groove2Pos);

    // Eye sockets (angled)
    eye_socket(1);
    eye_socket(-1);
}


//----------------------------
// PART 1: Bullet Body
//----------------------------

module body()
{
    rotate_extrude(convexity = 20)
        smooth_body_profile();
}


//----------------------------
// PART 2: Tapered Spigot, Retention Ribs & Collar
//----------------------------

module spigot()
{

    union()
    {

        //------------------------------------
        // Main tapered spigot
        //------------------------------------

        cylinder(
            h = spigotLength,
            d1 = spigotDia,
            d2 = spigotDia - 1.2
        );

        //------------------------------------
        // Retaining collar
        //------------------------------------

        translate([0,0,1.5])

            cylinder(
                h = collarHeight,
                d = collarDia
            );

        //------------------------------------
        // Retention Rib #1
        //------------------------------------

        translate([0,0,4.0])

        difference()
        {

            cylinder(
                h=1.1,
                d=spigotDia+1.0
            );

            translate([0,0,-0.2])

            cylinder(
                h=1.5,
                d=spigotDia-0.4
            );

        }

        //------------------------------------
        // Retention Rib #2
        //------------------------------------

        translate([0,0,7.0])

        difference()
        {

            cylinder(
                h=1.1,
                d=spigotDia+1.0
            );

            translate([0,0,-0.2])

            cylinder(
                h=1.5,
                d=spigotDia-0.4
            );

        }

        //------------------------------------
        // Retention Rib #3
        //------------------------------------

        translate([0,0,10.0])

        difference()
        {

            cylinder(
                h=1.1,
                d=spigotDia+1.0
            );

            translate([0,0,-0.2])

            cylinder(
                h=1.5,
                d=spigotDia-0.4
            );

        }

    }

}


//----------------------------
// PART 3: Hydrodynamic Groove Modules & Smooth Nose Profile
//----------------------------

// Rounded groove profile for rotate_extrude()
// Gives a stronger "smoke trail" than a square notch.

module groove_profile(depth=1.4, width=2.2)
{
    hull()
    {
        translate([0,0])
            circle(r=0.30);

        translate([depth,0])
            circle(r=0.30);

        translate([depth,width])
            circle(r=0.30);

        translate([0,width])
            circle(r=0.30);
    }
}


//------------------------------------
// Groove Cutter
//------------------------------------

module groove_cut(zPos)
{
    translate([0,0,zPos])

        rotate_extrude(convexity=10)

            translate([R-grooveDepth,0])

                groove_profile(
                    grooveDepth,
                    grooveWidth
                );
}


//------------------------------------
// Smooth Bullet Profile
//------------------------------------

module smooth_body_profile()
{

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
// PART 4: Eye Sockets & Rear Pocket Improvements
//----------------------------


//------------------------------------
// Angled Eye Socket
//------------------------------------

module eye_socket(side=1)
{

    translate([side*(R-1.3),0,31])

        rotate([0,side*82,0])

            cylinder(
                d=eyeDia,
                h=eyeDepth+1,
                $fn=80
            );

}


//------------------------------------
// Rear Pocket Entrance Radius
//------------------------------------

module rear_chamfer()
{

    translate([0,0,L-rearPocketDepth])

        difference()
        {

            cylinder(
                h=3.0,
                d1=rearPocketDia+4,
                d2=rearPocketDia
            );

            translate([0,0,-0.5])

                cylinder(
                    h=4,
                    d=rearPocketDia
                );

        }

}


//------------------------------------
// Internal Pocket Relief
//------------------------------------

module rear_relief()
{

    translate([0,0,L-rearPocketDepth+2])

        cylinder(
            h=rearPocketDepth,
            d1=rearPocketDia,
            d2=rearPocketDia-1.2,
            $fn=150
        );

}


//----------------------------
// Render Quality
//----------------------------

$fa = 2;
$fs = 0.25;

// Uncomment for a cutaway view during inspection:
// %translate([0,-30,0])
// cube([60,60,80]);
