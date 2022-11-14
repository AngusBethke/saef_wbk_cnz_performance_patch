if (!(hasInterface) or (isDedicated)) exitWith {};
[] spawn
{
	waitUntil {!(isNull findDisplay 46) };
	if ("ace_medical_engine" in activatedAddons) then {
WBK_ZombieGrab = {
_personWhoIsGrabbed = _this select 0;
_zombie = _this select 1;
if (!(((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) and ((_personWhoIsGrabbed isKindOf "WBK_DOS_Squig_Normal") or (_personWhoIsGrabbed isKindOf "WBK_DOS_Huge_ORK") or (_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") or (gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitWith {
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
_rndSnd = selectRandom ["sword_on_wood_shield01","sword_on_wood_shield02","sword_on_wood_shield03"];  
[_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_personWhoIsGrabbed, selectRandom ["leg_hit1","leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
if (!(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") and !(_personWhoIsGrabbed isKindOf "WBK_DOS_Huge_ORK") and !(_personWhoIsGrabbed isKindOf "WBK_DOS_Squig_Normal")) then {
[_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationToZero", _personWhoIsGrabbed, false];  
};
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0]; 
sleep 0.7;
[_zombie, true] remoteExec ["setUnconscious", _zombie]; 
sleep 5;
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_zombie, selectRandom ["plagued_rage_attack_1","plagued_rage_attack_1","plagued_rage_attack_3"], 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
_rndCatch = selectRandom ["WBK_Walker_TryingToCatch_success_1","WBK_Walker_TryingToCatch_success_2","WBK_Walker_TryingToCatch_success_3"];
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_personWhoIsGrabbed setVariable ["actualSwordBlock",0, true];
_personWhoIsGrabbed setVariable ["canMakeAttack",1, true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",1, true];
_zombie setVariable ["canMakeAttack",1, true];
if (((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) then  
{
_zombie attachTo [_personWhoIsGrabbed,[-0.3,-0.01,0]];
[_zombie, 180] remoteExec ["setDir", 0]; 
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Back"] remoteExec ["switchMove", 0]; 
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Back"] remoteExec ["playMoveNow", 0]; 
}else{
_zombie attachTo [_personWhoIsGrabbed,[0,0,0]];
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Front"] remoteExec ["switchMove", 0]; 
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Front"] remoteExec ["playMoveNow", 0]; 
};
[_personWhoIsGrabbed, "Disable_Gesture"] remoteExec ["playActionNow", 0]; 
sleep 0.2;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
[_zombie, "plagued_grab", 65, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, 0.2, "head", "stab"] remoteExec ["ace_medical_fnc_addDamageToUnit", _personWhoIsGrabbed];
if (!(isNil "WBK_NecroplagueDetected")) then {
[_personWhoIsGrabbed, side group _zombie] remoteExec ["dev_fnc_infect", _personWhoIsGrabbed];
};
[_personWhoIsGrabbed, selectRandom ["start_bayonetCharge_2","start_bayonetCharge_1"], 10, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 0.2;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
[_personWhoIsGrabbed, 0.16, "head", "stab"] remoteExec ["ace_medical_fnc_addDamageToUnit", _personWhoIsGrabbed];
[_personWhoIsGrabbed, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, selectRandom ["New_Death_5","New_Death_9"], 40, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 0.5;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
sleep 0.2;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
[_personWhoIsGrabbed, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_zombie, selectRandom ["plagued_attack_7","plagued_attack_8"], 50] call CBA_fnc_GlobalSay3D;
sleep 1;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
if (animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") then {
[_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1","melee_swing_equipment_2","melee_swing_equipment_3","melee_swing_equipment_4"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
}else{
[_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1","melee_swing_equipment_2","melee_swing_equipment_3","melee_swing_equipment_4"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, "leg_punch", 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
};
sleep 0.8;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0,true];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
if (_zombie getVariable "WBK_AI_ZombieMoveSet" == "WBK_Runner_Angry_Idle") exitWith {
_zombie disableAI "ANIM";
_zombie disableAI "MOVE";
if (animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") then {
_zombie attachTo [_personWhoIsGrabbed,[0,-1,0]];
[_zombie, 0] remoteExec ["setDir", 0]; 
}else{
_zombie attachTo [_personWhoIsGrabbed,[0,1,0]];
[_zombie, 180] remoteExec ["setDir", 0]; 
};
[_zombie, "WBK_Zombie_Evade_B"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Zombie_Evade_B"] remoteExec ["playMoveNow", 0]; 
sleep 0.1;
detach _zombie;
_personWhoIsGrabbed setVariable ["actualSwordBlock",0, true];
_personWhoIsGrabbed setVariable ["canMakeAttack",0, true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0, true];
if (alive _personWhoIsGrabbed) then {
if (currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons) then {
[_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
}else{
[_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0]; 
};
};
sleep 1;
_zombie enableAI "ANIM";
_zombie enableAI "MOVE";
};
_personWhoIsGrabbed setVariable ["actualSwordBlock",0, true];
_personWhoIsGrabbed setVariable ["canMakeAttack",0, true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0, true];
if (alive _personWhoIsGrabbed) then {
if (currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons) then {
[_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
}else{
[_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0]; 
};
};
detach _zombie;
[_zombie, [_zombie vectorModelToWorld [0,100,0], _zombie selectionPosition "head"]] remoteExec ["addForce", _zombie];
[_zombie, true] remoteExec ["setUnconscious", _zombie]; 
sleep 0.2;
[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
};
}else{
WBK_ZombieGrab = {
_personWhoIsGrabbed = _this select 0;
_zombie = _this select 1;
if ((getText (configfile >> 'CfgVehicles' >> typeOf _personWhoIsGrabbed >> 'moves') != 'CfgMovesMaleSdr') or (_personWhoIsGrabbed isKindOf "WBK_DOS_Squig_Normal") or (_personWhoIsGrabbed isKindOf "WBK_DOS_Huge_ORK") or (_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") or (!(((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3")))) exitWith {
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
_rndSnd = selectRandom ["sword_on_wood_shield01","sword_on_wood_shield02","sword_on_wood_shield03"];  
[_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_personWhoIsGrabbed, selectRandom ["leg_hit1","leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
if (!(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") and !(_personWhoIsGrabbed isKindOf "WBK_DOS_Huge_ORK") and !(_personWhoIsGrabbed isKindOf "WBK_DOS_Squig_Normal")) then {
[_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationToZero", _personWhoIsGrabbed, false];  
};
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0]; 
sleep 0.7;
[_zombie, true] remoteExec ["setUnconscious", _zombie]; 
sleep 5;
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_zombie, selectRandom ["plagued_rage_attack_1","plagued_rage_attack_1","plagued_rage_attack_3"], 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
_rndCatch = selectRandom ["WBK_Walker_TryingToCatch_success_1","WBK_Walker_TryingToCatch_success_2","WBK_Walker_TryingToCatch_success_3"];
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_personWhoIsGrabbed setVariable ["actualSwordBlock",0, true];
_personWhoIsGrabbed setVariable ["canMakeAttack",1, true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",1, true];
_zombie setVariable ["canMakeAttack",1, true];
if (((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) then  
{
_zombie attachTo [_personWhoIsGrabbed,[-0.3,-0.01,0]];
[_zombie, 180] remoteExec ["setDir", 0]; 
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Back"] remoteExec ["switchMove", 0]; 
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Back"] remoteExec ["playMoveNow", 0]; 
}else{
_zombie attachTo [_personWhoIsGrabbed,[0,0,0]];
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Front"] remoteExec ["switchMove", 0]; 
[_personWhoIsGrabbed, "WBK_CatchedByZombie_Front"] remoteExec ["playMoveNow", 0]; 
};
[_personWhoIsGrabbed, "Disable_Gesture"] remoteExec ["playActionNow", 0]; 
sleep 0.2;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
[_zombie, "plagued_grab", 65, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
_personWhoIsGrabbed setDamage ((damage _personWhoIsGrabbed) + 0.1);
if (!(isNil "WBK_NecroplagueDetected")) then {
[_personWhoIsGrabbed, side group _zombie] remoteExec ["dev_fnc_infect", _personWhoIsGrabbed];
};
[_personWhoIsGrabbed, selectRandom ["start_bayonetCharge_2","start_bayonetCharge_1"], 10, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 0.2;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
_personWhoIsGrabbed setDamage ((damage _personWhoIsGrabbed) + 0.1);
[_personWhoIsGrabbed, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, selectRandom ["New_Death_5","New_Death_9"], 40, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 0.5;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
sleep 0.2;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
_personWhoIsGrabbed setDamage ((damage _personWhoIsGrabbed) + 0.1);
[_personWhoIsGrabbed, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_zombie, selectRandom ["plagued_attack_7","plagued_attack_8"], 50] call CBA_fnc_GlobalSay3D;
sleep 1;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
if (animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") then {
[_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1","melee_swing_equipment_2","melee_swing_equipment_3","melee_swing_equipment_4"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
}else{
[_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1","melee_swing_equipment_2","melee_swing_equipment_3","melee_swing_equipment_4"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_personWhoIsGrabbed, "leg_punch", 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
};
sleep 0.8;
if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndCatch) or (!(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Front"))) exitWith {
detach _zombie;
[_zombie, true] remoteExec ["setUnconscious", _zombie];  
_zombie setVariable ["AI_CanTurn",0,true];
_zombie setVariable ["canMakeAttack",1,true];  
_personWhoIsGrabbed spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons)) exitWith {
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
};
if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitWith {
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
[_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
};
[_personWhoIsGrabbed, "A_PlayerDeathAnim_9"] remoteExec ["switchMove", 0, false];
sleep 0.2;
[_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
sleep 1;
[_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed]; 
};
_personWhoIsGrabbed setVariable ["canMakeAttack",0,true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0,true];
_personWhoIsGrabbed enableAI "ALL";
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
}; 
if (_zombie getVariable "WBK_AI_ZombieMoveSet" == "WBK_Runner_Angry_Idle") exitWith {
_zombie disableAI "ANIM";
_zombie disableAI "MOVE";
if (animationState _personWhoIsGrabbed == "WBK_CatchedByZombie_Back") then {
_zombie attachTo [_personWhoIsGrabbed,[0,-1,0]];
[_zombie, 0] remoteExec ["setDir", 0]; 
}else{
_zombie attachTo [_personWhoIsGrabbed,[0,1,0]];
[_zombie, 180] remoteExec ["setDir", 0]; 
};
[_zombie, "WBK_Zombie_Evade_B"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Zombie_Evade_B"] remoteExec ["playMoveNow", 0]; 
sleep 0.1;
detach _zombie;
_personWhoIsGrabbed setVariable ["actualSwordBlock",0, true];
_personWhoIsGrabbed setVariable ["canMakeAttack",0, true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0, true];
if (alive _personWhoIsGrabbed) then {
if (currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons) then {
[_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
}else{
[_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0]; 
};
};
sleep 1;
_zombie enableAI "ANIM";
_zombie enableAI "MOVE";
};
_personWhoIsGrabbed setVariable ["actualSwordBlock",0, true];
_personWhoIsGrabbed setVariable ["canMakeAttack",0, true];
_personWhoIsGrabbed setVariable ["AI_CanTurn",0, true];
if (alive _personWhoIsGrabbed) then {
if (currentWeapon _personWhoIsGrabbed in IMS_Melee_Weapons) then {
[_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
}else{
[_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0]; 
};
};
detach _zombie;
[_zombie, [_zombie vectorModelToWorld [0,100,0], _zombie selectionPosition "head"]] remoteExec ["addForce", _zombie];
[_zombie, true] remoteExec ["setUnconscious", _zombie]; 
sleep 0.2;
[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 6;
if (!(lifeState _zombie == "INCAPACITATED") or !(alive _zombie)) exitWith {};
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
};
};
	waitUntil {sleep 1; !(isNull findDisplay 312) };
	systemChat "WBK Zombies modules are loaded";
	WBK_ZombieObjectZeus = objNull;
	{ 
		_x addEventHandler ["CuratorObjectSelectionChanged", {
			params ["_curator", "_entity"];
			WBK_ZombieObjectZeus = _entity;
		}];
	} forEach AllCurators; 
	["WebKnight's Zombies", "WBK_ZombieAI_Load", ["(Zeus only!) Load Zombie AI on unit", "Load zombie ai on a whole group of the selected unit."], {  
	if (isNull(findDisplay 312)) exitWith {};
	createDialog "WBK_SelectZombieType";
	}, {}, [45, [true, true, false]]] call cba_fnc_addKeybind;  
};
