---@diagnostic disable: lowercase-global, unused-local, missing-return

-- This file was created manually and will need to be updated by hand in future

-- functions:
---@alias brain_function fun(body: body): brain
---@alias spawn_function fun(body_id: body_id, x: number, y: number): number[]

-- psuedo classes:

---Internally an *integer*
---@class body_id

---Internally an *integer*
---@class cell_id

---Internally a *string*
---@class id: string

---@alias mutation_id
---| 0 MUT_CHAIN_LIGHTNING
---| 1 MUT_BUDDING
---| 2 MUT_EXPLOSIVE_RESISTANCE
---| 3 MUT_MUTAGENIC_POISON
---| 4 MUT_CELL_COMBINE
---| 5 MUT_REBIRTH
---| 6 MUT_DRIFTING

---A value of 0 indicates a failure of some kind
---@alias maybe_body_id body_id | 0

---A value of -1 indicates a failure of some kind
---@alias maybe_cell_id cell_id | -1

---A value of 0 indicates a different failure of some kind
---@alias dual_maybe_cell_id maybe_cell_id | 0

-- base classes:

---Represents a creature in the world
---@class (exact) body
---@field id body_id The id of this body
---@field creature_id integer The id of the creature type for this body
---@field parent_id maybe_body_id The body id of the body this broke away from. This is 0 for creatures spawned at the start of the world.
---@field team integer The team the creature is on. Currently only 1 and 2 are used for used for the enemy and player teams, but this could expand for multiple creature factions
---@field com_x number Center of mass for the body `x`
---@field com_y number Center of mass for the body `y`
---@field vel_x number Velocity of the center of mass for the body `x`
---@field vel_y number Velocity of the center of mass for the body `y`
---@field cost_center_x number Like a center of mass, but weighted by cell cost instead of mass `x`
---@field cost_center_y number Like a center of mass, but weighted by cell cost instead of mass `y`
---@field dir_x number The normalized average direction for all cells in the body `x`
---@field dir_y number The normalized average direction for all cells in the body `x`
---@field angular_velocity number The rate at which the dir_x/y vector is rotating
---@field spawn_x number The spawn location for this body `x`
---@field spawn_y number The spawn location for this body `y`
---@field wall_dist number The value of the wall distance function for the body's cell which is closest to a wall.
---@field wall_dx number The normalized direction away from the nearest wall. `x`
---@field wall_dy number The normalized direction away from the nearest wall. `y`
---@field flow_x number The flow at the location of the cell nearest to a wall `x`
---@field flow_y number The flow at the location of the cell nearest to a wall `y`
---@field total_collision_force number The total force of all collsions between this body's cells and walls/other cells. This is the sum of the magnitudes, not a vector so it can be used to determine if the body is colliding even if the net force is 0
---@field mass number The total mass for all living cells in this body
---@field health number The total stored biomass for all living cells in this body
---@field max_health number The total stored biomass for all cells in the body plan
---@field cost number The total biomass cost for all living cells in this body
---@field max_cost number The highest total cell cost this body has had
---@field age number How many frames this body has been alive
---@field xp number How much xp this body has
---@field values number[] A 32 long list of numbers that you can use to store whatever you want. All 0 by default

---Represents a cell in the world
---@class (exact) cell
---@field id cell_id The id of the cell
---@field body_id body_id The id of the body this cell belongs to
---@field q integer The hex coordinates of the cell in its body's body plan `x`
---@field r integer The hex coordinates of the cell in its body's body plan `y`
---@field x number The coordinates of the cell `x`
---@field y number The coordinates of the cell `y`
---@field vel_x number The velocity of the cell `x`
---@field vel_y number The velocity of the cell `y`
---@field rot_x number The orientation of the cell, based on the average directions of its neighbors relative to their directions in the body plan. This is relative to the body plan coordinates. a rot of (1, 0) means that the body coordinates are aligned with the world coordinates. `x`
---@field rot_y number The orientation of the cell, based on the average directions of its neighbors relative to their directions in the body plan. This is relative to the body plan coordinates. a rot of (1, 0) means that the body coordinates are aligned with the world coordinates. `y`
---@field curl_x number This is used to figure out how much a cell should contribute to turning. Pressing A makes each cell accelerate in the +curl direction and pressing D makes them accelerate in the -curl direction. Calculated based on their open sides and the curls of neighboring cells. `x`
---@field curl_y number This is used to figure out how much a cell should contribute to turning. Pressing A makes each cell accelerate in the +curl direction and pressing D makes them accelerate in the -curl direction. Calculated based on their open sides and the curls of neighboring cells. `y`
---@field cell_type_index integer The index in the cell type list for this cell's cell type
---@field maturity number Starts at 0 when the cell first spawns and goes to 1 as the cell grows. This represents the fraction of it's biomass cost the cell has consumed. Most cell abilities only work at full maturity
---@field health number The stored biomass in the cell
---@field voltage number The cell's voltage
---@field dvoltage number The rate of change of the voltage, currently only used by inductive cells
---@field shock number The shock value of the cell
---@field poison number The amount of poison in the cell
---@field mutagen number The amount of mutagenic poison in the cell
---@field value number A general purpose variable used by certain cell types
---@field mass number The mass of the cell
---@field phasing number The amount of phasing the cell has, 0 is not phasing and 1 is a normally powered phasing cell
---@field stickyness number The stickyness of the cell
---@field attached_id dual_maybe_cell_id The cell id of the cell this cell is stuck to, -1 if it is stuck to a wall, or 0 if it is not stuck to anything
---@field light_radius number The light radius of the cell
---@field color_r number The color of the cell `r`
---@field color_g number The color of the cell `g`
---@field color_b number The color of the cell `b`
---@field color_a number The color of the cell `a`

