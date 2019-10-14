// Includes
include <BOSL/constants.scad>;
use <BOSL/transforms.scad>;
use <BOSL/shapes.scad>;

// Globals

nozzle_size = 0.4;

/// We set the smallest tesselation size to nozzle size
$fs = nozzle_size;

/// The actual pegboard which this is designed for has
/// 7mm holes, but we'll use the standard size of 3/16 in
pegboard_hole_diameter = 4.7625; 

/// This is the distance from the center of a hole to another
hole_dist = 26;

/// This is the height of the container
box_height = hole_dist * 4;
box_depth  = hole_dist * 1.5;
box_floor_height = nozzle_size * 6;
box_wall_thickness = nozzle_size * 6;
box_width  = (hole_dist * 2) + pegboard_hole_diameter - 0.5;

// Let's get started!

module hook() {
  forward_offset = pegboard_hole_diameter;
  dia = pegboard_hole_diameter - 0.5;
  section_height = pegboard_hole_diameter * 2;

  move([dia / 2, dia, dia]) {
      rotate([0, 90, 0]) {
        rotate_extrude(angle = 90) translate([dia / 2, 0, 0]) circle(r= dia / 2);
      }

      move([0, dia / 2, 0]) {
        linear_extrude(height = section_height) {
          circle(r= dia / 2);
      }
    }
  }
  move([dia / 2, dia, 0]) {
    rotate(180, [1,0,0]) {
      rotate(90, [0,1,0]) {
        rotate_extrude(angle = 90) move([dia / 2, 0]) circle(r= dia / 2);
      }
    }
  }
  move([dia / 2, dia, 0]) {
    rotate(270, [1,0,0]) {
      rotate(90, [0,1,0]) {
        rotate_extrude(angle = 90) move([dia / 2, 0]) circle(r= dia / 2);
      }
    }
  }
};

module box() {
  linear_extrude(height = box_floor_height) {
    round2d((pegboard_hole_diameter - 0.5) / 2) square(size=[box_width, box_depth]);
  };

  move([0, 0, box_floor_height]) {
    difference() {
      linear_extrude(height = box_height - box_floor_height) {
        difference() {
          round2d((pegboard_hole_diameter - 0.5) / 2) {
            square(size=[box_width, box_depth]);
          }
          offset(r = -box_wall_thickness) {
            round2d((pegboard_hole_diameter - 0.5) / 2) {
              square(size=[box_width, box_depth]);
            }
          }
        }
      }
    }
  }
};

move([0, 0, box_height]) {
  hook();
  move([hole_dist, 0, 0]) hook();
  move([hole_dist * 2, 0, 0]) hook();
}

move([0, (box_depth * -1) + (pegboard_hole_diameter - 0.5), 0]) {
  box();
}
