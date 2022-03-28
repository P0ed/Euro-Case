$fn = 128;

3U = 128.5;
HP = 5.08;

dx = 0.001;

connector_footprint = [12, 24];
border = 4;
pt = 1.75;
layer = 0.25;

module box(hp, height) {
	w = hp * HP;
	nut = [6, 6, 2];

	module hole() {
		linear_extrude(height = border + dx * 2)
		square(size = connector_footprint);
	}

	module rail() {
		h = height - border - pt;
		rail = [3, pt * 2 + nut.y, 4];
		rail_entrance = [nut.x + 2, rail.y + dx * 2, rail.z];

		union() {
			difference() {
				cube([hp * HP, rail.y, h]);
	
				translate([-dx, (rail.y - rail.x) / 2, h - rail.z - pt])
				cube([w, rail.x, rail.z + pt + dx]);
	
				translate([
					-dx, 
					pt - dx,
					h - rail.z + dx
				])
				cube([w, rail.y - pt * 2, rail.z - pt]);
		
				translate([
					(w - rail_entrance.x) / 2, 
					-dx,
					h - rail_entrance.z + dx
				])
				cube(rail_entrance);	
			}

			translate([(w - rail_entrance.x) / 2 - 2, 0, h - 2])
			cube([2, rail.y, 2]);

			translate([(w + rail_entrance.x) / 2, 0, h - 2])
			cube([2, rail.y, 2]);
		}
	}

	module box() {
		difference() {
			linear_extrude(height = height)
			square(size = [w + border * 2, 3U + border * 2]);
			
			// main volume
			translate([border, border, border])
			cube([w, 3U, height]);
	
			translate([border, border, -dx])
			translate([
				w - connector_footprint.x - 13, 
				3U - connector_footprint.y - 16
			])
			hole();
		}
	}

	color("#ffffff")
	union() {
		box();
		translate([border, border - pt, border]) rail();
		translate([border, border + 3U - nut.y - pt, border]) rail();
	}
}

box(14, 46);
