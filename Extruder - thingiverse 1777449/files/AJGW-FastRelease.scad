//
// Fast Release Lever for AJGW Extruder
// (c) 2012 by Alain Mouette - GPL
//
// Derived from: Quick Release Lever for wade
//   by simon litwan, http://www.thingiverse.com/thing:22830
// Licence: Creative Commons: CC BY 3.0 (almost GPL...)


lever();
translate([18,-20,0])rotate([0,90,90]) bar();

layer_thickness=0.2;
$fn=36;
width=6;
extra_width=0.0;// extra on each side in idler fit
inclination=4;//6;
hole=8.8;
corner=[10,2.9,0];
bearing_diameter=16+2;

bar_diameter=8;
bar_length=24;
bar_spring=5.2;
//washers
if(1){
translate([30,0,0]){
  washer(3.1,7,2);
  translate([10,0,0])washer(3.1,7,2);
}
translate([30,-10,0]){
  washer(3.1,7,3);
  translate([10,0,0])washer(3.1,7,3);
}
translate([30,-20,0]){
  washer(3.1,7,4);
  translate([10,0,0])washer(3.1,7,4);
}
}
module lever(){
	difference(){
		union(){
			translate([2,0,0]) cylinder(r=17/2,h=width);// head
			rotate([0,0,-90]) cube([8.5,10,width]);// body right
			translate([-1,0,0]) rotate([0,0,-90]) cube([28,10,width]);// body right
			translate([-1,-16.6,0]) rotate([0,0,20]) cube([4,15,width]);// body left
			translate([-1,-14,0]) rotate([0,0,-101.6]) cube([17,5,width]);// body left
//			translate([-3.4,-29.8-1,0]) cylinder(r=1,h=width);
		}
		translate([-0.3,0,-0.1]) cylinder(r=hole/2, h=width+0.2);// center hole
		translate([10,2.9,-0.1]) rotate([0,0,-90-inclination]) cube([13,2,width+0.2]);// fit into idler
		translate([bearing_diameter-5,-13,-0.1]) cylinder(d=bearing_diameter, h=width+0.2);// bearing space
		translate([6.75,-36,-0.1]) cylinder(r=21/2, h=width+0.2);// finger space
		// 45° sides
		translate(corner+[-1,0,0]) rotate([0,0,-92]) translate([-3,0,0]){
			//cube([16,1,width]);// for viewing only
			translate([-0.1,0,-extra_width-0.1]) rotate([-45,0,0]) cube([16,2,2]);
			translate([-0.1,0,width+extra_width+0.1]) rotate([-45,0,0]) cube([16,2,2]);
		}
  	}
	translate([-3,-30.6,0]) cylinder(r=1.4, h=width, $fn=12);
}

module bar(){
	difference(){
		translate([-bar_diameter/2+2,0,0])cylinder(h=bar_length,d=bar_diameter);
		translate([0,-bar_diameter/2,-0.1])cube([bar_diameter,bar_diameter,bar_length+0.2]);
		translate([0,0,5])rotate([0,90,180])m3Screw();
		translate([0,0,bar_length-5])rotate([0,90,180])m3Screw();
	}
}

module m4Screw(h=15) {
	union() {
		translate([0,0,3+layer_thickness])cylinder(h=h+3.3,r=4.3/2);
		translate([0,0,-0.1])cylinder(h=3,r=bar_spring/2,$fn=18);// round for spring
	}
}
module m3Screw(h=8) {
	union() {
		translate([0,0,2+layer_thickness])cylinder(h=h,d=3.2);
		translate([0,0,-0.1])cylinder(h=2.1,d=bar_spring,$fn=18);// round for spring
	}
}

module washer(in,out,h){
  difference(){
    cylinder(d=out,h=h);
    translate([0,0,-0.1])cylinder(d=in,h=h+0.2);
  }
}

// references
//%translate(corner+[-1,0,0]) rotate([0,0,-90]) cube([11.5,1,width]);// idler fit

