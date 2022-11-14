/*
	WBK_ShooterZombie.sqf

	Description:
		Handles Shooter Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_ShooterZombie", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
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

if is3DEN exitWith 
{
	_mutant switchMove "WBK_ShooterZombie_unnarmed_idle";
	_mutant setFace selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4"];
	systemChat "AI Loaded in Eden";
};

(group _mutant) setSpeedMode "FULL";

// Set custom world war 2 sounds
[_mutant] call WBK_AI_SetWW2CustomSounds;

// Set up zombie behaviour
_mutant disableAI "MINEDETECTION";
_mutant disableAI "SUPPRESSION";
_mutant disableAI "COVER";
_mutant disableAI "FSM";
_mutant disableAI "AUTOCOMBAT";
_mutant setSpeaker "NoVoice";
_mutant setUnitPos "UP";
_mutant disableConversation true;

// Set up zombie variables
[_mutant] call WBK_AI_SetupDefaultZombieVariables;

[_mutant, "WBK_ShooterZombie_unnarmed_idle"] remoteExec ["switchMove", 0, true];
_mutant setVariable ["WBK_AI_ZombieMoveSet","WBK_ShooterZombie_unnarmed_idle", true];
[_mutant, selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4"]] remoteExec ["setFace", 0, true];

// Handle zombie death animations
_mutant addEventHandler ["Killed", WBK_AI_DefaultKilledEventHandler];

// Add hitpart event handler
[_mutant, WBK_AI_DefaultHitPartEventHandler] remoteExec ["spawn", [0,-2] select isDedicated, true];

// Path calculated event handler
_mutant addEventHandler ["PathCalculated",
{ 
	params
	[
		"_unit",
		"_pathFindPoses"
	];
	
	_unit spawn {
		sleep 0.5;
		if (behaviour _this == "COMBAT") exitWith 
		{
			_this playMoveNow "WBK_ShooterZombie_armed_walk";
		};

		_this playMoveNow "WBK_ShooterZombie_unnarmed_walk";
	};

	_arStart = _unit getVariable "WBK_DT_PathFindingObjects";

	if (!(isNil "_arStart")) then 
	{
		deleteVehicle _arStart;
	};

    _lastPoint = _pathFindPoses select (count _pathFindPoses - 1);
	_marker = "Sign_Arrow_Yellow_F" createVehicleLocal _lastPoint; 
	_marker hideObject true;
	_unit setVariable ["WBK_DT_PathFindingObjects",_marker];

	[_unit,_marker] spawn {
		params
		[
			"_unit",
			"_marker"
		];

		waitUntil {
			sleep 0.3; 
			if ((isNull _unit) or (isNull _marker) or !(alive _unit)) exitWith { true };
			((_unit distance _marker) <= 1)
		};

		if (behaviour _unit == "COMBAT") exitWith 
		{
			_unit playMoveNow "WBK_ShooterZombie_armed_idle";
		};

		_unit playMoveNow "WBK_ShooterZombie_unnarmed_idle";
	};
}];

// Fired event handler
_mutant addEventHandler ["Fired", {  
	params
	[
		"_obj"
	];
	
	_obj setAmmo [currentWeapon _obj, 50];

	[_obj] spawn {
		params
		[
			"_obj"
		];

		private
		[
			"_val"
		];

		_val = _obj getVariable "WBK_AmountOfAmmunition";
		_val = _val - 1;

		if (_val > 0) then 
		{
			_obj setVariable ["WBK_AmountOfAmmunition",_val,true];
		}
		else
		{
			private
			[
				"_magazineClass",
				"_value"
			];

			////Чтобы другие жесты не сбивали анимацию перезарядки дублируем её.
			_obj playActionNow "WBK_ShooterZombie_reload";
			_obj playActionNow "WBK_ShooterZombie_reload";
			_obj playActionNow "WBK_ShooterZombie_reload";
			_magazineClass = currentMagazine _obj;
			_value = getNumber (configfile >> "CfgMagazines" >> _magazineClass >> "count");
			_obj setVariable ["WBK_AmountOfAmmunition",_value,true];
		};
	};
}];


sleep 0.5;
////Ждём пока вся снаряга выдастся.
_magazineClass = currentMagazine _mutant;
_value = getNumber (configfile >> "CfgMagazines" >> _magazineClass >> "count");
_mutant setVariable ["WBK_AmountOfAmmunition",_value,true];

_mutant setSkill ["aimingSpeed", 0.1];
_mutant setSkill ["aimingAccuracy", 0.3];
_mutant setSkill ["aimingShake", 0.4];
_mutant setSkill ["spotDistance", 1];
_mutant setSkill ["spotTime", 0.55];

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

    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith 
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
			[_unit, selectRandom ["runned_or_middle_idle_1","runned_or_middle_idle_2","runned_or_middle_idle_3","runned_or_middle_idle_4"], 25] call CBA_fnc_GlobalSay3D;
		};
		_unit setBehaviour "AWARE";
	};

	_unit setBehaviour "COMBAT";
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
}, 4, [_mutant]] call CBA_fnc_addPerFrameHandler;


while {alive _mutant} do 
{
	waitUntil {
		sleep 0.5; 
		if ((isNull _mutant) or !(alive _mutant)) exitWith { true };
		(behaviour _mutant == "COMBAT")
	};

	_mutant playMoveNow "WBK_ShooterZombie_armed_idle";
	sleep 1;

	waitUntil {
		sleep 0.5; 
		if ((isNull _mutant) or !(alive _mutant)) exitWith { true };
		!(behaviour _mutant == "COMBAT")
	};

	_mutant playMoveNow "WBK_ShooterZombie_unnarmed_idle";
	sleep 1;
};

[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;