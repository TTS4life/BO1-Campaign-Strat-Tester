#include common_scripts\utility;
#include maps\_utility;

main() {
	level.strat_tester_version = "0.1A";

    setDvar("st_version", level.strat_tester_version);
	setDvar("st_level", level.script);

	level.start_time = getTime();
	// level thread update_level_time();
    level thread update_game_time();

	level thread health_bar_hud();
	level thread player_angles_hud();

	
}

// mission_name(name) {
// 	switch name:
// 		case "cuba":
// 			return "Operation 40";
// 		case "vorkuta":
// 			return "Vorkuta";
// 		default:
// 			return level.script;
// }

//Mission index from Name
mission_index(name) {
	if( name == "cuba" ) {
		return 0;
	}
	if( name == "vorkuta") {
		return 1;
	}
}



update_game_time() {
	previous_mission_times = get_previous_mission_times(); //Only need to grab once
	while(1) {
		players = get_players()[0];
		level_time = getTime() - level.start_time;
		players setClientDvar("hud_level_time", seconds_to_string(level_time));
		players setClientDvar("st_" + level.script + "_time", level_time);
		players setClientDvar("hud_total_time", seconds_to_string(previous_mission_times + level_time));
		
		wait(.05);
	}
}

get_previous_mission_times() {
	
	if (level.script == "cuba") {
		return 0;
	}

	if(level.script == "vorkuta") {
		return getDvarInt("st_cuba_time");
	}
}


seconds_to_string(time) {
	seconds = int(time / 1000) % 60;
	minutes = int(time / 1000 / 60);
	milliseconds = time % 1000;
	time = "";

	if(seconds < 10) {
		seconds = "0" + seconds;
	}

	if(minutes < 10) {
		minutes = "0" + minutes;
	}


	if(milliseconds < 10 ) {
		milliseconds = "0" + milliseconds;
	}

	if(milliseconds < 100) {
		milliseconds = "0" + milliseconds;
	}

	time = minutes + ":" + seconds + "." + milliseconds;

	return time;
}

health_bar_hud()
{
	health_bar_width_max = 110;
	p = get_players()[0];

	while (1)
	{
		health_ratio = p.health / p.maxhealth;

		p SetClientDvar("st_hud_health_bar_value", p.health);
		p SetClientDvar("st_hud_health_bar_width", health_bar_width_max * health_ratio);

		wait 0.05;
		
	}
}

player_angles_hud() {
	player = get_players()[0];
	while(1) {
		angles = player getPlayerAngles();
		player setClientDvar("st_hud_xang", angles[0]);
		player setClientDvar("st_hud_yang", angles[1]);
		player setClientDvar("st_hud_zang", angles[2]);

		pos = player getOrigin();
		player setClientDvar("st_hud_xpos", pos[0]);
		player setClientDvar("st_hud_ypos", pos[1]);
		player setClientDvar("st_hud_zpos", pos[2]);

		speed = 0;
		speed = player getVelocity();
		// iprintln("Speed: " + speed);

		speed = sqrt( pow(speed[0], 2) + pow(speed[1], 2) + pow(speed[2], 2) );
		player setClientDvar("st_hud_pspeed", speed);

		wait(.05);
	}
}

pow( base, exp )
{
	if(exp < 0) {
		return -1;
	}

	if ( exp == 0 )
	{
		return 1;
	}
		
	return base * pow( base, exp - 1 );
}