/// Draw Event
draw_clear(c_aqua);
draw_sprite(spr_background_sand,0,0,0)
draw_set_colour(c_black);
draw_text(32, 32, "FPS = " + string(fps));

for (var i = 0; i < boid_count; i++) {
    var b = boids[i];

    var angle = point_direction(0, 0, b.fx, b.fy); // angle based on facing direction

    // You can scale them slightly differently for variety
    var scale = b.size; 

    // Draw with rotation and scale
    draw_sprite_ext(b.sprite, b.image_index, b.bx, b.by, scale*1.2, scale*1.2, angle, b.color, 1);
}
