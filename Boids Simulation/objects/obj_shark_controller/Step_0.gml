// --- Detect fish in front ---
var fish_in_front = 0;
var avg_fx = 0;
var avg_fy = 0;

// Get the instance of the fish controller
var fish_ctrl = instance_find(obj_fish_controller, 0);

if (fish_ctrl != noone && variable_instance_exists(fish_ctrl, "boids")) {
    var boids = fish_ctrl.boids;
    var boid_count = array_length(boids);

    for (var i = 0; i < boid_count; i++) {
        var b = boids[i];
        if (!is_struct(b)) continue;

        var fx = b.bx;
        var fy = b.by;
        var dist = point_distance(x, y, fx, fy);

        if (dist < fish_detect_distance) {
            var angle_to_fish = point_direction(x, y, fx, fy);
            var diff = abs(angle_difference(angle_to_fish, direction));
            if (diff < fish_detect_angle) {
                fish_in_front++;
                avg_fx += fx;
                avg_fy += fy;
            }
        }
    }
}

// --- Cooldown handling ---
if (!variable_instance_exists(self, "lunge_cooldown")) lunge_cooldown = 0;
if (lunge_cooldown > 0) lunge_cooldown--;

// --- Attempt lunge ---
if (!is_lunging && lunge_cooldown <= 0 && fish_in_front >= fish_trigger_count) {
    is_lunging = true;

    // Randomize lunge duration
    lunge_duration = irandom_range(25, 35);
    lunge_timer = lunge_duration;

    // Start at current speed and ramp up
    lunge_target_speed = lunge_speed;
    lunge_accel = (lunge_target_speed - normal_speed) / 6; // controls how quickly it accelerates

    image_speed = 0.4;

    // --- Aim toward the average fish position, but turn smoothly ---
    if (fish_in_front > 0) {
        avg_fx /= fish_in_front;
        avg_fy /= fish_in_front;
        desired_direction = point_direction(x, y, avg_fx, avg_fy);
    }

    // --- Set cooldown after this lunge ---
    lunge_cooldown = irandom_range(100,150); // ≈3 seconds
}

// --- Handle lunge timing ---
if (is_lunging) {
    // Smoothly speed up to lunge speed
    speed = lerp(speed, lunge_target_speed, 0.25);

    lunge_timer--;
    if (lunge_timer <= 0) {
        is_lunging = false;
        // Start a slowdown phase instead of instantly returning
        slowdown_timer = 40; // controls how long the slowdown lasts
    }
}
else {
    // --- Smooth slowdown after lunge ---
    if (variable_instance_exists(self, "slowdown_timer") && slowdown_timer > 0) {
        slowdown_timer--;
        speed = lerp(speed, normal_speed, 0.05); // slow easing back to normal
    } else {
        speed = normal_speed;
    }
}

// --- Movement ---
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// --- Wandering movement (only when not lunging) ---
if (!is_lunging) {
    wander_timer += random(wander_change);
    if (wander_timer > 1) {
        desired_direction = direction + irandom_range(-30, 30);
        wander_timer = 0;
    }
}

// --- Avoid walls smoothly ---
if (x < avoid_margin) desired_direction = 0;
if (x > room_width - avoid_margin) desired_direction = 180;
if (y < avoid_margin) desired_direction = 270;
if (y > room_height - avoid_margin) desired_direction = 90;

// --- Smooth turning toward desired direction ---
if (variable_instance_exists(self, "desired_direction")) {
    var diff = angle_difference(desired_direction, direction);
    var turn_rate = (is_lunging) ? turn_speed * 2 : turn_speed; // turn faster while lunging
    direction += clamp(diff, -turn_rate, turn_rate);
}

// --- Keep direction normalized ---
direction = angle_wrap(direction);

// --- Helper functions ---
function angle_wrap(a) {
    while (a < 0) a += 360;
    while (a >= 360) a -= 360;
    return a;
}

function angle_difference(target, current) {
    var diff = target - current;
    diff = (diff + 540) mod 360 - 180;
    return diff;
}
