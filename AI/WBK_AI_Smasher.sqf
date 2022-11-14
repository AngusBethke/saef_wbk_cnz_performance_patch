/*
	WBK_AI_Smasher.sqf

	Description:
		Handles Smasher Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Smasher", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

private
[
	"_unitWithSword"
];

_unitWithSword = _this;

if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

sleep 0.1;

// Set up zombie behaviour
[_unitWithSword] call WBK_AI_SetupDefaultZombieBehaviour;

// Set up zombie variables
[_unitWithSword] call WBK_AI_SetupDefaultZombieVariables;

// Set up the move sets
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet", "WBK_Smasher_Idle", true];
_unitWithSword setVariable ["WBK_SynthHP", WBK_Zombies_SmasherHP, true];

if !(WBK_Zombies_SmasherRockAbil) then 
{
	_unitWithSword setVariable ["CanThrowRocks",0];
};

if !(WBK_Zombies_SmasherFlyAbil) then 
{
	_unitWithSword setVariable ["CanFly",0];
};

// Add event handlers
[_unitWithSword] call WBK_AI_AddDefaulEventHandlers;

// Add killed event handler
_unitWithSword addEventHandler ["Killed", {
	params
	[
		"_zombie"
	];

	_zombie removeAllEventHandlers "HandleDamage";
	[_zombie, "WBK_Smasher_Die"] remoteExec ["switchMove", 0]; 
	[_zombie, selectRandom ["Smasher_die_1","Smasher_die_2","Smasher_die_3","Smasher_die_4"], 225, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	_zombie spawn {sleep 0.8; if (isNull _this) exitWith {}; [_this, "Smasher_hit", 155, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; };
}];

// Add hitpart event handler
[_unitWithSword, {
	// Ensuring headless clients don't fall into this
	if (!hasInterface) exitWith {};

	_this removeAllEventHandlers "HitPart";
	_this addEventHandler [
		"HitPart",
		{
			(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];

			private
			[
				"_forbiddenAnimStates"
			];

			_forbiddenAnimStates = ["WBK_Smasher_inAir_start_onRun", "WBK_Smasher_inAir_start", "WBK_Smasher_inAir_end", "WBK_Smasher_Attack_VEHICLE", 
				"WBK_Smasher_Throw", "WBK_Smasher_HitHard", "WBK_Smasher_Execution"];

			if (((animationState _target) in _forbiddenAnimStates) or (_target == _shooter) or (isNull _shooter) or !(alive _target)) exitWith {};

			_ammo params
			[
				"_isEnoughDamage",
				"_someSecondVar",
				"_someThirdVar",
				"_isExplosive"
			];

			if !(isNil "WBK_ZombiesShowDebugDamage") then 
			{
				systemChat str _isEnoughDamage;
			};

			if (((_isExplosive == 1) or (_isEnoughDamage >= 100)) and (isNil {_target getVariable "CanBeStunnedIMS"})) exitWith 
			{
				[_target, "Smasher_eat_voice", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
				[_target, "WBK_Smasher_HitHard"] remoteExec ["switchMove", 0]; 
				[_target, "WBK_Smasher_HitHard"] remoteExec ["playMoveNow", 0];

				_target enableAI "MOVE";
				_target enableAI "ANIM";
				_target setVariable ["CanBeStunnedIMS",1,true]; 
				_target spawn {sleep 6; _this setVariable ["CanBeStunnedIMS",nil,true];};

				private
				[
					"_vv",
					"_new_vv"
				];

				_vv = _target getVariable "WBK_SynthHP";
				_new_vv = _vv - _isEnoughDamage;

				if (_new_vv <= 0) exitWith 
				{
					_target removeAllEventHandlers "HitPart"; 
					_target setDamage 1;
				};

				_target setVariable ["WBK_SynthHP",_new_vv,true];
			};

			private
			[
				"_vv",
				"_new_vv"
			];

			_vv = _target getVariable "WBK_SynthHP";
			_new_vv = _vv - _isEnoughDamage;

			if (_new_vv <= 0) exitWith 
			{
				_target removeAllEventHandlers "HitPart"; 
				_target setDamage 1;
			};

			_target setVariable ["WBK_SynthHP",_new_vv,true];
			_target enableAI "MOVE";
		}
	];
}] remoteExec ["spawn", [0,-2] select isDedicated,true];

// Manage attack animations
private
[
	"_actFr"
];

_actFr = [{
    params ["_array"];
	_array params ["_mutant"];

	_mutant allowDamage false;

	private
	[
		"_forbiddenAnimStates"
	];

	_forbiddenAnimStates = ["WBK_Smasher_Throw", "WBK_Smasher_HitHard", "WBK_Smasher_Attack_3", "WBK_Smasher_Attack_1",
		"WBK_Smasher_Attack_2", "WBK_Smasher_inAir", "WBK_Smasher_inAir_start", "WBK_Smasher_inAir_start_onRun",
		"WBK_Smasher_inAir_end", "WBK_Smasher_Execution", "WBK_Smasher_Roar", "WBK_Smasher_Attack_VEHICLE",
		"WBK_Smasher_Die"];

	if (((animationState _mutant) in _forbiddenAnimStates) or
		!(isTouchingGround _mutant) or 
		!(alive _mutant)) exitWith {};

    private
	[
		"_en"
	];

	_en = _mutant findNearestEnemy _mutant;

	if ((isNil {_mutant getVariable "CanThrowRocks"}) and 
		!(currentWeapon _en in IMS_Melee_Weapons) and 
		((_en distance _mutant) > 10) and 
		((_en distance _mutant) <= 70) and 
		(alive _mutant) and 
		(!((vehicle _en) isKindOf "MAN") or 
		((speed (vehicle _en)) >= 13) or 
		((_en distance _mutant) >= 35) or 
		(_en isKindOf "TIOWSpaceMarine_Base"))) exitWith 
	{
		[_mutant, (vehicle _en)] spawn WBK_Smasher_RockThrowing;
	};

	if (((_en distance _mutant) <= 6.3) and !((vehicle _en) isKindOf "MAN") and (alive _mutant)) exitWith 
	{
		[_mutant, vehicle _en] spawn WBK_Smasher_VehicleAttack;
	};

	// Only calling lineIntersectsSurfaces now so that we do not have to waste resources when it will not be used
	private
	[
		"_ins"
	];

	_ins = lineIntersectsSurfaces [
		aimPos _mutant,
		aimPos _en,
		_mutant,
		_en,
		true,
		1,
		"GEOM",
		"NONE"
    ];

	if ((count _ins == 0) and (isNil {_mutant getVariable "WBK_CanMakeRoar"}) and ((_en distance _mutant) <= 45) and ((_en distance _mutant) > 15) and !(isNull _en) and (alive _en)) exitWith 
	{
		[_mutant, _en] spawn WBK_Smasher_MakeRoar;
	};

	if ((count _ins == 0) and (isNil {_mutant getVariable "CanFly"}) and ((_en distance _mutant) <= 25) and ((_en distance _mutant) > 8) and !(isNull _en) and (alive _en)) exitWith 
	{
		_mutant setFormDir (_mutant getDir _en);
		[_mutant, _en] spawn WBK_ChargerJump;
	};

    if ((count _ins == 0) and ((_en distance _mutant) <= 4) and (alive _mutant) and !(lifeState _en == "INCAPACITATED")) exitWith 
	{
		if ((isNil {_mutant getVariable "WBK_CanEatSomebody"}) and (getText (configfile >> 'CfgVehicles' >> typeOf _en >> 'moves') == 'CfgMovesMaleSdr')) exitWith 
		{
			if ((isPlayer _en) and (currentWeapon _en in IMS_Melee_Weapons)) exitWith 
			{
				[_mutant, _en] spawn selectRandom [WBK_Smasher_HumanoidAttack_4,WBK_Smasher_HumanoidAttack_2,WBK_Smasher_HumanoidAttack_1,WBK_Smasher_HumanoidAttack_3];
			};

			_mutant setVariable ["WBK_CanEatSomebody",1];
			[_mutant, _en] spawn WBK_Smasher_ExecutionFnc;
		};

		[_mutant, _en] spawn selectRandom [WBK_Smasher_HumanoidAttack_4,WBK_Smasher_HumanoidAttack_2,WBK_Smasher_HumanoidAttack_1,WBK_Smasher_HumanoidAttack_3];
	};
}, 0.4, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Life path, move to nearest enemy
private
[
	"_loopPathfindDoMove"
];

_loopPathfindDoMove = [{
	params ["_array"];
	_array params ["_unit"];

	if ((lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};

	private
	[
		"_nearEnemy"
	];

	_nearEnemy = _unit findNearestEnemy _unit; 
	[_unit, selectRandom ["Smasher_idle_1","Smasher_idle_2","Smasher_idle_3","Smasher_idle_4"],40] call CBA_fnc_GlobalSay3d;

    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith {};

	private
	[
		"_pos"
	];

	_pos = ASLtoAGL getPosASLVisual _nearEnemy;
	_unit doMove _pos;
}, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

waitUntil {
	sleep 0.5; 
	if (isNull _unitWithSword) exitWith { true };
	!(alive _unitWithSword)
};

[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
