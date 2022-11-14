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
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","Corrupted_idle", true];

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
if !(isNull attachedTo _obj1) exitWith {};
[_zombie, selectRandom ["Corrupted_die_1","Corrupted_die_2"]] remoteExec ["switchMove", 0]; 
}];

if ("ace_medical_engine" in activatedAddons) then {
_unitWithSword addEventHandler ["HandleDamage", {
_unit = _this select 0;
_hitter = _this select 3;
if (!(_unit == _hitter) and !(isNull _hitter)) then {
_unit setDamage ((damage _unit) + 0.5);
};
}];
};

_actFr = [{
    _array = _this select 0;
    _mutant = _array select 0;
	if ((animationState _mutant == "Corrupted_in_AIR") or (animationState _mutant == "Corrupted_Attack") or (animationState _mutant == "Corrupted_attack_success_front") or (animationState _mutant == "Corrupted_attack_success_back") or (animationState _mutant == "Corrupted_Attack_victim") or (animationState _mutant == "Corrupted_attack_success_failed") or (animationState _mutant == "Corrupted_attack_success_dying") or (animationState _mutant == "Corrupted_die_1") or (animationState _mutant == "Corrupted_die_2") or !(isTouchingGround _mutant) or !(alive _mutant)) exitWith {};
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
    if ((count _ins == 0) and ((_en distance _mutant) <= 2.5) and (alive _mutant) and !(lifeState _en == "INCAPACITATED") and (getText (configfile >> 'CfgVehicles' >> typeOf _en >> 'moves') == 'CfgMovesMaleSdr')) exitWith {
	[_mutant, _en] spawn WBK_HeadTryingToGrab;
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
	[_unit, selectRandom ["corrupted_head_idle_1","corrupted_head_idle_2"],20] call CBA_fnc_GlobalSay3d;
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
