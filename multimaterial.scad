$fn = 120;

/* parameters */
{
tollerance = 0.4;

filamentR = 1.3;
fittingR = 4.4;

M3 = 1.65;
M4 = 2.1;
/* e3d values */
    {
        e3d_headR1 = 8;
        e3d_headR2 = 6;
        e3d_headH1 = 3;
        e3d_headH2 = 5.3;
        e3d_headH3 = 3.7;
        e3d_fittingR = 4;
        e3d_fittingH = 6.5;
        e3d_heatR1 = 4.5;
        e3d_heatR2 = 7;
        e3d_heatH = 29;
        e3d_ribH = 1;
        e3d_ribSpace = 1.5;
        e3d_ribR = 11.15;
    }

}


// translate([0, 0, 10 - (e3d_headH1 + e3d_headH2 + e3d_headH3)]) Xcarriage();
//e3d();
filamentTower();

//translate([0,30, 10 - (e3d_headH1 + e3d_headH2 + e3d_headH3)]) e3dIddler();

/* Modules */

module filamentTower() {
    color([1,1,1])
        difference() {
            outerShape();
            tube();
            cutouts();
        }
}

module outerShape() {
    translate([0, 0, tollerance]) cylinder(r = 7.8, h = 10 - tollerance);
    translate([0, 0, 10]) cylinder(r1 = 7.8, r2 = 14.5, h = 28);
    translate([0, 0, 38]) cylinder(r1 = 14.5, r2 = 0, h = 2.5);
    translate([0, 0, -e3d_fittingH  + 3 * tollerance])
        cylinder(r = e3d_fittingR - tollerance, h = e3d_fittingH - 2 * tollerance);
    translate([0, 0, 9.5 - 2 * tollerance]) cube([36, 45, 3], center = true);
}

module tube() {
    translate([0, 0, -20]) cylinder(r = filamentR, h = 18);
    translate([0, 0, -2]) rotate([0, 11, 0])   inputFitting();
    translate([0, 0, -2]) rotate([0, 11, 90])  inputFitting();
    translate([0, 0, -2]) rotate([0, 11, 180]) inputFitting();
    translate([0, 0, -2]) rotate([0, 11, 270]) inputFitting();
}

module inputFitting() {
    cylinder(r = filamentR, h = 30);
    translate([0, 0, 5]) cylinder(r = filamentR, h = 34);
    translate([0, 0, 34]) cylinder(r = fittingR, h = 11);
}

module e3d() {
    translate([0, 0, -(e3d_headH1 + e3d_headH2 + e3d_headH3)])
    color([.6, .6, .6]) {
        difference() {
            union() {
                cylinder(r = e3d_headR1, h = e3d_headH1);
                translate([0,0,e3d_headH1]) cylinder(r = e3d_headR2, h = e3d_headH2);
                translate([0,0,e3d_headH1 + e3d_headH2]) cylinder(r = e3d_headR1, h = e3d_headH3);
            }
            translate([0,0,-1]) cylinder(r = filamentR, h = 2 + e3d_headH1 + e3d_headH2 + e3d_headH3);
            translate([0,0, e3d_headH1 + e3d_headH2 + e3d_headH3 - e3d_fittingH]) cylinder(r = e3d_fittingR, h = e3d_fittingH + 1);
        }
        
        translate([0, 0, -e3d_heatH])
            cylinder(r1 = e3d_heatR2, r2 = e3d_heatR1, h = e3d_heatH);

        translate([0, 0, -e3d_ribSpace - e3d_ribH])
            cylinder(r = e3d_headR1, h = e3d_ribH);
        
        for (i = [2 * e3d_ribSpace + 2 * e3d_ribH:e3d_ribSpace + e3d_ribH:e3d_heatH + e3d_ribH])
           translate([0, 0, -i])
                cylinder(r = e3d_ribR, h = e3d_ribH); 
    }
}

