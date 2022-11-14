_unitWithSword = _this select 0;
_isCrawler = _this select 1;
if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith {
systemChat "Wrong skeleton type. Cannot load AI.";
};
if is3DEN exitWith {
if (_isCrawler) then {
_unitWithSword switchMove "WBK_Crawler_Idle";
}else{
_rndMoveset = selectRandom ["WBK_Walker_Idle_1","WBK_Walker_Idle_2","WBK_Walker_Idle_3"];
_unitWithSword switchMove _rndMoveset;
};
_unitWithSword setFace selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4","WBK_DosHead_Normal_1","WBK_DosHead_Normal_2","WBK_DosHead_Normal_3"];
systemChat "AI Loaded in Eden";
};


if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};
if (
(getText (configfile >> "CfgVehicles" >> typeOf _unitWithSword >> "editorSubcategory") == "LIB_US_ARMY") or
(getText (configfile >> "CfgVehicles" >> typeOf _unitWithSword >> "editorSubcategory") == "LIB_RKKA") or
(getText (configfile >> "CfgVehicles" >> typeOf _unitWithSword >> "editorSubcategory") == "LIB_WEHRMACHT") or
(getText (configfile >> "CfgVehicles" >> typeOf _unitWithSword >> "editorSubcategory") == "WBK_Zombies_WW2_German") or
(getText (configfile >> "CfgVehicles" >> typeOf _unitWithSword >> "editorSubcategory") == "WBK_Zombies_WW2_RKKA") or
(getText (configfile >> "CfgVehicles" >> typeOf _unitWithSword >> "editorSubcategory") == "WBK_Zombies_WW2_US")
) then {
_unitWithSword setVariable ["WBK_Zombie_CustomSounds",
[
["WW2_Zombie_idle1","WW2_Zombie_idle2","WW2_Zombie_idle3","WW2_Zombie_idle4","WW2_Zombie_idle5","WW2_Zombie_idle6"],
["WW2_Zombie_walker1","WW2_Zombie_walker2","WW2_Zombie_walker3","WW2_Zombie_walker4","WW2_Zombie_walker5"],
["WW2_Zombie_attack1","WW2_Zombie_attack2","WW2_Zombie_attack3","WW2_Zombie_attack4","WW2_Zombie_attack5"],
["WW2_Zombie_death1","WW2_Zombie_death2","WW2_Zombie_death3","WW2_Zombie_death4","WW2_Zombie_death5"],
["WW2_Zombie_burning1","WW2_Zombie_burning2","WW2_Zombie_burning3"]
],true];
};


_unitWithSword setSpeaker "NoVoice";
_unitWithSword setUnitPos "UP";
_unitWithSword setVariable ["WBK_AI_ISZombie",0, true];
_unitWithSword setVariable ['isMutant', true];
_unitWithSword setVariable ["dam_ignore_hit0",true,true];
_unitWithSword setVariable ["dam_ignore_effect0",true,true];
removeAllWeapons _unitWithSword;
removeAllAssignedItems _unitWithSword;
removeGoggles _unitWithSword;

if (_isCrawler) then {
_rndMoveset = selectRandom ["WBK_Walker_Idle_1","WBK_Walker_Idle_2","WBK_Walker_Idle_3"];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet",_rndMoveset, true];
[_unitWithSword, 'WBK_Crawler_To_Idle'] remoteExec ['switchMove', 0]; 
_unitWithSword setVariable ['WBK_ZombieSwitchToCrawler',1,true];
}else{
_rndMoveset = selectRandom ["WBK_Walker_Idle_1","WBK_Walker_Idle_2","WBK_Walker_Idle_3"];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet",_rndMoveset, true];
[_unitWithSword, _rndMoveset] remoteExec ["switchMove", 0, true];
};



_rndFace = selectRandom ["WBK_ZombieFace_blood_1","WBK_ZombieFace_blood_2","WBK_ZombieFace_blood_3","WBK_ZombieFace_blood_4","WBK_DosHead_Normal_1","WBK_DosHead_Normal_2","WBK_DosHead_Normal_3"];
if ((_rndFace == "WBK_DosHead_Normal_1") or (_rndFace == "WBK_DosHead_Normal_2") or (_rndFace == "WBK_DosHead_Normal_3")) then {
removeHeadgear _unitWithSword;
};
[_unitWithSword, _rndFace] remoteExec ["setFace", 0, true];
_unitWithSword spawn {
sleep 0.5;
_this doMove (getPos _this);
};



