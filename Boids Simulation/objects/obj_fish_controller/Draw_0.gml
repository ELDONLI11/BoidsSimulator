/// Draw Event
draw_clear(c_aqua);
draw_sprite(spr_background_sand,0,0,0)
draw_set_colour(c_black);
// Draw GUI Event

// Draw FPS
draw_text(32, 32, "FPS = " + string(fps));

// Draw fish count
var fish_ctrl = instance_find(obj_fish_controller, 0);
var fish_count = 0;
if (fish_ctrl != noone) {
    fish_count = array_length(fish_ctrl.boids);
}
draw_text(32, 52, "Fish = " + string(fish_count));

// Draw shark count
var shark_ctrl = instance_find(obj_shark_controller, 0);
var shark_count = 0;
if (shark_ctrl != noone) {
    shark_count = array_length(shark_ctrl.sharks);
}
draw_text(32, 72, "Sharks = " + string(shark_count));


for (var i = 0; i < boid_count; i++) {
    var b = boids[i];

    var angle = point_direction(0, 0, b.fx, b.fy); // angle based on facing direction

    // You can scale them slightly differently for variety
    var scale = b.size; 

    // Draw with rotation and scale
    //draw_sprite_ext(b.sprite, b.image_index, b.bx, b.by, scale*1.2, scale*1.2, angle, b.color, 1);
	
	draw_sprite_ext(b.sprite, floor(b.image_index), b.bx, b.by, b.size, b.size, point_direction(0, 0, b.fx, b.fy), b.color, b.alpha);

}
