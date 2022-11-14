
["WebKnight's Zombies", "WBK_ZombieAI_Load", ["(Zeus only!) Load Zombie AI on unit", "Load zombie ai on a whole group of the selected unit."], {  
if (isNull(findDisplay 312)) exitWith {};
createDialog "WBK_SelectZombieType";
}, {}, [45, [true, true, false]]] call cba_fnc_addKeybind;  






[ 
    "WBK_ZombiesIsUseStatDeathControl", 
    "LIST", 
    "Use static death animations? (Good for huge hordes)",
    "WebKnight's Zombies",
    [[false, true], ["NO", "YES"], 0],
    1,
    {   
        params ["_value"]; 
        WBK_Zombies_EnableStaticAnimations = _value; 
    }
] call CBA_fnc_addSetting;


[ 
    "WBK_ZombiesIsUseParticleDeathControl", 
    "LIST", 
    "Use headshot particle effects?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {   
        params ["_value"]; 
        WBK_Zombies_EnableHeadShotsParticles = _value; 
    }
] call CBA_fnc_addSetting;


[ 
    "WBK_ZombiesIsUseBitingAnimation", 
    "LIST", 
    "Will infected use biting animations?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {   
        params ["_value"]; 
        WBK_Zombies_EnableBitingMechanic = _value; 
    }
] call CBA_fnc_addSetting;



[ 
    "WBK_ZommbiesSmasherHealthParam", 
    "EDITBOX", 
    "(Smasher) Health",
    "WebKnight's Zombies",
    "3500",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		WBK_Zombies_SmasherHP = _number;
    }
] call CBA_fnc_addSetting;


[ 
    "WBK_ZommbiesSmasherThrowParam", 
    "LIST", 
    "(Smasher) Can throw rocks?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {   
        params ["_value"]; 
        WBK_Zombies_SmasherRockAbil = _value; 
    }
] call CBA_fnc_addSetting;

[ 
    "WBK_ZommbiesSmasherJumpParam", 
    "LIST", 
    "(Smasher) Can do jump attack?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {   
        params ["_value"]; 
        WBK_Zombies_SmasherFlyAbil = _value; 
    }
] call CBA_fnc_addSetting;



[ 
    "WBK_ZommbiesLeaperHealthParam", 
    "EDITBOX", 
    "(Leaper) Health",
    "WebKnight's Zombies",
    "120",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		WBK_Zombies_LeaperHP = _number;
    }
] call CBA_fnc_addSetting;



if ("dev_common" in activatedAddons) then {
WBK_NecroplagueDetected = true;
};


WBK_getClasses = { 
  params ["_faction", "_array"]; 
  _array = []; 
  _cfg = (configFile >> "CfgVehicles");
  { 
   if (((configName _x) isKindoF "CAManBase") and (getNumber (configFile >> "CfgVehicles" >> (configName _x)>> "scope") == 2)) then { 
    _array pushback (configName _x); 
   }; 
  } forEach ("getText (_x >> 'faction') == _faction" configClasses (configfile >> "CfgVehicles")); 
  _array 
};


///Default faction classes:  "OPF_T_F" "OPF_R_F" "OPF_F" "blu_F" "BLU_G_F" "BLU_CTRG_F" "BLU_GEN_F" "BLU_T_F" "BLU_W_F" "CIV_F" "CIV_IDAP_F" "IND_C_F" "IND_E_F" "IND_F" "IND_L_F"
WBK_ZombiesRandomEquipment = {
_unit = _this select 0;
_faction = _this select 1; //Look for cfgFactionClasses to see more classes for your units
_UnitArray = [_faction] call WBK_getClasses;
_rndUnit = selectRandom _UnitArray;
_outFit = getUnitLoadout _rndUnit;
_unit setUnitLoadout _outFit;
};



WBK_LoadAIThroughEden = {
_unit = _this select 0;
_loadScript = _this select 1;
if (_loadScript == 0) exitWith {};
switch (_loadScript) do
{
    case 1: { 
	[_unit, true] execVM '\WBK_Zombies\AI\WBK_AI_Walker.sqf';
	};
	case 2: { 
	[_unit, false] execVM '\WBK_Zombies\AI\WBK_AI_Walker.sqf';
	};
	case 3: { 
	_unit execVM '\WBK_Zombies\AI\WBK_AI_Middle.sqf';
	};
	case 4: { 
	[_unit, false] execVM '\WBK_Zombies\AI\WBK_AI_Runner.sqf';
	};
	case 5: { 
	[_unit, true] execVM '\WBK_Zombies\AI\WBK_AI_Runner.sqf';
	};
	case 6: { 
	_unit execVM '\WBK_Zombies\AI\WBK_ShooterZombie.sqf';
	};
};

};



/*
Custom zombie sounds


this setVariable ["WBK_Zombie_CustomSounds",
[
["WW2_Zombie_idle1","WW2_Zombie_idle2","WW2_Zombie_idle3","WW2_Zombie_idle4","WW2_Zombie_idle5","WW2_Zombie_idle6"],
["WW2_Zombie_walker1","WW2_Zombie_walker2","WW2_Zombie_walker3","WW2_Zombie_walker4","WW2_Zombie_walker5"],
["WW2_Zombie_attack1","WW2_Zombie_attack2","WW2_Zombie_attack3","WW2_Zombie_attack4","WW2_Zombie_attack5"],
["WW2_Zombie_death1","WW2_Zombie_death2","WW2_Zombie_death3","WW2_Zombie_death4","WW2_Zombie_death5"],
["WW2_Zombie_burning1","WW2_Zombie_burning2","WW2_Zombie_burning3"]
],true];

this setVariable ["WBK_Zombie_CustomSounds",
[
["WW2_Zombie_walker1","WW2_Zombie_walker2","WW2_Zombie_walker3","WW2_Zombie_walker4","WW2_Zombie_walker5"],
["WW2_Zombie_sprinter1","WW2_Zombie_sprinter2","WW2_Zombie_sprinter3","WW2_Zombie_sprinter4","WW2_Zombie_sprinter5","WW2_Zombie_sprinter6","WW2_Zombie_sprinter7","WW2_Zombie_sprinter8","WW2_Zombie_sprinter9"],
["WW2_Zombie_attack1","WW2_Zombie_attack2","WW2_Zombie_attack3","WW2_Zombie_attack4","WW2_Zombie_attack5"],
["WW2_Zombie_death1","WW2_Zombie_death2","WW2_Zombie_death3","WW2_Zombie_death4","WW2_Zombie_death5"],
["WW2_Zombie_burning1","WW2_Zombie_burning2","WW2_Zombie_burning3"]
],true];


for special infected
this setVariable ["WBK_Zombie_CustomSounds",
[
["WW2_Zombie_walker1","WW2_Zombie_walker2","WW2_Zombie_walker3","WW2_Zombie_walker4","WW2_Zombie_walker5"], - idle
["WW2_Zombie_sprinter1","WW2_Zombie_sprinter2","WW2_Zombie_sprinter3","WW2_Zombie_sprinter4","WW2_Zombie_sprinter5","WW2_Zombie_sprinter6","WW2_Zombie_sprinter7","WW2_Zombie_sprinter8","WW2_Zombie_sprinter9"], - attack
["WW2_Zombie_attack1","WW2_Zombie_attack2","WW2_Zombie_attack3","WW2_Zombie_attack4","WW2_Zombie_attack5"], - special
["WW2_Zombie_death1","WW2_Zombie_death2","WW2_Zombie_death3","WW2_Zombie_death4","WW2_Zombie_death5"], -death
["WW2_Zombie_burning1","WW2_Zombie_burning2","WW2_Zombie_burning3"]
],true];




*/




