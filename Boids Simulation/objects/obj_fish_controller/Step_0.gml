/// Step Event — Smooth boid movement
for (var i = 0; i < boid_count; i++) {
    var b = boids[i];

    // --- Rule 1: Fly toward center
    var cx = 0;
    var cy = 0;
    var count = 0;
    for (var j = 0; j < boid_count; j++) {
        if (i == j) continue;
        var o = boids[j];
        var dx = b.bx - o.bx;
        var dy = b.by - o.by;
        var dist = sqrt(dx * dx + dy * dy);
        if (dist < visual_range) {
            cx += o.bx;
            cy += o.by;
            count++;
        }
    }
    if (count > 0) {
        cx /= count;
        cy /= count;
        b.vx += (cx - b.bx) * centering_factor;
        b.vy += (cy - b.by) * centering_factor;
    }

    // --- Rule 2: Avoid crowding
    var move_x = 0;
	var move_y = 0;
	for (var j = 0; j < boid_count; j++) {
	    if (i == j) continue;
	    var o = boids[j];
	    var dx = b.bx - o.bx;
	    var dy = b.by - o.by;
	    var dist = sqrt(dx * dx + dy * dy);
	    if (dist > 0 && dist < min_distance) {
	        // Push harder when closer
	        var strength = (min_distance - dist) / min_distance;
	        move_x += (dx / dist) * strength;
	        move_y += (dy / dist) * strength;
	    }
	}
	// Apply stronger avoidance force
	b.vx += move_x * avoid_factor * 1.5;
	b.vy += move_y * avoid_factor * 1.5;

    // --- Rule 3: Match nearby velocity
    var avg_vx = 0;
    var avg_vy = 0;
    count = 0;
    for (var j = 0; j < boid_count; j++) {
        if (i == j) continue;
        var o = boids[j];
        var dx = b.bx - o.bx;
        var dy = b.by - o.by;
        var dist = sqrt(dx * dx + dy * dy);
        if (dist < visual_range) {
            avg_vx += o.vx;
            avg_vy += o.vy;
            count++;
        }
    }
    if (count > 0) {
        avg_vx /= count;
        avg_vy /= count;
        b.vx += (avg_vx - b.vx) * matching_factor;
        b.vy += (avg_vy - b.vy) * matching_factor;
    } 

    // --- Rule 4: Smooth border steering
    var steer_x = 0;
    var steer_y = 0;

    if (b.bx < margin) steer_x = turn_factor;
    else if (b.bx > screen_w - margin) steer_x = -turn_factor;

    if (b.by < margin) steer_y = turn_factor;
    else if (b.by > screen_h - margin) steer_y = -turn_factor;

    // Apply smoother steering force
    b.vx += steer_x * 0.2;
    b.vy += steer_y * 0.2;

    // --- Rule 5: Smooth acceleration limit
    var vmag = sqrt(b.vx * b.vx + b.vy * b.vy);
    var max_speed = speed_limit;

    if (vmag > max_speed) {
        var scale = max_speed / vmag;
        b.vx *= scale;
        b.vy *= scale;
    }
	
	// --- Rule 6: Avoid the shark ---
	if (instance_exists(obj_shark_controller)) {
	    var sx = obj_shark_controller.x;
	    var sy = obj_shark_controller.y;

	    var dx = b.bx - sx;
	    var dy = b.by - sy;
	    var dist = sqrt(dx * dx + dy * dy);

	    if (dist < 300) { // avoidance radius (adjust as needed)
	        var strength = (300 - dist) / 300; // stronger when closer
	        b.vx += (dx / dist) * strength * 3.0; // 3.0 = shark_avoid_factor
	        b.vy += (dy / dist) * strength * 3.0;
	    }
	}


    // --- Add subtle natural wobble
    var wobble_strength = 0.05;
    b.vx += random_range(-wobble_strength, wobble_strength);
    b.vy += random_range(-wobble_strength, wobble_strength);

    // --- Smoothly move toward target velocity
    b.bx += b.vx;
    b.by += b.vy;

    // --- Smoothly align facing with velocity
    if (vmag > 0.001) {
        var desired_fx = b.vx / vmag;
        var desired_fy = b.vy / vmag;
        var smooth_turn = 0.08;
        b.fx = lerp(b.fx, desired_fx, smooth_turn);
        b.fy = lerp(b.fy, desired_fy, smooth_turn);
        var fmag = sqrt(b.fx * b.fx + b.fy * b.fy);
        b.fx /= fmag;
        b.fy /= fmag;
    }
	
	
	b.image_index += b.image_speed;
	if (b.image_index >= 7) {
	    b.image_index = 0;
	}


    // --- Save updated boid
    boids[i] = b;
}
