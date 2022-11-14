_unitWithSword = _this;

if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};
sleep 0.1;
_unitWithSword setUnitPos "UP";
_unitWithSword setVariable ["WBK_AI_ISZombie",0, true];
_unitWithSword setVariable ['isMutant', true];
_unitWithSword setSpeaker "NoVoice";
_unitWithSword setVariable ["dam_ignore_hit0",true,true];
_unitWithSword setVariable ["dam_ignore_effect0",true,true];
_unitWithSword disableConversation true;
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Smasher_Idle", true];


_unitWithSword setVariable ["WBK_SynthHP",WBK_Zombies_SmasherHP,true];
if !(WBK_Zombies_SmasherRockAbil) then {
_unitWithSword setVariable ["CanThrowRocks",0];
};
if !(WBK_Zombies_SmasherFlyAbil) then {
_unitWithSword setVariable ["CanFly",0];
};





_unitWithSword addEventHandler ["Suppressed", {
params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
if (!(alive _unit)) exitWith {};
_unit reveal [_instigator, 4];
}];


_unitWithSword addEventHandler ["FiredNear", {
params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
if (!(alive _unit)) exitWith {};
_unit reveal [_firer, 4];
}];


_unitWithSword addEventHandler ["Killed", {
_zombie = _this select 0;
_zombie removeAllEventHandlers "HandleDamage";
[_zombie, "WBK_Smasher_Die"] remoteExec ["switchMove", 0]; 
[_zombie, selectRandom ["Smasher_die_1","Smasher_die_2","Smasher_die_3","Smasher_die_4"], 225, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
_zombie spawn {sleep 0.8; if (isNull _this) exitWith {}; [_this, "Smasher_hit", 155, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; };
}];


[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
_this addEventHandler [
    "HitPart",
    {
		(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];
		if ((animationState _target == "WBK_Smasher_inAir_start_onRun") or (animationState _target == "WBK_Smasher_inAir_start") or (animationState _target == "WBK_Smasher_inAir_end") or (animationState _target == "WBK_Smasher_Attack_VEHICLE") or (animationState _target == "WBK_Smasher_Throw") or (animationState _target == "WBK_Smasher_HitHard") or (animationState _target == "WBK_Smasher_Execution") or (_target == _shooter) or (isNull _shooter) or !(alive _target)) exitWith {};
		_isExplosive = _ammo select 3;
		_isEnoughDamage = _ammo select 0;
		if !(isNil "WBK_ZombiesShowDebugDamage") then {
        systemChat str _isEnoughDamage;
		};
		if (((_isExplosive == 1) or (_isEnoughDamage >= 100)) and (isNil {_target getVariable "CanBeStunnedIMS"})) exitWith {
		[_target, "Smasher_eat_voice", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
		[_target, "WBK_Smasher_HitHard"] remoteExec ["switchMove", 0]; 
		[_target, "WBK_Smasher_HitHard"] remoteExec ["playMoveNow", 0];
		_target enableAI "MOVE";
		_target enableAI "ANIM";
		_target setVariable ["CanBeStunnedIMS",1,true]; 
		_target spawn {sleep 6; _this setVariable ["CanBeStunnedIMS",nil,true];};
		_vv = _target getVariable "WBK_SynthHP";
		_new_vv = _vv - _isEnoughDamage;
		if (_new_vv <= 0) exitWith {_target removeAllEventHandlers "HitPart"; _target setDamage 1;};
		_target setVariable ["WBK_SynthHP",_new_vv,true];
		};
		_vv = _target getVariable "WBK_SynthHP";
		_new_vv = _vv - _isEnoughDamage;
		if (_new_vv <= 0) exitWith {_target removeAllEventHandlers "HitPart"; _target setDamage 1;};
		_target setVariable ["WBK_SynthHP",_new_vv,true];
		_target enableAI "MOVE";
	}
];
}] remoteExec ["spawn", [0,-2] select isDedicated,true];

_actFr = [{
    _array = _this select 0;
    _mutant = _array select 0;
	_mutant allowDamage false;
	if ((animationState _mutant == "WBK_Smasher_Throw") or (animationState _mutant == "WBK_Smasher_HitHard") or (animationState _mutant == "WBK_Smasher_Attack_3") or (animationState _mutant == "WBK_Smasher_Attack_1") or (animationState _mutant == "WBK_Smasher_Attack_2") or (animationState _mutant == "WBK_Smasher_inAir") or (animationState _mutant == "WBK_Smasher_inAir_start") or (animationState _mutant == "WBK_Smasher_inAir_start_onRun") or (animationState _mutant == "WBK_Smasher_inAir_end") or (animationState _mutant == "WBK_Smasher_Execution") or (animationState _mutant == "WBK_Smasher_Roar") or (animationState _mutant == "WBK_Smasher_Attack_VEHICLE") or (animationState _mutant == "WBK_Smasher_Die") or !(isTouchingGround _mutant) or !(alive _mutant)) exitWith {};
    _mutant action ["SwitchWeapon", _mutant, _mutant, 100]; 
	removeAllWeapons _mutant;
	_mutant disableAI "MINEDETECTION";
	_mutant disableAI "WEAPONAIM";
	_mutant disableAI "SUPPRESSION";
	_mutant disableAI "COVER";
	_mutant disableAI "AIMINGERROR";
	_mutant disableAI "TARGET";
	_mutant disableAI "AUTOCOMBAT";
	_mutant disableAI "FSM";
	_mutant setBehaviour "CARELESS";
	_en = _mutant findNearestEnemy _mutant;
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
	if ((isNil {_mutant getVariable "CanThrowRocks"}) and !(currentWeapon _en in IMS_Melee_Weapons) and ((_en distance _mutant) > 10) and ((_en distance _mutant) <= 70) and (alive _mutant) and (!((vehicle _en) isKindOf "MAN") or ((speed (vehicle _en)) >= 13) or ((_en distance _mutant) >= 35) or (_en isKindOf "TIOWSpaceMarine_Base"))) exitWith {
	[_mutant, vehicle _en] spawn WBK_Smasher_RockThrowing;
	};
	if (((_en distance _mutant) <= 6.3) and !((vehicle _en) isKindOf "MAN") and (alive _mutant)) exitWith {
	[_mutant, vehicle _en] spawn WBK_Smasher_VehicleAttack;
	};
	if ((count _ins == 0) and (isNil {_mutant getVariable "WBK_CanMakeRoar"}) and ((_en distance _mutant) <= 45) and ((_en distance _mutant) > 15) and !(isNull _en) and (alive _en)) exitWith {
	[_mutant, _en] spawn WBK_Smasher_MakeRoar;
	};
	if ((count _ins == 0) and (isNil {_mutant getVariable "CanFly"}) and ((_en distance _mutant) <= 25) and ((_en distance _mutant) > 8) and !(isNull _en) and (alive _en)) exitWith {
	_mutant setFormDir (_mutant getDir _en);
	[_mutant, _en] spawn WBK_ChargerJump;
	};
    if ((count _ins == 0) and ((_en distance _mutant) <= 4) and (alive _mutant) and !(lifeState _en == "INCAPACITATED")) exitWith {
	if ((isNil {_mutant getVariable "WBK_CanEatSomebody"}) and (getText (configfile >> 'CfgVehicles' >> typeOf _en >> 'moves') == 'CfgMovesMaleSdr')) exitWith {
	if ((isPlayer _en) and (currentWeapon _en in IMS_Melee_Weapons)) exitWith {
	[_mutant, _en] spawn selectRandom [WBK_Smasher_HumanoidAttack_4,WBK_Smasher_HumanoidAttack_2,WBK_Smasher_HumanoidAttack_1,WBK_Smasher_HumanoidAttack_3];
	};
	_mutant setVariable ["WBK_CanEatSomebody",1];
	[_mutant, _en] spawn WBK_Smasher_ExecutionFnc;
	};
	[_mutant, _en] spawn selectRandom [WBK_Smasher_HumanoidAttack_4,WBK_Smasher_HumanoidAttack_2,WBK_Smasher_HumanoidAttack_1,WBK_Smasher_HumanoidAttack_3];
	};
}, 0.4, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;


/*
_actFr_Loop = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _unit findNearestEnemy _unit;
	if (((_nearEnemy distance _unit) <= 320) and ((animationState _unit == "antlionGuardian_Charge_Loop") or (animationState _unit == "antlionGuardian_Charge_Start") or (animationState _unit == "antlionGuardian_Roar")) and !(isNull _nearEnemy) and (alive _nearEnemy)) then {
	_ins = lineIntersectsSurfaces [
		AGLToASL (_unit modelToWorld [0,0,0.5]), 
		AGLToASL (_unit modelToWorld [0,1,0.5]), 
		_unit,
		_nearEnemy,
		true,
		1,
		"GEOM",
		"NONE"
    ];
	if ((animationState _unit == "antlionGuardian_Charge_Loop") and (count _ins > 0)) exitWith {
	[_unit, "antlionGuardian_Charge_Crash"] remoteExec ["switchMove", 0];
	_unit playMove "antlionGuardian_Charge_Crash";
	_unit spawn {uiSleep 3; _this enableAI "MOVE";};
	[_unit, selectRandom ["WBK_AG_shell_crack_1","WBK_AG_shell_crack_2"], 85, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	};
	if ((animationState _unit == "antlionGuardian_Charge_Loop") and ((_unit distance _nearEnemy) <= 2.1)) exitWith {
	[_unit, "antlionGuardian_Charge_End"] remoteExec ["switchMove", 0];
	_unit enableAI "MOVE";
	if !(isNil {_nearEnemy getVariable "IMS_IsUnitInvicibleScripted"}) exitWith {};
	if !(isPlayer _nearEnemy) then {
	_nearEnemy setDamage 1;
	_nearEnemy spawn WBK_OB_FriendlyDown_Combine;
	}else{
	[_nearEnemy, 0.5, _unit] remoteExec ["WBK_CreateDamage", _nearEnemy];
	[_nearEnemy, ["","pain_01","pain_02","pain_03","pain_04","pain_05","pain_06","pain_07","pain_08","pain_09","pain_10"], 70, true] call WBK_MakeVoiceOver_Combine;
	};
	[_nearEnemy, [_unit vectorModelToWorld [0,3000,800], _nearEnemy selectionPosition "head"]] remoteExec ["addForce", _nearEnemy];
	[_unit, selectRandom ["WBK_AG_attack_1","WBK_AG_attack_2","WBK_AG_attack_3"], 85, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	[_nearEnemy, "dobi_CriticalHit", 125, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	[_nearEnemy, "WBK_AG_Hit", 155, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	_nearEnemy spawn {uiSleep 9; [_this, false] remoteExec ["setUnconscious", _this];};
	_unit enableAI "MOVE";
	};
	_dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2)],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2)-1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
	};
}, 0.01, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;
*/



_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	if ((lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};
	_nearEnemy = _unit findNearestEnemy _unit; 
	[_unit, selectRandom ["Smasher_idle_1","Smasher_idle_2","Smasher_idle_3","Smasher_idle_4"],40] call CBA_fnc_GlobalSay3d;
    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith {};
	    _pos = ASLtoAGL getPosASLVisual _nearEnemy;
		_unit doMove _pos;
}, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

waitUntil {sleep 0.5; 
if (isNull _unitWithSword) exitWith { true };
!(alive _unitWithSword)
};
[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
