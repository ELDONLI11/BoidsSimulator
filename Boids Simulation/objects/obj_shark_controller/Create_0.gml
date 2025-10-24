// Shark variables
randomise();
speed = 2.5;
direction = irandom(359);

wander_timer = 0;
avoid_margin = 300;
avoid_strength = 30;
image_index_shark=0;


turn_speed = 1;
wander_change = 0.05;

normal_speed = 2.5;
lunge_speed = 10.0; // speed when lunging
lunge_duration = 300; // frames to stay lunging
fish_detect_distance = 500; // how far shark can "see"
fish_detect_angle = 45; // degrees from center direction
fish_trigger_count = 3; // how many fish needed to trigger a lunge
alarm_set(0,2)

