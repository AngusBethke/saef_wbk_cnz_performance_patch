/*
	WBK_AI_Stunden.sqf

	Description:
		Handles Stunden Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Stunden", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

private
[
	"_unitWithSword"
];

_unitWithSword = _this;

if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith 
{
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

// Set up zombie behaviour
_unitWithSword setSpeaker "NoVoice";
_unitWithSword setUnitPos "UP";

removeAllWeapons _unitWithSword;
removeAllItems _unitWithSword;
removeAllAssignedItems _unitWithSword;
removeUniform _unitWithSword;
removeVest _unitWithSword;
removeBackpack _unitWithSword;
removeHeadgear _unitWithSword;
removeGoggles _unitWithSword;

_unitWithSword forceAddUniform "Zombie2_BioHazard";
_unitWithSword disableAI "FSM";
_unitWithSword disableAI "TARGET";
_unitWithSword disableAI "AUTOTARGET";
_unitWithSword disableAI "AIMINGERROR";
_unitWithSword disableAI "AUTOCOMBAT";
_unitWithSword setBehaviour "SAFE";

// Set up zombie variables
[_unitWithSword] call WBK_AI_SetupDefaultZombieVariables;
_unitWithSword setVariable ["WBK_DirectionToLookAt","FRONT"];
_unitWithSword setVariable ["IMS_ISAI", 1, true];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Runner_Angry_Idle", true];

[_unitWithSword, "WBK_Runner_Calm_Idle"] remoteExec ["switchMove", 0, true];
[_unitWithSword, "screamer_start", 720, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

// Set up zombie hp
_unitWithSword allowDamage false;
_unitWithSword setVariable ["CustomHPSet", 14];

_unitWithSword addEventHandler ["HandleDamage", {
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

_unitWithSword spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

// Handle zombie death animations
_unitWithSword addEventHandler ["Killed", WBK_AI_DefaultKilledEventHandler];

// Event Handlers
_unitWithSword addEventHandler ["Suppressed", {
	params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];

	private
	[
		"_hasSilencer"
	];
	_hasSilencer = _shooter weaponAccessories currentMuzzle _shooter param [0, ""] != "";


	if (_hasSilencer) exitWith 
	{
		if (_distance <= 9) exitWith 
		{
			_unit reveal [_instigator, 4];
			_unit setBehaviour "COMBAT";
		};
	};

	_unit reveal [_instigator, 4];
	_unit setBehaviour "COMBAT";
}];

_unitWithSword addEventHandler ["FiredNear", {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];

	private
	[
		"_hasSilencer"
	];
	_hasSilencer = _firer weaponAccessories currentMuzzle _firer param [0, ""] != "";

     if ((_hasSilencer) or (_distance > 50)) exitWith {};

	_unit reveal [_firer, 4];
	_unit setBehaviour "COMBAT";
}];

// Add hitpart event handler
[_unitWithSword, WBK_AI_DefaultHitPartEventHandler] remoteExec ["spawn", [0,-2] select isDedicated, true];

// Life path, move to nearest enemy
private
[
	"_loopPathfindDoMove"
];

_loopPathfindDoMove = [{
    params ["_array"];
	_array params ["_unit"];
	
	[_unit, selectRandom ["screamer_idle_1","screamer_idle_2","screamer_idle_3"], 50] call CBA_fnc_GlobalSay3D;
}, 30, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Handle behaviour
_unitWithSword spawn {
	private
	[
		"_unit"
	];

    _unit = _this;

	// Toggle ai functionality
	_unit disableAI "FSM";
	_unit disableAI "TARGET";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "AIMINGERROR";
	_unit disableAI "AUTOCOMBAT";

	while {((alive _unit) and !(behaviour _unit == "COMBAT"))} do 
	{
		{
			if (((speed _x >= 6) or (_x distance _unit < 5) or (speed _x <= (-6))) and (isNil {_x getVariable "WBK_AI_ISZombie"})) then 
			{
				if (behaviour _unit == "SAFE") then 
				{
					[[_unit, [0.9,0.8,0,1], 40, ""], "\WebKnight_StarWars_Mechanic\WebKnights_AI_createNotice.sqf"] remoteExec ["execVM", 0];
					[_unit, selectRandom ["screamer_idle_1","screamer_idle_2","screamer_idle_3"], 50] call CBA_fnc_GlobalSay3D;
					_unit setBehaviour "AWARE";
					_pos = ASLtoAGL getPosASLVisual _x;
					_unit doMove _pos;

					sleep 3;
				}
				else
				{
					[[_unit, [0.9,0,0,1], 40, ""], "\WebKnight_StarWars_Mechanic\WebKnights_AI_createNotice.sqf"] remoteExec ["execVM", 0];
					_unit setBehaviour "COMBAT";
				};
			};
		} forEach nearestObjects [_unit, ["Man"], 35];

		sleep 1;
	};
};

// Toggle calm and angry
_unitWithSword spawn {
	waitUntil {
		sleep 0.5; 

		if ((isNull _this) or !(alive _this)) exitWith 
		{ 
			true 
		};

		(behaviour _this == "COMBAT")
	};

	if (!(alive _this)) exitWith {};

	[_this, "WBK_Runner_Calm_Scream"] remoteExec ["switchMove", 0]; 
	[_this, "WBK_Runner_Calm_Scream"] remoteExec ["playMoveNow", 0]; 
	[_this, "screamer_scream", 520] call CBA_fnc_GlobalSay3D;

	sleep 1.5;

	if (!(alive _this) or !(animationState _this == "WBK_Runner_Calm_Scream")) exitWith {};

	[_this, "screamer_echo", 1200, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 

	_this spawn {
		{
			if (!(isNil {_x getVariable "WBK_AI_ISZombie"}) and (alive _x) and !(_x == _this)) then 
			{
				if ((_x getVariable "WBK_AI_ZombieMoveSet" != "WBK_ShooterZombie_unnarmed_idle") and (_x getVariable "WBK_AI_ZombieMoveSet" != "Star_Wars_KaaTirs_idle")) then 
				{
					[_x, "WBK_Runner_Calm_To_Angry"] remoteExec ["switchMove", 0, true];
					[_x, "WBK_Runner_Calm_To_Angry"] remoteExec ["playMoveNow", 0, true];
				};
				_x doMove (getPos _this);
			};
			sleep 0.1;
		} forEach nearestObjects [_this,["MAN"],500];
	};

	sleep 1;
	_this setBehaviour "CARELESS";

	sleep 1;
	_randomPosAroundPlayer = [[[position _this, 600]], ["water",[position _this, 300]]] call BIS_fnc_randomPos;
	_this doMove _randomPosAroundPlayer;
};

// Unconcious standup handler
[_unitWithSword, true] spawn WBK_AI_DefaultUnconStandUp;

waitUntil {
	sleep 0.5; 
	if (isNull _unitWithSword) exitWith { true };
	(!(alive _unitWithSword))
};

[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;

[_unitWithSword, {
	// Ensuring headless clients don't fall into this
	if (!hasInterface) exitWith {};

	_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated,true];
