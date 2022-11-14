/*
	WBK_AI_Runner.sqf

	Description:
		Handles Runner Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Runner", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

params
[
	"_unitWithSword",
	"_isCalm"
];

if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith {
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if is3DEN exitWith {
	if (_isCalm) then 
	{
		_unitWithSword switchMove "WBK_Runner_Calm_Idle";
	}
	else
	{
		_unitWithSword switchMove "WBK_Runner_Angry_Idle";
	};

	_unitWithSword setFace selectRandom ["WBK_ZombieFace_1","WBK_ZombieFace_2","WBK_ZombieFace_3","WBK_ZombieFace_4","WBK_ZombieFace_5","WBK_ZombieFace_6"];
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
if (_isCalm) then 
{
	_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Runner_Angry_Idle", true];
	[_unitWithSword, "WBK_Runner_Calm_Idle"] remoteExec ["switchMove", 0, true];
}
else
{
	_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Runner_Angry_Idle", true];
	[_unitWithSword, "WBK_Runner_Angry_Idle"] remoteExec ["switchMove", 0, true];
};

[_unitWithSword, selectRandom ["WBK_ZombieFace_1","WBK_ZombieFace_2","WBK_ZombieFace_3","WBK_ZombieFace_4","WBK_ZombieFace_5","WBK_ZombieFace_6"]] remoteExec ["setFace", 0, true];

_unitWithSword spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

// Handle zombie death animations
_unitWithSword addEventHandler ["Killed", WBK_AI_DefaultKilledEventHandler];

// Add event handlers
[_unitWithSword] call WBK_AI_AddDefaulEventHandlers;

// Add hitpart event handler
[_unitWithSword, WBK_AI_DefaultHitPartEventHandler] remoteExec ["spawn", [0,-2] select isDedicated, true];

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

	_forbiddenAnimStates = ["WBK_Zombie_Evade_B", "WBK_Zombie_Evade_L", "WBK_Zombie_Evade_R", "WBK_Runner_TryingToCatch", 
		"WBK_Walker_TryingToCatch_success_1", "WBK_Walker_TryingToCatch_success_2", "WBK_Walker_TryingToCatch_success_3", "WBK_Middle_GetUpUnconscious",
		"WBK_Middle_GetUpUnconscious_1", "WBK_Runner_hit_b", "WBK_Runner_hit_f_2", "WBK_Runner_hit_f_1",
		"WBK_Runner_Fall_Back", "WBK_Runner_Fall_Forward", "IMS_Rifle_Sync_Blunt_back_victim", "IMS_Rifle_Sync_Blunt_front_victim",
		"IMS_Rifle_Sync_Knife_back_reversed_victim", "IMS_Rifle_Sync_Knife_back_victim", "IMS_Rifle_Sync_Knife_front_reversed_victim", "IMS_Rifle_Sync_Knife_front_victim",
		"IMS_Rifle_Sync_Knife_front_victim_1", "IMS_Rifle_Sync_Player_1_victim", "IMS_Rifle_Sync_Player_2_victim"];

	_forbiddenGestureStates = ["WBK_Zombie_attack_Left", "WBK_Zombie_attack_Right"];

	_allowedAnimStates = ["WBK_CatchedByZombie_Front", "WBK_CatchedByZombie_Back", "IMS_Rifle_Sync_Blunt_back_main", "IMS_Rifle_Sync_Blunt_front_main",
			"IMS_Rifle_Sync_Knife_back_main", "IMS_Rifle_Sync_Knife_back_reversed_main", "IMS_Rifle_Sync_Knife_front_main", "IMS_Rifle_Sync_Knife_front_main_1",
			"IMS_Rifle_Sync_Knife_front_reversed_main", "IMS_Rifle_Sync_Player_1_main", "IMS_Rifle_Sync_Player_2_main", "IMS_KnifeExec_main",
			"IMS_KnifeExec_main_1", "IMS_Crawling_Away", "Human_Execution_Bayonet_main", "Human_Execution_Axe_main",
			"Human_Execution_Blunt_main", "Human_Execution_GenericHeavy_main", "Human_Execution_GenericOnehanded_headSmash_1_main", "Human_Execution_Shield_main"];

	[_mutant, _forbiddenCrawlerAnimStates, _forbiddenAnimStates, _forbiddenGestureStates, _allowedAnimStates, [2.6, 3.2], WBK_ZombieTryingToGrab_fast] call WBK_AI_SetupDefaultAttackAnimations;
}, 0.2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Life path, move to nearest enemy
private
[
	"_loopPathfindDoMove"
];

_loopPathfindDoMove = [WBK_AI_DefaultLoopPathfindDoMove, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Unconcious standup handler
[_unitWithSword, true] spawn WBK_AI_DefaultUnconStandUp;

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