module Xcarriage() {
    // main body
    color([0, 1, 0]) difference() {
        union() {
            // main carriage body
            cube([48, 45, 20], center = true);
            rotate([90, 0, 0]) translate([24, 0, -22.5]) cylinder(r = 10, h = 45);
            rotate([90, 0, 0]) translate([-24, 0, -22.5]) cylinder(r = 10, h = 45);
        }
        // cutouts for LM8LUU
        rotate([90, 0, 0])
            translate([24, 0, -24])
                cylinder(r = 7.5, h = 48);
        rotate([90, 0, 0])
            translate([-24, 0, -24])
                cylinder(r = 7.5, h = 48);
        // cutout for e3d idler
        cube([28, 48, 20 - 2 * e3d_headH1], center = true);
        // cutout for e3d body
        cylinder(r = e3d_headR1 + tollerance, h = 22, center = true);
        // cutouts for e3d idler screws
        translate([14 - 2 * M3, 23 - 2 * M3,  0])
            cylinder(r = M3, h = 22, center = true);
        translate([14 - 2 * M3, -23 + 2 * M3,  0])
            cylinder(r = M3, h = 22, center = true);
        translate([-14 + 2 * M3, 23 - 2 * M3,  0])
            cylinder(r = M3, h = 22, center = true);
        translate([-14 + 2 * M3, -23 + 2 * M3,  0])
            cylinder(r = M3, h = 22, center = true);
        
        // cabling cutout
        translate([-14 + 3 * M3, -23 + 6 * M3,  0])
            cylinder(r = M4, h = 22, center = true);
        translate([14 - 3 * M3, -23 + 6 * M3,  0])
            cylinder(r = M4, h = 22, center = true);
        translate([0, -23 + 6 * M3, 0,]) 
            cube([28 - 6 * M3, 2 * M4, 22], center = true);
        translate([-14 + 3 * M3, 23 - 6 * M3,  0])
            cylinder(r = M4, h = 22, center = true);
        translate([14 - 3 * M3, 23 - 6 * M3,  0])
            cylinder(r = M4, h = 22, center = true);
        translate([0, 23 - 6 * M3, 0,]) 
            cube([28 - 6 * M3, 2 * M4, 22], center = true);
        
    }
    // LM8LUU
    /*{
        translate([24, 0, 0])
            rotate([90, 0, 0]) LM8LUU();
        translate([-24, 0, 0])
            rotate([90, 0, 0]) LM8LUU();
    }*/
    // e3d idler
    //e3dIddler();
    //rotate([0, 0, 180]) e3dIddler();
}
module e3dIddler() {
    // internal part
    color([0.3, 0.4, 1]) {
        difference() {
        translate([0, (23 + 2 * tollerance) / 2, 0]) 
            // inner part
            cube([28 - tollerance, 22.5, 20 - 2 * e3d_headH1 - tollerance],
                center = true);
            // cutout for e3d
            translate([0, tollerance, -(20 - 2 * e3d_headH1 - 2 * tollerance) / 2 - tollerance]) {
                cylinder(r = e3d_headR2, h = e3d_headH2 + 2 * tollerance);
                translate([0, 0, e3d_headH2])
                    cylinder(r = e3d_headR1, h = 20);
            }
            // cutout for cabling
            translate([-14 + 3 * M3, 23 - 6 * M3,  0])
                cylinder(r = M4, h = 22, center = true);
            translate([14 - 3 * M3, 23 - 6 * M3,  0])
                cylinder(r = M4, h = 22, center = true);
            translate([0, 23 - 6 * M3, 0,]) 
                cube([28 - 6 * M3, 2 * M4, 22], center = true);
            // cutout for idler screws
            translate([14 - 2 * M3, 23 - 2 * M3,  0]) {
                cylinder(r = M3, h = 22, center = true);
                translate([0, 0, -5.5]) cylinder(r = 2 * M3, h = M3 + 2 * tollerance, center = true, $fn = 6);
            }
            translate([-14 + 2 * M3, 23 - 2 * M3,  0]) {
                cylinder(r = M3, h = 22, center = true);
                translate([0, 0, -5.5]) cylinder(r = 2 * M3, h = M3 + 2 * tollerance, center = true, $fn = 6);
            }
        }
        // external part
        translate([0, 23 + tollerance, 0])  {
            difference() {
                union() {
                    cube([48, 2, 20], center = true);
                    translate([-24, 0, 0]) rotate([90, 0, 0])
                        cylinder(r = 10,h = 2, center = true);
                    translate([24, 0, 0]) rotate([90, 0, 0])
                        cylinder(r = 10,h = 2, center = true);
                }
                translate([-24, 0, 0]) rotate([90, 0, 0])
                    cylinder(r = 6,h = 3, center = true);
                translate([24, 0, 0]) rotate([90, 0, 0])
                    cylinder(r = 6,h = 3, center = true);
            }
        }
    }
}

module cutouts() {
    // cutouts for e3d idler screws
    translate([14 - 2 * M3, 23 - 2 * M3,  0])
        cylinder(r = M3, h = 22, center = true);
    translate([14 - 2 * M3, -23 + 2 * M3,  0])
        cylinder(r = M3, h = 22, center = true);
    translate([-14 + 2 * M3, 23 - 2 * M3,  0])
        cylinder(r = M3, h = 22, center = true);
    translate([-14 + 2 * M3, -23 + 2 * M3,  0])
        cylinder(r = M3, h = 22, center = true);
    
    // cabling cutout
    translate([-14 + 3 * M3, -23 + 6 * M3,  0])
        cylinder(r = M4, h = 22, center = true);
    translate([14 - 3 * M3, -23 + 6 * M3,  0])
        cylinder(r = M4, h = 22, center = true);
    translate([0, -23 + 6 * M3, 0,]) 
        cube([28 - 6 * M3, 2 * M4, 22], center = true);
    translate([-14 + 3 * M3, 23 - 6 * M3,  0])
        cylinder(r = M4, h = 22, center = true);
    translate([14 - 3 * M3, 23 - 6 * M3,  0])
        cylinder(r = M4, h = 22, center = true);
    translate([0, 23 - 6 * M3, 0,]) 
        cube([28 - 6 * M3, 2 * M4, 22], center = true);
}
    
    
module LM8LUU() {
    color("yellow") {
        translate([0, 0, -22.5]) 
        difference() {
            cylinder(r = 7.5, h = 45);
            translate([0, 0, -1]) cylinder(r = 4, h = 47);
        }
    }
}
/* end modules */

