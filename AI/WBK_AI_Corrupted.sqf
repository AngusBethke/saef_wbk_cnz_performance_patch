_unitWithSword = _this;
if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith {
systemChat "Wrong skeleton type. Cannot load AI.";
};
if is3DEN exitWith {
_rndMoveset = selectRandom ["WBK_Middle_Idle_1","WBK_Middle_Idle"];
_unitWithSword switchMove _rndMoveset;
_unitWithSword setFace "WBK_DosHead_Corrupted";
systemChat "AI Loaded in Eden";
};


if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

_unitWithSword setVariable ["WBK_Zombie_CustomSounds",
[
["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"],
["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"]
],true];

_unitWithSword setSpeaker "NoVoice";
_unitWithSword setUnitPos "UP";
_unitWithSword setVariable ["WBK_AI_ISZombie",0, true];
_unitWithSword setVariable ['isMutant', true];
_unitWithSword setVariable ["dam_ignore_hit0",true,true];
_unitWithSword setVariable ["dam_ignore_effect0",true,true];
removeAllWeapons _unitWithSword;
removeGoggles _unitWithSword;
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet","WBK_Runner_Angry_Idle", true];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSetRunningState","WBK_Runner_Angry_Idle"];

[_unitWithSword, "WBK_DosHead_Corrupted"] remoteExec ["setFace", 0, true];
_unitWithSword spawn {
sleep 0.5;
_this doMove (getPos _this);
};






