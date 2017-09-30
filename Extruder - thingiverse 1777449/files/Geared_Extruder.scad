use <hardware.scad>
use <mk7.scad>

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

m3_cap_diameter = 5.3 + bolt_slop;

bf605zz = [10, 3.5, 5, 11.7, 0.8];
b625zz = [16, 5, 5, 0, 0];
b624zz = [13, 5, 4, 0, 0];

//[drive_d,effective_d,gear_shift,axis_shift]
mk7g=[13.6,10,4.7,0];
mk8g=[9   ,7 ,5.5,1.4];

//MAIN config
bearing = b625zz;  // b625zz or b624zz or bf605zz
gear=mk8g; //mk7g or mk8g
filament_diameter = 1.75 + clearance; //1.75 or 3.0
fitting_diameter = 9.5 + clearance;
plywood_thickness=[7,9,40]; //prusa_support [upper,lower,height]

show_extruder=1;
show_other=1;
show_prusa_support=1;
show_support=0;

//
show_motor=0;
show_mk7=0;
//MAIN config end

gear_axis=10+gear[3];
motor_distane=-20+gear[3];
drive_diameter = gear[0];
gear_screw_shift=gear[2];
effective_diameter = gear[1];

if(show_prusa_support)
  translate([0,30,5])support_prusa();
if(show_extruder)
  mirror([1,0,0]) 	translate([0,0,4.8]) rotate([90,0,0]) extruder();
if(show_support)
  translate([0,30,5]) rotate([90,0,180]) support();

