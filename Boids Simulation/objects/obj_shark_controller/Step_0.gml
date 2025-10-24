// --- Persistent variables ---
if (!variable_instance_exists(self, "is_lunging")) is_lunging = false;
if (!variable_instance_exists(self, "lunge_timer")) lunge_timer = 0;
if (!variable_instance_exists(self, "desired_direction")) desired_direction = direction;

// --- Detect fish in front ---
var fish_in_front = 0;
with (obj_fish_controller) {
    var dx = x - other.x;
    var dy = y - other.y;
    var dist = point_distance(other.x, other.y, x, y);

    if (dist < other.fish_detect_distance) {
        var angle_to_fish = point_direction(other.x, other.y, x, y);
        var diff = abs(angle_difference(angle_to_fish, other.direction));
        if (diff < other.fish_detect_angle) {
            fish_in_front++;
        }
    }
}

// --- Trigger lunge if enough fish detected ---
if (!is_lunging && fish_in_front >= fish_trigger_count) {
    is_lunging = true;
    lunge_timer = lunge_duration;
    speed = lunge_speed;
}

// --- Handle lunge timing ---
if (is_lunging) {
    lunge_timer--;
    if (lunge_timer <= 0) {
        is_lunging = false;
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
if (x < avoid_margin) desired_direction = 0; // too far left → turn right
if (x > room_width - avoid_margin) desired_direction = 180; // too far right → turn left
if (y < avoid_margin) desired_direction = 270; // too high → go down
if (y > room_height - avoid_margin) desired_direction = 90; // too low → go up

// --- Smooth turning toward desired direction ---
if (variable_instance_exists(self, "desired_direction")) {
    var diff = angle_difference(desired_direction, direction);
    direction += clamp(diff, -turn_speed, turn_speed);
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