_unitWithSword = _this;
if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith {
systemChat "Wrong skeleton type. Cannot load AI.";
};
if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};
_unitWithSword setSpeaker "NoVoice";
_unitWithSword setUnitPos "UP";
_unitWithSword setVariable ["IMS_ISAI",1, true];
_unitWithSword setVariable ["WBK_AI_ISZombie",0, true];
_unitWithSword setVariable ["dam_ignore_hit0",true,true];
_unitWithSword setVariable ["dam_ignore_effect0",true,true];
removeAllWeapons _unitWithSword;
removeAllItems _unitWithSword;
removeAllAssignedItems _unitWithSword;
removeUniform _unitWithSword;
removeVest _unitWithSword;
removeBackpack _unitWithSword;
removeHeadgear _unitWithSword;
removeGoggles _unitWithSword;
_unitWithSword forceAddUniform "Zombie2_BioHazard";
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Runner_Angry_Idle", true];
[_unitWithSword, "WBK_Runner_Calm_Idle"] remoteExec ["switchMove", 0, true];
_unitWithSword disableAI "FSM";
_unitWithSword disableAI "TARGET";
_unitWithSword disableAI "AUTOTARGET";
_unitWithSword disableAI "AIMINGERROR";
_unitWithSword disableAI "AUTOCOMBAT";
_unitWithSword setBehaviour "SAFE";
_unitWithSword setVariable ["WBK_DirectionToLookAt","FRONT"];
_unitWithSword setVariable ['isMutant', true];
[_unitWithSword, "screamer_start", 720, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

_unitWithSword allowDamage false;
_unitWithSword setVariable ["CustomHPSet",14];
_unitWithSword addEventHandler ["HandleDamage",{
_zombie = _this select 0;
_hitter = _this select 3;
if ((_zombie == _hitter) or (isNull _hitter)) exitWith {};
_vv = _zombie getVariable "CustomHPSet";
_new_vv = _vv - 1;
if (_new_vv <= 0) exitWith {_zombie setDamage 1;};
_zombie setVariable ["CustomHPSet",_new_vv];

if (gestureState _zombie == "WBK_ZombieHitGest_2") exitWith {
[_zombie, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _zombie]; 
};
if (gestureState _zombie == "WBK_ZombieHitGest_1") exitWith {
[_zombie, "WBK_ZombieHitGest_2"] remoteExec ["playActionNow", _zombie]; 
};
[_zombie, "WBK_ZombieHitGest_1"] remoteExec ["playActionNow", _zombie]; 
}];
_unitWithSword spawn {
sleep 0.5;
_this doMove (getPos _this);
};



_unitWithSword addEventHandler ["Killed", {
_zombie = _this select 0;
_killer = _this select 1;
if (isBurning _zombie) exitWith {
[_zombie, selectRandom ["flamethrower_burning_1","flamethrower_burning_2","flamethrower_burning_3","flamethrower_burning_4","flamethrower_burning_7"]] remoteExec ["switchMove", 0, false];
[_zombie, selectRandom ["plagued_burn_1","plagued_burn_2","plagued_burn_3"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
[_zombie, selectRandom ["screamer_death_1","screamer_death_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
if ((isNil {_zombie getVariable "WBK_ZombieSwitchToCrawler"}) and (WBK_Zombies_EnableStaticAnimations) and !(_zombie == _killer) and !(isNull _killer)) exitWith {
[_zombie, _killer] spawn {
_victim = _this select 0;
_shooter = _this select 1;
_victim spawn {
sleep 0.02;
[_this, "Disable_Gesture"] remoteExec ["playActionNow", 0];
};
if (((_victim worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) > 0) then {
_rndAnim = selectRandom ["IMS_Die_Spec_1","A_PlayerDeathAnim_19","A_PlayerDeathAnim_17","A_PlayerDeathAnim_14","A_PlayerDeathAnim_15","A_PlayerDeathAnim_1","A_PlayerDeathAnim_2","A_PlayerDeathAnim_3","A_PlayerDeathAnim_5","A_PlayerDeathAnim_7","A_PlayerDeathAnim_8","A_PlayerDeathAnim_9","A_PlayerDeathAnim_10","A_PlayerDeathAnim_11","A_PlayerDeathAnim_12","A_PlayerDeathAnim_13"];
[_victim, _rndAnim] remoteExec ["switchMove", 0];
if (_rndAnim == "A_PlayerDeathAnim_17") exitWith {
sleep 1.95;
[_victim, [-4 * (sin (getdir _victim )), -4 * (cos (getdir _victim)), 1]] remoteExec ["setvelocity", _victim];
};
if (_rndAnim == "A_PlayerDeathAnim_19") exitWith {
sleep 0.2;
[_victim, [-5 * (sin (getdir _victim )), -5 * (cos (getdir _victim)), 0.5]] remoteExec ["setvelocity", _victim];
};
if ((_rndAnim == "A_PlayerDeathAnim_3") or (_rndAnim == "A_PlayerDeathAnim_5")) exitWith {
[_victim, [-5 * (sin (getdir _victim )), -5 * (cos (getdir _victim)), 1.35]] remoteExec ["setvelocity", _victim];
};
if ((_rndAnim == "A_PlayerDeathAnim_13")) exitWith {
sleep 0.3; 
[_victim, [1.2,0,0.1]] remoteExec ["setVelocityModelSpace", _victim];
sleep 0.2; 
[_victim, [2,0,0.3]] remoteExec ["setVelocityModelSpace", _victim];
sleep 0.2; 
[_victim, [1,0,0.3]] remoteExec ["setVelocityModelSpace", _victim];
sleep 0.2; 
[_victim, [1,0,0.3]] remoteExec ["setVelocityModelSpace", _victim];
};
if ((_rndAnim == "A_PlayerDeathAnim_12")) exitWith {
sleep 1.5; 
[_victim, [0,2,0.5]] remoteExec ["setVelocityModelSpace", _victim];
};
}else{
[_victim, selectRandom ["IMS_Die_Spec_2","A_PlayerDeathAnim_18","A_PlayerDeathAnim_20","A_PlayerDeathAnim_4","A_PlayerDeathAnim_6"]] remoteExec ["switchMove", 0];
[_victim, [5 * (sin (getdir _victim )), 5 * (cos (getdir _victim)), 1.35]] remoteExec ["setvelocity", _victim];
[_victim, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
};
};
};
}];





_unitWithSword addEventHandler ["Suppressed", {
params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
_hasSilencer = _shooter weaponAccessories currentMuzzle _shooter param [0, ""] != "";
if (_hasSilencer) exitWith {
if (_distance <= 9) exitWith {
_unit reveal [_instigator, 4];
_unit setBehaviour "COMBAT";
};
};
_unit reveal [_instigator, 4];
_unit setBehaviour "COMBAT";
}];


_unitWithSword addEventHandler ["FiredNear", {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
	_hasSilencer = _firer weaponAccessories currentMuzzle _firer param [0, ""] != "";
     if ((_hasSilencer) or (_distance > 50)) exitWith {};
	_unit reveal [_firer, 4];
	_unit setBehaviour "COMBAT";
}];



[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
_this addEventHandler [
    "HitPart",
    {
		(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];
		if ((_target == _shooter) or (isNull _shooter) or !(alive _target) or (lifeState _target == "INCAPACITATED")) exitWith {};
		_target reveal [_shooter, 4];
		_isExplosive = _ammo select 3;
		if (_isExplosive == 1) exitWith {
		_anim = selectRandom ["WBK_Runner_Fall_Forward","WBK_Runner_Fall_Back"];
		[_target, _anim] remoteExec ["switchMove", 0]; 
	    [_target, _anim] remoteExec ["playMoveNow", 0]; 
		};
		_isEnoughDamage = _ammo select 0;
		_partOfTheBody = _selection select 0;
        if (((_partOfTheBody == "head") or (_partOfTheBody == "neck")) and (_isEnoughDamage >= 10)) exitWith {
		if (_isEnoughDamage >= 14) exitWith {
		_target setDamage 1;
		if !(WBK_Zombies_EnableStaticAnimations) exitWith {
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		[_target, [_target vectorModelToWorld [0,300,0], _target selectionPosition "head"]] remoteExec ["addForce", _target];
		};
		[_target, [_target vectorModelToWorld [0,-300,0], _target selectionPosition "head"]] remoteExec ["addForce", _target];
		};
		[_target, selectRandom ["A_PlayerDeathAnim_17","A_PlayerDeathAnim_10","A_PlayerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
		};
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		[_target, "WBK_Runner_Fall_Forward"] remoteExec ["switchMove", 0]; 
	    [_target, "WBK_Runner_Fall_Forward"] remoteExec ["playMoveNow", 0]; 
		[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	    };
		[_target, "WBK_Runner_Fall_Back"] remoteExec ["switchMove", 0]; 
	    [_target, "WBK_Runner_Fall_Back"] remoteExec ["playMoveNow", 0]; 
		[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
		};
		if (gestureState _target == "WBK_ZombieHitGest_2") exitWith {
		[_target, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _target]; 
		};
		if (gestureState _target == "WBK_ZombieHitGest_1") exitWith {
		[_target, "WBK_ZombieHitGest_2"] remoteExec ["playActionNow", _target]; 
		};
		[_target, "WBK_ZombieHitGest_1"] remoteExec ["playActionNow", _target]; 
	}
];
}] remoteExec ["spawn", [0,-2] select isDedicated,true];



_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	[_unit, selectRandom ["screamer_idle_1","screamer_idle_2","screamer_idle_3"], 50] call CBA_fnc_GlobalSay3D;
}, 30, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;


_unitWithSword spawn {
    _unit = _this;
	_unit disableAI "FSM";
	_unit disableAI "TARGET";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "AIMINGERROR";
	_unit disableAI "AUTOCOMBAT";
	while {((alive _unit) and !(behaviour _unit == "COMBAT"))} do {
	{
    if (((speed _x >= 6) or (_x distance _unit < 5) or (speed _x <= (-6))) and (isNil {_x getVariable "WBK_AI_ISZombie"})) then {
	if (behaviour _unit == "SAFE") then {
	[[_unit, [0.9,0.8,0,1], 40, ""], "\WebKnight_StarWars_Mechanic\WebKnights_AI_createNotice.sqf"] remoteExec ["execVM", 0];
	[_unit, selectRandom ["screamer_idle_1","screamer_idle_2","screamer_idle_3"], 50] call CBA_fnc_GlobalSay3D;
	_unit setBehaviour "AWARE";
	_pos = ASLtoAGL getPosASLVisual _x;
	_unit doMove _pos;
	sleep 3;
	}else{
	[[_unit, [0.9,0,0,1], 40, ""], "\WebKnight_StarWars_Mechanic\WebKnights_AI_createNotice.sqf"] remoteExec ["execVM", 0];
	_unit setBehaviour "COMBAT";
	};
	};
	} forEach nearestObjects [_unit, ["Man"], 35];
	sleep 1;
	};
};




_unitWithSword spawn {
waitUntil {
sleep 0.5; 
if ((isNull _this) or !(alive _this)) exitWith { true };
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
if (!(isNil {_x getVariable "WBK_AI_ISZombie"}) and (alive _x) and !(_x == _this)) then {
if ((_x getVariable "WBK_AI_ZombieMoveSet" != "WBK_ShooterZombie_unnarmed_idle") and (_x getVariable "WBK_AI_ZombieMoveSet" != "Star_Wars_KaaTirs_idle")) then {
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


_unitWithSword spawn {
while {(alive _this)} do {
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
_this spawn {
if (!(isNil {_this getVariable "WBK_ZombieSwitchToCrawler"})) exitWith {
[_this, "WBK_Crawler_To_Idle"] remoteExec ["switchMove", 0]; 
[_this, "WBK_Crawler_To_Idle"] remoteExec ["playMoveNow", 0];
};
_rndStandUp = selectRandom ["WBK_Middle_GetUpUnconscious","WBK_Middle_GetUpUnconscious_1"];
[_this, _rndStandUp] remoteExec ["switchMove", 0]; 
[_this, _rndStandUp] remoteExec ["playMoveNow", 0];
sleep 1.9;
if (!(animationState _this == _rndStandUp)) exitWith {};
_this disableAI "ANIM";
_this disableAI "MOVE";
_rndMove = selectRandom ["WBK_Zombie_Evade_B","WBK_Zombie_Evade_L","WBK_Zombie_Evade_R"];
[_this, _rndMove] remoteExec ["switchMove", 0]; 
[_this, _rndMove] remoteExec ["playMoveNow", 0]; 
sleep 0.8;
_this enableAI "ANIM";
_this enableAI "MOVE";
};
sleep 0.1;
};
};

waitUntil {sleep 0.5; 
if (isNull _unitWithSword) exitWith { true };
(!(alive _unitWithSword))
};

///[_loopPathfind] call CBA_fnc_removePerFrameHandler;
///[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated,true];
