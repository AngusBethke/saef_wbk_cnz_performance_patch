/*
	WBK_AI_CorruptedHead.sqf

	Description:
		Handles Corrupted Head Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_CorruptedHead", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
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
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","Corrupted_idle", true];

// Set up event handlers
[_unitWithSword] call WBK_AI_AddDefaulEventHandlers;

_unitWithSword addEventHandler ["Killed", {
	params ["_zombie"];
	if !(isNull attachedTo _obj1) exitWith {};
	[_zombie, selectRandom ["Corrupted_die_1","Corrupted_die_2"]] remoteExec ["switchMove", 0]; 
}];

// Ensure damage is handled correctly for ace
if ("ace_medical_engine" in activatedAddons) then {
	_unitWithSword addEventHandler ["HandleDamage", {
		params
		[
			"_unit",
			"_someSecondVar",
			"_someThirdVar",
			"_hitter"
		];

		if (!(_unit == _hitter) and !(isNull _hitter)) then {
			_unit setDamage ((damage _unit) + 0.5);
		};
	}];
};

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
		"_allowedAnimStates"
	];

	_allowedAnimStates = ["Corrupted_in_AIR", "Corrupted_Attack", "Corrupted_attack_success_front", "Corrupted_attack_success_back",
		"Corrupted_Attack_victim", "Corrupted_attack_success_failed", "Corrupted_attack_success_dying", "Corrupted_die_1",
		"Corrupted_die_2"];
	
	if (((animationState _mutant) in _allowedAnimStates) or 
		!(isTouchingGround _mutant) or 
		!(alive _mutant)) exitWith {};
    
	// Find the nearest enemy
	_en = _mutant findNearestEnemy _mutant;

	// Ensuring distance between nearest enemy and zombie is done first, so that we do not have to waste resources executing the rest of this code
	if ((_en distance _mutant) > 2.5) exitWith {};

	// Check if the unit can do the head grab
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

    if ((count _ins == 0) and 
		((_en distance _mutant) <= 2.5) and 
		(alive _mutant) and 
		!(lifeState _en == "INCAPACITATED") and 
		(getText (configfile >> 'CfgVehicles' >> typeOf _en >> 'moves') == 'CfgMovesMaleSdr')) 
	exitWith 
	{
		[_mutant, _en] spawn WBK_HeadTryingToGrab;
	};
}, 0.4, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

// Life path, move to nearest enemy
private
[
	"_loopPathfindDoMove"
];

_loopPathfindDoMove = [{
	params ["_array"];
	_array params ["_mutant"];
	
	if ((lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};

	_nearEnemy = _unit findNearestEnemy _unit; 
	[_unit, selectRandom ["corrupted_head_idle_1","corrupted_head_idle_2"], 20] call CBA_fnc_GlobalSay3d;

    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith {};

	_pos = ASLtoAGL getPosASLVisual _nearEnemy;
	_unit doMove _pos;
}, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

waitUntil {
	sleep 0.5; 
	if (isNull _unitWithSword) exitWith { true };
	!(alive _unitWithSword)
};

// Remove per frame event handlers
[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;