var fish_ctrl = instance_find(obj_fish_controller, 0);
var boids = [];
var boid_count = 0;
if (fish_ctrl != noone && variable_instance_exists(fish_ctrl, "boids")) {
    boids = fish_ctrl.boids;
    boid_count = array_length(boids);
}





for (var i = 0; i < array_length(sharks); i++) {
    var s = sharks[i];

    // --- Detect fish in front ---
    var fish_in_front = 0;
    var avg_fx = 0;
    var avg_fy = 0;

    for (var j = 0; j < boid_count; j++) {
        var b = boids[j];
        var fx = b.bx;
        var fy = b.by;
        var dist = point_distance(s.x, s.y, fx, fy);

        if (dist < fish_detect_distance) {
            var angle_to_fish = point_direction(s.x, s.y, fx, fy);
            var diff = abs(angle_difference(angle_to_fish, s.direction));
            if (diff < fish_detect_angle) {
                fish_in_front++;
                avg_fx += fx;
                avg_fy += fy;
            }
        }
    }

    // --- Cooldown ---
    if (!variable_instance_exists(s, "lunge_cooldown")) s.lunge_cooldown = 0;
    if (s.lunge_cooldown > 0) s.lunge_cooldown--;

    // --- Attempt lunge ---
    if (!s.is_lunging && s.lunge_cooldown <= 0 && fish_in_front >= fish_trigger_count) {
        s.is_lunging = true;
        s.lunge_timer = irandom_range(lunge_duration_range[0], lunge_duration_range[1]);
        s.lunge_target_speed = lunge_speed;
        s.lunge_accel = (s.lunge_target_speed - normal_speed) / 6;

        if (fish_in_front > 0) {
            avg_fx /= fish_in_front;
            avg_fy /= fish_in_front;
            s.desired_direction = point_direction(s.x, s.y, avg_fx, avg_fy);
        }

        s.lunge_cooldown = irandom_range(100,150);
    }

    // --- Handle lunge timing ---
    if (s.is_lunging) {
        s.speed = lerp(s.speed, s.lunge_target_speed, 0.25);
        s.lunge_timer--;
        if (s.lunge_timer <= 0) {
            s.is_lunging = false;
            s.slowdown_timer = slowdown_time;
        }
    } else {
        if (variable_instance_exists(s, "slowdown_timer") && s.slowdown_timer > 0) {
            s.slowdown_timer--;
            s.speed = lerp(s.speed, normal_speed, 0.05);
        } else {
            s.speed = normal_speed;
        }
    }

    // --- Movement ---
    s.x += lengthdir_x(s.speed, s.direction);
    s.y += lengthdir_y(s.speed, s.direction);

    // --- Wandering ---
    if (!s.is_lunging) {
        s.desired_direction += random(wander_change);
        if (random(1) < wander_change) s.desired_direction += irandom_range(-30, 30);
    }

    // --- Avoid walls ---
    if (s.x < avoid_margin) s.desired_direction = 0;
    if (s.x > room_width - avoid_margin) s.desired_direction = 180;
    if (s.y < avoid_margin) s.desired_direction = 270;
    if (s.y > room_height - avoid_margin) s.desired_direction = 90;

    // --- Smooth turning ---
    var diff = angle_difference(s.desired_direction, s.direction);
    var turn_rate_adj = s.is_lunging ? turn_speed*2 : turn_speed;
    s.direction += clamp(diff, -turn_rate_adj, turn_rate_adj);
    s.direction = angle_wrap(s.direction);

    // --- Animate shark (inside loop!) ---
    if (!variable_instance_exists(s, "image_speed_timer")) s.image_speed_timer = 0;
    s.image_speed_timer++;
    var anim_speed = s.is_lunging ? 2 : 7;
    if (s.image_speed_timer >= anim_speed) {
        s.image_index = (s.image_index + 1) mod 4; // 4-frame sprite
        s.image_speed_timer = 0;
    }

    sharks[i] = s;
}

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
