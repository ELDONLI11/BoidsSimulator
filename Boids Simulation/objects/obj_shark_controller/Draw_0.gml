/// Draw Event — Draw all sharks

for (var i = 0; i < array_length(sharks); i++) {
    var s = sharks[i];

    // Optional: you could scale sharks differently if desired
    var scale = 1; // or random/assigned per shark in Create Event

    // Draw shark with rotation and scale
    draw_sprite_ext(
        spr_shark,       // the shark sprite
        s.image_index,   // the shark's current frame
        s.x,             // x position
        s.y,             // y position
        scale,           // horizontal scale
        scale,           // vertical scale
        s.direction,     // facing direction
        c_white,         // color
        1                // alpha
    );
}
