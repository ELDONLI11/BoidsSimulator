/// Shark controller initialization

shark_count = 3; // number of sharks
sharks = [];

// Shark behavior settings
normal_speed = 2.5;
lunge_speed = 7.0;
lunge_duration_range = [25, 35];
fish_detect_distance = 300;
fish_detect_angle = 20;
fish_trigger_count = 15;
wander_change = 0.05;
turn_speed = 1;
avoid_margin = 300;
slowdown_time = 40;

// Initialize sharks
for (var i = 0; i < shark_count; i++) {
    var dir = irandom(359);
    var s = {
        x: random(room_width),
        y: random(room_height),
        direction: dir,
        speed: normal_speed,
        is_lunging: false,
        lunge_timer: 0,
        lunge_cooldown: irandom_range(0, 150),
        slowdown_timer: 0,
        desired_direction: dir,
        image_index: 0,
        image_speed_timer: 0
    };
    array_push(sharks, s);
}

