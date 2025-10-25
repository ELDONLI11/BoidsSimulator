/// --- Boid Settings ---
boid_count = 1000;
visual_range = 50;
min_distance = 20;
centering_factor = 0.01;
avoid_factor = 0.75;
matching_factor = 0.05;
speed_limit = 3;
margin = 300;
turn_factor = 0.5;
turn_rate = 0.075;
facing_eps = 0.0001;

/// --- Screen size ---
screen_w = room_width;
screen_h = room_height;

/// --- Grid for spatial partitioning ---
grid_size = visual_range;
grid_cols = ceil(screen_w / grid_size);
grid_rows = ceil(screen_h / grid_size);

// Create the grid as a 2D array of preallocated empty arrays
grid = array_create(grid_cols, 0);
for (var c = 0; c < grid_cols; c++) {
    grid[c] = array_create(grid_rows, 0);
    for (var r = 0; r < grid_rows; r++) {
        grid[c][r] = [];
    }
}

/// --- Fish sprites ---
fish_sprites = [
    spr_fish_e1, spr_fish_b6, spr_fish_e2, spr_fish_c2, spr_fish_e3,
    spr_fish_e4, spr_fish_a3, spr_fish_d2, spr_fish_a1, spr_fish_b1,
    spr_fish_b2, spr_fish_d1, spr_fish_b4, spr_fish_b3, spr_fish_a2,
    spr_fish_c1, spr_fish_b5
];

/// --- Create Boids ---
boids = [];
for (var i = 0; i < boid_count; i++) {
    var vx = random_range(-5, 5);
    var vy = random_range(-5, 5);
    var vmag = sqrt(vx*vx + vy*vy);
    if (vmag < 0.0001) { vx = 1; vy = 0; vmag = 1; }

    var sprite_choice = fish_sprites[irandom(array_length(fish_sprites)-1)];
    var group_letter = string_copy(sprite_get_name(sprite_choice), 10, 1);

    var b = {
        bx: random(screen_w),
        by: random(screen_h),
        vx: vx,
        vy: vy,
        fx: vx / vmag,
        fy: vy / vmag,
        sprite: sprite_choice,
        group_letter: group_letter,
        color: c_white,
        size: random_range(0.6, 1.2),
        image_index: 0,
        image_speed: random_range(0.15, 0.3)
    };
    array_push(boids, b);
}
