/*
	WBK_AI_Corrupted.sqf

	Description:
		Handles Corrupted Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Corrupted", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

private
[
	"_unitWithSword";
];

_unitWithSword = _this;

if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith 
{
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if is3DEN exitWith 
{
	_rndMoveset = selectRandom ["WBK_Middle_Idle_1","WBK_Middle_Idle"];
	_unitWithSword switchMove _rndMoveset;
	_unitWithSword setFace "WBK_DosHead_Corrupted";
	systemChat "AI Loaded in Eden";
};

if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

// Set custom sounds for corrupted ai
_unitWithSword setVariable ["WBK_Zombie_CustomSounds",
[
	["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
	["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
	["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
	["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"],
	["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"]
], true];

// Set up zombie behaviour
[_unitWithSword] call WBK_AI_SetupDefaultZombieBehaviour;

// Set up zombie variables
[_unitWithSword] call WBK_AI_SetupDefaultZombieVariables;

// Set up the move sets
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Runner_Angry_Idle", true];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSetRunningState","WBK_Runner_Angry_Idle"];

// Set up zombie face
[_unitWithSword, "WBK_DosHead_Corrupted"] remoteExec ["setFace", 0, true];

// Debug zombie movement on spawn
_unitWithSword spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

// Handle zombie death animations
_unitWithSword spawn {
	sleep 0.2;
	_this removeAllEventHandlers "Killed";
	_this addEventHandler ["Killed", {
		params
		[
			"_zombie",
			"_killer"
		];

		if (isBurning _zombie) exitWith 
		{
			[_zombie, selectRandom ["flamethrower_burning_1","flamethrower_burning_2","flamethrower_burning_3","flamethrower_burning_4","flamethrower_burning_7"]] remoteExec ["switchMove", 0, false];
			[_zombie, selectRandom ["plagued_burn_1","plagued_burn_2","plagued_burn_3"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		};

		private
		[
			"_z"
		];

		_z = _zombie getHit "head";

		if (_z < 1) then 
		{
			_zombie spawn WBK_SpawnCorruptedHead;
		}
		else 
		{
			[_zombie, selectRandom ["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		};
		
		if ((isNil {_zombie getVariable "WBK_ZombieSwitchToCrawler"}) and (WBK_Zombies_EnableStaticAnimations) and !(_zombie == _killer) and !(isNull _killer)) exitWith 
		{
			[_zombie, _killer] spawn {
				params
				[
					"_victim",
					"_shooter"
				];

				_victim spawn {
					sleep 0.02;

					// playActionNow has a global effect (https://community.bistudio.com/wiki/playActionNow) no need to execute on all machines
					_this playActionNow "Disable_Gesture";
				};

				if (((_victim worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) > 0) then 
				{
					private
					[
						"_rndAnim"
					];

					_rndAnim = selectRandom ["A_PlayerDeathAnim_19","A_PlayerDeathAnim_17","A_PlayerDeathAnim_14","A_PlayerDeathAnim_15","A_PlayerDeathAnim_1","A_PlayerDeathAnim_2","A_PlayerDeathAnim_3","A_PlayerDeathAnim_5","A_PlayerDeathAnim_7","A_PlayerDeathAnim_8","A_PlayerDeathAnim_9","A_PlayerDeathAnim_10","A_PlayerDeathAnim_11","A_PlayerDeathAnim_12","A_PlayerDeathAnim_13"];
					[_victim, _rndAnim] remoteExec ["switchMove", 0];

					if (_rndAnim == "A_PlayerDeathAnim_17") exitWith 
					{
						sleep 1.95;

						// setVelocity has a global effect (https://community.bistudio.com/wiki/setVelocity) no need to execute on all machines
						_victim setvelocity [-4 * (sin (getdir _victim )), -4 * (cos (getdir _victim)), 1];
					};

					if (_rndAnim == "A_PlayerDeathAnim_19") exitWith 
					{
						sleep 0.2;

						// setVelocity has a global effect (https://community.bistudio.com/wiki/setVelocity) no need to execute on all machines
						_victim setvelocity [-5 * (sin (getdir _victim )), -5 * (cos (getdir _victim)), 0.5];
					};

					if ((_rndAnim == "A_PlayerDeathAnim_3") or (_rndAnim == "A_PlayerDeathAnim_5")) exitWith 
					{
						// setVelocity has a global effect (https://community.bistudio.com/wiki/setVelocity) no need to execute on all machines
						_victim setvelocity [-5 * (sin (getdir _victim )), -5 * (cos (getdir _victim)), 1.35];
					};

					if ((_rndAnim == "A_PlayerDeathAnim_13")) exitWith {
						// setVelocityModelSpace has a global effect (https://community.bistudio.com/wiki/setVelocityModelSpace) no need to execute on all machines

						sleep 0.3; 
						_victim setVelocityModelSpace [1.2,0,0.1];
						sleep 0.2; 
						_victim setVelocityModelSpace [2,0,0.3];
						sleep 0.2; 
						_victim setVelocityModelSpace [1,0,0.3];
						sleep 0.2; 
						_victim setVelocityModelSpace [1,0,0.3];
					};

					if ((_rndAnim == "A_PlayerDeathAnim_12")) exitWith {
						sleep 1.5;

						// setVelocityModelSpace has a global effect (https://community.bistudio.com/wiki/setVelocityModelSpace) no need to execute on all machines
						_victim setVelocityModelSpace [0,2,0.5];
					};
				}
				else
				{
					[_victim, selectRandom ["A_PlayerDeathAnim_18","A_PlayerDeathAnim_20","A_PlayerDeathAnim_4","A_PlayerDeathAnim_6"]] remoteExec ["switchMove", 0];

					// setVelocity has a global effect (https://community.bistudio.com/wiki/setVelocity) no need to execute on all machines
					_victim setvelocity [5 * (sin (getdir _victim )), 5 * (cos (getdir _victim)), 1.35];
					[_victim, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
				};
			};
		};
	}];
};

// Add eventhandlers for alerting zombies to units shooting at them
[_unitWithSword] call WBK_AI_AddDefaulEventHandlers;

// Add hitpart event handler
[_unitWithSword, {
	// Ensuring headless clients don't fall into this eventhandler creation
	if (!hasInterface) exitWith {};

	_this removeAllEventHandlers "HitPart";
	_this addEventHandler [
    "HitPart",
    {
		(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];

		if ((_target == _shooter) or (isNull _shooter) or !(alive _target) or (lifeState _target == "INCAPACITATED")) exitWith {};

		if (gestureState _target == "WBK_ZombieHitGest_2") exitWith {
			[_target, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _target]; 
		};

		if (gestureState _target == "WBK_ZombieHitGest_1") exitWith {
			[_target, "WBK_ZombieHitGest_2"] remoteExec ["playActionNow", _target]; 
		};

		[_target, "WBK_ZombieHitGest_1"] remoteExec ["playActionNow", _target]; 
	}
];
}] remoteExec ["spawn", [0,-2] select isDedicated, true];

// Manage attack animations
private
[
	"_actFr"
];

_actFr = [{
	params ["_array"];
	_array params ["_mutant"];

	if ((lifeState _mutant == "INCAPACITATED") or !(alive _mutant)) exitWith {};

	// Find the nearest enemy
	private
	[
		"_en"
	];

	_en = _mutant findNearestEnemy _mutant;

	if (!(_en isKindOf "MAN") or !(isNil {_en getVariable "IMS_IsUnitInvicibleScripted"}) or (_en isKindOf "WBK_C_ExportClass") or (_en isKindOf "WBK_Horses_ExportClass")) exitWith {};

	// Ensuring distance between nearest enemy and zombie is done first, so that we do not have to waste resources executing the rest of this code
	if ((_en distance _mutant) > 2.6) exitWith {};

	if !(isNil {_mutant getVariable "WBK_ZombieSwitchToCrawler"}) exitWith {
		private
		[
			"_forbiddenAnimStates"
		];

		_forbiddenAnimStates = ["WBK_Crawler_Attack", "WBK_Walker_Fall_Forward_Moveset_1", "WBK_Walker_Fall_Forward_Moveset_2", "WBK_Walker_Fall_Forward_Moveset_3", 
			"WBK_Walker_Fall_Back_Moveset_1", "WBK_Walker_Fall_Back_Moveset_2", "WBK_Walker_Fall_Back_Moveset_3"];

		if (!((animationState _mutant) in _forbiddenAnimStates) and 
			((_mutant distance _en) <= 2.6)
		) exitWith 
		{
			[_mutant, _en] spawn WBK_ZombieAttack_Crawler;
		};
	};

	// Ensuring distance between nearest enemy and zombie is done first, so that we do not have to waste resources executing the rest of this code
	if ((_en distance _mutant) > 2.9) exitWith {};

	private
	[
		"_forbiddenAnimStates",
		"_forbiddenGestureStates"
	];

	_forbiddenAnimStates = ["WBK_Walker_Idle_1_attack", "WBK_Walker_Idle_2_attack", "WBK_Middle_TryingToCatch_1", "WBK_Middle_TryingToCatch",
		"WBK_Walker_TryingToCatch_success_1", "WBK_Walker_TryingToCatch_success_2", "WBK_Walker_TryingToCatch_success_3", "WBK_Middle_GetUpUnconscious",
		"WBK_Middle_GetUpUnconscious_1", "WBK_Middle_hit_b_1", "WBK_Middle_hit_b_2", "WBK_Middle_hit_f_2_1",
		"WBK_Middle_hit_f_2_2", "WBK_Middle_hit_f_1_1", "WBK_Middle_hit_f_1_2", "WBK_Runner_hit_f_2",
		"WBK_Runner_hit_f_1", "WBK_Middle_Fall_Forward", "WBK_Middle_Fall_Forward_1", "WBK_Middle_Fall_Back",
		"WBK_Middle_Fall_Back_1", "IMS_Rifle_Sync_Blunt_back_victim", "IMS_Rifle_Sync_Blunt_front_victim", "IMS_Rifle_Sync_Knife_back_reversed_victim",
		"IMS_Rifle_Sync_Knife_back_victim", "IMS_Rifle_Sync_Knife_front_reversed_victim", "IMS_Rifle_Sync_Knife_front_victim", "IMS_Rifle_Sync_Knife_front_victim_1",
		"IMS_Rifle_Sync_Player_1_victim", "IMS_Rifle_Sync_Player_2_victim"];

	_forbiddenGestureStates = ["WBK_Zombie_attack_Left", "WBK_Zombie_attack_Right"];

	if (((_mutant distance _en) <= 2.9) and
		!((animationState _mutant) in _forbiddenAnimStates) and
		!((gestureState _mutant) in _forbiddenGestureStates)
	) exitWith 
	{
		// The 'if' statement here was unnecessary as both resulted in calls to [_mutant, _en] spawn WBK_ZombieAttack_gesture
		[_mutant, _en] spawn WBK_ZombieAttack_gesture;
	};
}, 0.2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

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

	[_unit, selectRandom ["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"], 35] call CBA_fnc_GlobalSay3D;

    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith {};

	private
	[
		"_pos"
	];

	_pos = ASLtoAGL getPosASLVisual _nearEnemy;
	_unit doMove _pos;
}, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Unconcious standup handler
[_unitWithSword] spawn WBK_AI_DefaultUnconStandUp;

// Wait until this zombie is no longer alive
waitUntil {
	sleep 0.5; 
	if (isNull _unitWithSword) exitWith { true };
	(!(alive _unitWithSword))
};

// Remove per frame event handlers
[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;

// Remove hitpart eventhandlers
[_unitWithSword, {
	// Ensuring headless clients don't fall into this eventhandler deletion
	if (!hasInterface) exitWith {};

	_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated, true];