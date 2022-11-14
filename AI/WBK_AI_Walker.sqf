/*
	WBK_AI_Walker.sqf

	Description:
		Handles Walker Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Walker", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

params
[
	"_unitWithSword",
	"_isCrawler"
];

if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith 
{
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if is3DEN exitWith 
{
	if (_isCrawler) then 
	{
		_unitWithSword switchMove "WBK_Crawler_Idle";
	}
	else
	{
		_rndMoveset = selectRandom ["WBK_Walker_Idle_1","WBK_Walker_Idle_2","WBK_Walker_Idle_3"];
		_unitWithSword switchMove _rndMoveset;
	};

	_unitWithSword setFace selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4","WBK_DosHead_Normal_1","WBK_DosHead_Normal_2","WBK_DosHead_Normal_3"];
	systemChat "AI Loaded in Eden";
};


if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

// Set custom world war 2 sounds
[_unitWithSword] call WBK_AI_SetWW2CustomSounds;

// Set up zombie behaviour
[_unitWithSword] call WBK_AI_SetupDefaultZombieBehaviour;
removeAllAssignedItems _unitWithSword;
removeGoggles _unitWithSword;

// Set up zombie variables
[_unitWithSword] call WBK_AI_SetupDefaultZombieVariables;

// Set up the move sets
if (_isCrawler) then {
	private
	[
		"_rndMoveset"
	];

	_rndMoveset = selectRandom ["WBK_Walker_Idle_1","WBK_Walker_Idle_2","WBK_Walker_Idle_3"];
	_unitWithSword setVariable ["WBK_AI_ZombieMoveSet",_rndMoveset, true];
	[_unitWithSword, 'WBK_Crawler_To_Idle'] remoteExec ['switchMove', 0]; 
	_unitWithSword setVariable ['WBK_ZombieSwitchToCrawler',1,true];
}
else
{
	private
	[
		"_rndMoveset"
	];

	_rndMoveset = selectRandom ["WBK_Walker_Idle_1","WBK_Walker_Idle_2","WBK_Walker_Idle_3"];
	_unitWithSword setVariable ["WBK_AI_ZombieMoveSet",_rndMoveset, true];
	[_unitWithSword, _rndMoveset] remoteExec ["switchMove", 0, true];
};

// Set up zombie face
private
[
	"_rndFace"
];

_rndFace = selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4","WBK_DosHead_Normal_1","WBK_DosHead_Normal_2","WBK_DosHead_Normal_3"];

if ((_rndFace == "WBK_DosHead_Normal_1") or (_rndFace == "WBK_DosHead_Normal_2") or (_rndFace == "WBK_DosHead_Normal_3")) then 
{
	removeHeadgear _unitWithSword;
};

[_unitWithSword, _rndFace] remoteExec ["setFace", 0, true];

// Debug start position
_unitWithSword spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

// Handle zombie death animations
_unitWithSword addEventHandler ["Killed", WBK_AI_DefaultKilledEventHandler];

// Set up event handlers
_unitWithSword addEventHandler ["Suppressed", {
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
	if (!(isNil {_unit getVariable "WBK_AI_ZombieCanMove"})) exitWith {};

	_pos = ASLtoAGL getPosASLVisual _instigator;
	_unit doMove _pos;
	_unit reveal [_instigator, 4];

	_unit spawn {
		_this setVariable ["WBK_AI_ZombieCanMove",0];
		sleep 5;
		_this setVariable ["WBK_AI_ZombieCanMove",nil];
	};
}];

_unitWithSword addEventHandler ["FiredNear", {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
	if (!(isNil {_unit getVariable "WBK_AI_ZombieCanMove"})) exitWith {};

	_unit reveal [_firer, 4];
	_pos = ASLtoAGL getPosASLVisual _firer;
    _unit doMove _pos;

	_unit spawn {
		_this setVariable ["WBK_AI_ZombieCanMove",0];
		sleep 5;
		_this setVariable ["WBK_AI_ZombieCanMove",nil];
	};
}];

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

	_forbiddenAnimStates = ["WBK_Runner_hit_f_2", "WBK_Runner_hit_f_1", "WBK_Walker_Idle_1_attack", "WBK_Walker_Idle_2_attack",
		"WBK_Walker_TryingToCatch_1", "WBK_Walker_TryingToCatch_2", "WBK_Walker_TryingToCatch_3", "WBK_Walker_TryingToCatch_success_1",
		"WBK_Walker_TryingToCatch_success_2", "WBK_Walker_TryingToCatch_success_3", "WBK_Walker_GetUpUnconscious_1", "WBK_Walker_GetUpUnconscious_2",
		"WBK_Walker_GetUpUnconscious_3", "WBK_Walker_Hit_B", "WBK_Walker_Hit_B_1", "WBK_Walker_Hit_B_2", 
		"WBK_Walker_Hit_F_1", "WBK_Walker_Hit_F_2", "WBK_Walker_Hit_F_1_2", "WBK_Walker_Hit_F_2_2",
		"WBK_Walker_Hit_F_1_3", "WBK_Walker_Hit_F_2_3", "WBK_Walker_Fall_Forward_Moveset_1", "WBK_Walker_Fall_Forward_Moveset_2",
		"WBK_Walker_Fall_Forward_Moveset_3", "WBK_Walker_Fall_Back_Moveset_1", "WBK_Walker_Fall_Back_Moveset_2", "WBK_Walker_Fall_Back_Moveset_3",
		"WBK_Walker_Hit_F_2_2", "WBK_Walker_Hit_F_1_3", "WBK_Walker_Hit_F_2_3", "IMS_Rifle_Sync_Blunt_back_victim", "IMS_Rifle_Sync_Blunt_front_victim",
		"IMS_Rifle_Sync_Knife_back_reversed_victim", "IMS_Rifle_Sync_Knife_back_victim", "IMS_Rifle_Sync_Knife_front_reversed_victim", "IMS_Rifle_Sync_Knife_front_victim",
		"IMS_Rifle_Sync_Knife_front_victim_1", "IMS_Rifle_Sync_Player_1_victim", "IMS_Rifle_Sync_Player_2_victim"];

	_forbiddenGestureStates = ["WBK_Zombie_attack_Left", "WBK_Zombie_attack_Right"];

	_allowedAnimStates = ["WBK_CatchedByZombie_Front", "WBK_CatchedByZombie_Back", "IMS_Rifle_Sync_Blunt_back_main", "IMS_Rifle_Sync_Blunt_front_main",
			"IMS_Rifle_Sync_Knife_back_main", "IMS_Rifle_Sync_Knife_back_reversed_main", "IMS_Rifle_Sync_Knife_front_main", "IMS_Rifle_Sync_Knife_front_main_1",
			"IMS_Rifle_Sync_Knife_front_reversed_main", "IMS_Rifle_Sync_Player_1_main", "IMS_Rifle_Sync_Player_2_main", "IMS_KnifeExec_main",
			"IMS_KnifeExec_main_1", "IMS_Crawling_Away", "Human_Execution_Bayonet_main", "Human_Execution_Axe_main",
			"Human_Execution_Blunt_main", "Human_Execution_GenericHeavy_main", "Human_Execution_GenericOnehanded_headSmash_1_main", "Human_Execution_Shield_main"];

	[_mutant, _forbiddenCrawlerAnimStates, _forbiddenAnimStates, _forbiddenGestureStates, _allowedAnimStates, [2.6, 2.9], WBK_ZombieTryingToGrab, WBK_ZombieAttack] call WBK_AI_SetupDefaultAttackAnimations;
}, 1, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Life path, move to nearest enemy
private
[
	"_loopPathfindDoMove"
];

_loopPathfindDoMove = [{
    params ["_array"];
	_array params ["_unit"];

	private
	[
		"_nearEnemy"
	];

	_nearEnemy = _unit findNearestEnemy _unit; 

    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit)) exitWith 
	{
		if (!(isNil {_unit getVariable "WBK_Zombie_CustomSounds"})) then 
		{
			private
			[
				"_snds"
			];

			_snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 0;
			[_unit, selectRandom _snds, 20] call CBA_fnc_GlobalSay3D;
		}
		else
		{
			[_unit, selectRandom ["plagued_idle_1","plagued_idle_2","plagued_idle_3","plagued_idle_4","plagued_idle_5"], 25] call CBA_fnc_GlobalSay3D;
		};
	};

	_pos = ASLtoAGL getPosASLVisual _nearEnemy;
	_unit doMove _pos;

	if (!(isNil {_unit getVariable "WBK_Zombie_CustomSounds"})) then 
	{
		private
		[
			"_snds"
		];

		_snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 1;
		[_unit, selectRandom _snds, 20] call CBA_fnc_GlobalSay3D;
	}
	else
	{
		[_unit, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6","plagued_attack_9"], 20] call CBA_fnc_GlobalSay3D;
	};
}, 7, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

_unitWithSword spawn {
	while {(alive _this)} do 
	{
		if (!(alive _this)) exitWith {};

		waitUntil {
			sleep 0.2;
			if (isNull _this) exitWith { true };
			((lifeState _this == "INCAPACITATED") or !(alive _this))
		};

		if (!(alive _this)) exitWith {};

		sleep 0.1;
		waitUntil {
			sleep 0.2;
			if (isNull _this) exitWith { true };
			(!(lifeState _this == "INCAPACITATED") or !(alive _this))
		};

		if (!(alive _this)) exitWith {};

		_this spawn 
		{
			if (!(isNil {_this getVariable "WBK_ZombieSwitchToCrawler"})) exitWith 
			{
				[_this, "WBK_Crawler_To_Idle"] remoteExec ["switchMove", 0]; 
				[_this, "WBK_Crawler_To_Idle"] remoteExec ["playMoveNow", 0];
			};

			private
			[
				"_rndStandUp"
			];

			_rndStandUp = selectRandom ["WBK_Walker_GetUpUnconscious_1","WBK_Walker_GetUpUnconscious_2","WBK_Walker_GetUpUnconscious_3"];
			[_this, _rndStandUp] remoteExec ["switchMove", 0]; 
			[_this, _rndStandUp] remoteExec ["playMoveNow", 0];

			sleep 1.8;

			if (!(animationState _this == _rndStandUp) or !(alive _this) or (lifeState _this == "INCAPACITATED")) exitWith {};

			_this setVariable ["canMakeAttack",0, true];

			if (_rndStandUp == "WBK_Walker_GetUpUnconscious_1") exitWith 
			{
				[_this, "WBK_Walker_Idle_1"] remoteExec ["playMoveNow", 0]; 
			};

			if (_rndStandUp == "WBK_Walker_GetUpUnconscious_2") exitWith 
			{
				[_this, "WBK_Walker_Idle_2"] remoteExec ["playMoveNow", 0]; 
			};

			if (_rndStandUp == "WBK_Walker_GetUpUnconscious_3") exitWith 
			{
				[_this, "WBK_Walker_Idle_3"] remoteExec ["playMoveNow", 0]; 
			};
		};

		sleep 0.1;
	};
};

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
