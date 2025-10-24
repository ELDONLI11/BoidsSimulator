/// Create Event (boid init)
boid_count = 150;
visual_range = 50;
boids = [];
direction = irandom(359);
 
/// Boid behavior settings
centering_factor = 0.01;
avoid_factor = 0.75;
matching_factor = 0.05;
speed_limit = 3;
margin = 300;
turn_factor = 0.5;
min_distance = 20;
 
/// Smooth facing update
turn_rate = 0.075;
facing_eps = 0.0001;
 
/// Screen size
screen_w = room_width;
screen_h = room_height;
 
for (var i = 0; i < boid_count; i++) {
    var vx = random_range(-5, 5);
    var vy = random_range(-5, 5);
    var vmag = sqrt(vx*vx + vy*vy);
    if (vmag < 0.0001) { vx = 1; vy = 0; vmag = 1; }

    var b = {
        bx: random(screen_w),
        by: random(screen_h),
        vx: vx,
        vy: vy,
        fx: vx / vmag,
        fy: vy / vmag,

        // NEW: Add variety
        sprite: spr_fish2, // or choose randomly from an array of fish sprites
        color: make_color_hsv(irandom_range(0, 360), 240, 255),
        size: random_range(0.6, 1.2),
        image_index: 0,
        image_speed: random_range(0.15, 0.3)
    };
    array_push(boids, b);
}
