 var vx = random_range(-5, 5);
    var vy = random_range(-5, 5);
    var vmag = sqrt(vx*vx + vy*vy);
    if (vmag < 0.0001) { vx = 1; vy = 0; vmag = 1; }

    var sprite_choice = fish_sprites[irandom(array_length(fish_sprites) - 1)];
    var group_letter = string_copy(sprite_get_name(sprite_choice), 10, 1);

    	var b = {
	    bx: mouse_x,
	    by: mouse_y,
	    vx: vx,
	    vy: vy,
	    fx: vx / vmag,
	    fy: vy / vmag,
	    sprite: sprite_choice,
	    group_letter: group_letter,
	    color: c_white,
	    size: random_range(0.6, 1.2),
	    image_index: 0,
	    image_speed: random_range(0.15, 0.3),
	    alpha: 1,   
	    fade_speed: 0,
	    remove_me: false,
		is_dying: false
	};
    array_push(boids, b);
	boid_count++;