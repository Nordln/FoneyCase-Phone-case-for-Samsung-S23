include <BOSL2/std.scad>

backplane_size_X = 155;
backplane_size_Y = 180;
hole_spacing = 4;
hole_size = 0.6;
hole_inset = 5;
core_material_inset = 12;
spine_width = 18;
spine_holes_instep = 8;

cardslotX = 5;
cardslotY = 55;

cam_cutout_size_X = 55;
cam_cutout_size_Y = 28;
cam_cutout_pos_X = 42;
cam_cutout_pos_Y = -68;

strap_size_X = 20;
strap_size_Y = 80;
strap_pos_X = -2.4;
strap_pos_Y = -backplane_size_X/2-13;
strap_hole_inset = 4;
strap_hole_spacing = 4;

layer_thickness = 1;

separation = 10;

show_phoneholder = 1;
show_strap = 1;
show_cardwallet = 1;
show_notewallet = 1;
show_midplane = 1;
show_coreplates = 1;
show_backplane = 1;

main();


// main

module main() {
    
    // phoneholder
    if(show_phoneholder==1) translate([0,-50,0 + (separation*3)]) rotate([0,0,-90]) import("S23.stl");
    
    // Magnetic stap
    if(show_strap==1) color("black") translate([0,0,0 + (separation*0.5)]) linear_extrude(height = layer_thickness) strap_panel();

    // Cardwallet
    if (show_cardwallet==1) color("green") translate([0,0,0 + (separation*4)]) linear_extrude(height = layer_thickness) cardwallet_panel();

    // Notewallet
    if (show_notewallet==1) color("orange") translate([0,0,0  + (separation*3)]) linear_extrude(height = layer_thickness) notewallet_panel();

    // Midplane
    if (show_midplane==1) color("red") translate([0,0,0 + (separation*2)]) linear_extrude(height = layer_thickness) backplane_panel();

    // Coreplates
    if (show_coreplates==1) color("pink") translate([0,0,0 + separation]) linear_extrude(height = layer_thickness) backplane_panel_core();

    // Backplane
    if (show_backplane==1) color("blue") linear_extrude(height = layer_thickness) backplane_panel();

}



// intermidates

module cardwallet_panel() {
    difference() {
        difference() {
            notewallet_panel();
            translate([0,(backplane_size_Y/4)+(spine_width/4),0]) color("yellow") cardslot();
        }
        translate([0,+spine_width*1.3,0]) cardwallet_panel_holes();
    }
}

module notewallet_panel() {
     difference() {
        intersection() {
            backplane_panel();
            translate([0,(backplane_size_Y/4)+(spine_width/2)+1.5,0]) rect([backplane_size_X,(backplane_size_Y/2)-(hole_size*2)], rounding=0);
        }
        translate([0,+spine_width*1.3,0]) cardwallet_panel_holes();
    }
}

module backplane_panel() {
    difference() {
        backplane();
        translate([cam_cutout_pos_X,cam_cutout_pos_Y,0]) camera_cutout();
        backplane_edge_holes();
        backplane_fold_holes();
    }
}

module backplane_panel_core() {
        //rect([backplane_size_X-core_material_inset,backplane_size_Y-core_material_inset], rounding=5); // core_all
        translate([0,(backplane_size_Y/4)+2,0]) rect([backplane_size_X-core_material_inset,(backplane_size_Y/2)-core_material_inset-4], rounding=0); // core_large
        translate([0,-(backplane_size_Y/8)-3.8,0]) rect([backplane_size_X-core_material_inset,(backplane_size_Y/4)-core_material_inset], rounding=0); // core_med
        translate([-(backplane_size_X-cam_cutout_size_X*1.2)/3,-(backplane_size_Y/8)*2.8-3,0]) rect([backplane_size_X-cam_cutout_size_X*1.35,(backplane_size_Y/3)-core_material_inset*1.9], rounding=0); // core_sml
}

module strap_panel(){
    difference() {
        strap();
        backplane_edge_holes();
        strap_holes();
    }
}

module backplane_edge_holes() {
   path1 = rect([backplane_size_X-hole_inset,backplane_size_Y-hole_inset], rounding=5); 
   sampled1 = resample_path(path1, spacing=hole_spacing);
   color("red")move_copies(sampled1) circle(r = hole_size, $fn=16);
   
   path2 = rect([cam_cutout_size_X*1.1,cam_cutout_size_Y*1.2], rounding=2);
   sampled2 = resample_path(path2, spacing=hole_spacing);
   color("red") translate([cam_cutout_pos_X,cam_cutout_pos_Y,0]) move_copies(sampled2) circle(r = hole_size, $fn=16);
}

module backplane_fold_holes() { 
   translate ([0,-spine_width/2,0]) {
       path = [[(-backplane_size_X /2)+spine_holes_instep,0],[0,0],[(backplane_size_X/2)-spine_holes_instep,0]];
       sampled = resample_path(path, spacing=hole_spacing);
       color("red")move_copies(sampled) circle(r = hole_size, $fn=16);
   }
   translate ([0,spine_width/2,0]) {    
       path = [[(-backplane_size_X/2)+spine_holes_instep,0],[0,0],[(backplane_size_X/2)-spine_holes_instep,0]];
       sampled = resample_path(path, spacing=hole_spacing);
       color("red")move_copies(sampled) circle(r = hole_size, $fn=16);
    }
    translate ([0,-backplane_size_Y/4,0]) {    
       path = [[(-backplane_size_X/2)+spine_holes_instep,0],[0,0],[(backplane_size_X/2)-spine_holes_instep,0]];
       sampled = resample_path(path, spacing=hole_spacing);
       color("red")move_copies(sampled) circle(r = hole_size, $fn=16);
    }
}

module cardwallet_panel_holes() { 
   translate ([0,(-spine_width/2)*1.1,0]) {
       path = [[(-backplane_size_X/2)+spine_holes_instep,0],[0,0],[0-spine_holes_instep,0]];
       sampled = resample_path(path, spacing=hole_spacing);
       color("red")move_copies(sampled) circle(r = hole_size, $fn=16);
   }

}

module strap_holes(){
   translate([strap_pos_X,strap_pos_Y,0]){
        path = rect([strap_size_X-strap_hole_inset,strap_size_Y-strap_hole_inset], rounding=7); 
        sampled = resample_path(path, spacing=strap_hole_spacing);
        color("red")move_copies(sampled) circle(r = hole_size, $fn=16);
   }
}



// primitives

module backplane() {
   rect([backplane_size_X,backplane_size_Y], rounding=5); 
}

module cardslot() {
   rect([cardslotX,cardslotY], rounding=2); 
}

module camera_cutout() {
   rect([cam_cutout_size_X,cam_cutout_size_Y], rounding=2); 
}

module strap() {
   translate([strap_pos_X,strap_pos_Y,0]) rect([strap_size_X,strap_size_Y], rounding=10); 
}

echo(version=version());
// Written by Ed Watson <mail@edwardwatson.co.uk>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.