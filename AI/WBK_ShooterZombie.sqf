_mutant = _this;
if (getText (configfile >> 'CfgVehicles' >> typeOf _mutant >> 'moves') != 'CfgMovesMaleSdr') exitWith {
systemChat "Wrong skeleton type. Cannot load AI.";
};
if is3DEN exitWith {
_mutant switchMove "WBK_ShooterZombie_unnarmed_idle";
_mutant setFace selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4"];
systemChat "AI Loaded in Eden";
};



if ((isPlayer _mutant) or !(isNil {_mutant getVariable "WBK_AI_ISZombie"}) or !(alive _mutant)) exitWith {};
if (
(getText (configfile >> "CfgVehicles" >> typeOf _mutant >> "editorSubcategory") == "LIB_US_ARMY") or
(getText (configfile >> "CfgVehicles" >> typeOf _mutant >> "editorSubcategory") == "LIB_RKKA") or
(getText (configfile >> "CfgVehicles" >> typeOf _mutant >> "editorSubcategory") == "LIB_WEHRMACHT") or
(getText (configfile >> "CfgVehicles" >> typeOf _mutant >> "editorSubcategory") == "WBK_Zombies_WW2_German") or
(getText (configfile >> "CfgVehicles" >> typeOf _mutant >> "editorSubcategory") == "WBK_Zombies_WW2_RKKA") or
(getText (configfile >> "CfgVehicles" >> typeOf _mutant >> "editorSubcategory") == "WBK_Zombies_WW2_US")
) then {
_mutant setVariable ["WBK_Zombie_CustomSounds",
[
["WW2_Zombie_idle1","WW2_Zombie_idle2","WW2_Zombie_idle3","WW2_Zombie_idle4","WW2_Zombie_idle5","WW2_Zombie_idle6"],
["WW2_Zombie_walker1","WW2_Zombie_walker2","WW2_Zombie_walker3","WW2_Zombie_walker4","WW2_Zombie_walker5"],
["WW2_Zombie_attack1","WW2_Zombie_attack2","WW2_Zombie_attack3","WW2_Zombie_attack4","WW2_Zombie_attack5"],
["WW2_Zombie_death1","WW2_Zombie_death2","WW2_Zombie_death3","WW2_Zombie_death4","WW2_Zombie_death5"],
["WW2_Zombie_burning1","WW2_Zombie_burning2","WW2_Zombie_burning3"]
],true];
};
group _mutant setSpeedMode "FULL";
_mutant setSpeaker "NoVoice";
_mutant setUnitPos "UP";
_mutant setVariable ["WBK_AI_ISZombie",0, true];
_mutant setVariable ['isMutant', true];
_mutant setVariable ["dam_ignore_hit0",true,true];
_mutant setVariable ["dam_ignore_effect0",true,true];
[_mutant, "WBK_ShooterZombie_unnarmed_idle"] remoteExec ["switchMove", 0, true];
_mutant setVariable ["WBK_AI_ZombieMoveSet","WBK_ShooterZombie_unnarmed_idle", true];
[_mutant, selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4"]] remoteExec ["setFace", 0, true];



_mutant addEventHandler ["Killed", {
_zombie = _this select 0;
_killer = _this select 1;
if !(isNil {_zombie getVariable "WBK_AI_Zombie_DecapHead_BEHIND"}) exitWith {
[_zombie, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie unlinkItem hmd _zombie;
removeGoggles _zombie;
removeHeadgear _zombie;
[_zombie, {
_object = _this;
_object setFace "WBK_DosHead_BackHole";
if (!(WBK_Zombies_EnableHeadShotsParticles)) exitWith {};
_breath = "#particlesource" createVehicleLocal (getposATL _object);                      
_breath setParticleParams            
	[            
		["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], //shape name            
		"", //anim name            
		"spaceObject",        
		0.5, 12, //timer period & life time            
		[0, 0, 0], //pos         
		[3 + random -3, 2 + random -2, random 3], //moveVel       
		1,1.275,0.2,0, //rotation vel, weight, volume, rubbing            
		[1.6,0], //size transform           
		[[0.005,0,0,0.05], [0.006,0,0,0.06], [0.2,0,0,0]],      
		[1000], //animationPhase (speed in config)            
		1, //randomdirection period            
		0.1, //random direction intensity            
		"", //onTimer            
		"", //before destroy            
		"", //object            
		0, //angle            
		false, //on surface            
		0.0 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.25;
deleteVehicle _breath; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
};
if !(isNil {_zombie getVariable "WBK_AI_Zombie_DecapHead_FRONT"}) exitWith {
[_zombie, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
removeGoggles _zombie;
[_zombie, {
_object = _this;
_object setFace "WBK_DosHead_FrontHole";
if (!(WBK_Zombies_EnableHeadShotsParticles)) exitWith {};
_breath = "#particlesource" createVehicleLocal (getposATL _object);                      
_breath setParticleParams            
	[            
		["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], //shape name            
		"", //anim name            
		"spaceObject",        
		0.5, 12, //timer period & life time            
		[0, 0, 0], //pos         
		[3 + random -3, 2 + random -2, random 3], //moveVel       
		1,1.275,0.2,0, //rotation vel, weight, volume, rubbing            
		[1.6,0], //size transform           
		[[0.005,0,0,0.05], [0.006,0,0,0.06], [0.2,0,0,0]],      
		[1000], //animationPhase (speed in config)            
		1, //randomdirection period            
		0.1, //random direction intensity            
		"", //onTimer            
		"", //before destroy            
		"", //object            
		0, //angle            
		false, //on surface            
		0.0 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.25;
deleteVehicle _breath; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
};
if !(isNil {_zombie getVariable "WBK_AI_Zombie_DecapHead"}) exitWith {
[_zombie, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie unlinkItem hmd _zombie;
removeGoggles _zombie;
removeHeadgear _zombie;
[_zombie, {
_object = _this;
_object setFace "WBK_DecapatedHead_Normal";
if (!(WBK_Zombies_EnableHeadShotsParticles)) exitWith {};
_blood = "#particlesource" createVehicleLocal (getposATL _object);          
_blood attachTo [_object,[0,0,0],"head"];  
_blood setParticleParams [ 
		["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 13, 1, 32],   //model name            
		"",   //animation            
		"billboard", //type            
		0.1, 2, //period and lifecycle            
		[0, 0, 0], //position            

		[3 + random -6, 3 + random -6, 2], //movement vector            
		5, 6, 0.4, 0.4, //rotation, weight, volume , rubbing            
		[0.05, 1.4], //size transform            
		[[0.5,0,0,0.6], [0.8,0,0,0.1], [0.1,0,0,0.03]],    
		[0.00001],    
		0.4,    
		0.4,    
		"",    
		"",    
		"",   
		360, //angle             
		false, //on surface             
		0 //bounce on surface     
	];  
_blood setdropinterval 0.01;  
_breath = "#particlesource" createVehicleLocal (getposATL _object);                      
_breath setParticleParams            
	[            
		["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], //shape name            
		"", //anim name            
		"spaceObject",        
		0.5, 12, //timer period & life time            
		[0, 0, 0], //pos         
		[3 + random -3, 2 + random -2, random 3], //moveVel       
		1,1.275,0.2,0, //rotation vel, weight, volume, rubbing            
		[1.6,0], //size transform           
		[[0.005,0,0,0.05], [0.006,0,0,0.06], [0.2,0,0,0]],      
		[1000], //animationPhase (speed in config)            
		1, //randomdirection period            
		0.1, //random direction intensity            
		"", //onTimer            
		"", //before destroy            
		"", //object            
		0, //angle            
		false, //on surface            
		0.0 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.15;
deleteVehicle _breath; 
sleep 0.9;
deleteVehicle _blood; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
};
if (isBurning _zombie) exitWith {
[_zombie, selectRandom ["flamethrower_burning_1","flamethrower_burning_2","flamethrower_burning_3","flamethrower_burning_4","flamethrower_burning_7"]] remoteExec ["switchMove", 0, false];
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 4;
[_zombie, selectRandom _snds, 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
}else{
[_zombie, selectRandom ["plagued_burn_1","plagued_burn_2","plagued_burn_3"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
};
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 3;
[_zombie, selectRandom _snds, 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
}else{
[_zombie, selectRandom ["plagued_death_1","plagued_death_2","plagued_death_3","plagued_death_4","plagued_death_5","plagued_death_6","plagued_death_7","plagued_death_8","plagued_death_9"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
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


[_mutant, {
_this removeAllEventHandlers "HitPart";
_this addEventHandler [
    "HitPart",
    {
		(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];
		if ((_target == _shooter) or (isNull _shooter) or !(alive _target) or (lifeState _target == "INCAPACITATED")) exitWith {};
		_isEnoughDamage = _ammo select 0;
		_partOfTheBody = _selection select 0;
        if (((_partOfTheBody == "head") or (_partOfTheBody == "neck")) and (_isEnoughDamage >= 10.5)) exitWith {
		if (_isEnoughDamage >= 14) exitWith {
		_target setVariable ["WBK_AI_Zombie_DecapHead",1,true];
		_target setDamage 1;
		if !(WBK_Zombies_EnableStaticAnimations) exitWith {
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		[_target, [_target vectorModelToWorld [0,300,0], _target selectionPosition "head"]] remoteExec ["addForce", _target];
		};
		[_target, [_target vectorModelToWorld [0,-300,0], _target selectionPosition "head"]] remoteExec ["addForce", _target];
		};
		[_target, selectRandom ["A_PlayerDeathAnim_17","A_PlayerDeathAnim_10","A_PlayerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
		};
		if !(WBK_Zombies_EnableStaticAnimations) exitWith {
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		[_target, [_target vectorModelToWorld [0,300,0], _target selectionPosition "head"]] remoteExec ["addForce", _target];
		_target setVariable ["WBK_AI_Zombie_DecapHead_BEHIND",1,true];
		_target setDamage 1;
		};
		[_target, [_target vectorModelToWorld [0,-300,0], _target selectionPosition "head"]] remoteExec ["addForce", _target];
		_target setVariable ["WBK_AI_Zombie_DecapHead_FRONT",1,true];
		_target setDamage 1;
		};
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		_target setVariable ["WBK_AI_Zombie_DecapHead_BEHIND",1,true];
		_target setDamage 1;
		[_target, selectRandom ["A_PlayerDeathAnim_18","A_PlayerDeathAnim_4","A_PlayerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
		};
		_target setVariable ["WBK_AI_Zombie_DecapHead_FRONT",1,true];
		_target setDamage 1;
		[_target, selectRandom ["A_PlayerDeathAnim_17","A_PlayerDeathAnim_10","A_PlayerDeathAnim_11"]] remoteExec ["switchMove", 0, false];
		};
		if (gestureState _target == "WBK_ZombieHitGest_2_weapon") exitWith {
		[_target, "WBK_ZombieHitGest_3_weapon"] remoteExec ["playActionNow", _target]; 
		};
		if (gestureState _target == "WBK_ZombieHitGest_1_weapon") exitWith {
		[_target, "WBK_ZombieHitGest_2_weapon"] remoteExec ["playActionNow", _target]; 
		};
		[_target, "WBK_ZombieHitGest_1_weapon"] remoteExec ["playActionNow", _target]; 
	}
];
}] remoteExec ["spawn", [0,-2] select isDedicated,true];



_mutant addEventHandler ["PathCalculated",
{ 
	_unit = _this select 0;
	_unit spawn {
	sleep 0.5;
	if (behaviour _this == "COMBAT") exitWith {_this playMoveNow "WBK_ShooterZombie_armed_walk";};
	_this playMoveNow "WBK_ShooterZombie_unnarmed_walk";
	};
	_pathFindPoses = _this select 1;
	_arStart = _unit getVariable "WBK_DT_PathFindingObjects";
	if (!(isNil "_arStart")) then {
	deleteVehicle _arStart;
	};
    _lastPoint = _pathFindPoses select (count _pathFindPoses - 1);
	_marker = "Sign_Arrow_Yellow_F" createVehicleLocal _lastPoint; 
	_marker hideObject true;
	_unit setVariable ["WBK_DT_PathFindingObjects",_marker];
[_unit,_marker] spawn {
_unit = _this select 0;
_marker = _this select 1;
waitUntil {
sleep 0.3; 
if ((isNull _unit) or (isNull _marker) or !(alive _unit)) exitWith { true };
((_unit distance _marker) <= 1)
};

if (behaviour _unit == "COMBAT") exitWith {_unit playMoveNow "WBK_ShooterZombie_armed_idle";};
_unit playMoveNow "WBK_ShooterZombie_unnarmed_idle";
};
}];


_mutant addEventHandler ["Fired", {  
_obj = _this select 0; 
_obj setAmmo [currentWeapon _obj, 50];
[_obj] spawn {
_obj = _this select 0;
_val = _obj getVariable "WBK_AmountOfAmmunition";
_val = _val - 1;
if (_val > 0) then {
_obj setVariable ["WBK_AmountOfAmmunition",_val,true];
}else{
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


_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _unit findNearestEnemy _unit; 
    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAIFeature "MOVE")) exitWith {
	if (!(isNil {_unit getVariable "WBK_Zombie_CustomSounds"})) then {
	    _snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 0;
        [_unit, selectRandom _snds, 20] call CBA_fnc_GlobalSay3D;
	}else{
	    [_unit, selectRandom ["runned_or_middle_idle_1","runned_or_middle_idle_2","runned_or_middle_idle_3","runned_or_middle_idle_4"], 25] call CBA_fnc_GlobalSay3D;
	};
	_unit setBehaviour "AWARE";
	};
		_unit setBehaviour "COMBAT";
		if (!(isNil {_unit getVariable "WBK_Zombie_CustomSounds"})) then {
			_snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 1;
            [_unit, selectRandom _snds, 20] call CBA_fnc_GlobalSay3D;
		}else{
			[_unit, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6","plagued_attack_9"], 20] call CBA_fnc_GlobalSay3D;
		};
}, 4, [_mutant]] call CBA_fnc_addPerFrameHandler;


while {alive _mutant} do {
_mutant disableAI "MINEDETECTION";
_mutant disableAI "SUPPRESSION";
_mutant disableAI "COVER";
_mutant disableAI "FSM";
_mutant disableAI "AUTOCOMBAT";
waitUntil {sleep 0.5; 
if ((isNull _mutant) or !(alive _mutant)) exitWith { true };
(behaviour _mutant == "COMBAT")
};
_mutant playMoveNow "WBK_ShooterZombie_armed_idle";
sleep 1;
waitUntil {sleep 0.5; 
if ((isNull _mutant) or !(alive _mutant)) exitWith { true };
!(behaviour _mutant == "COMBAT")};
_mutant playMoveNow "WBK_ShooterZombie_unnarmed_idle";
sleep 1;
};
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;