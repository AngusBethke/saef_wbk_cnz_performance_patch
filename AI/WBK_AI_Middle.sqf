/*
	WBK_AI_Middle.sqf

	Description:
		Handles Middle Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Middle", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

private
[
	"_unitWithSword"
];

_unitWithSword = _this;

if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith {
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if is3DEN exitWith {
	private
	[
		"_rndMoveset"
	];

	_rndMoveset = selectRandom ["WBK_Middle_Idle_1","WBK_Middle_Idle"];
	_unitWithSword switchMove _rndMoveset;
	_unitWithSword setFace selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4","WBK_ZombieFace_1","WBK_ZombieFace_2","WBK_ZombieFace_3","WBK_ZombieFace_4","WBK_ZombieFace_5","WBK_ZombieFace_6"];
	systemChat "AI Loaded in Eden";
};

if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

// Set custom world war 2 sounds
[_unitWithSword] call WBK_AI_SetWW2CustomSounds;

// Set up zombie behaviour
[_unitWithSword] call WBK_AI_SetupDefaultZombieBehaviour;

// Set up zombie variables
[_unitWithSword] call WBK_AI_SetupDefaultZombieVariables;

// Set up the move sets
private
[
	"_rndMoveset"
];

_rndMoveset = selectRandom ["WBK_Middle_Idle_1","WBK_Middle_Idle"];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet",_rndMoveset, true];

if (_rndMoveset == "WBK_Middle_Idle_1") then 
{
	_unitWithSword setVariable ["WBK_AI_ZombieMoveSetRunningState","WBK_Middle_Run_1"];
}
else
{
	_unitWithSword setVariable ["WBK_AI_ZombieMoveSetRunningState","WBK_Middle_Run"];
};

[_unitWithSword, _rndMoveset] remoteExec ["switchMove", 0, true];

[_unitWithSword, selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4",
	"WBK_ZombieFace_1","WBK_ZombieFace_2","WBK_ZombieFace_3","WBK_ZombieFace_4",
	"WBK_ZombieFace_5","WBK_ZombieFace_6"]] remoteExec ["setFace", 0, true];

_unitWithSword spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

// Handle zombie death animations
_unitWithSword addEventHandler ["Killed", WBK_AI_DefaultKilledEventHandler];

// Add event handlers
[_unitWithSword] call WBK_AI_AddDefaulEventHandlers;

// Add hitpart event handler
[_unitWithSword, WBK_AI_DefaultHitPartEventHandler] remoteExec ["spawn", [0,-2] select isDedicated,true];

// Manage attack animations
private
[
	"_actFr"
];

_actFr = [{
	params ["_array"];
	_array params ["_mutant"];

	private
	[
		"_forbiddenCrawlerAnimStates",
		"_forbiddenAnimStates",
		"_forbiddenGestureStates",
		"_allowedAnimStates"
	];

	_forbiddenCrawlerAnimStates = ["WBK_Crawler_Attack", "WBK_Walker_Fall_Forward_Moveset_1", "WBK_Walker_Fall_Forward_Moveset_2", "WBK_Walker_Fall_Forward_Moveset_3", 
		"WBK_Walker_Fall_Back_Moveset_1", "WBK_Walker_Fall_Back_Moveset_2", "WBK_Walker_Fall_Back_Moveset_3"];

	_forbiddenAnimStates = ["WBK_Walker_Idle_1_attack", "WBK_Walker_Idle_2_attack", "WBK_Middle_TryingToCatch_1", "WBK_Middle_TryingToCatch",
		"WBK_Walker_TryingToCatch_success_1", "WBK_Walker_TryingToCatch_success_2", "WBK_Walker_TryingToCatch_success_3", "WBK_Middle_GetUpUnconscious",
		"WBK_Middle_GetUpUnconscious_1", "WBK_Middle_hit_b_1", "WBK_Middle_hit_b_2", "WBK_Middle_hit_f_2_1",
		"WBK_Middle_hit_f_2_2", "WBK_Middle_hit_f_1_1", "WBK_Middle_hit_f_1_2", "WBK_Runner_hit_f_2",
		"WBK_Runner_hit_f_1", "WBK_Middle_Fall_Forward", "WBK_Middle_Fall_Forward_1", "WBK_Middle_Fall_Back",
		"WBK_Middle_Fall_Back_1", "IMS_Rifle_Sync_Blunt_back_victim", "IMS_Rifle_Sync_Blunt_front_victim", "IMS_Rifle_Sync_Knife_back_reversed_victim",
		"IMS_Rifle_Sync_Knife_back_victim", "IMS_Rifle_Sync_Knife_front_reversed_victim", "IMS_Rifle_Sync_Knife_front_victim", "IMS_Rifle_Sync_Knife_front_victim_1",
		"IMS_Rifle_Sync_Player_1_victim", "IMS_Rifle_Sync_Player_2_victim"];

	_forbiddenGestureStates = ["WBK_Zombie_attack_Left", "WBK_Zombie_attack_Right"];

	_allowedAnimStates = ["WBK_CatchedByZombie_Front", "WBK_CatchedByZombie_Back", "IMS_Rifle_Sync_Blunt_back_main", "IMS_Rifle_Sync_Blunt_front_main",
			"IMS_Rifle_Sync_Knife_back_main", "IMS_Rifle_Sync_Knife_back_reversed_main", "IMS_Rifle_Sync_Knife_front_main", "IMS_Rifle_Sync_Knife_front_main_1",
			"IMS_Rifle_Sync_Knife_front_reversed_main", "IMS_Rifle_Sync_Player_1_main", "IMS_Rifle_Sync_Player_2_main", "IMS_KnifeExec_main",
			"IMS_KnifeExec_main_1", "IMS_Crawling_Away", "Human_Execution_Bayonet_main", "Human_Execution_Axe_main",
			"Human_Execution_Blunt_main", "Human_Execution_GenericHeavy_main", "Human_Execution_GenericOnehanded_headSmash_1_main", "Human_Execution_Shield_main"];

	[_mutant, _forbiddenCrawlerAnimStates, _forbiddenAnimStates, _forbiddenGestureStates, _allowedAnimStates, [2.6, 2.9], WBK_ZombieTryingToGrab_middle] call WBK_AI_SetupDefaultAttackAnimations;
}, 0.2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Life path, move to nearest enemy
private
[
	"_loopPathfindDoMove"
];

_loopPathfindDoMove = [WBK_AI_DefaultLoopPathfindDoMove, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Unconcious standup handler
[_unitWithSword] spawn WBK_AI_DefaultUnconStandUp;

waitUntil {
	sleep 0.5; 
	if (isNull _unitWithSword) exitWith { true };
	(!(alive _unitWithSword))
};

[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;

[_unitWithSword, {
	// Ensuring headless clients don't fall into this
	if (!hasInterface) exitWith {};

	_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated,true];
