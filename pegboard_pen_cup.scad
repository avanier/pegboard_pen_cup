// Includes
include <BOSL/constants.scad>;
use <BOSL/transforms.scad>;
use <BOSL/shapes.scad>;

// Constants

/// This is the distance from the center of a hole to another
hole_dist = 26;

/// Self explanatory
/// Useful for tolerances and material strength guesstimations
nozzle_size = 0.4;

/// We set the smallest tesselation size to nozzle size
$fs = nozzle_size;

/// The actual pegboard which this is designed for has
/// 7mm holes, but we'll use the standard size of 3/16 in
pegboard_hole_diameter = 4.7625;

// Globals

/// This is the height of the container.
/// This is designed to extend from "hole zero" to just above
/// the hole of the number you're entering.
height_in_holes = 1;

/// Control the width of the box in number or holes wide.
/// That's inclusive of hole number zero.
width_in_holes = 2;

/// The depth of the box, or how far it extends away from the pegboard
/// Expressed
depth_in_holes = 1;

/// A keen reader will notice that this makes it so that
/// "vertical hole units" and "horizontal hole units" aren't
/// the same size. That's right. Deal with it.

/// Other things to fiddle with
box_floor_height = nozzle_size * 4;
box_wall_thickness = nozzle_size * 2;

// Let's get started!
box_width = (hole_dist * (width_in_holes - 1)) + pegboard_hole_diameter - 0.5;
box_height = (hole_dist * height_in_holes) - pegboard_hole_diameter;
box_depth  = hole_dist * depth_in_holes;

module hook() {
  forward_offset = pegboard_hole_diameter;
  dia = pegboard_hole_diameter - 0.5;
  section_height = pegboard_hole_diameter * 2;
  pegboard_thickness = dia * (2 / 3);

  // This is the upper part of the hook
  move([dia / 2, dia + pegboard_thickness, dia]) {
      // This is the top straight part
      move([0, dia / 2, 0]) {
        linear_extrude(height = section_height) {
          circle(r= dia / 2);
      };

      // This is the upper elbow
      move([0, dia / -2, 0]) {
        rotate([0, 90, 0]) {
          rotate_extrude(angle = 90) translate([dia / 2, 0, 0]) circle(r= dia / 2);
        };
      };

      // This is the horizontal exeension going through the pegboard
      // Something like the middle part of the S <-
      if (pegboard_thickness > 0) {
        move([0, dia / -2, dia / -2]) {
          rotate([90, 0, 0]) {
            linear_extrude(pegboard_thickness) {
              circle(r = dia / 2);
            }
          }
        }
      }
    }
  };

  // This is the top half of the lower elbow, right along the ridge of the box
  move([dia / 2, dia, 0]) {
    rotate(180, [1,0,0]) {
      rotate(90, [0,1,0]) {
        rotate_extrude(angle = 90) move([dia / 2, 0]) circle(r= dia / 2);
      };
    };
  };

  // This is the lower straight section that merges in the box 
  move([dia / 2, dia / 2, section_height * -0.5]) {
    intersection() {
      cylinder(h = section_height, r = dia / 2, center = true);
      move([dia / -2, dia / -2, section_height / 2]) {
        rotate([0, 90, 0]) {
          linear_extrude(dia) {
            polygon([
              [0 ,0],
              [section_height ,dia],
              [0 ,dia]
            ]);
          };
        };
      };
    };
  };
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
    // Brace the box if it's getting too thin
    if (box_wall_thickness <= nozzle_size * 2) {
      move([box_wall_thickness, box_depth / 2, (box_height - box_floor_height) / 2]) {
        sparse_strut(
          h = box_height - box_floor_height,
          l = box_depth - pegboard_hole_diameter,
          thick = box_wall_thickness,
          strut = 2,
          maxang=45
        );
      };

      move([box_width - box_wall_thickness, box_depth / 2, (box_height - box_floor_height) / 2]) {
        sparse_strut(
          h = box_height - box_floor_height,
          l = box_depth - pegboard_hole_diameter,
          thick = box_wall_thickness,
          strut = 2,
          maxang=45
        );
      };

      move([box_width / 2, box_depth - box_wall_thickness, (box_height - box_floor_height) / 2]) {
        rotate([0,0,90]) {
          sparse_strut(
            h = box_height - box_floor_height,
            l = box_width - pegboard_hole_diameter,
            thick = box_wall_thickness,
            strut = 2,
            maxang=45
          );
        };
      };

      move([box_width / 2, box_wall_thickness, (box_height - box_floor_height) / 2]) {
        rotate([0,0,90]) {
          sparse_strut(
            h = box_height - box_floor_height,
            l = box_width - pegboard_hole_diameter,
            thick = box_wall_thickness,
            strut = 2,
            maxang=45
          );
        };
      };
    }
  }
};

// Place all our hooks
move([0, 0, box_height]) {
  for (a = [0: width_in_holes - 1]) {
    move([a * hole_dist, 0, 0]) {
      hook();
    }
  };
}

move([0, (box_depth * -1) + (pegboard_hole_diameter - 0.5), 0]) {
  box();
}