if(show_other){ //others
  mirror([1,0,0]) translate([-5,-30,28]) rotate([180,0,0]) idler();
  translate([40,-37,1.5]) rotate([0,0,0]) idler_screw_holder();
  translate([30,-37,2.5]) rotate([0,180,0]) fitting_screw_holder();
}
module extruder(){
	difference(){
		union(){
		//main block
			translate([0,8.7,3.5]) cube([41.5,27,32], center = true);
    //fitting block
      translate([-51.5/2-11/2,-4.8,6.5]) cube([11,27,gear_axis + filament_diameter/2 + effective_diameter/2-6.5+fitting_diameter/2*0.57]);
    //idler mount 
			for (i=[-1.8,14.8])
      hull(){
				translate([16.5,i,24]) rotate([90,0,0]) cylinder(r = 4.25, h = 6, $fn = 32, center = true);
				translate([16.5,i,15]) cube([8.5,6,1],center = true);
			}
      if (show_motor)
        %translate([-21,48,-42/2+motor_distane]) rotate([90,0,0]) nema17();
      if (show_mk7)
        %translate([0,8.5,gear_axis]) rotate([90,0,0]) mk7();
		}
		
		//filament hole
		translate([0,6.5,gear_axis + filament_diameter/2 + effective_diameter/2]) rotate([0,90,0]) cylinder(r = filament_diameter/2, h = 50, $fn = 16, center = true);
		
		//filament entrance
		translate([19.5,6.5,gear_axis + filament_diameter/2 + effective_diameter/2]) rotate([0,90,0]) cylinder(r1 = filament_diameter/2, r2 = (filament_diameter + 2)/2, h = 3, $fn = 16, center = true);
		
		//PTFE tubing holder nut
    if(0)
        hull(){
			translate([-15.5,6.5,10 + filament_diameter/2 + effective_diameter/2]) rotate([0,90,0]) cylinder(r = ((7.8+0.6)/cos(30))/2, h = 4, $fn = 6, center = true);
			translate([-15.5,6.5,25]) rotate([0,90,0]) cylinder(r = ((7.8+0.6)/cos(30))/2, h = 4, $fn = 6, center = true);
		}
		
		//PTFE tubing insert
		translate([-16.5-0.05,6.5,gear_axis + filament_diameter/2 + effective_diameter/2]) rotate([0,90,0]) cylinder(d = 4 + 0.5, h = 10, $fn = 16, center = true);

		//fitting insert
		translate([-16.5-10,6.5,gear_axis + filament_diameter/2 + effective_diameter/2])
        difference(){
        rotate([0,90,0])
            cylinder(r = fitting_diameter/2, h = 10, $fn = 16, center = true);
    //fitting support
    translate([-6,-6,2.8-0.6])  cube([10,12,1]);
            
		}
    for (i=[8,-8]){
		//fitting screw holes
		translate([-16.5-10,6.5+i,12]) rotate([0,0,90]) cylinder(d = m3_diameter, h = 25, $fn = 16, center = true);
		//fitting nut insert
		translate([-16.5-10,6.5+i,8-0.05]) rotate([0,0,0]) cylinder(d = m3_nut_diameter-nut_slop/2, h = 3, $fn = 6, center = true);
    }
		//main block differences
		translate([-21,48,-42/2+motor_distane]) rotate([90,0,0]) nema17();
		translate([0,-2,motor_distane]) rotate([90,0,0]) cylinder(r = 11.5, h = 10, $fn = 128, center = true); 
		
		//drive gear hole
		translate([0,15.3,gear_axis]) rotate([90,0,0]) cylinder(r = (drive_diameter + 1)/2, h = 30, $fn = 32, center = true);
		
		//bearings holes
		translate([0,-2.5,gear_axis]) rotate([90,0,0])  bearing(bearing, false);
		translate([0,20,gear_axis]) rotate([-90,0,0])  bearing(bearing, true);
		
		//idler bearing hole
		translate([0,6.5,24]) rotate([90,0,0]) scale([1.2,1.2,1.1])  bearing(bearing, false);
		
		//drive gear grub screw hole
		translate([0,6.5+gear_screw_shift,17]) rotate([0,0,45])cylinder(d = m3_diameter, h = 7, $fn = 4, center = true);
		translate([0,6.5+gear_screw_shift,gear_axis]) rotate([90,0,0]) cylinder(d = (drive_diameter + 3), h = m3_diameter*1.5, $fn = 32, center = true);
		
		//idler nut
		translate([16.5,16.5,24]) rotate([90,0,0]) cylinder(r = m3_nut_diameter/2, h = 3, $fn = 6, center = true);
		
		//idler bolt
		translate([16.5,18.6,24]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
		
		//idler bolt head
		translate([16.5,-3.5,24]) rotate([90,0,0]) cylinder(r = m3_cap_diameter/2, h = 3.5, $fn = 16, center = true);
		
    for(i=[-0.5,13.5]){
		//idler pressure bolt nuts
		hull(){
			translate([-20,i,8]) cylinder(r = (m3_nut_diameter)/2, h = 8, $fn = 6, center = true);
			translate([-12,i,8]) cylinder(r = (m3_nut_diameter)/2, h = 8, $fn = 6, center = true);
		}
		//idler pressure bolts
		hull(){
			translate([-17.5,i,22]) cylinder(r = m3_diameter/2, h = 30, $fn = 16, center = true);
			translate([-13,i,22]) cylinder(r = m3_diameter/2, h = 30, $fn = 16, center = true);
		}
    }
		//motor fixing holes
    for(i=[1,-1])
		hull(){
			translate([15.5*i,0,-4+20+motor_distane]) rotate([90,0,0]) cylinder(d = m3_diameter, h = 20, $fn = 16, center = true);
			translate([15.5*i,0,-7+20+motor_distane]) rotate([90,0,0]) cylinder(d = m3_diameter, h = 20, $fn = 16, center = true);
		}

    //filament brush 
    angle=7;
    dd=drive_diameter+1-0.05;
		translate([dd/2*cos(angle),6.5,gear_axis+dd/2*sin(angle)]){
      rotate([0,110,0])translate([filament_diameter,0,0])cylinder(r=filament_diameter,h=10,$fn=16);
      translate([-5,0,0])rotate([0,90,0])cylinder(d=3,h=27, $fn=16);
      translate([17.5-drive_diameter/2,6,0]) rotate([90,0,0]) cylinder(d = 2.5, h = 12, $fn = 128, center = true);
    }
		//material reduction my
    translate([0,10,5.5+20+motor_distane])
		hull(){
			translate([13,0,0]) rotate([90,0,0]) cylinder(r = 3, h = 40, $fn = 128, center = true);
			translate([16,0,0]) rotate([90,0,0]) cylinder(r = 3, h = 40, $fn = 128, center = true);
		}
		//translate([10,7.5,0]) cube([20,20,20]);
		translate([10,17.5,0]) cube([20,20,20]);
		translate([-35,18.5,0]) cube([25,20,25]);
        //rotate([90,0,0]) cylinder(r = 3.5, h = 40, $fn = 128,  center = true);
	}
	
	//idler hinge support
	difference(){
		translate([16.5,3.5,25]) cube([12,16.6,10],center = true);
		translate([16.5,1.5,24.3]) cube([10.5,13,10],center = true);
		translate([16.5,4.9,25]) cube([10.5,13,8.5],center = true);
	}
	
    //fitting support
    //translate([-51.5/2,6.5,3.5+15.75]) cube([10,8,0.5], center = true);
}

module idler(){
	difference(){
		//main body
		union(){
			translate([0,6.5,24]) cube([34,22,8], center = true);
			translate([16.5,6.5,24]) rotate([90,0,0]) cylinder(r = 4, h = 22, $fn = 64, center = true);
		}
		
		//hinge cuts
		translate([16.5,-3.5,24]) rotate([90,0,0]) cylinder(r = 7, h = 10, center = true);
		translate([16.5,16.5,24]) rotate([90,0,0]) cylinder(r = 7, h = 10, center = true);
		
		//handle cut
		translate([-17,0,11]) rotate([90,0,0]) cylinder(r = 15, h = 50, $fn = 128, center = true);

		//bearing hole
		translate([0,6.5,24]) rotate([90,0,0]) scale([1.2,1.2,1.1]) bearing(b625zz, false);
		
		//bearing bolt
		translate([0,6.5,24]) rotate([90,0,0]) cylinder(r = (m5_diameter - bolt_slop)/2, h = 30, $fn = 24, center = true);
		
		//hinge bolt
		translate([16.5,10,24]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
		
		//pressure bolt holes
		hull(){
			translate([-22,-0.5,10]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
			translate([-13,-0.5,10]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
		}
			
		hull(){
			translate([-22,13.5,10]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
			translate([-13,13.5,10]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
		}
	}
}

//to fix the extruder to a rostock mini frame
module support(){
	difference(){
		translate([0,4,-4]) cube([70,18,15], center = true);
		
		translate([34,10,-10.5]) cube([20,20,20], center = true);
		translate([-34,10,-10.5]) cube([20,20,20], center = true);
	
		translate([0,21.5,-21])cube([43,43,43], center = true);
		translate([0,-2,-20]) rotate([90,0,0]) cylinder(r = 11.5, h = 10, $fn = 128, center = true);
		
		hull(){
			translate([-15.5,0,-4.5]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 20, $fn = 16, center = true);
			translate([-15.5,0,-7]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 20, $fn = 16, center = true);
		}
		
		hull(){
			translate([15.5,0,-4.5]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 20, $fn = 16, center = true);
			translate([15.5,0,-7]) rotate([90,0,0]) cylinder(r = m3_diameter/2, h = 20, $fn = 16, center = true);
		}
		
		translate([-30,7.5,0]) cylinder(r = m4_diameter/2, h = 20, $fn = 16, center = true);
		translate([30,7.5,0]) cylinder(r = m4_diameter/2, h = 20, $fn = 16, center = true);
	}
}
//to fix the extruder to a rostock mini frame
module support_prusa(){
    mirror([0,1,0])rotate([90,0,0])
	difference(){
		translate([0,4,2]) cube([50,18,27], center = true);
    //material reduction
		rotate([45,0,0])translate([0,0,-20]) cube([52,22,22], center = true);
    //hook
		translate([15,-5.2,3.5])mirror([180,0,0])cube([plywood_thickness[2]-5,20,15]);
		translate([16-plywood_thickness[2],-5.2,3.5])mirror([180,0,0])cube([100,20,15]);

		translate([15,-5.2,11.5])mirror([180,0,0])cube([45,20,5]);
		translate([19,-5-0.2,3.5])
        hull(){
            cube([1,20,plywood_thickness[0]]);
            translate([-5,0,0])cube([1,20,plywood_thickness[1]]);
        }
    //motor
		translate([0,21.5,-21])cube([43,43,43], center = true);
		translate([0,-2,-20]) rotate([90,0,0]) cylinder(r = 11.5, h = 10, $fn = 128, center = true);

		for(i=[1,-1])
		hull(){
			translate([15.5*i,0,-4.5]) rotate([90,0,0]) cylinder(d = m3_diameter, h = 20, $fn = 16, center = true);
			translate([15.5*i,0,-7]) rotate([90,0,0]) cylinder(d = m3_diameter, h = 20, $fn = 16, center = true);
		}
		
	}
}


//for ease of reapplying pressure to the idler
module idler_screw_holder(){
	difference(){
		cube([6,22,3], center = true);
		
		translate([0,-6.75,0]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
		translate([0,6.75,0]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
	}
}

module fitting_screw_holder(){
        //fitting bracket
		//translate([-25.75,2,19.75]) cube([10,16,0.5], center = true);
		//translate([-25.75,18.75,19.75]) cube([10,16,0.5], center = true);
        
        
	difference(){
		cube([8.5,22.5,5], center = true);
		
		translate([0,-8,0]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
		translate([0,8,0]) cylinder(r = m3_diameter/2, h = 40, $fn = 16, center = true);
        //fitting insert
		translate([0,0,-6]) rotate([0,90,0]) cylinder(r = fitting_diameter/2, h = 10, $fn = 16, center = true);
	}
}

module bearing(bearing_sizes, id){
	difference(){
		union(){
			cylinder(r = (bearing_sizes[0] + bearing_clearance)/2, h = bearing_sizes[1], $fn = 32, center = true);
			translate([0,0,bearing_sizes[1]/2 + bearing_sizes[4]/2 - 0.01]) cylinder(r = (bearing_sizes[3] + bearing_clearance)/2, h = bearing_sizes[4], $fn = 32, center = true);
		}
		
		if(id == true){
			cylinder(r = (bearing_sizes[2] + bearing_clearance)/2, h = bearing_sizes[1] + bearing_sizes[4] + 10, $fn = 16, center = true);
		}
	}
}

module bearing_adapter(){
	difference(){
		cylinder(r = bearing[0]/2, h = bearing[1], $fn = 64, center = true);
		translate([0,0,0.51]) cylinder(r = 13/2, h = 4, $fn = 32, center = true);
		cylinder(r = (m4_diameter+0.4)/2, h = 10, $fn = 24, center = true);
	}
}
