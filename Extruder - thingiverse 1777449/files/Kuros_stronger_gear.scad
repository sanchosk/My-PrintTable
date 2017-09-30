use <involute_gears.scad>

bolt_slop = 0.7;
nut_slop = 0.4;

clearance = 0.4;
bearing_clearance = 0.4;

m3_diameter = 3 + bolt_slop;
m4_diameter = 4 + bolt_slop;
m5_diameter = 5 + bolt_slop;

m3_nut_diameter = 5.5/cos(30) + nut_slop;
m4_nut_diameter = 6.87/cos(30) + nut_slop;
m5_nut_diameter = 7.8/cos(30) + nut_slop;

pitch = 0.73;
big_teeth = 34;
small_teeth = 10;
thickness = 8;
gear_clearance = 0;
gear_backlash = 0;
gear_pressure_angle = 20;

//big gear
translate([30.5,0,0])difference(){
	gear(number_of_teeth=big_teeth, diametral_pitch=pitch, hub_diameter=0, hub_thickness=thickness, bore_diameter=0, rim_thickness=thickness, rim_width=0, gear_thickness=thickness, clearance=gear_clearance, backlash=gear_backlash, pressure_angle=gear_pressure_angle);
	
	translate([0,0,9]) 
	difference(){
		cylinder(r1 = 18, r2 = 20, h = 8, $fn = 128, center = true);
		translate([0,0,-5]) cylinder(r1 = 9, r2 = 7, h = 6, $fn = 64, center = true);
	}
	
	cylinder(r = m5_diameter/2, h = 20, $fn = 24, center = true);
	translate([0,0,5]) 
	cylinder(r = m5_nut_diameter/2, h = 5, $fn = 6, center = true);
	
	difference(){
		cylinder(r = 18, h = 20, $fn = 128, center = true);
		cylinder(r = 7.5, h = 20, $fn = 128, center = true);
		
		translate([25,0,0]) 
		cube([50,4,30], center = true);
		
		rotate([0,0,120]) 
		translate([25,0,0]) 
		cube([50,4,30], center = true);

		rotate([0,0,60]) 
		translate([25,0,0]) 
		cube([50,4,30], center = true);

		rotate([0,0,-60]) 
		translate([25,0,0]) 
		cube([50,4,30], center = true);

		rotate([0,0,180]) 
		translate([25,0,0]) 
		cube([50,4,30], center = true);

		rotate([0,0,-120]) 
		translate([25,0,0]) 
		cube([50,4,30], center = true);
	}
}

//small gear
translate([-10,0,7.5]) difference(){
	union(){
		rotate([0,0,18]) gear(number_of_teeth=small_teeth, diametral_pitch=pitch, hub_diameter=0, hub_thickness=thickness, bore_diameter=0, rim_thickness=thickness+3, rim_width=0, gear_thickness=thickness+3, clearance=gear_clearance, backlash=gear_backlash, pressure_angle=gear_pressure_angle);
		translate([0,0,-3.5]) cylinder(r = 8.5, h = 8, $fn = 32, center = true);
	}
	
	cylinder(r = (m5_diameter-0.4)/2, h = 30, $fn = 24, center = true);
	
	translate([0,-5.5,-3.5]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 10, $fn = 24, center = true);
	hull(){
		translate([0,-5.5,-3]) rotate([90,30,0]) cylinder(r = (m3_nut_diameter+0.4)/2, h = 2.5, $fn = 6, center = true);
		translate([0,-5.5,-9]) rotate([90,30,0]) cylinder(r = (m3_nut_diameter+0.4)/2, h = 2.5, $fn = 6, center = true);
	}
}

echo("big radius", outer_radius(big_teeth, pitch));
echo("small radius", outer_radius(small_teeth, pitch));

function pitch_radius(number_of_teeth, diametral_pitch) = number_of_teeth * (180/diametral_pitch) / 360;
function outer_radius(number_of_teeth, diametral_pitch) = pitch_radius(number_of_teeth, diametral_pitch)+(1/(number_of_teeth / (pitch_radius(number_of_teeth, diametral_pitch) * 2)));

