/// Step Event

// Make sure we have sharks
if (instance_exists(obj_shark_controller)) {
    var shark_ctrl = instance_find(obj_shark_controller, 0);
    var shark_count = array_length(shark_ctrl.sharks);

    // Loop backward through boids to safely remove any fish
    for (var i = array_length(boids) - 1; i >= 0; i--) {
        var b = boids[i];

        // Initialize variables if missing
        if (!variable_struct_exists(b, "is_dying")) b.is_dying = false;
        if (!variable_struct_exists(b, "fade_speed")) b.fade_speed = 0.05;
        if (!variable_struct_exists(b, "alpha")) b.alpha = 1.0;

        // Check shark collision if not dying
        if (!b.is_dying) {
            for (var s = 0; s < shark_count; s++) {
                var sh = shark_ctrl.sharks[s];
                var avoid_radius = 30
                var dx = b.bx - sh.x;
                var dy = b.by - sh.y;
                var dist = sqrt(dx*dx + dy*dy);

                if (dist < avoid_radius) {
                    b.is_dying = true;
                    b.fade_speed = 0.05 + random_range(0, 0.03); // random fade speed
                    break;
                }
            }
        } else {
            // Fade out
            b.alpha -= b.fade_speed;
            if (b.alpha <= 0) {
				boid_count--;
                array_delete(boids, i, 1); // safe removal
                continue;
            }
        }

        // Save changes back to the array
		
        boids[i] = b;
    }
}










// --- Clear spatial grid ---
for (var c = 0; c < grid_cols; c++) {
    for (var r = 0; r < grid_rows; r++) {
        grid[c][r] = []; // reset each cell to a new empty array
    }
}

// --- Place boids into the grid ---
for (var i = 0; i < boid_count; i++) {
    var b = boids[i];
    var col = clamp(floor(b.bx / grid_size), 0, grid_cols-1);
    var row = clamp(floor(b.by / grid_size), 0, grid_rows-1);
    array_push(grid[col][row], i);
}

// --- Boid Movement ---
for (var i = 0; i < boid_count; i++) {
    var b = boids[i];
    var col = clamp(floor(b.bx / grid_size), 0, grid_cols-1);
    var row = clamp(floor(b.by / grid_size), 0, grid_rows-1);

    var cx = 0;
    var cy = 0;
    var count = 0;
    var move_x = 0;
    var move_y = 0;
    var intergroup_x = 0;
    var intergroup_y = 0;
    var avg_vx = 0;
    var avg_vy = 0;

    // --- Check neighboring cells (3x3) ---
    for (var dc = -1; dc <= 1; dc++) {
        for (var dr = -1; dr <= 1; dr++) {
            var nc = col + dc;
            var nr = row + dr;
            if (nc < 0 || nc >= grid_cols || nr < 0 || nr >= grid_rows) continue;

            var cell = grid[nc][nr];
            for (var k = 0; k < array_length(cell); k++) {
                var j = cell[k];
                if (i == j) continue;
                var o = boids[j];

                var dx = b.bx - o.bx;
                var dy = b.by - o.by;
                var dist = sqrt(dx*dx + dy*dy);
                if (dist <= 0) continue;

                // Same-group: flocking & strong avoidance
                if (b.group_letter == o.group_letter) {
                    if (dist < visual_range) {
                        cx += o.bx;
                        cy += o.by;
                        count++;
                    }
                    if (dist < min_distance) {
                        var strength = (min_distance - dist)/min_distance;
                        move_x += (dx/dist)*strength;
                        move_y += (dy/dist)*strength;
                    }
                    if (dist < visual_range) {
                        avg_vx += o.vx;
                        avg_vy += o.vy;
                    }
                }
                // Different-group: mild avoidance
                else if (dist < visual_range) {
                    var strength = (visual_range - dist)/visual_range * 0.25;
                    intergroup_x += (dx/dist) * strength;
                    intergroup_y += (dy/dist) * strength;
                }
            }
        }
    }

    // --- Apply same-group flocking & matching ---
    if (count > 0) {
        cx /= count; cy /= count;
        b.vx += (cx - b.bx) * centering_factor;
        b.vy += (cy - b.by) * centering_factor;
        avg_vx /= count; avg_vy /= count;
        b.vx += (avg_vx - b.vx) * matching_factor;
        b.vy += (avg_vy - b.vy) * matching_factor;
    }

    // --- Apply avoidance ---
    b.vx += move_x * avoid_factor * 1.5;
    b.vy += move_y * avoid_factor * 1.5;
    b.vx += intergroup_x;
    b.vy += intergroup_y;

    // --- Border steering ---
    if (b.bx < margin) b.vx += turn_factor*0.2;
    else if (b.bx > screen_w-margin) b.vx -= turn_factor*0.2;
    if (b.by < margin) b.vy += turn_factor*0.2;
    else if (b.by > screen_h-margin) b.vy -= turn_factor*0.2;

    // --- Speed limit ---
    var vmag = sqrt(b.vx*b.vx + b.vy*b.vy);
    if (vmag > speed_limit) {
        var scale = speed_limit / vmag;
        b.vx *= scale;
        b.vy *= scale;
    }

    // --- Shark avoidance (all sharks in sharks array) ---
	if (instance_exists(obj_shark_controller)) {
	    var shark_ctrl = instance_find(obj_shark_controller, 0);
	    var shark_count = array_length(shark_ctrl.sharks);

	    for (var s = 0; s < shark_count; s++) {
	        var sh = shark_ctrl.sharks[s];

	        // Randomize perception distance slightly for each fish-shark pair
	        var avoid_radius = 150 + random_range(0, 100); // between 250 and 350
	        var dx = b.bx - sh.x;
	        var dy = b.by - sh.y;
	        var dist = sqrt(dx*dx + dy*dy);

	        if (dist < avoid_radius) {
	            // Randomize strength slightly as well
	            var base_strength = (avoid_radius - dist)/avoid_radius * 3.0;
	            var strength = base_strength * random_range(0.8, 1.2); // 80% - 120% variation
	            b.vx += (dx/dist) * strength;
	            b.vy += (dy/dist) * strength;
	        }
	    }
	}


    // --- Natural wobble ---
    var wobble = 0.05;
    b.vx += random_range(-wobble,wobble);
    b.vy += random_range(-wobble,wobble);

    // --- Update position ---
    b.bx += b.vx;
    b.by += b.vy;

    // --- Update facing ---
    if (vmag > 0.001) {
        var desired_fx = b.vx/vmag;
        var desired_fy = b.vy/vmag;
        b.fx = lerp(b.fx, desired_fx, turn_rate);
        b.fy = lerp(b.fy, desired_fy, turn_rate);
        var fmag = sqrt(b.fx*b.fx + b.fy*b.fy);
        b.fx /= fmag; b.fy /= fmag;
    }

    // --- Animate ---
    b.image_index += b.image_speed;
    if (b.image_index >= 7) b.image_index = 0;

    boids[i] = b;
}