_unitWithSword spawn {
sleep 0.2;
_this removeAllEventHandlers "Killed";
_this addEventHandler ["Killed", {
_zombie = _this select 0;
_killer = _this select 1;
if (isBurning _zombie) exitWith {
[_zombie, selectRandom ["flamethrower_burning_1","flamethrower_burning_2","flamethrower_burning_3","flamethrower_burning_4","flamethrower_burning_7"]] remoteExec ["switchMove", 0, false];
[_zombie, selectRandom ["plagued_burn_1","plagued_burn_2","plagued_burn_3"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
_z = _zombie getHit "head";
if (_z < 1) then {
_zombie spawn WBK_SpawnCorruptedHead;
}else{
[_zombie, selectRandom ["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
if ((isNil {_zombie getVariable "WBK_ZombieSwitchToCrawler"}) and (WBK_Zombies_EnableStaticAnimations) and !(_zombie == _killer) and !(isNull _killer)) exitWith {
[_zombie, _killer] spawn {
_victim = _this select 0;
_shooter = _this select 1;
_victim spawn {
sleep 0.02;
[_this, "Disable_Gesture"] remoteExec ["playActionNow", 0];
};
if (((_victim worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) > 0) then {
_rndAnim = selectRandom ["A_PlayerDeathAnim_19","A_PlayerDeathAnim_17","A_PlayerDeathAnim_14","A_PlayerDeathAnim_15","A_PlayerDeathAnim_1","A_PlayerDeathAnim_2","A_PlayerDeathAnim_3","A_PlayerDeathAnim_5","A_PlayerDeathAnim_7","A_PlayerDeathAnim_8","A_PlayerDeathAnim_9","A_PlayerDeathAnim_10","A_PlayerDeathAnim_11","A_PlayerDeathAnim_12","A_PlayerDeathAnim_13"];
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
[_victim, selectRandom ["A_PlayerDeathAnim_18","A_PlayerDeathAnim_20","A_PlayerDeathAnim_4","A_PlayerDeathAnim_6"]] remoteExec ["switchMove", 0];
[_victim, [5 * (sin (getdir _victim )), 5 * (cos (getdir _victim)), 1.35]] remoteExec ["setvelocity", _victim];
[_victim, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
};
};
};
}];
};




_unitWithSword addEventHandler ["Suppressed", {
params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
_unit reveal [_instigator, 4];
}];


_unitWithSword addEventHandler ["FiredNear", {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
	_unit reveal [_firer, 4];
}];



[_unitWithSword, {
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
}] remoteExec ["spawn", [0,-2] select isDedicated,true];




_actFr = [{
    _array = _this select 0;
    _mutant = _array select 0;
	if ((lifeState _mutant == "INCAPACITATED") or !(alive _mutant)) exitWith {};
	removeAllWeapons _mutant;
    _mutant action ["SwitchWeapon", _mutant, _mutant, 100]; 
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
	if (!(_en isKindOf "MAN") or !(isNil {_en getVariable "IMS_IsUnitInvicibleScripted"}) or (_en isKindOf "WBK_C_ExportClass") or (_en isKindOf "WBK_Horses_ExportClass")) exitWith {
	};
	if !(isNil {_mutant getVariable "WBK_ZombieSwitchToCrawler"}) exitWith {
	if (
	!(animationState _mutant == "WBK_Crawler_Attack") and 
	((_mutant distance _en) <= 2.6) and
	!(animationState _mutant == "WBK_Walker_Fall_Forward_Moveset_1") and 
	!(animationState _mutant == "WBK_Walker_Fall_Forward_Moveset_2") and 
	!(animationState _mutant == "WBK_Walker_Fall_Forward_Moveset_3") and 
	!(animationState _mutant == "WBK_Walker_Fall_Back_Moveset_1") and 
	!(animationState _mutant == "WBK_Walker_Fall_Back_Moveset_2") and 
	!(animationState _mutant == "WBK_Walker_Fall_Back_Moveset_3")
	) exitWith {
	[_mutant, _en] spawn WBK_ZombieAttack_Crawler;
	};
	};
	if (
	((_mutant distance _en) <= 2.9) and 
	!(animationState _mutant == "WBK_Walker_Idle_1_attack") and 
	!(animationState _mutant == "WBK_Walker_Idle_2_attack") and 
	!(animationState _mutant == "WBK_Middle_TryingToCatch_1") and 
	!(animationState _mutant == "WBK_Middle_TryingToCatch") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_success_1") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_success_2") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_success_3") and 
	!(animationState _mutant == "WBK_Middle_GetUpUnconscious") and 
	!(animationState _mutant == "WBK_Middle_GetUpUnconscious_1") and  
	!(animationState _mutant == "WBK_Middle_hit_b_1") and 
	!(animationState _mutant == "WBK_Middle_hit_b_2") and 
	!(animationState _mutant == "WBK_Middle_hit_f_2_1") and 
	!(animationState _mutant == "WBK_Middle_hit_f_2_2") and 
	!(animationState _mutant == "WBK_Middle_hit_f_1_1") and 
	!(animationState _mutant == "WBK_Middle_hit_f_1_2") and 
	!(animationState _mutant == "WBK_Runner_hit_f_2") and 
	!(animationState _mutant == "WBK_Runner_hit_f_1") and 
	!(animationState _mutant == "WBK_Middle_Fall_Forward") and 
	!(animationState _mutant == "WBK_Middle_Fall_Forward_1") and 
	!(animationState _mutant == "WBK_Middle_Fall_Back") and 
	!(animationState _mutant == "WBK_Middle_Fall_Back_1") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Blunt_back_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Blunt_front_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_back_reversed_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_back_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_front_reversed_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_front_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_front_victim_1") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Player_1_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Player_2_victim") and
	!(gestureState _mutant == "WBK_Zombie_attack_Left") and
	!(gestureState _mutant == "WBK_Zombie_attack_Right")
	) exitWith {
	if (
	((animationState _en == "WBK_CatchedByZombie_Front") or 
	(animationState _en == "WBK_CatchedByZombie_Back") or 
	(animationState _en == "IMS_Rifle_Sync_Blunt_back_main") or 
	(animationState _en == "IMS_Rifle_Sync_Blunt_front_main") or 
	(animationState _en == "IMS_Rifle_Sync_Knife_back_main") or 
	(animationState _en == "IMS_Rifle_Sync_Knife_back_reversed_main") or 
	(animationState _en == "IMS_Rifle_Sync_Knife_front_main") or 
	(animationState _en == "IMS_Rifle_Sync_Knife_front_main_1") or 
	(animationState _en == "IMS_Rifle_Sync_Knife_front_reversed_main") or 
	(animationState _en == "IMS_Rifle_Sync_Player_1_main") or 
	(animationState _en == "IMS_Rifle_Sync_Player_2_main") or 
	(animationState _en == "IMS_KnifeExec_main") or 
	(animationState _en == "IMS_KnifeExec_main_1") or 
	(animationState _en == "IMS_Crawling_Away") or 
	(animationState _en == "Human_Execution_Bayonet_main") or 
	(animationState _en == "Human_Execution_Axe_main") or 
	(animationState _en == "Human_Execution_Blunt_main") or 
	(animationState _en == "Human_Execution_GenericHeavy_main") or 
	(animationState _en == "Human_Execution_GenericOnehanded_headSmash_1_main") or 
	(animationState _en == "Human_Execution_Shield_main") or 
	(((_mutant worldToModel (_en modelToWorld [0, 0, 0])) select 1) < 0) or 
	(speed _en >= 13) or 
	(_en isKindOf "TIOWSpaceMarine_Base") or
	!(isNil {_en getVariable "WBK_AI_ISZombie"}) or 
	!(WBK_Zombies_EnableBitingMechanic)
	) and  ((_mutant distance _en) <= 2.9)
	) exitWith { 
	[_mutant, _en] spawn WBK_ZombieAttack_gesture;
	};
	[_mutant, _en] spawn WBK_ZombieAttack_gesture;
	};
}, 0.2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;


_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _unit findNearestEnemy _unit; 
	[_unit, selectRandom ["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"], 35] call CBA_fnc_GlobalSay3D;
    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith {};
	    _pos = ASLtoAGL getPosASLVisual _nearEnemy;
		_unit doMove _pos;
}, 2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;



/*
_loopPathfind = [{
    _array = _this select 0;
    _unit = _array select 0;
	if ((lifeState _unit == "INCAPACITATED") or (captive _unit) or !(alive _unit) or !(isNil {_unit getVariable "WBK_ZombieSwitchToCrawler"})) exitWith {
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_unit enableAI "MOVE";
	};
	_nearEnemy = _unit findNearestEnemy _unit; 
	_var = ((_unit worldToModel (_nearEnemy modelToWorld [0, 0, 0])) select 2);
	hintSilent str _var;
	_posE = ATLToASL getPosATLVisual _nearEnemy;
	_pos = ATLToASL getPosATLVisual _unit;
	_ifInter = lineIntersectsSurfaces [
		[_posE select 0,_posE select 1,(_posE select 2) + 0.5], 
		[_pos select 0,_pos select 1,(_pos select 2) + 0.5], 
		_unit,
		_nearEnemy,
		true,
		1,
		"GEOM",
		"NONE"
	];
	_varRun = _unit getVariable "WBK_AI_ZombieMoveSetRunningState";
	_varIdle = _unit getVariable "WBK_AI_ZombieMoveSet";
    if (
	(isNull _nearEnemy) or 
	!(alive _nearEnemy) or 
	!(alive _unit) or 
	!(isNull attachedTo _unit) or
	!(isTouchingGround _unit) or
	((_unit distance _nearEnemy) > 15) or
	((_unit distance _nearEnemy) <= 2) or
	(((_unit worldToModel (_nearEnemy modelToWorld [0, 0, 0])) select 2) > 3) or 
	(((_unit worldToModel (_nearEnemy modelToWorld [0, 0, 0])) select 2) < (-1.4)) or 
	(!(animationState _unit == _varRun) and !(animationState _unit == _varIdle)) 
	) exitWith { 
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_unit enableAI "MOVE";
	};
	  if (count _ifInter > 0) exitWith {
	  _geomObj = (_ifInter select 0 select 2);
      if ((isNull _geomObj) or (_geomObj isKindOf "MAN")) exitWith {
	  _posE = getPosATLVisual _nearEnemy;
	   _pos = getPosATLVisual _unit;
	    drawLine3D [[_posE select 0,_posE select 1,(_posE select 2) + 0.5], [_pos select 0,_pos select 1,(_pos select 2) + 0.5], [1,1,1,1]];
	    drawIcon3D ["\a3\ui_f\data\gui\cfg\hints\BasicLook_ca.paa", [1,1,1,1], [_pos select 0,_pos select 1,(_pos select 2) + 0.5], 0.4, 0.4, 45, "TRACKING", 1, 0.05, "TahomaB"];
	    _unit disableAI "PATH";
		_unit disableAI "ANIM";
		_unit disableAI "MOVE";
		doStop _unit;
		_var = _unit getVariable "WBK_AI_ZombieMoveSetRunningState";
		_unit playMoveNow _var;
        _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
        _unit setVelocityTransformation [ 
          getPosASL _unit,  
          getPosASL _unit,  
          [0,0,(velocity _unit select 2)],  
          [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2)], 
          vectorDir _unit,  
          _dir,  
          vectorUp _unit,  
          vectorUp _unit, 
          0.1
        ]; 
	  };
	  _unit enableAI "PATH";
	  _unit enableAI "ANIM";
	  _unit enableAI "MOVE";
	  };
	   _posE = getPosATLVisual _nearEnemy;
	   _pos = getPosATLVisual _unit;
	    drawLine3D [[_posE select 0,_posE select 1,(_posE select 2) + 0.5], [_pos select 0,_pos select 1,(_pos select 2) + 0.5], [1,1,1,1]];
	    drawIcon3D ["\a3\ui_f\data\gui\cfg\hints\BasicLook_ca.paa", [1,1,1,1], [_pos select 0,_pos select 1,(_pos select 2) + 0.5], 0.4, 0.4, 45, "TRACKING", 1, 0.05, "TahomaB"];
	    _unit disableAI "PATH";
		_unit disableAI "ANIM";
		_unit disableAI "MOVE";
		doStop _unit;
		_var = _unit getVariable "WBK_AI_ZombieMoveSetRunningState";
		_unit playMoveNow _var;
        _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
        _unit setVelocityTransformation [ 
          getPosASL _unit,  
          getPosASL _unit,  
          [0,0,(velocity _unit select 2)],  
          [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2)], 
          vectorDir _unit,  
          _dir,  
          vectorUp _unit,  
          vectorUp _unit, 
          0.1
        ]; 
}, 0.01, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;
*/


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
};
sleep 0.1;
};
};

waitUntil {sleep 0.5; 
if (isNull _unitWithSword) exitWith { true };
(!(alive _unitWithSword))
};

///[_loopPathfind] call CBA_fnc_removePerFrameHandler;
[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated,true];