WBK_Smasher_VictimDamageProceed = {
_zombie = _this select 0;
_enemy = _this select 1;
_damage = _this select 2;
_distance = _this select 3;
if (!(animationState _enemy == "starWars_landRoll_b") and !(animationState _enemy == "starWars_landRoll") and !(animationState _enemy == "STAR_WARS_FIGHT_DODGE_RIGHT") and !(animationState _enemy == "STAR_WARS_FIGHT_DODGE_LEFT") and (isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and ((_zombie distance _enemy) <= _distance) and (alive _zombie) and (alive _enemy)) exitWith {
[_enemy, "Smasher_hit", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_enemy, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
if ((_enemy isKindOf "WBK_DOS_Squig_Normal") or (_enemy isKindOf "WBK_DOS_Huge_ORK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_CatchedByZombie_Front") or (animationState _enemy == "WBK_CatchedByZombie_Back")) then {
_personWhoIsGrabbed = _enemy;
if (!(((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitWith {
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
_rndSnd = selectRandom ["sword_on_wood_shield01","sword_on_wood_shield02","sword_on_wood_shield03"];  
[_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_personWhoIsGrabbed, selectRandom ["leg_hit1","leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
[_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationToZero", _personWhoIsGrabbed, false];  
};
[_enemy, 0.45, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
}else{
if (!(isNil {_enemy getVariable "WBK_AI_ISZombie"})) then {
[_enemy,_zombie,0.9,"WBK_survival_weapon_2"] remoteExec ["WBK_ZombiesProcessDamage", _enemy];
}else{
if (_damage >= 0.8) exitWith {
[_enemy, 1, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
};
[_enemy,_zombie] remoteExec ["WBK_CreateMeleeHitAnim", _enemy];
sleep 0.05;
[_enemy, _damage, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
};
};
};
};


WBK_ZombiesProcessDamage = {
_zombie = _this select 0;
_hitter = _this select 1;
if (_zombie isKindOf "WBK_SpecialZombie_Smasher_1") exitWith {
if ((animationState _zombie == "WBK_Smasher_Execution") or !(alive _zombie)) exitWith {}; 
if ((_hitter isKindOf "TIOWSpaceMarine_Base") and !(animationState _zombie == "WBK_Smasher_HitHard") and (isNil {_zombie getVariable "CanBeStunnedIMS"})) then { 
_zombie enableAI "MOVE";
_zombie enableAI "ANIM";
[_zombie, "Smasher_eat_voice", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
[_zombie, "WBK_Smasher_HitHard"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_HitHard"] remoteExec ["playMoveNow", 0];
_zombie setVariable ["CanBeStunnedIMS",1,true]; 
_zombie spawn {sleep 8; _this setVariable ["CanBeStunnedIMS",nil,true];};
};
_vv = _zombie getVariable "WBK_SynthHP";
_new_vv = _vv - (WBK_Zombies_SmasherHP / 30);
if !(isNil "WBK_ZombiesShowDebugDamage") then {
systemChat str (WBK_Zombies_SmasherHP / 30);
};
if (_new_vv <= 0) exitWith {_zombie removeAllEventHandlers "HandleDamage"; _zombie setDamage 1;};
_zombie setVariable ["WBK_SynthHP",_new_vv,true];
};
if (_hitter isKindOf "TIOWSpaceMarine_Base") exitWith {
_rndDecap = random 100;
if (_rndDecap >= 70) exitWith {
_zombie setVariable ["WBK_AI_Zombie_DecapHead",1,true];
_zombie setDamage 1;
if !(WBK_Zombies_EnableStaticAnimations) exitWith {
if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
[_zombie, [_zombie vectorModelToWorld [0,300,0], _zombie selectionPosition "head"]] remoteExec ["addForce", _zombie];
};
[_zombie, [_zombie vectorModelToWorld [0,-300,0], _zombie selectionPosition "head"]] remoteExec ["addForce", _zombie];
};
[_zombie, selectRandom ["A_PlayerDeathAnim_17","A_PlayerDeathAnim_10","A_PlayerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
};
_zombie setDamage 1;
if !(WBK_Zombies_EnableStaticAnimations) exitWith {
if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
[_zombie, [_zombie vectorModelToWorld [0,300,0], _zombie selectionPosition "head"]] remoteExec ["addForce", _zombie];
};
[_zombie, [_zombie vectorModelToWorld [0,-300,0], _zombie selectionPosition "head"]] remoteExec ["addForce", _zombie];
};
[_zombie, selectRandom ["A_PlayerDeathAnim_19","A_PlayerDeathAnim_17","A_PlayerDeathAnim_14","A_PlayerDeathAnim_15","A_PlayerDeathAnim_1","A_PlayerDeathAnim_2","A_PlayerDeathAnim_3","A_PlayerDeathAnim_5","A_PlayerDeathAnim_7","A_PlayerDeathAnim_8","A_PlayerDeathAnim_9","A_PlayerDeathAnim_10","A_PlayerDeathAnim_11","A_PlayerDeathAnim_12","A_PlayerDeathAnim_13"]] remoteExec ["switchMove", 0, false];
};
_damageVar = _this select 2;
_weaponThatDealsDamage = _this select 3;
doStop _zombie;
if (
(lifeState _zombie == "INCAPACITATED") or 
(animationState _zombie == "WBK_Walker_Fall_Forward_Moveset_1") or
(animationState _zombie == "WBK_Walker_Fall_Forward_Moveset_2") or
(animationState _zombie == "WBK_Walker_Fall_Forward_Moveset_3") or
(animationState _zombie == "WBK_Walker_Fall_Back_Moveset_1") or
(animationState _zombie == "WBK_Walker_Fall_Back_Moveset_2") or
(animationState _zombie == "WBK_Walker_Fall_Back_Moveset_3") or
(animationState _zombie == "WBK_Runner_Fall_Forward") or
(animationState _zombie == "WBK_Runner_Fall_Back") or
!(isNil {_zombie getVariable "WBK_ZombieSwitchToCrawler"})
) exitWith {
if (_weaponThatDealsDamage == "Fists") exitWith {
_zombie setDamage ((damage _zombie) + _damageVar);
};
_zombie setDamage 1;
};
_var = _zombie getVariable "WBK_AI_ZombieMoveSet";
if (_var == "Star_Wars_KaaTirs_idle") then {
    _vv = _zombie getVariable "WBK_SynthHP";
	_new_vv = _vv - (WBK_Zombies_LeaperHP / 4);
	if !(isNil "WBK_ZombiesShowDebugDamage") then {
	systemChat str (WBK_Zombies_LeaperHP / 4);
	};
	if (_new_vv <= 0) exitWith {
	_rndAnim = selectRandom ["WBK_Leaper_Death_1","WBK_Leaper_Death_2"];
    [_zombie, _rndAnim] remoteExec ["switchMove", 0]; 
	_zombie setDamage 1;
	};
	_zombie setVariable ["WBK_SynthHP",_new_vv,true];
}else{
    _zombie setDamage ((damage _zombie) + _damageVar);
};
if ((_var != "Star_Wars_KaaTirs_idle") and (_var != "WBK_ShooterZombie_unnarmed_idle")) then {
_zombie spawn {
sleep 0.02;
[_this, "Disable_Gesture"] remoteExec ["playActionNow", 0];
};
};
switch (_var) do
{
    case "Corrupted_idle": { 
	if (_weaponThatDealsDamage == "Fists") exitWith {
	_zombie setDamage ((damage _zombie) + _damageVar);
	};
	_zombie setDamage 1;
	};
    case "WBK_Middle_Idle": { 
	if ((animationState _zombie == "WBK_Middle_hit_b_1") or (animationState _zombie == "WBK_Middle_hit_f_2_1") or (_weaponThatDealsDamage in IMS_Melee_Heavy) or (_weaponThatDealsDamage in IMS_Melee_Greatswords)) exitWith {
	[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Middle_Fall_Forward"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_Fall_Forward"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Middle_Fall_Back"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_Fall_Back"] remoteExec ["playMoveNow", 0]; 
	};
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Middle_hit_b_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_hit_b_1"] remoteExec ["playMoveNow", 0]; 
	};
	if (animationState _zombie == "WBK_Middle_hit_f_1_1") exitWith {
	[_zombie, "WBK_Middle_hit_f_2_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_hit_f_2_1"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Middle_hit_f_1_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_hit_f_1_1"] remoteExec ["playMoveNow", 0]; 
	};
    case "WBK_Middle_Idle_1": { 
	if ((animationState _zombie == "WBK_Middle_hit_b_2") or (animationState _zombie == "WBK_Middle_hit_f_2_2") or (_weaponThatDealsDamage in IMS_Melee_Heavy) or (_weaponThatDealsDamage in IMS_Melee_Greatswords)) exitWith {
	[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Middle_Fall_Forward_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_Fall_Forward_1"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Middle_Fall_Back_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_Fall_Back_1"] remoteExec ["playMoveNow", 0]; 
	};
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Middle_hit_b_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_hit_b_2"] remoteExec ["playMoveNow", 0]; 
	};
	if (animationState _zombie == "WBK_Middle_hit_f_1_2") exitWith {
	[_zombie, "WBK_Middle_hit_f_2_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_hit_f_2_2"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Middle_hit_f_1_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Middle_hit_f_1_2"] remoteExec ["playMoveNow", 0]; 
	};
    case "WBK_ShooterZombie_unnarmed_idle": { 
	if (gestureState _zombie == "WBK_ZombieHitGest_2_weapon") exitWith {
	[_zombie, "WBK_ZombieHitGest_3_weapon"] remoteExec ["playActionNow", _zombie]; 
	};
	if (gestureState _zombie == "WBK_ZombieHitGest_1_weapon") exitWith {
	[_zombie, "WBK_ZombieHitGest_2_weapon"] remoteExec ["playActionNow", _zombie]; 
	};
	[_zombie, "WBK_ZombieHitGest_1_weapon"] remoteExec ["playActionNow", _zombie]; 
	};
    case "Star_Wars_KaaTirs_idle": { 
	if (gestureState _zombie == "WBK_ZombieHitGest_2") exitWith {
	[_zombie, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _zombie]; 
	};
	if (gestureState _zombie == "WBK_ZombieHitGest_1") exitWith {
	[_zombie, "WBK_ZombieHitGest_2"] remoteExec ["playActionNow", _zombie]; 
	};
	[_zombie, "WBK_ZombieHitGest_1"] remoteExec ["playActionNow", _zombie]; 
	};
    case "WBK_Runner_Angry_Idle": { 
	if ((animationState _zombie == "WBK_Runner_hit_b") or (animationState _zombie == "WBK_Runner_hit_f_2") or (_weaponThatDealsDamage in IMS_Melee_Heavy) or (_weaponThatDealsDamage in IMS_Melee_Greatswords)) exitWith {
	[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Runner_Fall_Forward"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Runner_Fall_Forward"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Runner_Fall_Back"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Runner_Fall_Back"] remoteExec ["playMoveNow", 0]; 
	};
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Runner_hit_b"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Runner_hit_b"] remoteExec ["playMoveNow", 0]; 
	};
	if (animationState _zombie == "WBK_Runner_hit_f_1") exitWith {
	[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Runner_hit_f_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Runner_hit_f_1"] remoteExec ["playMoveNow", 0]; 
	};
	case "WBK_Walker_Idle_1": { 
	if ((animationState _zombie == "WBK_Walker_Hit_B") or (animationState _zombie == "WBK_Walker_Hit_F_2") or (_weaponThatDealsDamage in IMS_Melee_Heavy) or (_weaponThatDealsDamage in IMS_Melee_Greatswords)) exitWith {
	[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Walker_Fall_Forward_Moveset_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Fall_Forward_Moveset_1"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Walker_Fall_Back_Moveset_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Fall_Back_Moveset_1"] remoteExec ["playMoveNow", 0]; 
	};
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Walker_Hit_B"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_B"] remoteExec ["playMoveNow", 0]; 
	};
	if (animationState _zombie == "WBK_Walker_Hit_F_1") exitWith {
	[_zombie, "WBK_Walker_Hit_F_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_F_2"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Walker_Hit_F_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_F_1"] remoteExec ["playMoveNow", 0]; 
	};
	case "WBK_Walker_Idle_2": { 
	if ((animationState _zombie == "WBK_Walker_Hit_B_1") or (animationState _zombie == "WBK_Walker_Hit_F_2_2") or (_weaponThatDealsDamage in IMS_Melee_Heavy) or (_weaponThatDealsDamage in IMS_Melee_Greatswords)) exitWith {
	[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Walker_Fall_Forward_Moveset_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Fall_Forward_Moveset_2"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Walker_Fall_Back_Moveset_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Fall_Back_Moveset_2"] remoteExec ["playMoveNow", 0]; 
	};
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Walker_Hit_B_1"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_B_1"] remoteExec ["playMoveNow", 0]; 
	};
	if (animationState _zombie == "WBK_Walker_Hit_F_1_2") exitWith {
	[_zombie, "WBK_Walker_Hit_F_2_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_F_2_2"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Walker_Hit_F_1_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_F_1_2"] remoteExec ["playMoveNow", 0]; 
	};
	case "WBK_Walker_Idle_3": { 
	if ((animationState _zombie == "WBK_Walker_Hit_B_2") or (animationState _zombie == "WBK_Walker_Hit_F_2_3") or (_weaponThatDealsDamage in IMS_Melee_Heavy) or (_weaponThatDealsDamage in IMS_Melee_Greatswords)) exitWith {
	[_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Walker_Fall_Forward_Moveset_3"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Fall_Forward_Moveset_3"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Walker_Fall_Back_Moveset_3"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Fall_Back_Moveset_3"] remoteExec ["playMoveNow", 0]; 
	};
	if (((_zombie worldToModel (_hitter modelToWorld [0, 0, 0])) select 1) < 0) exitWith {
	[_zombie, "WBK_Walker_Hit_B_2"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_B_2"] remoteExec ["playMoveNow", 0]; 
	};
	if (animationState _zombie == "WBK_Walker_Hit_F_1_3") exitWith {
	[_zombie, "WBK_Walker_Hit_F_2_3"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_F_2_3"] remoteExec ["playMoveNow", 0]; 
	};
	[_zombie, "WBK_Walker_Hit_F_1_3"] remoteExec ["switchMove", 0]; 
	[_zombie, "WBK_Walker_Hit_F_1_3"] remoteExec ["playMoveNow", 0]; 
	};
};
};


WBK_ZombieTryingToGrab = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_2") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_3") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_3")) exitWith {};
_enemy = _this select 1;
if (!(isPlayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
};
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50] call CBA_fnc_GlobalSay3D;
}else{
[_zombie, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6"], 50] call CBA_fnc_GlobalSay3D;
};
_rndCatch = selectRandom ["WBK_Walker_TryingToCatch_1","WBK_Walker_TryingToCatch_2","WBK_Walker_TryingToCatch_3"];
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, _rndCatch]] call CBA_fnc_addPerFrameHandler;
sleep 0.7;
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
sleep 0.1;
_zombie allowDamage true;
if ((isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and !(animationState _enemy == "WBK_CatchedByZombie_Front") and !(animationState _enemy == "WBK_CatchedByZombie_Back") and ((_zombie distance _enemy) <= 2) and (animationState _zombie == _rndCatch) and (alive _zombie)) exitWith {
[_enemy,_zombie] remoteExec ["WBK_ZombieGrab", _enemy];
};
sleep 0.9;
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};



WBK_ZombieTryingToGrab_middle = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Middle_GetUpUnconscious") or (animationState _zombie == "WBK_Middle_GetUpUnconscious_1") or (animationState _zombie == "WBK_Middle_TryingToCatch") or (animationState _zombie == "WBK_Middle_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_3")) exitWith {};
_enemy = _this select 1;

if (!(isPlayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
};
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50] call CBA_fnc_GlobalSay3D;
}else{
[_zombie, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6"], 50] call CBA_fnc_GlobalSay3D;
};
_rndCatch = selectRandom ["WBK_Middle_TryingToCatch_1","WBK_Middle_TryingToCatch"];
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_zombie disableAI "MOVE";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {
	_unit allowDamage true;
	_unit enableAI "ANIM";
    _unit enableAI "MOVE";
	};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, _rndCatch]] call CBA_fnc_addPerFrameHandler;
sleep 0.6;
_zombie allowDamage true;
if ((isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and !(animationState _enemy == "WBK_CatchedByZombie_Front") and !(animationState _enemy == "WBK_CatchedByZombie_Back") and ((_zombie distance _enemy) <= 2.6) and (animationState _zombie == _rndCatch) and (alive _zombie)) exitWith {
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
_zombie enableAI "MOVE";
[_enemy,_zombie] remoteExec ["WBK_ZombieGrab", _enemy];
};
sleep 0.5;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
_zombie enableAI "MOVE";
sleep 0.4;
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};




WBK_ZombieTryingToGrab_fast = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Middle_GetUpUnconscious") or (animationState _zombie == "WBK_Middle_GetUpUnconscious_1") or (animationState _zombie == "WBK_Middle_TryingToCatch") or (animationState _zombie == "WBK_Middle_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_3")) exitWith {};
_enemy = _this select 1;

if (!(isPlayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
};
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50] call CBA_fnc_GlobalSay3D;
}else{
[_zombie, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6"], 50] call CBA_fnc_GlobalSay3D;
};
_rndCatch = "WBK_Runner_TryingToCatch";
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_zombie disableAI "MOVE";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {
	_unit allowDamage true;
	_unit enableAI "ANIM";
    _unit enableAI "MOVE";
	};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, _rndCatch]] call CBA_fnc_addPerFrameHandler;
sleep 0.4;
_zombie spawn {
sleep 0.4;
_this allowDamage true;
};
if ((isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and !(animationState _enemy == "WBK_CatchedByZombie_Front") and !(animationState _enemy == "WBK_CatchedByZombie_Back") and ((_zombie distance _enemy) <= 2.6) and (animationState _zombie == _rndCatch) and (alive _zombie)) exitWith {
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
_zombie enableAI "MOVE";
[_enemy,_zombie] remoteExec ["WBK_ZombieGrab", _enemy];
};
sleep 0.7;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (animationState _zombie == _rndCatch) then {
_rndMove = selectRandom ["WBK_Zombie_Evade_B","WBK_Zombie_Evade_L","WBK_Zombie_Evade_R"];
[_zombie, _rndMove] remoteExec ["switchMove", 0]; 
[_zombie, _rndMove] remoteExec ["playMoveNow", 0]; 
};
sleep 0.4;
_zombie enableAI "ANIM";
_zombie enableAI "MOVE";
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};








WBK_ZombieAttack_gesture = {
_zombie = _this select 0;
_enemy = _this select 1;
if (!(isPlayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
};
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50] call CBA_fnc_GlobalSay3D;
}else{
[_zombie, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6"], 50] call CBA_fnc_GlobalSay3D;
};
_rndCatch = selectRandom ["WBK_Zombie_attack_Left","WBK_Zombie_attack_Right"];
[_zombie, _rndCatch] remoteExec ["playActionNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(gestureState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, _rndCatch]] call CBA_fnc_addPerFrameHandler;
sleep 0.3;
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 55, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 0.2;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
sleep 0.1;
_zombie allowDamage true;
if ((isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and ((_zombie distance _enemy) <= 2.4) and (gestureState _zombie == _rndCatch) and (alive _zombie) and (alive _enemy)) exitWith {
[_enemy, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
if ((_enemy isKindOf "WBK_DOS_Squig_Normal") or (_enemy isKindOf "WBK_DOS_Huge_ORK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_CatchedByZombie_Front") or (animationState _enemy == "WBK_CatchedByZombie_Back")) then {
_personWhoIsGrabbed = _enemy;
if (!(((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitWith {
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
_rndSnd = selectRandom ["sword_on_wood_shield01","sword_on_wood_shield02","sword_on_wood_shield03"];  
[_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_personWhoIsGrabbed, selectRandom ["leg_hit1","leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
if !(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") then {
[_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationToZero", _personWhoIsGrabbed, false];  
};
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0]; 
sleep 0.7;
[_zombie, true] remoteExec ["setUnconscious", _zombie]; 
sleep 5;
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
};
[_enemy, 0.01, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
}else{
if (!(isNil {_enemy getVariable "WBK_AI_ISZombie"})) then {
[_enemy,_zombie,0.2,"Fists"] remoteExec ["WBK_ZombiesProcessDamage", _enemy];
}else{
[_enemy, 0.1, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
[_enemy,_zombie] remoteExec ["WBK_CreateMeleeHitAnim", _enemy];
};
};
};
sleep 0.9;
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};






WBK_ZombieAttack = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_2") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_3") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_3")) exitWith {};
_enemy = _this select 1;
if (!(isPlayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
};
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50] call CBA_fnc_GlobalSay3D;
}else{
[_zombie, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6"], 50] call CBA_fnc_GlobalSay3D;
};
_rndCatch = selectRandom ["WBK_Walker_Idle_1_attack","WBK_Walker_Idle_2_attack"];
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, _rndCatch]] call CBA_fnc_addPerFrameHandler;
sleep 0.5;
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 55, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
sleep 0.1;
_zombie allowDamage true;
if ((isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and ((_zombie distance _enemy) <= 2.9) and (animationState _zombie == _rndCatch) and (alive _zombie) and (alive _enemy)) exitWith {
[_enemy, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
if ((_enemy isKindOf "WBK_DOS_Squig_Normal") or (_enemy isKindOf "WBK_DOS_Huge_ORK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_CatchedByZombie_Front") or (animationState _enemy == "WBK_CatchedByZombie_Back")) then {
_personWhoIsGrabbed = _enemy;
if (!(((_personWhoIsGrabbed worldToModel (_zombie modelToWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitWith {
[_personWhoIsGrabbed, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
_rndSnd = selectRandom ["sword_on_wood_shield01","sword_on_wood_shield02","sword_on_wood_shield03"];  
[_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
}else{
[_personWhoIsGrabbed, selectRandom ["leg_hit1","leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
};
if !(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") then {
[_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationToZero", _personWhoIsGrabbed, false];  
};
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0]; 
sleep 0.7;
[_zombie, true] remoteExec ["setUnconscious", _zombie]; 
sleep 5;
[_zombie, false] remoteExec ["setUnconscious", _zombie]; 
};
[_enemy, 0.01, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
}else{
if (!(isNil {_enemy getVariable "WBK_AI_ISZombie"})) then {
[_enemy,_zombie,0.2,"Fists"] remoteExec ["WBK_ZombiesProcessDamage", _enemy];
}else{
[_enemy, 0.1, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
[_enemy,_zombie] remoteExec ["WBK_CreateMeleeHitAnim", _enemy];
};
};
};
sleep 0.9;
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};







WBK_ZombieAttack_Crawler = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_2") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_3") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_success_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_1") or (animationState _zombie == "WBK_Walker_TryingToCatch_2") or (animationState _zombie == "WBK_Walker_TryingToCatch_3")) exitWith {};
_enemy = _this select 1;
if (!(isNil {_zombie getVariable "WBK_Zombie_CustomSounds"})) then {
_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
[_zombie, selectRandom _snds, 50] call CBA_fnc_GlobalSay3D;
}else{
[_zombie, selectRandom ["plagued_attack_1","plagued_attack_2","plagued_attack_3","plagued_attack_4","plagued_attack_5","plagued_attack_6"], 50] call CBA_fnc_GlobalSay3D;
};
[_zombie, "WBK_Crawler_Attack"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Crawler_Attack"] remoteExec ["playMoveNow", 0]; 
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 55, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, "WBK_Crawler_Attack"]] call CBA_fnc_addPerFrameHandler;
sleep 0.5;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
sleep 0.1;
_zombie allowDamage true;
if ((isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and ((_zombie distance _enemy) <= 2.2) and (animationState _zombie == "WBK_Crawler_Attack") and (alive _zombie) and (alive _enemy)) exitWith {
[_enemy, selectRandom ["PF_Hit_1","PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
if ((_enemy isKindOf "WBK_DOS_Squig_Normal") or (_enemy isKindOf "WBK_DOS_Huge_ORK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_CatchedByZombie_Front") or (animationState _enemy == "WBK_CatchedByZombie_Back")) then {
[_enemy, 0.01, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
}else{
if (!(isNil {_enemy getVariable "WBK_AI_ISZombie"})) then {
[_enemy,_zombie,0.2,"Fists"] remoteExec ["WBK_ZombiesProcessDamage", _enemy];
}else{
[_enemy, 0.1, _zombie] remoteExec ["WBK_CreateDamage", _enemy];
[_enemy,_zombie] remoteExec ["WBK_CreateMeleeHitAnim", _enemy];
};
};
};
sleep 0.9;
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};


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




WBK_Smasher_MakeRoar = {
_zombie = _this select 0;
_enemy = _this select 1;
_zombie setVariable ["WBK_CanMakeRoar",1];
_zombie enableAI "MOVE";
_zombie spawn {uiSleep 60; _this setVariable ["WBK_CanMakeRoar",nil];};
_zombie setFormDir (_zombie getDir _enemy);
[_zombie, "WBK_Smasher_Roar"] remoteExec ["switchMove", 0]; 
_zombie spawn WBK_Smasher_CreateCamShake;
_zombie playMove "WBK_Smasher_Roar";
[_zombie, "Smasher_Roar", 345, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
doStop _zombie;
uiSleep 0.1;
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};
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
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Roar"]] call CBA_fnc_addPerFrameHandler;
uisleep 4;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
};



WBK_Smasher_VehicleAttack = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or (animationState _zombie == "WBK_Smasher_Execution")) exitWith {};
_enemy = _this select 1;
[_zombie, "WBK_Smasher_Attack_VEHICLE"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_Attack_VEHICLE"] remoteExec ["playMoveNow", 0]; 
doStop _zombie;
uiSleep 0.1;
if (!(animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};
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
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_VEHICLE"]] call CBA_fnc_addPerFrameHandler;
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 1;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (!(animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_zombie spawn {sleep 1; if ((isNull _this) or !(alive _this)) exitWith {};[_this, selectRandom ["Smasher_scream_1","Smasher_scream_2"], 320, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";};
_zombie spawn WBK_Smasher_CreateCamShake;
[_zombie, selectRandom ["Smasher_attack_4","Smasher_attack_6","Smasher_attack_7"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie enableAI "MOVE";
if (((_zombie distance _enemy) > 7) or !(animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or !(alive _zombie)) exitWith {};
[_zombie, "Smasher_hit", 245, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_dir = getDirVisual _zombie;
_vel = velocity _enemy;
[_enemy, [(_vel select 0)+(sin _dir*15),(_vel select 1)+(cos _dir*15),5]] remoteExec ["setVelocity", _enemy];
if ((_enemy isKindOf "CAR") or (_enemy isKindOf "Helicopter") or (_enemy isKindOf "StaticWeapon")) then {
_enemy setDamage 1;
}else{
[_enemy, "Smasher_hit_vehicle", 245, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_enemy setDamage ((damage _enemy) + 0.5);
};
};


WBK_Smasher_HumanoidAttack_1 = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or (animationState _zombie == "WBK_Smasher_Execution")) exitWith {};
_enemy = _this select 1;
{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_zombie, "WBK_Smasher_Attack_1"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_Attack_1"] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_1"]] call CBA_fnc_addPerFrameHandler;
sleep 0.8;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_rndEquip = selectRandom ["Smasher_swoosh_1","Smasher_swoosh_2"];
[_zombie, _rndEquip, 80, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie spawn WBK_Smasher_CreateCamShake;
sleep 0.3;
if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x, 0.5, 3.75] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_zombie,["MAN"],3.75];
sleep 0.6;
if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_1"]] call CBA_fnc_addPerFrameHandler;
sleep 0.6;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_zombie, selectRandom ["Smasher_swoosh_1","Smasher_swoosh_2"], 80, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie spawn WBK_Smasher_CreateCamShake;
sleep 0.1;
if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x, 1, 3.9] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_zombie,["MAN"],3.9];
_zombie enableAI "ANIM";
};







WBK_Smasher_HumanoidAttack_2 = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or (animationState _zombie == "WBK_Smasher_Execution")) exitWith {};
_enemy = _this select 1;
{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];

[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_zombie, "WBK_Smasher_Attack_2"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_Attack_2"] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_2"]] call CBA_fnc_addPerFrameHandler;
sleep 1;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (!(animationState _zombie == "WBK_Smasher_Attack_2") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_rndEquip = selectRandom ["Smasher_swoosh_1","Smasher_swoosh_2"];
[_zombie, _rndEquip, 80, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 0.6;
if (!(animationState _zombie == "WBK_Smasher_Attack_2") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
[_zombie, "Smasher_hit", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
_zombie spawn WBK_Smasher_CreateCamShake;
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_zombie,["MAN"],3.9];
_zombie enableAI "ANIM";
_electra = "#particlesource" createVehicle position _zombie; 
_electra setParticleClass "HDustVTOL1"; 
_electra attachTo [_zombie,[0,0,0]];
sleep 1;
deleteVehicle _electra;
};




WBK_Smasher_HumanoidAttack_3 = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or (animationState _zombie == "WBK_Smasher_Execution")) exitWith {};
_enemy = _this select 1;
[_zombie, "WBK_Smasher_Attack_VEHICLE"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_Attack_VEHICLE"] remoteExec ["playMoveNow", 0]; 
_zombie enableAI "ANIM";
doStop _zombie;
uiSleep 0.1;
if (!(animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};
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
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_VEHICLE"]] call CBA_fnc_addPerFrameHandler;
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];

sleep 1;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (!(animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or !(alive _zombie)) exitWith {
_zombie enableAI "ANIM";
};
_zombie spawn {sleep 1; if ((isNull _this) or !(alive _this)) exitWith {};[_this, selectRandom ["Smasher_scream_1","Smasher_scream_2"], 320, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";};
[_zombie, selectRandom ["Smasher_attack_4","Smasher_attack_6","Smasher_attack_7"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie enableAI "MOVE";
_zombie spawn WBK_Smasher_CreateCamShake;
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x] spawn {
_zombie = _this select 0;
_enemy = _this select 1;
if ((animationState _enemy == "starWars_landRoll_b") or (animationState _enemy == "starWars_landRoll") or (animationState _enemy == "STAR_WARS_FIGHT_DODGE_RIGHT") or (animationState _enemy == "STAR_WARS_FIGHT_DODGE_LEFT") or !(animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or !(alive _zombie) or !(isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"})) exitWith {};
[_zombie, "Smasher_hit", 245, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_enemy, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 140, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
_enemy setDamage 1;
uisleep 0.05;
[_enemy, [_zombie vectorModelToWorld [0,3000,800], _enemy selectionPosition "head"]] remoteExec ["addForce", _enemy];
};
};
} forEach nearestObjects [_zombie,["MAN"],4.5];
};


WBK_Smasher_HumanoidAttack_4 = {
_zombie = _this select 0;
if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or (animationState _zombie == "WBK_Smasher_Execution")) exitWith {};
_enemy = _this select 1;
{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_zombie, "WBK_Smasher_Attack_3"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_Attack_3"] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_3"]] call CBA_fnc_addPerFrameHandler;
sleep 0.5;
if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitWith {
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
};
_zombie spawn WBK_Smasher_CreateCamShake;
[_zombie, "Smasher_hit", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_zombie,["MAN"],3.9];
_zombie enableAI "ANIM";
_electra = "#particlesource" createVehicle position _zombie; 
_electra setParticleClass "HDustVTOL1"; 
_electra attachTo [_zombie,[0,0,0]];
detach _electra;
_electra spawn {sleep 1; deleteVehicle _this;};
sleep 0.4;
if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitWith {
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
};
[_zombie, selectRandom ["Smasher_swoosh_1","Smasher_swoosh_2"], 140, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 0.3;
if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitWith {
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
};
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_zombie,["MAN"],5.2];
_zombie spawn WBK_Smasher_CreateCamShake;
sleep 0.3;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitWith {
};
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};

WBK_Smasher_ExecutionFnc = {  
_main = _this select 0;  
_main spawn {uiSleep 60; _this setVariable ["WBK_CanEatSomebody",nil];};
_victim = _this select 1;  
_victim setVariable ["AI_CanTurn",1,true];  
_victim setVariable ["canMakeAttack",1,true];   
_main setVariable ["canMakeAttack",1];  
_main setVariable ["AI_CanTurn",1];  
_main setVariable ["actualSwordBlock",0, true];  
[_main, _victim] remoteExecCall ["disableCollisionWith", 0, _main];  
[_victim, _main] remoteExecCall ["disableCollisionWith", 0, _victim];  
[_main, "WBK_Smasher_Execution"] remoteExec ["switchMove", 0, false];  
[_main, "WBK_Smasher_Execution"] remoteExec ["playMoveNow", 0, false];  
[_victim, "WBK_Smasher_Execution"] remoteExec ["switchMove", 0, true];  
[_victim, "WBK_Smasher_Execution"] remoteExec ["switchMove", 0, true];  
[_victim, "Disable_Gesture"] remoteExec ["playActionNow", _victim];  
_victim attachTo [_main,[0,3.51,0]];    
_victim setDamage 0;  
_main setDamage 0;
[_victim, 180] remoteExec ["setDir", 0];  
[_victim, "dead"] remoteExec ["setMimic", 0];  
sleep 0.1;
[_main, selectRandom ["Smasher_attack_8","Smasher_attack_9"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "PF_Hit_2", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "dobi_fall_2", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
if (isNil {_victim getVariable "WBK_AI_ISZombie"}) then {
[_victim, selectRandom ["Smasher_human_scream_1","Smasher_human_scream_2","Smasher_human_scream_3"], 110, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
sleep 1.9;
_victim setDamage 1;
[_victim, 1.25] remoteExec ["setAnimSpeedCoef", 0];  
[_main, selectRandom ["Smasher_attack_6","Smasher_attack_7"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "dobi_CriticalHit", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_main spawn WBK_Smasher_CreateCamShake;
if (isNil {_victim getVariable "WBK_AI_ISZombie"}) then {
[_victim, selectRandom ["New_Death_1","New_Death_2","New_Death_3","New_Death_4","New_Death_5","New_Death_6","New_Death_7","New_Death_8","New_Death_9"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
[_victim, {
_object = _this;
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
{
if (!(_x == _victim) and !(_x == _main) and (alive _main) and (alive _x)) then {
[_main, _x, 0.2, 5.5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_victim,["MAN"],5.5];
sleep 1.5;
[_main, "Smasher_eat_voice", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_main, "Smasher_Eat", 100, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "PF_Hit_1", 40, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "decapetadet_sound_1", 50, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_victim unlinkItem hmd _victim;
removeGoggles _victim;
removeHeadgear _victim;
[_victim, {
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
sleep 2.5;
[_main, "Smasher_execution_end", 90, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 0.2;
[_victim, "decapetadet_sound_2", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_victim spawn WBK_Smasher_CreateCamShake;
[_victim, {
_object = _this;
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
{
if (!(_x == _victim) and !(_x == _main) and (alive _main) and (alive _x)) then {
[_main, _x, 0.2, 5.5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_victim,["MAN"],5.5];
sleep 0.8;
detach _victim;
};


QS_fnc_geomPolygonCentroid = {
_count = count _this;
private _vectors = _this select 0;
for '_i' from 1 to (_count - 1) step 1 do {
	_vectors = _vectors vectorAdd (_this select _i);
};
(_vectors vectorMultiply (1 / _count))
};




WBK_ChargerJump = {
_zombie = _this select 0;
if (!(alive _zombie)) exitWith {};
_enemy = _this select 1;
_dist = _this select 2;
_positions = [
	getPosASLVisual _zombie,
	getPosASLVisual _enemy
];
_centroid = _positions call QS_fnc_geomPolygonCentroid;
_arrow = "#particlesource" createVehicleLocal [0,0,0];  
_arrow setPosASL [_centroid select 0, _centroid select 1, (getPosASLVisual _enemy select 2) + 3];
_geometryForward = lineIntersectsSurfaces [
	getPosASLVisual _zombie, 
	getPosASLVisual _arrow, 
	_zombie,
	_arrow,
	true,
	1,
	"GEOM",
	"FIRE"
    ];
_geometryForward_1 = lineIntersectsSurfaces [
	getPosASLVisual _arrow, 
	getPosASLVisual _enemy, 
	_enemy,
	_arrow,
	true,
	1,
	"GEOM",
	"FIRE"
    ];
if ((count _geometryForward > 0) or (count _geometryForward_1 > 0)) exitWith {deleteVehicle _arrow;};
_zombie disableAI "MOVE";
_zombie setVariable ["CanFly",1];
_zombie allowDamage false;
[_zombie, "WBK_Smasher_inAir_start"] remoteExec ["switchMove", 0, false];
[_zombie, "WBK_Smasher_inAir_start"] remoteExec ["playMoveNow", 0, false];
_zombie setFormDir (_zombie getDir _enemy);
doStop _zombie;
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {};
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
}, 0.01, [_zombie, _enemy, "WBK_Smasher_inAir_start"]] call CBA_fnc_addPerFrameHandler;
uiSleep 0.55;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
if (!(alive _zombie)) exitWith {
deleteVehicle _arrow;
};
uiSleep 0.1;
if (!(alive _zombie)) exitWith {
deleteVehicle _arrow;
};
_zombie setDir (_zombie getDir _enemy);
_pos = (getPosATL _enemy) select 2;
_pos1 = (getPosATL _zombie) select 2;
_actPos = _pos - _pos1;
[_zombie, [0,(_zombie distance _enemy) * 0.9,_actPos + 7]] remoteExec ["setVelocityModelSpace", _zombie];
[_zombie, selectRandom ["Smasher_swoosh_1","Smasher_swoosh_2"], 160, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_zombie spawn {
_zombie = _this;
uiSleep 0.6;
if (isTouchingGround _zombie) exitWith {};
[_zombie, [0,13,-10]] remoteExec ["setVelocityModelSpace", _zombie];
};
uiSleep 0.3;
if (!(alive _zombie)) exitWith {
deleteVehicle _arrow;
};
deleteVehicle _arrow;
waitUntil {
	if ((isNull _zombie) or !(alive _zombie)) exitWith { true };
	(isTouchingGround _zombie)
};
if (!(alive _zombie)) exitWith {
};
_zombie enableAI "MOVE";
[_zombie, "WBK_Smasher_inAir_end"] remoteExec ["switchMove", 0, false];
[_zombie, "WBK_Smasher_inAir_end"] remoteExec ["playMoveNow", 0, false];
{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];
Sleep 0.4;
if (!(alive _zombie) or !(animationState _zombie == "WBK_Smasher_inAir_end")) exitWith {
deleteVehicle _arrow;
};
_zombie spawn WBK_Smasher_CreateCamShake;
_electra = "#particlesource" createVehicle position _zombie; 
_electra setParticleClass "HDustVTOL1"; 
_electra attachTo [_zombie,[0,0,0]];
detach _electra;
_electra spawn {sleep 1; deleteVehicle _this;};
[_zombie, "Smasher_execution_end", 140, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_zombie, "Smasher_hit", 160, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
if (vehicle _x isKindOf "MAN") then {
[_zombie, _x, 1, 5.5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
}else{
_x setDamage 1;
};
};
} forEach nearestObjects [_zombie,["MAN","CAR","TANK","HELI","StaticWeapon"],5.5];
uiSleep (15 + random 5);
_zombie setVariable ["CanFly",nil];
};




WBK_Smasher_RockThrowing = {
_zombie = _this select 0;
if (!(isNil {_zombie getVariable "CanThrowRocks"}) or (animationState _zombie == "WBK_Smasher_Throw") or (animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_VEHICLE") or (animationState _zombie == "WBK_Smasher_Execution")) exitWith {};
_zombie setVariable ["CanThrowRocks",1];
_zombie spawn {uiSleep 45; _this setVariable ["CanThrowRocks",nil];};
_enemy = _this select 1;
{
if (!(_x == _zombie) and !(isPlayer _x) and (alive _x)) then {
[_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
};
} forEach nearestObjects [_zombie,["MAN"],5.9];
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_zombie, "WBK_Smasher_Throw"] remoteExec ["switchMove", 0]; 
[_zombie, "WBK_Smasher_Throw"] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_throwableItem = "Smasher_RockGrenade" createVehicle [0,0,6000];
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, "WBK_Smasher_Throw"]] call CBA_fnc_addPerFrameHandler;
sleep 0.5;
if (!(animationState _zombie == "WBK_Smasher_Throw") or !(alive _zombie)) exitWith {
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
deleteVehicle _throwableItem;
};
[_zombie, "Smasher_hit", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
_zombie spawn WBK_Smasher_CreateCamShake;
{
if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
[_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_zombie,["MAN"],3.9];
_zombie enableAI "ANIM";
_electra = "#particlesource" createVehicle position _zombie; 
_electra setParticleClass "HDustVTOL1"; 
_electra attachTo [_zombie,[0,0,0]];
detach _electra;
_electra spawn {sleep 2; deleteVehicle _this;};
sleep 0.95;
if (!(animationState _zombie == "WBK_Smasher_Throw") or !(alive _zombie)) exitWith {
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
deleteVehicle _throwableItem;
};
_throwableItem attachTo [_zombie,[0,-1,0],"Smash_Hand_R",true];
[_zombie, "Smasher_hit", 150, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
sleep 0.65;
if (!(animationState _zombie == "WBK_Smasher_Throw") or !(alive _zombie)) exitWith {
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
deleteVehicle _throwableItem;
};
[_zombie, selectRandom ["Smasher_swoosh_1","Smasher_swoosh_2"], 340, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 0.1;
detach _throwableItem;
_dir = (_zombie getDir _enemy);
_vel = velocity _zombie;
_distance = (_zombie distance _enemy) * 0.8;
_pos = (getPosASL _enemy) select 2;
_pos1 = (getPosASL _zombie) select 2;
_actPos = _pos - _pos1;
if (_actPos < 0) then {
_throwableItem setVelocity [(_vel select 0)+(sin _dir*_distance),(_vel select 1)+(cos _dir*_distance),_actPos + 6.2];
}else{
if (_actPos > 4) then {
_throwableItem setVelocity [(_vel select 0)+(sin _dir*_distance),(_vel select 1)+(cos _dir*_distance),_actPos + 3];
}else{
_distance = (_zombie distance _enemy) * 0.86;
_throwableItem setVelocity [(_vel select 0)+(sin _dir*_distance),(_vel select 1)+(cos _dir*_distance),_actPos + 4.6];
};
};
sleep 0.1;
[_throwableItem, _zombie] spawn {
_grenade = _this select 0;
_actualHitClass = "#particlesource" createVehicle position _grenade; 
_actualHitClass attachTo [_grenade,[0,0,0]];
_zombie = _this select 1;
while {alive _grenade} do {
{
if ((alive _x) and !(_x == _zombie)) then {
[_grenade, _x, 0.1, 5] remoteExec ["WBK_Smasher_VictimDamageProceed",_x];
};
} forEach nearestObjects [_grenade,["MAN"],5];
uiSleep 0.1;
};
{
if ((alive _x) and !(_x == _zombie)) then {
[_x, 228, _actualHitClass] remoteExec ["concentrationToZero", _x, false];
};
} forEach nearestObjects [_actualHitClass,["MAN"],15];
[_actualHitClass, "Smash_rockHit", 450] call CBA_fnc_GlobalSay3d;
_actualHitClass spawn WBK_Smasher_CreateCamShake;
[_actualHitClass, {
_aslLoc = _this;
	_col = [0,0,0];
	_c1 = _col select 0;
	_c2 = _col select 1;
	_c3 = _col select 2;

	_rocks1 = "#particlesource" createVehicleLocal getPosAsl _aslLoc;
	_rocks1 setposasl getPosAsl _aslLoc;
	_rocks1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.45, .45], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc,0,false,0.3];
	_rocks1 setParticleRandom [0, [1, 1, 0], [20, 20, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
	_rocks1 setDropInterval 0.01;
	_rocks1 setParticleCircle [0, [0, 0, 0]];

	_rocks2 = "#particlesource" createVehicleLocal getPosAsl _aslLoc;
	_rocks2 setposasl getPosAsl _aslLoc;
	_rocks2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.27, .27], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc,0,false,0.3];
	_rocks2 setParticleRandom [0, [1, 1, 0], [25, 25, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
	_rocks2 setDropInterval 0.01;
	_rocks2 setParticleCircle [0, [0, 0, 0]];

	_rocks3 = "#particlesource" createVehicleLocal getPosAsl _aslLoc;
	_rocks3 setposasl getPosAsl _aslLoc;
	_rocks3 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.09, .09], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc,0,false,0.3];
	_rocks3 setParticleRandom [0, [1, 1, 0], [30, 30, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
	_rocks3 setDropInterval 0.01;
	_rocks3 setParticleCircle [0, [0, 0, 0]];
	_rocks = [_rocks1,_rocks2, _rocks3];
	sleep 0.3;
	{
		deletevehicle _x;
	} foreach _rocks;
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
uisleep 15;
deleteVehicle _actualHitClass;
};
sleep 0.1;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
if (!(animationState _zombie == "WBK_Smasher_Throw") or !(alive _zombie)) exitWith {
};
[_zombie, selectRandom ["Smasher_attack_1","Smasher_attack_2","Smasher_attack_3","Smasher_attack_4","Smasher_attack_5","Smasher_attack_6","Smasher_attack_7","Smasher_attack_8","Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};



WBK_Smasher_CreateCamShake = {
_obj = _this;
[_obj, {
_unit = missionNamespace getVariable["bis_fnc_moduleRemoteControl_unit", player];
if ((_unit distance _this) <= 20) then {
enableCamShake true;
addCamShake [5, 5, 25];
};
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
};



WBK_CorruptedAttack_success = {  
_main = _this select 0;  
_victim = _this select 1;  
_victim setVariable ['IMS_IsUnitInvicibleScripted',1,true];
_victim setVariable ["AI_CanTurn",1,true];  
_victim setVariable ["canMakeAttack",1,true];   
_main setVariable ["canMakeAttack",1];  
_main setVariable ["AI_CanTurn",1];  
_main disableAI "RADIOPROTOCOL";
_main setVariable ["actualSwordBlock",0, true];  
[_main, _victim] remoteExecCall ["disableCollisionWith", 0, _main];  
[_victim, _main] remoteExecCall ["disableCollisionWith", 0, _victim];  
if (((_victim worldToModel (_main modelToWorld [0, 0, 0])) select 1) > 0) then {
[_main, "Corrupted_attack_success_front"] remoteExec ["switchMove", 0, false];  
[_main, "Corrupted_attack_success_front"] remoteExec ["playMoveNow", 0, false];  
}else{
[_main, "Corrupted_attack_success_back"] remoteExec ["switchMove", 0, false];  
[_main, "Corrupted_attack_success_back"] remoteExec ["playMoveNow", 0, false];  
};
[_victim, "Corrupted_Attack_victim"] remoteExec ["switchMove", 0, true];  
[_victim, "Corrupted_Attack_victim"] remoteExec ["playMoveNow", 0, true];  
[_victim, "WBK_Runner_Angry_Idle"] remoteExec ["playMove", _victim, true];  
[_victim, "Disable_Gesture"] remoteExec ["playActionNow", _victim];  
_main attachTo [_victim,[0,0,0]];    
_victim setDamage 0;  
_main setDamage 0;
[_victim, "dead"] remoteExec ["setMimic", 0];  
_main setVariable ["WBK_ZombieAttachedParasite",_victim,true];
_main addEventHandler ["Killed",{
_main = _this select 0;
detach _main;
_main removeAllEventHandlers "Killed";
_victim = _main getVariable "WBK_ZombieAttachedParasite";
_victim removeAllEventHandlers "Killed";
[_main, "Corrupted_attack_success_dying"] remoteExec ["switchMove", 0, false];  
[_main, "Corrupted_attack_success_dying"] remoteExec ["playMoveNow", 0, false];  
_victim spawn {
_personWhoIsGrabbed = _this;
if (!(alive _personWhoIsGrabbed)) exitWith {};
[_personWhoIsGrabbed, "angry"] remoteExec ["setMimic", 0]; 
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
_victim setVariable ["canMakeAttack",0,true];
_victim setVariable ["AI_CanTurn",0,true];
_victim enableAI "ALL";
_victim setVariable ['IMS_IsUnitInvicibleScripted',nil,true];
}];
_victim setVariable ["WBK_ZombieAttachedParasite",_main,true];
_victim addEventHandler ["Killed",{
_unit = _this select 0;
_unit removeAllEventHandlers "Killed";
_main = _unit getVariable "WBK_ZombieAttachedParasite";
detach _main;
[_main, "Corrupted_attack_success_failed"] remoteExec ["switchMove", 0, false];  
[_main, "Corrupted_attack_success_failed"] remoteExec ["playMoveNow", 0, false];  
}];
sleep 1;
if (!(alive _main) or !(alive _victim) or !(animationState _victim == "Corrupted_Attack_victim") or (!(animationState _main == "Corrupted_attack_success_back") and !(animationState _main == "Corrupted_attack_success_front"))) exitWith {};
if (isNil {_victim getVariable "WBK_AI_ISZombie"}) then {
[_victim, selectRandom ["Smasher_human_scream_1","Smasher_human_scream_2","Smasher_human_scream_3"], 110, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};
[_victim, selectRandom ["corrupted_head_attack_1","corrupted_head_attack_2","corrupted_head_attack_3","corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 1.8;
if (!(alive _main) or !(alive _victim) or !(animationState _victim == "Corrupted_Attack_victim") or (!(animationState _main == "Corrupted_attack_success_back") and !(animationState _main == "Corrupted_attack_success_front"))) exitWith {};
[_victim, selectRandom ["corrupted_head_attack_1","corrupted_head_attack_2","corrupted_head_attack_3","corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_main allowDamage false;
_main removeAllEventHandlers "Killed";
[_victim, false] remoteExec ["allowDamage", 0];
[_victim, "RADIOPROTOCOL"] remoteExec ["disableAI", 0];
[_victim, "PF_Hit_2", 40, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
if (isPlayer _victim) then {
[_victim, {
_player_unit = player;
_player_unit enableai "MOVE";
_player_unit enableai "AUTOTARGET";
_player_unit enableai "TARGET";
_player_name = name _player_unit;
_player_face = face _player_unit;
_unit_for_select = ((creategroup (side _player_unit)) createunit [typeOf _player_unit, [0, 0, 0], [], 0, "NONE"]);
selectplayer _unit_for_select;
_player_unit switchcamera "EXTERNAL";
_player_unit setskill 1;
_player_unit setface _player_face;
_player_unit setname _player_name;
removeSwitchableUnit _player_unit;
unassignVehicle _player_unit;
sleep 5;
_unit_for_select setVariable ["actualSwordBlock",0, true];
_unit_for_select setVariable ["canMakeAttack",0, true];
_unit_for_select setVariable ["canDeflectBullets",0, true];
_unit_for_select setVariable ["concentrationParam",0.5, true];
_unit_for_select setVariable ["BlockCountdown",1,true];
_unit_for_select setVariable ["IMS_StaminaRegenerationParam",0.0016];
_unit_for_select setVariable ["SM_CanUseSkill",nil];
_unit_for_select setVariable ["IMS_LaF_ShotsToTakeOutOneGuy",50,true];
_unit_for_select setVariable ["inBlock",0,true];
_unit_for_select setVariable ["IMS_LaF_ForceMana",0.5,true];
[_unit_for_select] execVM "\WebKnight_StarWars_Mechanic\lighsaber_moveSet.sqf";
_unit_for_select addEventHandler ["Respawn", {
if (IMS_IsAddAweaponTOplrRsp) then {
if (side player == west) then {player addItem "Knife_m3";};
if (side player == east) then {player addItem "Weap_melee_knife";};
if (side player == resistance) then {player addItem "Knife_kukri";};
};
inDeflectingBullets = 0;
jumpUpParam = 0;
jumpFwrdParam = 0;
PlayerForceMana = 0;
PowerChokeKillOrNot = 0;
inUsingChoke = false;
jumpDirection = "Forward";
SupaPunch = 1;
player setVariable ["actualSwordBlock",0, true];
player setVariable ["canMakeAttack",0, true];
player setVariable ["canDeflectBullets",0, true];
player setVariable ["concentrationParam",0.5, true];
player setVariable ["SM_CanUseSkill",nil];
player setVariable ["IMS_LaF_ShotsToTakeOutOneGuy",50,true];
player setVariable ["IMS_LaF_ForceMana",0.5,true];
player setVariable ["inBlock",0,true];
nextMeleeAttack = "woodaxe_attack1";
attackStyle = "Light";
[player] execVM "\WebKnight_StarWars_Mechanic\lighsaber_moveSet.sqf";
}];
sleep 5;
_unit_for_select setDamage 1;
}] remoteExec ["spawn", _victim]; 
};
[_victim, {
_object = _this;
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
		-1 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.25;
deleteVehicle _breath; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
sleep 0.95;
[[_victim,_main], {
_victim = _this select 0;
_main = _this select 1;
removeAllWeapons _victim;
[_victim] joinSilent (group _main);
}] remoteExec ["spawn", _victim];  
[_victim, selectRandom ["corrupted_head_attack_1","corrupted_head_attack_2","corrupted_head_attack_3","corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "PF_Hit_1", 40, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "decapetadet_sound_1", 50, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_victim unlinkItem hmd _victim;
removeGoggles _victim;
removeHeadgear _victim;
[_victim, {
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
		-1 //bounce on surface     
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
		-1 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.15;
deleteVehicle _breath; 
sleep 0.9;
deleteVehicle _blood; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
sleep 1.5;
[_victim, selectRandom ["corrupted_head_attack_1","corrupted_head_attack_2","corrupted_head_attack_3","corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, selectRandom ["dobi_blood_1","dobi_blood_2"], 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "decapetadet_sound_2", 50, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, "Smasher_Eat", 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, {
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
		-1 //bounce on surface     
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
		-1 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.15;
deleteVehicle _breath; 
sleep 0.9;
deleteVehicle _blood; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
sleep 1.3;
[_victim, "corrupted_transformed", 150, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
sleep 1;
deleteVehicle _main;
[_victim, {
_this execVM "\WBK_Zombies\AI\WBK_AI_Corrupted.sqf";
_this allowDamage true;
_this setVariable ['IMS_IsUnitInvicibleScripted',nil,true];
}] remoteExec ["spawn", _victim]; 
_victim setVariable ["WBK_Zombie_CustomSounds",
[
["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
["corrupted_idle_1","corrupted_idle_2","corrupted_idle_3","corrupted_idle_4"],
["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"],
["corrupted_dead_1","corrupted_dead_2","corrupted_dead_3"]
],true];
if !(isNil {_victim getVariable "WBK_AI_ISZombie"}) then {
[_victim, "WBK_DosHead_Corrupted"] remoteExec ["setFace", 0, true];
};
[_victim, "dobi_blood_1", 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_victim, {
_object = _this;
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
		-1 //bounce on surface            
	];            
_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];      
_breath setDropInterval 0.01;            
_breath attachTo [_object,[0,0,0.2], "head"];  
sleep 0.15;
deleteVehicle _breath; 
}] remoteExec ["spawn", [0,-2] select isDedicated,false];
};




WBK_HeadTryingToGrab = {
_zombie = _this select 0;
if (animationState _zombie == "Corrupted_Attack") exitWith {};
_enemy = _this select 1;
if (!(isPlayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
};
[_zombie, selectRandom ["corrupted_head_attack_1","corrupted_head_attack_2","corrupted_head_attack_3","corrupted_head_attack_4"], 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_rndCatch = "Corrupted_Attack";
[_zombie, _rndCatch] remoteExec ["switchMove", 0]; 
[_zombie, _rndCatch] remoteExec ["playMoveNow", 0]; 
_zombie allowDamage false;
doStop _zombie;
_zombie disableAI "ANIM";
_loopPathfindDoMove = [{
    _array = _this select 0;
    _unit = _array select 0;
	_nearEnemy = _array select 1;
	_anim = _array select 2;
	if (!(animationState _unit == _anim) or (lifeState _unit == "INCAPACITATED") or !(alive _unit)) exitWith {_unit allowDamage true;};
    _dir = [[0,1,0], -([_unit, _nearEnemy] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D;
    _unit setVelocityTransformation [ 
        getPosASL _unit,  
        getPosASL _unit,  
        [0,0,(velocity _unit select 2) - 1],  
        [(velocity _unit select 0),(velocity _unit select 1),(velocity _unit select 2) - 1], 
        vectorDir _unit,  
        _dir,  
        vectorUp _unit,  
        vectorUp _unit, 
        0.1
    ]; 
}, 0.01, [_zombie, _enemy, _rndCatch]] call CBA_fnc_addPerFrameHandler;
sleep 0.7;
_rndEquip = selectRandom ["melee_whoosh_00","melee_whoosh_01","melee_whoosh_02"];
[_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_zombie enableAI "ANIM";
sleep 0.1;
_zombie allowDamage true;
if (!(animationState _enemy == "Corrupted_Attack_victim") and (isNil {_enemy getVariable "IMS_IsUnitInvicibleScripted"}) and !(animationState _enemy == "Corrupted_Attack") and !(animationState _enemy == "WBK_CatchedByZombie_Back") and ((_zombie distance _enemy) <= 2.3) and (animationState _zombie == _rndCatch) and (alive _zombie)) exitWith {
[_zombie,_enemy] spawn WBK_CorruptedAttack_success;
};
sleep 0.9;
_pos = ASLtoAGL getPosASLVisual _enemy;
_zombie doMove _pos;
};


WBK_SpawnCorruptedHead = {
_unit = _this;
[_unit, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
_unit unlinkItem hmd _unit;
removeGoggles _unit;
removeHeadgear _unit;
[_unit, {
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
if (side group _unit == resistance) exitWith {
_headcrab = group _unit createUnit ["WBK_SpecialZombie_Corrupted_1", [0,0,100], [], 0, "FORM"];
_headcrab attachTo [_unit,[0,0,0],"head"];
detach _headcrab;
_headcrab setSpeaker "NoVoice";
};
if (side group _unit == west) exitWith {
_headcrab = group _unit createUnit ["WBK_SpecialZombie_Corrupted_2", [0,0,100], [], 0, "FORM"];
_headcrab attachTo [_unit,[0,0,0],"head"];
detach _headcrab;
_headcrab setSpeaker "NoVoice";
};
if (side group _unit == east) exitWith {
_headcrab = group _unit createUnit ["WBK_SpecialZombie_Corrupted_3", [0,0,100], [], 0, "FORM"];
_headcrab attachTo [_unit,[0,0,0],"head"];
detach _headcrab;
_headcrab setSpeaker "NoVoice";
};
};