_unitWithSword addEventHandler ["Killed", {
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





_unitWithSword addEventHandler ["Suppressed", {
params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
if (!(isNil {_unit getVariable "WBK_AI_ZombieCanMove"})) exitWith {};
_pos = ASLtoAGL getPosASLVisual _instigator;
_unit doMove _pos;
_unit reveal [_instigator, 4];
_unit spawn {
_this setVariable ["WBK_AI_ZombieCanMove",0];
sleep 5;
_this setVariable ["WBK_AI_ZombieCanMove",nil];
};
}];


_unitWithSword addEventHandler ["FiredNear", {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
	if (!(isNil {_unit getVariable "WBK_AI_ZombieCanMove"})) exitWith {};
	_unit reveal [_firer, 4];
	_pos = ASLtoAGL getPosASLVisual _firer;
    _unit doMove _pos;
	_unit spawn {
	_this setVariable ["WBK_AI_ZombieCanMove",0];
	sleep 5;
	_this setVariable ["WBK_AI_ZombieCanMove",nil];
	};
}];



[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
_this addEventHandler [
    "HitPart",
    {
		(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];
		if ((_target == _shooter) or (isNull _shooter) or !(alive _target) or (lifeState _target == "INCAPACITATED")) exitWith {};
		if !(isNil {_target getVariable "WBK_ZombieSwitchToCrawler"}) exitWith {
		if (gestureState _target == "WBK_ZombieHitGest_2") exitWith {
		[_target, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _target]; 
		};
		if (gestureState _target == "WBK_ZombieHitGest_1") exitWith {
		[_target, "WBK_ZombieHitGest_2"] remoteExec ["playActionNow", _target]; 
		};
		[_target, "WBK_ZombieHitGest_1"] remoteExec ["playActionNow", _target]; 
		};
		_isExplosive = _ammo select 3;
		if (_isExplosive == 1) exitWith {
		_anim = selectRandom ["WBK_Walker_Fall_Forward_Moveset_1","WBK_Walker_Fall_Forward_Moveset_2","WBK_Walker_Fall_Forward_Moveset_3","WBK_Walker_Fall_Back_Moveset_1","WBK_Walker_Fall_Back_Moveset_2","WBK_Walker_Fall_Back_Moveset_3"];
		[_target, _anim] remoteExec ["switchMove", 0]; 
	    [_target, _anim] remoteExec ["playMoveNow", 0]; 
		};
		_isEnoughDamage = _ammo select 0;
		_partOfTheBody = _selection select 0;
		if (
		((_partOfTheBody == "leftfoot") or
		(_partOfTheBody == "lefttoebase") or
		(_partOfTheBody == "leftleg") or
		(_partOfTheBody == "leftlegroll") or
		(_partOfTheBody == "leftupleg") or
		(_partOfTheBody == "leftuplegroll") or
		(_partOfTheBody == "rightupleg") or
		(_partOfTheBody == "rightuplegroll") or
		(_partOfTheBody == "rightleg") or
		(_partOfTheBody == "rightlegroll") or
		(_partOfTheBody == "rightfoot") or
		(_partOfTheBody == "righttoebase")) and (_isEnoughDamage >= 10)
		) exitWith {
		[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		_target spawn {
		_this setVariable ["WBK_ZombieSwitchToCrawler",1,true];
		sleep 0.6;
		[_this, true] remoteExec ["setUnconscious", _this]; 
		sleep 8;
		if (!(lifeState _this == "INCAPACITATED") or !(alive _this)) exitWith {};
		[_this, false] remoteExec ["setUnconscious", _this];
		};
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		[_target, "WBK_Walker_Fall_Back_Moveset_1"] remoteExec ["switchMove", 0]; 
	    [_target, "WBK_Walker_Fall_Back_Moveset_1"] remoteExec ["playMoveNow", 0];  
	    };
		[_target, "WBK_Walker_Fall_Forward_Moveset_1"] remoteExec ["switchMove", 0]; 
	    [_target, "WBK_Walker_Fall_Forward_Moveset_1"] remoteExec ["playMoveNow", 0]; 
		};
        if (((_partOfTheBody == "head") or (_partOfTheBody == "neck")) and (_isEnoughDamage >= 9)) exitWith {
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
		if (_isEnoughDamage >= 10.5) exitWith {
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
		if (((_target worldToModel (_shooter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
		_anim = selectRandom ["WBK_Walker_Fall_Forward_Moveset_1","WBK_Walker_Fall_Forward_Moveset_2","WBK_Walker_Fall_Forward_Moveset_3"];
		[_target, _anim] remoteExec ["switchMove", 0]; 
	    [_target, _anim] remoteExec ["playMoveNow", 0]; 
		[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	    };
		_anim = selectRandom ["WBK_Walker_Fall_Back_Moveset_1","WBK_Walker_Fall_Back_Moveset_2","WBK_Walker_Fall_Back_Moveset_3"];
		[_target, _anim] remoteExec ["switchMove", 0]; 
	    [_target, _anim] remoteExec ["playMoveNow", 0]; 
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




_actFr = [{
    _array = _this select 0;
    _mutant = _array select 0;
	if ((lifeState _mutant == "INCAPACITATED") or !(alive _mutant)) exitWith {};
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
	!(animationState _mutant == "WBK_Runner_hit_f_2") and 
	!(animationState _mutant == "WBK_Runner_hit_f_1") and 
	!(animationState _mutant == "WBK_Walker_Idle_1_attack") and 
	!(animationState _mutant == "WBK_Walker_Idle_2_attack") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_1") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_2") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_3") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_success_1") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_success_2") and 
	!(animationState _mutant == "WBK_Walker_TryingToCatch_success_3") and 
	!(animationState _mutant == "WBK_Walker_GetUpUnconscious_1") and 
	!(animationState _mutant == "WBK_Walker_GetUpUnconscious_2") and 
	!(animationState _mutant == "WBK_Walker_GetUpUnconscious_3") and 
	!(animationState _mutant == "WBK_Walker_Hit_B") and 
	!(animationState _mutant == "WBK_Walker_Hit_B_1") and 
	!(animationState _mutant == "WBK_Walker_Hit_B_2") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_1") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_2") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_1_2") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_2_2") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_1_3") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_2_3") and 
	!(animationState _mutant == "WBK_Walker_Fall_Forward_Moveset_1") and 
	!(animationState _mutant == "WBK_Walker_Fall_Forward_Moveset_2") and 
	!(animationState _mutant == "WBK_Walker_Fall_Forward_Moveset_3") and 
	!(animationState _mutant == "WBK_Walker_Fall_Back_Moveset_1") and 
	!(animationState _mutant == "WBK_Walker_Fall_Back_Moveset_2") and 
	!(animationState _mutant == "WBK_Walker_Fall_Back_Moveset_3") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_2_2") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_1_3") and 
	!(animationState _mutant == "WBK_Walker_Hit_F_2_3") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Blunt_back_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Blunt_front_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_back_reversed_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_back_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_front_reversed_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_front_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Knife_front_victim_1") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Player_1_victim") and 
	!(animationState _mutant == "IMS_Rifle_Sync_Player_2_victim") and 
	(_mutant getVariable "canMakeAttack" == 0)
	) exitWith {
	if (
	(
	(animationState _en == "WBK_CatchedByZombie_Front") or 
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
	(_en isKindOf "TIOWSpaceMarine_Base") or
	!(isNil {_en getVariable "WBK_AI_ISZombie"}) or 
	!(WBK_Zombies_EnableBitingMechanic)
	) and  ((_mutant distance _en) <= 2.9)
	) exitWith { 
	[_mutant, _en] spawn WBK_ZombieAttack;
	};
	[_mutant, _en] spawn WBK_ZombieTryingToGrab;
	};
}, 1, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;



_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _unit findNearestEnemy _unit; 
    if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit)) exitWith {
	if (!(isNil {_unit getVariable "WBK_Zombie_CustomSounds"})) then {
	    _snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 0;
        [_unit, selectRandom _snds, 20] call CBA_fnc_GlobalSay3D;
	}else{
	    [_unit, selectRandom ["plagued_idle_1","plagued_idle_2","plagued_idle_3","plagued_idle_4","plagued_idle_5"], 25] call CBA_fnc_GlobalSay3D;
	};
	};
	    _pos = ASLtoAGL getPosASLVisual _nearEnemy;
		_unit doMove _pos;
		if (!(isNil {_unit getVariable "WBK_Zombie_CustomSounds"})) then {
			_snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 1;
            [_unit, selectRandom _snds, 20] call CBA_fnc_GlobalSay3D;
		}else{
			[_unit, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6","plagued_attack_9"], 20] call CBA_fnc_GlobalSay3D;
		};
}, 7, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

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
_rndStandUp = selectRandom ["WBK_Walker_GetUpUnconscious_1","WBK_Walker_GetUpUnconscious_2","WBK_Walker_GetUpUnconscious_3"];
[_this, _rndStandUp] remoteExec ["switchMove", 0]; 
[_this, _rndStandUp] remoteExec ["playMoveNow", 0];
sleep 1.8;
if (!(animationState _this == _rndStandUp) or !(alive _this) or (lifeState _this == "INCAPACITATED")) exitWith {};
_this setVariable ["canMakeAttack",0, true];
if (_rndStandUp == "WBK_Walker_GetUpUnconscious_1") exitWith {
[_this, "WBK_Walker_Idle_1"] remoteExec ["playMoveNow", 0]; 
};
if (_rndStandUp == "WBK_Walker_GetUpUnconscious_2") exitWith {
[_this, "WBK_Walker_Idle_2"] remoteExec ["playMoveNow", 0]; 
};
if (_rndStandUp == "WBK_Walker_GetUpUnconscious_3") exitWith {
[_this, "WBK_Walker_Idle_3"] remoteExec ["playMoveNow", 0]; 
};
};
sleep 0.1;
};
};

waitUntil {sleep 0.5; 
if (isNull _unitWithSword) exitWith { true };
(!(alive _unitWithSword))
};
[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
[_unitWithSword, {
_this removeAllEventHandlers "HitPart";
}] remoteExec ["spawn", [0,-2] select isDedicated,true];