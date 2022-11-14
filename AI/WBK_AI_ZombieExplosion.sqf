/*
	WBK_AI_ZombieExplosion.sqf

	Description:
		Handles Explosion Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_ZombieExplosion", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

private
[
	"_mutant"
];

_mutant = _this;

if (getText (configfile >> 'CfgVehicles' >> typeOf _mutant >> 'moves') != 'CfgMovesMaleSdr') exitWith 
{
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if ((isPlayer _mutant) or !(isNil {_mutant getVariable "WBK_AI_ISZombie"}) or !(alive _mutant)) exitWith {};

// Set up zombie behaviour
[_mutant] call WBK_AI_SetupDefaultZombieBehaviour;
removeAllItems _mutant;
removeAllAssignedItems _mutant;
removeUniform _mutant;
removeVest _mutant;
removeBackpack _mutant;
removeHeadgear _mutant;
removeGoggles _mutant;
_mutant forceAddUniform "Zombie_Smog";

// Set up zombie variables
[_mutant] call WBK_AI_SetupDefaultZombieVariables;
_mutant setVariable ["WBK_AI_ISZombie", 1, true];

_mutant setVariable ["IMS_IsAnimPlayed",0, true];
_mutant setVariable ["canMakeAttack",0, true];
_mutant setVariable ["AI_CanTurn",0, true];
_mutant setVariable ["IMS_ISAI",1, true];

[_mutant, "WBK_Middle_Idle"] remoteExec ["switchMove", 0, true];
_mutant setVariable ["WBK_AI_ZombieMoveSet","WBK_Middle_Idle", true];
_mutant action ["SwitchWeapon", _mutant, _mutant, 100]; 

deleteVehicleBlood = {
	params
	[
		"_veh"
	];
	
	sleep 500;
	deleteVehicle _veh;
};

_mutant spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

_mutant allowDamage false;
_mutant setVariable ["CustomHPSet",10];
_mutant addEventHandler ["HandleDamage",{
	params
	[
		"_zombie",
		"_someSecondVar",
		"_someThirdVar",
		"_hitter"
	];
	
	if ((_zombie == _hitter) or (isNull _hitter)) exitWith {};

	private
	[
		"_vv",
		"_new_vv"
	];

	_vv = _zombie getVariable "CustomHPSet";
	_new_vv = _vv - 1;

	if (_new_vv <= 0) exitWith 
	{
		_zombie setDamage 1; 
		[_zombie, "A_PlayerDeathAnim_11"] remoteExec ["switchMove", 0];
	};

	_zombie setVariable ["CustomHPSet",_new_vv];

	if (gestureState _zombie == "WBK_ZombieHitGest_2") exitWith 
	{
		[_zombie, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _zombie]; 
	};

	if (gestureState _zombie == "WBK_ZombieHitGest_1") exitWith 
	{
		[_zombie, "WBK_ZombieHitGest_2"] remoteExec ["playActionNow", _zombie]; 
	};

	[_zombie, "WBK_ZombieHitGest_1"] remoteExec ["playActionNow", _zombie]; 
}];

_mutant addEventHandler ["Killed", {
	params
	[
		"_creature"
	];

 	[_creature, "blower_dead", 60, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
}];

animPush_GORE = {
	params
	[
		"_unit",
		"_anim"
	];
	private
	[
		"_myNearestEnemy"
	];
	_myNearestEnemy = _unit findNearestEnemy _unit;

	_ifInter = lineIntersectsSurfaces [
		AGLToASL (_myNearestEnemy modelToWorld [0,0,0.1]), 
		AGLToASL (_unit modelToWorld [0,0,0.1]), 
		_unit,
		_myNearestEnemy,
		true,
		1,
		"GEOM",
		"NONE"
	];

	private
	[
		"_forbiddenAnimStates"
	];

	_forbiddenAnimStates = ["starWars_lightsaber_block_1", "starWars_lightsaber_block_2", "starWars_lightsaber_block_3",
		"starWars_lightsaber_hit_1", "starWars_lightsaber_hit_2", "starWars_lightsaber_blockPursuit"];

	if ((_unit getVariable "IMS_IsAnimPlayed" == 0) and 
		(alive _unit) and 
		(_unit getVariable "canMakeAttack" == 0) and 
		(isTouchingGround _unit) and 
		(count _ifInter == 0) and 
		!((animationState _unit) in _forbiddenAnimStates)) then 
	{
		_unit setVariable ["IMS_IsAnimPlayed",1, true];
		sleep 0.5;

		if ((_unit getVariable "canMakeAttack" == 0)) then 
		{
			_unit playMoveNow _anim;
		};

		sleep 1;
		_unit setVariable ["IMS_IsAnimPlayed",0, true];
	};
};

createAggresiveSound = {
	params ["_mutant","_sound","_seconds"];
	if (isNull _mutant) exitWith {objNull};
	if ((isNil {_mutant getVariable "CanMakeSoundPath"})) then {
		_mutant setVariable ["CanMakeSoundPath",0];
		[_mutant, _sound, 70] call CBA_fnc_globalSay3d;
		sleep _seconds;
		_mutant setVariable ["CanMakeSoundPath",nil];
	};
};

[_mutant, "blower_scream_1", 3] spawn createAggresiveSound;

createBlowUp = {
	params
	[
		"_unit"
	];
	
	_unit setVariable ["canMakeAttack",1,true];
	[_unit, "WBK_Middle_TryingToCatch"] remoteExec ["switchMove", 0];
	[_unit, "WBK_Middle_TryingToCatch"] remoteExec ["playMoveNow", 0];
	_rndSound = selectRandom ["blower_blow_1","blower_blow_2"];
	[_unit, _rndSound, 90, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	sleep 0.1;

	if (!(alive _unit) or !(animationState _unit == "WBK_Middle_TryingToCatch")) exitWith {};
	sleep 0.1;

	if (!(alive _unit) or !(animationState _unit == "WBK_Middle_TryingToCatch")) exitWith {};
	sleep 0.1;

	if (!(alive _unit) or !(animationState _unit == "WBK_Middle_TryingToCatch")) exitWith {};
	sleep 0.1;

	if (!(alive _unit) or !(animationState _unit == "WBK_Middle_TryingToCatch")) exitWith {};
	_unit setDamage 1;

	[(_unit findNearestEnemy _unit), "blower_explode", 150, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	
	{
		[_x, ((damage _x) + 0.5)] remoteExec ["setDamage", _x, false];  
	} forEach nearestObjects [_unit,["CAR","HELI"],10];

	{
		if (!(_x == _unit) and (alive _x) and 
			!(_x isKindOf "WBK_DOS_Squig_Normal") and 
			!(_x isKindOf "WBK_Horses_ExportClass") and 
			(isNil {_x getVariable "IMS_IsUnitInvicibleScripted"}) and 
			!(_x isKindOf "WBK_C_ExportClass")) then 
		{
			[_x, 0.5, _unit] remoteExec ["WBK_CreateDamage", _x, false];  
			[_x, 228, _unit] remoteExec ["concentrationToZero", _x, false];  
		};
	} forEach nearestObjects [_unit,["MAN"],7];

	_electra1 = "#particlesource" createVehicle position _unit;  
	_electra1 setParticleClass "VehExpSmokeSmall"; 
	_electra2 = "#particlesource" createVehicle position _unit;  
	_electra2 setParticleClass "MineExplosionParticles"; 
	_deathBlood = "BloodPool_01_Large_New_F" createVehicle getPosATL _unit;
	_deathBlood setPosATL [(getPosATL _unit select 0), (getPosATL _unit select 1),0];

	_t1 = "BloodTrail_01_New_F" createVehicle getPosATL _unit;
	_t2 = "BloodTrail_01_New_F" createVehicle getPosATL _unit;
	_t3 = "BloodTrail_01_New_F" createVehicle getPosATL _unit;
	_t4 = "BloodTrail_01_New_F" createVehicle getPosATL _unit;
	_t1 attachTo [_deathBlood,[2.5,1.4,0]]; 
	detach _t1; 
	_t1 setDir 70; 
	_t2 attachTo [_deathBlood,[-2.5,-1.4,0]]; 
	detach _t2; 
	_t2 setDir 70; 
	_t3 attachTo [_deathBlood,[2.1,-2.3,0]];  
	detach _t3;  
	_t3 setDir 140; 
	_t4 attachTo [_deathBlood,[-2.1,2.3,0]];   
	detach _t4;   
	_t4 setDir 140; 

	_electra = "#particlesource" createVehicle position _unit; 
	_electra setParticleClass "HDustVTOL1"; 

	detach _electra;
	deleteVehicle _unit;
	
	{
		_x setVectorUp surfaceNormal getposatl _x;
		_x setPosATL [(getPosATL _x select 0), (getPosATL _x select 1),0];
		[_x] spawn deleteVehicleBlood;
	} forEach [_t1,_t2,_t3,_t4,_deathBlood];

	sleep 0.2;
	deleteVehicle _electra;
	deleteVehicle _electra1;
	deleteVehicle _electra2;
};

sleep 0.1;

// Manage attack animations
private
[
	"_actFr"
];

_actFr = [{
	params ["_array"];
	_array params ["_mutant"];
	
	_mutant setBehaviour "CARELESS";  

	{ 
		private
		[
			"_ifInter"
		];

		_ifInter = lineIntersects [ getPosASL _mutant, eyePos _x, _mutant, _x];
		if (!(_ifInter)) then {
			_mutant reveal [_x, 4]; 
		};
	} forEach nearestObjects [_mutant, ["Man"], 40];  

	private
	[
		"_myNearestEnemy",
		"_rndSnd"
	];

	_myNearestEnemy = _mutant findNearestEnemy _mutant;
	_rndSnd = selectRandom["blower_scream_1","blower_scream_2"];
	[_mutant, _rndSnd, 1.6] spawn createAggresiveSound;

	private
	[
		"_forbiddenAnimStates"
	];

	_forbiddenAnimStates = ["WBK_Middle_TryingToCatch", "WBK_Middle_hit_b_1", "WBK_Middle_hit_f_2_1", 
		"WBK_Middle_hit_f_1_1", "WBK_Middle_Fall_Forward", "WBK_Middle_Fall_Back"];

	if ((_mutant getVariable "canMakeAttack" == 0) and 
		((_myNearestEnemy distance _mutant) <= 4.2) and 
		(alive _mutant) and 
		!((animationState _mutant) in _forbiddenAnimStates)) then 
	{
		[_mutant] spawn createBlowUp;
	};
}, 0.5, [_mutant]] call CBA_fnc_addPerFrameHandler;

// Life path, move to nearest enemy
private
[
	"_loopPathfind"
];

_loopPathfind = [{
	params ["_array"];
	_array params ["_unit"];
	
	private
	[
		"_nearEnemy"
	];

	_nearEnemy = _unit findNearestEnemy _unit;

	if ((_unit distance _nearEnemy >= 40)) exitWith {};

    if (!(isNull _nearEnemy) and (alive _nearEnemy) and (alive _unit)) then 
	{
		_ifInter = lineIntersectsSurfaces [
			AGLToASL (_nearEnemy modelToWorld [0,0,0.1]), 
			AGLToASL (_unit modelToWorld [0,0,0.1]), 
			_unit,
			_nearEnemy,
			true,
			1,
			"GEOM",
			"NONE"
		];
		
		if ((_unit getVariable "AI_CanTurn" == 0) and 
			(isTouchingGround _unit) and
			(count _ifInter == 0) and 
			(_unit distance _nearEnemy < 40) and
			((getPosATL _nearEnemy select 2) < 1.45)) exitWith 
		{
			_unit disableAI "PATH";
			_unit disableAI "ANIM";
			doStop _unit;
			[_unit, "WBK_Middle_Run"] spawn animPush_GORE;
			_dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
			
			_unit setVelocityTransformation [ 
				getPosASL _unit,  
				getPosASL _unit,  
				[0,0,(velocity _unit select 2) - 1],  
				[(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
				vectorDir _unit,  
				_dir,  
				vectorUp _unit,  
				vectorUp _unit, 
				0.1
			]; 
		};
	}; 
}, 0.01, [_mutant]] call CBA_fnc_addPerFrameHandler;

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

    if (!(isNull _nearEnemy) and (alive _nearEnemy) and (alive _unit)) then 
	{
		_ifInter = lineIntersectsSurfaces [
			AGLToASL (_nearEnemy modelToWorld [0,0,0.1]), 
			AGLToASL (_unit modelToWorld [0,0,0.1]), 
			_unit,
			_nearEnemy,
			true,
			1,
			"GEOM",
			"NONE"
		];

		if ((_unit distance _nearEnemy > 40) or (!(count _ifInter == 0)) or ((getPosATL _nearEnemy select 2) >= 1.45)) exitWith 
		{
			_unit enableAI "PATH";
			_unit enableAI "ANIM";
			_unit enableAI "MOVE";
			_unit doMove [getPos _nearEnemy select 0, getPos _nearEnemy select 1, 0];
		};
	}; 
}, 2, [_mutant]] call CBA_fnc_addPerFrameHandler;

waitUntil {
	sleep 0.5; 
	!(alive _mutant)
};

[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfind] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;

_mutant removeAllEventHandlers "HandleDamage";
_mutant removeAllEventHandlers "Killed";