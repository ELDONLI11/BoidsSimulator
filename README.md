<img width="2535" height="1269" alt="image" src="https://github.com/user-attachments/assets/33795d20-30c8-487e-b60a-e49a1eda3465" />
Fish Swarm Boid Simulation (GameMaker / GML)

This is a 2D physics and swarm simulation I built in GameMaker using GML (GameMaker Language) as a Computer Science Special Topics project. It uses Craig Reynolds' classic Boids algorithm to make a bunch of fish swim in realistic schools, react to the sharks, and smoothly curve when they hit the edges of the room.

The main goal of the project was to show how you can get really complex, lifelike group behaviors just by giving individual objects a few simple, local rules to follow.

Features

Organic Schooling: The fish automatically find each other and form schools without any central controller telling them where to go.

Scattering from Sharks: I added sharks that swim around randomly. If the fish get too close, they immediately scatter and then try to regroup somewhere safe.

No Overlapping: I tuned the separation forces so the fish and sharks don't clip through each other, which makes the movement look a lot more natural.

Smart Borders: Instead of just wrapping around the screen which looked weird, the fish and sharks detect when they are getting close to the walls and smoothly steer away.

Custom Vector Math: GameMaker doesn't have a ton of built-in vector functions, so I wrote a custom Vector2 struct and math utility directly into the code to handle all the physics forces.

How It Works

Every single frame, each fish (obj_fish) looks at its surroundings and calculates four main forces to decide where to swim:

Separation (Weight: 1.8): If a fish gets too close to its neighbors, it pushes away so they don't overlap.

Alignment (Weight: 1.0): The fish tries to point itself in the same general direction as the other fish around it.

Cohesion (Weight: 1.2): The fish feels a pull toward the center of the local group so they clump up instead of drifting apart.

Shark Avoidance (Weight: -2.5): If a shark gets inside a fish's bubble, the fish applies a strong negative force to swim in the opposite direction.

Both the fish and the sharks also check their distance from the room borders. If they enter the border_margin, a steering force kicks in to push them back toward the center of the room.

Code & Technical Details

Vector Structs: I used GameMaker’s lightweight constructor templates (new Vector2()) to handle the math (adding, subtracting, normalising, and limiting vectors). It keeps the code much cleaner than trying to manage separate x and y variables for every single force.

Optimization: Since looping through every fish for every other fish can slow things down, I used GameMaker's with() statement blocks to quickly check distances. It runs super smoothly at 60 FPS even with 100+ fish on screen.

How to Set It Up in GameMaker

If you want to run this yourself, here is how to set up the project:

Get the Sprites Ready:

Create a fish sprite facing Right and name it spr_fish. Set the origin to Middle Center.

Create a shark sprite also facing Right and name it spr_shark. Set the origin to Middle Center.

Create the Objects:

Create obj_fish and give it the spr_fish sprite. Copy the code from obj_fish.gml into the Create Event, and obj_fish_step.gml into the Step Event.

Create obj_shark and give it the spr_shark sprite. Copy the code from obj_shark.gml into its Create Event, and put the rest of its movement/alarm logic in the Step Event and Alarm 0 Event.

Build the Room:

Create a normal room (something like $1366 \times 768$ or $1920 \times 1080$ works best).

Put about 100 to 150 obj_fish instances in the room, and throw in 2 or 3 obj_shark instances.

Hit F5 to compile and run!

Tweaking the Simulation

You can easily change how the school behaves by opening the Create Event of obj_fish and messing with these variables:

separation_force = 1.8; // Turn this up to make fish stay further apart
alignment_force  = 1.0; // Turn this up to make them align directions quicker
cohesion_force   = 1.2; // Turn this up for super tight-knit schools
avoid_force      = 2.5; // Turn this up to make them explode away from sharks faster
perception_radius = 50; // How far the fish can "see" things around them
