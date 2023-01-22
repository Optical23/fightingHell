// Create events are events that set the starting values for object when the game is created or object is

horz_spd = 0;
vert_spd = 0;
spd = 1.2;
hp = 100;

state = PLAYERSTATE.FREE;
enemyHit = ds_list_create();


enum PLAYERSTATE {
	FREE,
	ATTACK,
	ROLL,
}