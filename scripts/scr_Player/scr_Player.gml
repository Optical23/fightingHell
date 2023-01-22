// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function inputs(){
	//Taking inputs from keyboard
	key_left = keyboard_check(ord("A"));
	key_right = keyboard_check(ord("D"));
	key_up = keyboard_check(ord("W"));
	key_down = keyboard_check(ord("S"));
	key_attack = keyboard_check(ord("E"));
	key_roll = keyboard_check_pressed(vk_lshift);
	
	//Pressing a key gives a number value by subtracting them when the game goes to get 
	//an input by subtracting them it'll come back as -1 to 1
	x_input = key_right - key_left;
	y_input = key_down - key_up;
	
	
		
}
function player_movement(){
	//a check so this code doesn't run unless an input is happening
	if(x_input != 0 || y_input !=0){
		
	dir = point_direction(0,0,x_input,y_input);
	horz_spd = lengthdir_x(spd, dir);
	vert_spd = lengthdir_y(spd, dir);
	
	if(key_roll){
		state = PLAYERSTATE.ROLL;
	}
	
	}else{
		horz_spd = 0;
		vert_spd = 0;
	}
	
	if(key_attack) {
		state = PLAYERSTATE.ATTACK;
	}
	//Animation
	if(horz_spd != 0){
		image_xscale = sign(horz_spd) * 0.5;
		sprite_index = sprPlayer_run;
	}
	if(vert_spd != 0){
		sprite_index = sprPlayer_run;
	}
	if(vert_spd == 0 && horz_spd == 0){
		sprite_index = sprPlayer;
	}
}

function player_roll(){
	
	if(sprite_index != sprPlayer_roll){
		x_direction = x_input;
		y_direction = y_input;
		sprite_index = sprPlayer_roll;
		image_index = 0;
	}
	dir = point_direction(0,0,x_direction,y_direction);
	horz_spd = lengthdir_x(spd*1.5, dir);
	vert_spd = lengthdir_y(spd*1.5, dir);
	if (animation_end()){
		sprite_index = sprPlayer;
		state = PLAYERSTATE.FREE;
	}
}

function player_attack(){
	horz_spd = 0;
	vert_spd = 0;
	dir = image_xscale;
	if(sprite_index != sprPlayer_attack){
		sprite_index = sprPlayer_attack;
		image_index = 0;
		ds_list_clear(enemyHit);
	}
	
	//Attack hitbox, checking for hits
	mask_index = sprPlayer_attack_hitbox;
	var hitByAttackNow = ds_list_create();
	var hits = instance_place_list(x,y,oEnemy,hitByAttackNow,false);
	if(hits > 0){
		for(var i = 0; i < hits; i++){
			//If instance has not yet been hit by this attack
			var hitID = ds_list_find_value(hitByAttackNow, i); 
			if (ds_list_find_index(enemyHit,hitID) == -1){
				ds_list_add(enemyHit,hitID);
				with (hitID){
					EnemyTakeDamage(2);
					x += oPlayer.image_xscale * 10;
				}
			}
		}
	}
	ds_list_destroy(hitByAttackNow);
	mask_index = sprPlayer;
	
	if(animation_end()){
		sprite_index = sprPlayer;
		state = PLAYERSTATE.FREE;
	}
}

function EnemyTakeDamage(){
	var _damage = argument0;
	hp -= _damage;
	if(hp > 0){
		state = ENEMYSTATE.HIT;
		animate_hit = true;
	}else{
		state = ENEMYSTATE.DEAD;
		animate_dead = true;
	}
		
}