---@class (exact) brain
---@field movement number? The forward/backward movement of the creature, equivalent to pressing W/S. This is clamped to [-1,1]
---@field rotation number? The turning of the creature, equivalent to pressing A/D. This is clamped to [-1,1]
---@field grab_target_x number? The x and y coordinates of the target for seeker cells, multiply this by your grab_weight if grab_weight is not 1 or 0 `x`
---@field grab_target_y number? The x and y coordinates of the target for seeker cells, multiply this by your grab_weight if grab_weight is not 1 or 0 `y`
---@field grab_weight number? Usually you just want to set this to 1 to activate seeker cells. Any non-zero value will activate seeker cells.  The reason this is here is so multiple sources can influence the grab target, and they all get averaged together later by dividing by the total grab_weight. For example you could multiply grab_target_x/y and grab_weight by some number to adjust how much your input is weighted compared to a neuron's.
---@field grab_dir number? 1 by default, set to -1 to make seeker cells repel from the target point
---@field ability boolean? true/false to activate the creature's ability or not
---@field values number[]? A list of 32 numbers that you can use to store whatever you want, Any values you don't set will retain their previous value

---@class (exact) dist_body: body
---@field dist number

---Returns a random int uniformly distributed on [min, max)
---@param min number `0`
---@param max number `1`
---@return number value
function rand_int(min, max) end

---Returns a random number uniformly distributed on [min, max]
---@param min number `0`
---@param max number `1`
---@return number value
function rand_float(min, max) end

---Returns a random number from a normal distribution
---@return number value
function rand_normal() end

---`dist`: The value of the wall distance field, < 0 inside a wall and > 0 outside a wall
---`dx`, `dy`: The normalized direction away from the wall
---`flow_x`, `flow_y`: The velocity of the stream flow
---@param x number
---@param y number
---@return number dist, number dx, number dy, number flow_x, number flow_y
function wall_map(x, y) end

---@param ax number The x coordinate of the first point
---@param ay number The y coordinate of the first point
---@param bx number The x coordinate of the second point
---@param by number The y coordinate of the second point
---@param r number `0.0` The radius that is swept out when performing the line of sight check
---@return boolean can_see true if there are no walls within radius r of the line between a & b, false otherwise
function line_of_sight(ax, ay, bx, by, r) end

---@param body_id body_id The body id of the body to search around
---@param range number The maximum range to find bodies within, the upper limit is 1000
---@param no_children boolean `false` If true, parts that broke off of creatures will be ignored, if false only the children of this body will be returned (temporary performance fix)
---@param ignored_team integer? `nil` If set, bodies on this team will not be returned
---@return dist_body[] bodies In addition to the normal body properties, each body will contain an entry called dist, which contains the distance away from the searching body
function get_visible_bodies(body_id, range, no_children, ignored_team) end

---@param id body_id
---@return body?
function get_body_info(id) end

---@param body_id body_id
---@param q integer
---@param r integer
---@param use_closest boolean `false`
---@return maybe_cell_id? id If the specified cell is not alive, and use_closest is true, then the id of the closest living cell will be returned instead. This function will return nil if the body does not exist, or if use_closest is false and the cell does not exist. A cell id of -1 means the cell is alive but the body is outside of the loading radius.
function get_body_cell_id(body_id, q, r, use_closest) end

---@param id cell_id
---@return cell? cell Returns nil if the cell does not exist
function get_cell_info(id) end

---Registers a creature type with the specified parameters. This is only intended for use in creature_list().
---@param id id A 4 character string that will be used as the id for this creature type
---@param body_plan_filename string The filename of the .bod file for the creature's body plan. The path is relative to the exe location
---@param brain_function string? `nil` The name of the (global) lua function that simulates the creature's brain. The function is of type `brain_function`
---@param spawn_function string? `nil` The name of the (global) lua function that is called when the creature is spawned. The function is of type `spawn_function`
function register_creature(id, body_plan_filename, brain_function, spawn_function) end

---Gives the specified mutation to the specified body
---@param body_id body_id
---@param mutation_id mutation_id
function give_mutation(body_id, mutation_id) end

---Adds a chance per map hex for the specified creature to spawn in the specified biome
---@param biome_id id
---@param creature_id id
---@param chance number The chance per hex for the creature to spawn. The spawn chances for all creatures will be added together to get the chance for any creature to spawn, and the individual chances will be a weight to choose which creature to spawn
---@param xp integer The experience that this creature should drop
function add_creature_spawn_chance(biome_id, creature_id, chance, xp) end

---Like add_creature_spawn_chance, but it will only spawn on walls, and can spawn multiple per map hex.
---@param biome_id id
---@param creature_id id
---@param chance number The chance per roll per hex for the creature to spawn. The spawn chances for all creatures will be added together to get the chance for any plant to spawn, and the individual chances will be a weight to choose which plant to spawn. Each hex performs this check 3 times, so up to 3 plants can spawn per hex
---@param xp integer The experience that this creature should drop
function add_plant_spawn_chance(biome_id, creature_id, chance, xp) end
