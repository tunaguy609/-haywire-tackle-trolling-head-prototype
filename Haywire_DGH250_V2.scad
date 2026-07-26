//
// Haywire Tackle DGH-250 Rev B - Version 2.0
// Parametric Trolling Head with Improved Spigot
//

$fn = 200;

//----------------------------
// Dimensions (mm)
//----------------------------

// Overall
L = 63.5;                    // Overall length (2.5")
D = 38.1;                    // Maximum diameter (1.5")
R = D/2;                     // Radius

leaderHole = 2.0;            // Leader hole diameter

// Rear skirt cavity
rearPocketDia = 25.4;        // Pocket ID (1.0")
rearPocketDepth = 25.4;      // Pocket depth (1.0")
rearPocketRadius = 1.587;    // 1/16" radius at entrance

// Improved skirt spigot
spigotOD = 22.225;           // 0.875" base OD
spigotLength = 12.7;         // 0.5" length
spigotTaper = 2.0;           // 2° taper toward rear

// Retention collar
collarOD = 24.892;           // 0.980" OD
collarThickness = 2.032;     // 0.080" thickness
collarHeight = 1.524;        // 0.060" height

// Retention ribs
ribHeight = 0.508;           // 0.020" high
ribCount = 3;                // Three ribs evenly spaced

// Grooves
groove1Pos = 18;
groove2Pos = 27;
grooveWidth = 2.2;
grooveDepth = 1.4;

// Eye sockets
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
// Bullet Body with Smooth Ogive Profile
//----------------------------

module body()
{
    rotate_extrude(convexity = 20)
        smooth_body_profile();
}


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
// Improved Spigot with Tapered Design
//----------------------------

module spigot()
{
    union()
    {
        //------------------------------------
        // Main tapered spigot (2° taper)
        //------------------------------------

        cylinder(
            h = spigotLength,
            d1 = spigotOD,
            d2 = spigotOD - (spigotLength * tan(spigotTaper))
        );

        //------------------------------------
        // Retaining collar with rounded edge
        //------------------------------------

        translate([0,0,collarThickness])
            union()
            {
                // Main collar cylinder
                cylinder(
                    h = collarHeight,
                    d = collarOD
                );

                // Rounded front edge
                translate([0,0,-0.3])
                    cylinder(
                        h = 0.3,
                        d1 = collarOD + 0.4,
                        d2 = collarOD
                    );
            }

        //------------------------------------
        // Three Retention Ribs (evenly spaced)
        //------------------------------------

        for (i = [0:ribCount-1])
        {
            angle = i * 360 / ribCount;

            rotate([0,0,angle])
                translate([spigotOD/2 - 0.2, 0, 3.0])
                    retention_rib();
        }
    }
}


//------------------------------------
// Retention Rib Module
//------------------------------------

module retention_rib()
{
    // Rounded profile rib
    hull()
    {
        // Back end of rib
        translate([0,0,0])
            sphere(r=0.254);

        // Front end of rib
        translate([0,0,2.0])
            sphere(r=0.254);
    }
}


//----------------------------
// Hydrodynamic Groove Modules
//----------------------------

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


//----------------------------
// Eye Sockets (Angled Recessed)
//----------------------------

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


//----------------------------
// Rear Pocket Features
//----------------------------

module rear_chamfer()
{
    // 1/16" radius entrance
    translate([0,0,L-rearPocketDepth])
        difference()
        {
            cylinder(
                h=rearPocketRadius*2,
                d1=rearPocketDia+rearPocketRadius*2,
                d2=rearPocketDia
            );

            translate([0,0,-0.5])
                cylinder(
                    h=rearPocketRadius*2+1,
                    d=rearPocketDia
                );
        }
}


module rear_relief()
{
    // Slight taper inside pocket for easier skirt removal
    translate([0,0,L-rearPocketDepth+rearPocketRadius*2])
        cylinder(
            h=rearPocketDepth-rearPocketRadius*2,
            d1=rearPocketDia,
            d2=rearPocketDia-1.2,
            $fn=150
        );
}


//----------------------------
// Render Quality Settings
//----------------------------

$fa = 1.5;   // Minimum angle (degrees)
$fs = 0.2;   // Minimum size (mm)

// Uncomment for cutaway view during inspection:
// %translate([0,-30,0])
// cube([60,60,80]);
