 var dir = irandom(359);
    var s = {
        x: mouse_x,
        y: mouse_y,
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