["WebKnight's Zombies", "WBK_ZombieAI_load", ["(Zeus only!) load Zombie AI on unit", "load zombie ai on a whole group of the selected unit."], {
    if (isNull(findDisplay 312)) exitwith {};
    createdialog "WBK_selectZombietype";
}, {}, [45, [true, true, false]]] call cba_fnc_addKeybind;

[
    "WBK_ZombiesIsUseStatDeathControl",
    "list",
    "Use static death animations? (Good for huge hordes)",
    "WebKnight's Zombies",
    [[false, true], ["NO", "YES"], 0],
    1,
    {
        params ["_value"];
        WBK_Zombies_EnableStaticAnimations = _value;
    }
] call CBA_fnc_addsetting;

[
    "WBK_ZombiesIsUseParticleDeathControl",
    "list",
    "Use headshot particle effects?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {
        params ["_value"];
        WBK_Zombies_EnableHeadShotsParticles = _value;
    }
] call CBA_fnc_addsetting;

[
    "WBK_ZombiesIsUseBitingAnimation",
    "list",
    "Will infected use biting animations?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {
        params ["_value"];
        WBK_Zombies_EnableBitingMechanic = _value;
    }
] call CBA_fnc_addsetting;

[
    "WBK_ZommbiesSmasherHealthparam",
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
] call CBA_fnc_addsetting;

[
    "WBK_ZommbiesSmasherthrowparam",
    "list",
    "(Smasher) Can throw rocks?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {
        params ["_value"];
        WBK_Zombies_SmasherRockAbil = _value;
    }
] call CBA_fnc_addsetting;

[
    "WBK_ZommbiesSmasherJumpparam",
    "list",
    "(Smasher) Can do jump attack?",
    "WebKnight's Zombies",
    [[true, false], ["YES", "NO"], 0],
    1,
    {
        params ["_value"];
        WBK_Zombies_SmasherFlyAbil = _value;
    }
] call CBA_fnc_addsetting;

[
    "WBK_ZommbiesLeaperHealthparam",
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
] call CBA_fnc_addsetting;

if ("dev_common" in activatedAddons) then {
    WBK_NecroplagueDetected = true;
};

WBK_getClasses = {
    params ["_faction", "_array"];
    _array = [];
    _cfg = (configFile >> "Cfgvehicles");
    {
        if (((configname _x) isKindOf "CAManBase") and (getNumber (configFile >> "Cfgvehicles" >> (configname _x)>> "scope") == 2)) then {
            _array pushBack (configname _x);
        };
    } forEach ("gettext (_x >> 'faction') == _faction" configClasses (configFile >> "Cfgvehicles"));
    _array
};

// default faction classes: "OPF_T_F" "OPF_R_F" "OPF_F" "blu_F" "BLU_G_F" "BLU_CTRG_F" "BLU_GEN_F" "BLU_T_F" "BLU_W_F" "CIV_F" "CIV_IDAP_F" "inD_C_F" "inD_E_F" "inD_F" "inD_L_F"
WBK_ZombiesrandomEquipment = {
    _unit = _this select 0;
    _faction = _this select 1;
    // Look for cfgfactionClasses to see more classes for your units
    _UnitArray = [_faction] call WBK_getClasses;
    _rndUnit = selectRandom _UnitArray;
    _outFit = getUnitloadout _rndUnit;
    _unit setUnitLoadout _outFit;
};

WBK_loadAIThroughEden = {
    _unit = _this select 0;
    _loadScript = _this select 1;
    if (_loadScript == 0) exitwith {};
    switch (_loadScript) do
    {
        case 1: {
            [_unit, true] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Walker.sqf';
        };
        case 2: {
            [_unit, false] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Walker.sqf';
        };
        case 3: {
            _unit execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Middle.sqf';
        };
        case 4: {
            [_unit, false] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Runner.sqf';
        };
        case 5: {
            [_unit, true] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Runner.sqf';
        };
        case 6: {
            _unit execVM '\saef_wbk_cnz_performance_patch\AI\WBK_ShooterZombie.sqf';
        };
    };
};

/*
Custom zombie sounds

this setVariable ["WBK_Zombie_CustomSounds",
[
	["WW2_Zombie_idle1", "WW2_Zombie_idle2", "WW2_Zombie_idle3", "WW2_Zombie_idle4", "WW2_Zombie_idle5", "WW2_Zombie_idle6"],
	["WW2_Zombie_walker1", "WW2_Zombie_walker2", "WW2_Zombie_walker3", "WW2_Zombie_walker4", "WW2_Zombie_walker5"],
	["WW2_Zombie_attack1", "WW2_Zombie_attack2", "WW2_Zombie_attack3", "WW2_Zombie_attack4", "WW2_Zombie_attack5"],
	["WW2_Zombie_death1", "WW2_Zombie_death2", "WW2_Zombie_death3", "WW2_Zombie_death4", "WW2_Zombie_death5"],
	["WW2_Zombie_burning1", "WW2_Zombie_burning2", "WW2_Zombie_burning3"]
], true];

this setVariable ["WBK_Zombie_CustomSounds",
[
	["WW2_Zombie_walker1", "WW2_Zombie_walker2", "WW2_Zombie_walker3", "WW2_Zombie_walker4", "WW2_Zombie_walker5"],
	["WW2_Zombie_sprinter1", "WW2_Zombie_sprinter2", "WW2_Zombie_sprinter3", "WW2_Zombie_sprinter4", "WW2_Zombie_sprinter5", "WW2_Zombie_sprinter6", "WW2_Zombie_sprinter7", "WW2_Zombie_sprinter8", "WW2_Zombie_sprinter9"],
	["WW2_Zombie_attack1", "WW2_Zombie_attack2", "WW2_Zombie_attack3", "WW2_Zombie_attack4", "WW2_Zombie_attack5"],
	["WW2_Zombie_death1", "WW2_Zombie_death2", "WW2_Zombie_death3", "WW2_Zombie_death4", "WW2_Zombie_death5"],
	["WW2_Zombie_burning1", "WW2_Zombie_burning2", "WW2_Zombie_burning3"]
], true];

for special infected
this setVariable ["WBK_Zombie_CustomSounds",
[
	["WW2_Zombie_walker1", "WW2_Zombie_walker2", "WW2_Zombie_walker3", "WW2_Zombie_walker4", "WW2_Zombie_walker5"], - idle
	["WW2_Zombie_sprinter1", "WW2_Zombie_sprinter2", "WW2_Zombie_sprinter3", "WW2_Zombie_sprinter4", "WW2_Zombie_sprinter5", "WW2_Zombie_sprinter6", "WW2_Zombie_sprinter7", "WW2_Zombie_sprinter8", "WW2_Zombie_sprinter9"], - attack
	["WW2_Zombie_attack1", "WW2_Zombie_attack2", "WW2_Zombie_attack3", "WW2_Zombie_attack4", "WW2_Zombie_attack5"], - special
	["WW2_Zombie_death1", "WW2_Zombie_death2", "WW2_Zombie_death3", "WW2_Zombie_death4", "WW2_Zombie_death5"], -death
	["WW2_Zombie_burning1", "WW2_Zombie_burning2", "WW2_Zombie_burning3"]
], true];

*/

WBK_Smasher_VictimdamageProceed = {
    _zombie = _this select 0;
    _enemy = _this select 1;
    _damage = _this select 2;
    _distance = _this select 3;
    if (!(animationState _enemy == "starWars_landRoll_b") and !(animationState _enemy == "starWars_landRoll") and !(animationState _enemy == "STAR_WARS_FIGHT_doDGE_RIGHT") and !(animationState _enemy == "STAR_WARS_FIGHT_doDGE_LEFT") and (isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and ((_zombie distance _enemy) <= _distance) and (alive _zombie) and (alive _enemy)) exitwith {
        [_enemy, "Smasher_hit", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_enemy, selectRandom ["decapetadet_sound_1", "decapetadet_sound_2"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        if ((_enemy isKindOf "WBK_doS_Squig_Normal") or (_enemy isKindOf "WBK_doS_Huge_orK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_catchedByZombie_Front") or (animationState _enemy == "WBK_catchedByZombie_Back")) then {
            _personWhoIsGrabbed = _enemy;
            if (!(((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitwith {
                [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
                    _rndSnd = selectRandom ["sword_on_wood_shield01", "sword_on_wood_shield02", "sword_on_wood_shield03"];
                    [_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                } else {
                    [_personWhoIsGrabbed, selectRandom ["leg_hit1", "leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                };
                [_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationtoZero", _personWhoIsGrabbed, false];
            };
            [_enemy, 0.45, _zombie] remoteExec ["WBK_Createdamage", _enemy];
        } else {
            if (!(isnil {
                _enemy getVariable "WBK_AI_ISZombie"
            })) then {
                [_enemy, _zombie, 0.9, "WBK_survival_weapon_2"] remoteExec ["WBK_ZombiesProcessdamage", _enemy];
            } else {
                if (_damage >= 0.8) exitwith {
                    [_enemy, 1, _zombie] remoteExec ["WBK_Createdamage", _enemy];
                };
                [_enemy, _zombie] remoteExec ["WBK_CreateMeleeHitanim", _enemy];
                sleep 0.05;
                [_enemy, _damage, _zombie] remoteExec ["WBK_Createdamage", _enemy];
            };
        };
    };
};

WBK_ZombiesProcessdamage = {
    _zombie = _this select 0;
    _hitter = _this select 1;
    if (_zombie isKindOf "WBK_SpecialZombie_Smasher_1") exitwith {
        if ((animationState _zombie == "WBK_Smasher_execution") or !(alive _zombie)) exitwith {};
        if ((_hitter isKindOf "TIOWSpaceMarine_Base") and !(animationState _zombie == "WBK_Smasher_HitHard") and (isnil {
            _zombie getVariable "CanBeStunnedIMS"
        })) then {
            _zombie enableAI "move";
            _zombie enableAI "ANIM";
            [_zombie, "Smasher_eat_voice", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_zombie, "WBK_Smasher_HitHard"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Smasher_HitHard"] remoteExec ["playMoveNow", 0];
            _zombie setVariable ["CanBeStunnedIMS", 1, true];
            _zombie spawn {
                sleep 8;
                _this setVariable ["CanBeStunnedIMS", nil, true];
            };
        };
        _vv = _zombie getVariable "WBK_SynthHP";
        _new_vv = _vv - (WBK_Zombies_SmasherHP / 30);
        if !(isnil "WBK_ZombiesShowDebugdamage") then {
            systemChat str (WBK_Zombies_SmasherHP / 30);
        };
        if (_new_vv <= 0) exitwith {
            _zombie removeAllEventHandlers "Handledamage";
            _zombie setDamage 1;
        };
        _zombie setVariable ["WBK_SynthHP", _new_vv, true];
    };
    if (_hitter isKindOf "TIOWSpaceMarine_Base") exitwith {
        _rndDecap = random 100;
        if (_rndDecap >= 70) exitwith {
            _zombie setVariable ["WBK_AI_Zombie_DecapHead", 1, true];
            _zombie setDamage 1;
            if !(WBK_Zombies_EnableStaticAnimations) exitwith {
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, [_zombie vectorModelToWorld [0, 300, 0], _zombie selectionPosition "head"]] remoteExec ["addforce", _zombie];
                };
                [_zombie, [_zombie vectorModelToWorld [0, -300, 0], _zombie selectionPosition "head"]] remoteExec ["addforce", _zombie];
            };
            [_zombie, selectRandom ["A_playerDeathAnim_17", "A_playerDeathAnim_10", "A_playerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
        };
        _zombie setDamage 1;
        if !(WBK_Zombies_EnableStaticAnimations) exitwith {
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, [_zombie vectorModelToWorld [0, 300, 0], _zombie selectionPosition "head"]] remoteExec ["addforce", _zombie];
            };
            [_zombie, [_zombie vectorModelToWorld [0, -300, 0], _zombie selectionPosition "head"]] remoteExec ["addforce", _zombie];
        };
        [_zombie, selectRandom ["A_playerDeathAnim_19", "A_playerDeathAnim_17", "A_playerDeathAnim_14", "A_playerDeathAnim_15", "A_playerDeathAnim_1", "A_playerDeathAnim_2", "A_playerDeathAnim_3", "A_playerDeathAnim_5", "A_playerDeathAnim_7", "A_playerDeathAnim_8", "A_playerDeathAnim_9", "A_playerDeathAnim_10", "A_playerDeathAnim_11", "A_playerDeathAnim_12", "A_playerDeathAnim_13"]] remoteExec ["switchMove", 0, false];
    };
    _damageVar = _this select 2;
    _weaponThatDealsdamage = _this select 3;
    dostop _zombie;
    if ((lifeState _zombie == "inCAPACITATED") or
    (animationState _zombie == "WBK_Walker_Fall_forward_moveset_1") or
    (animationState _zombie == "WBK_Walker_Fall_forward_moveset_2") or
    (animationState _zombie == "WBK_Walker_Fall_forward_moveset_3") or
    (animationState _zombie == "WBK_Walker_Fall_Back_moveset_1") or
    (animationState _zombie == "WBK_Walker_Fall_Back_moveset_2") or
    (animationState _zombie == "WBK_Walker_Fall_Back_moveset_3") or
    (animationState _zombie == "WBK_Runner_Fall_forward") or
    (animationState _zombie == "WBK_Runner_Fall_Back") or
    !(isnil {
        _zombie getVariable "WBK_ZombieswitchtoCrawler"
    })
    ) exitwith {
        if (_weaponThatDealsdamage == "Fists") exitwith {
            _zombie setDamage ((damage _zombie) + _damageVar);
        };
        _zombie setDamage 1;
    };
    _var = _zombie getVariable "WBK_AI_Zombiemoveset";
    if (_var == "Star_Wars_KaaTirs_idle") then {
        _vv = _zombie getVariable "WBK_SynthHP";
        _new_vv = _vv - (WBK_Zombies_LeaperHP / 4);
        if !(isnil "WBK_ZombiesShowDebugdamage") then {
            systemChat str (WBK_Zombies_LeaperHP / 4);
        };
        if (_new_vv <= 0) exitwith {
            _rndAnim = selectRandom ["WBK_Leaper_Death_1", "WBK_Leaper_Death_2"];
            [_zombie, _rndAnim] remoteExec ["switchMove", 0];
            _zombie setDamage 1;
        };
        _zombie setVariable ["WBK_SynthHP", _new_vv, true];
    } else {
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
            if (_weaponThatDealsdamage == "Fists") exitwith {
                _zombie setDamage ((damage _zombie) + _damageVar);
            };
            _zombie setDamage 1;
        };
        case "WBK_Middle_Idle": {
            if ((animationState _zombie == "WBK_Middle_hit_b_1") or (animationState _zombie == "WBK_Middle_hit_f_2_1") or (_weaponThatDealsdamage in IMS_Melee_Heavy) or (_weaponThatDealsdamage in IMS_Melee_Greatswords)) exitwith {
                [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, "WBK_Middle_Fall_forward"] remoteExec ["switchMove", 0];
                    [_zombie, "WBK_Middle_Fall_forward"] remoteExec ["playMoveNow", 0];
                };
                [_zombie, "WBK_Middle_Fall_Back"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Middle_Fall_Back"] remoteExec ["playMoveNow", 0];
            };
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, "WBK_Middle_hit_b_1"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Middle_hit_b_1"] remoteExec ["playMoveNow", 0];
            };
            if (animationState _zombie == "WBK_Middle_hit_f_1_1") exitwith {
                [_zombie, "WBK_Middle_hit_f_2_1"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Middle_hit_f_2_1"] remoteExec ["playMoveNow", 0];
            };
            [_zombie, "WBK_Middle_hit_f_1_1"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Middle_hit_f_1_1"] remoteExec ["playMoveNow", 0];
        };
        case "WBK_Middle_Idle_1": {
            if ((animationState _zombie == "WBK_Middle_hit_b_2") or (animationState _zombie == "WBK_Middle_hit_f_2_2") or (_weaponThatDealsdamage in IMS_Melee_Heavy) or (_weaponThatDealsdamage in IMS_Melee_Greatswords)) exitwith {
                [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, "WBK_Middle_Fall_forward_1"] remoteExec ["switchMove", 0];
                    [_zombie, "WBK_Middle_Fall_forward_1"] remoteExec ["playMoveNow", 0];
                };
                [_zombie, "WBK_Middle_Fall_Back_1"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Middle_Fall_Back_1"] remoteExec ["playMoveNow", 0];
            };
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, "WBK_Middle_hit_b_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Middle_hit_b_2"] remoteExec ["playMoveNow", 0];
            };
            if (animationState _zombie == "WBK_Middle_hit_f_1_2") exitwith {
                [_zombie, "WBK_Middle_hit_f_2_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Middle_hit_f_2_2"] remoteExec ["playMoveNow", 0];
            };
            [_zombie, "WBK_Middle_hit_f_1_2"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Middle_hit_f_1_2"] remoteExec ["playMoveNow", 0];
        };
        case "WBK_ShooterZombie_unnarmed_idle": {
            if (gestureState _zombie == "WBK_ZombieHitgest_2_weapon") exitwith {
                [_zombie, "WBK_ZombieHitgest_3_weapon"] remoteExec ["playActionNow", _zombie];
            };
            if (gestureState _zombie == "WBK_ZombieHitgest_1_weapon") exitwith {
                [_zombie, "WBK_ZombieHitgest_2_weapon"] remoteExec ["playActionNow", _zombie];
            };
            [_zombie, "WBK_ZombieHitgest_1_weapon"] remoteExec ["playActionNow", _zombie];
        };
        case "Star_Wars_KaaTirs_idle": {
            if (gestureState _zombie == "WBK_ZombieHitgest_2") exitwith {
                [_zombie, "WBK_ZombieHitgest_3"] remoteExec ["playActionNow", _zombie];
            };
            if (gestureState _zombie == "WBK_ZombieHitgest_1") exitwith {
                [_zombie, "WBK_ZombieHitgest_2"] remoteExec ["playActionNow", _zombie];
            };
            [_zombie, "WBK_ZombieHitgest_1"] remoteExec ["playActionNow", _zombie];
        };
        case "WBK_Runner_Angry_Idle": {
            if ((animationState _zombie == "WBK_Runner_hit_b") or (animationState _zombie == "WBK_Runner_hit_f_2") or (_weaponThatDealsdamage in IMS_Melee_Heavy) or (_weaponThatDealsdamage in IMS_Melee_Greatswords)) exitwith {
                [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, "WBK_Runner_Fall_forward"] remoteExec ["switchMove", 0];
                    [_zombie, "WBK_Runner_Fall_forward"] remoteExec ["playMoveNow", 0];
                };
                [_zombie, "WBK_Runner_Fall_Back"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Runner_Fall_Back"] remoteExec ["playMoveNow", 0];
            };
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, "WBK_Runner_hit_b"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Runner_hit_b"] remoteExec ["playMoveNow", 0];
            };
            if (animationState _zombie == "WBK_Runner_hit_f_1") exitwith {
                [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0];
            };
            [_zombie, "WBK_Runner_hit_f_1"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Runner_hit_f_1"] remoteExec ["playMoveNow", 0];
        };
        case "WBK_Walker_Idle_1": {
            if ((animationState _zombie == "WBK_Walker_Hit_B") or (animationState _zombie == "WBK_Walker_Hit_F_2") or (_weaponThatDealsdamage in IMS_Melee_Heavy) or (_weaponThatDealsdamage in IMS_Melee_Greatswords)) exitwith {
                [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, "WBK_Walker_Fall_forward_moveset_1"] remoteExec ["switchMove", 0];
                    [_zombie, "WBK_Walker_Fall_forward_moveset_1"] remoteExec ["playMoveNow", 0];
                };
                [_zombie, "WBK_Walker_Fall_Back_moveset_1"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Fall_Back_moveset_1"] remoteExec ["playMoveNow", 0];
            };
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, "WBK_Walker_Hit_B"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Hit_B"] remoteExec ["playMoveNow", 0];
            };
            if (animationState _zombie == "WBK_Walker_Hit_F_1") exitwith {
                [_zombie, "WBK_Walker_Hit_F_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Hit_F_2"] remoteExec ["playMoveNow", 0];
            };
            [_zombie, "WBK_Walker_Hit_F_1"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Walker_Hit_F_1"] remoteExec ["playMoveNow", 0];
        };
        case "WBK_Walker_Idle_2": {
            if ((animationState _zombie == "WBK_Walker_Hit_B_1") or (animationState _zombie == "WBK_Walker_Hit_F_2_2") or (_weaponThatDealsdamage in IMS_Melee_Heavy) or (_weaponThatDealsdamage in IMS_Melee_Greatswords)) exitwith {
                [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, "WBK_Walker_Fall_forward_moveset_2"] remoteExec ["switchMove", 0];
                    [_zombie, "WBK_Walker_Fall_forward_moveset_2"] remoteExec ["playMoveNow", 0];
                };
                [_zombie, "WBK_Walker_Fall_Back_moveset_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Fall_Back_moveset_2"] remoteExec ["playMoveNow", 0];
            };
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, "WBK_Walker_Hit_B_1"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Hit_B_1"] remoteExec ["playMoveNow", 0];
            };
            if (animationState _zombie == "WBK_Walker_Hit_F_1_2") exitwith {
                [_zombie, "WBK_Walker_Hit_F_2_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Hit_F_2_2"] remoteExec ["playMoveNow", 0];
            };
            [_zombie, "WBK_Walker_Hit_F_1_2"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Walker_Hit_F_1_2"] remoteExec ["playMoveNow", 0];
        };
        case "WBK_Walker_Idle_3": {
            if ((animationState _zombie == "WBK_Walker_Hit_B_2") or (animationState _zombie == "WBK_Walker_Hit_F_2_3") or (_weaponThatDealsdamage in IMS_Melee_Heavy) or (_weaponThatDealsdamage in IMS_Melee_Greatswords)) exitwith {
                [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                    [_zombie, "WBK_Walker_Fall_forward_moveset_3"] remoteExec ["switchMove", 0];
                    [_zombie, "WBK_Walker_Fall_forward_moveset_3"] remoteExec ["playMoveNow", 0];
                };
                [_zombie, "WBK_Walker_Fall_Back_moveset_3"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Fall_Back_moveset_3"] remoteExec ["playMoveNow", 0];
            };
            if (((_zombie worldToModel (_hitter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
                [_zombie, "WBK_Walker_Hit_B_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Hit_B_2"] remoteExec ["playMoveNow", 0];
            };
            if (animationState _zombie == "WBK_Walker_Hit_F_1_3") exitwith {
                [_zombie, "WBK_Walker_Hit_F_2_3"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Walker_Hit_F_2_3"] remoteExec ["playMoveNow", 0];
            };
            [_zombie, "WBK_Walker_Hit_F_1_3"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Walker_Hit_F_1_3"] remoteExec ["playMoveNow", 0];
        };
    };
};

WBK_ZombietryingtoGrab = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_2") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_3") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_3")) exitwith {};
    _enemy = _this select 1;
    if (!(isplayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
        [_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
    };
    if (!(isnil {
        _zombie getVariable "WBK_Zombie_CustomSounds"
    })) then {
        _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
        [_zombie, selectRandom _snds, 50] call CBA_fnc_Globalsay3D;
    } else {
        [_zombie, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6"], 50] call CBA_fnc_Globalsay3D;
    };
    _rndcatch = selectRandom ["WBK_Walker_tryingtocatch_1", "WBK_Walker_tryingtocatch_2", "WBK_Walker_tryingtocatch_3"];
    [_zombie, _rndcatch] remoteExec ["switchMove", 0];
    [_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, _rndcatch]] call CBA_fnc_addPerFrameHandler;
    sleep 0.7;
    _rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
    [_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    sleep 0.1;
    _zombie allowdamage true;
    if ((isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and !(animationState _enemy == "WBK_catchedByZombie_Front") and !(animationState _enemy == "WBK_catchedByZombie_Back") and ((_zombie distance _enemy) <= 2) and (animationState _zombie == _rndcatch) and (alive _zombie)) exitwith {
        [_enemy, _zombie] remoteExec ["WBK_ZombieGrab", _enemy];
    };
    sleep 0.9;
    _pos = ASLtoAGL getPosASLVisual _enemy;
    _zombie domove _pos;
};

WBK_ZombietryingtoGrab_middle = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Middle_GetUpUnconscious") or (animationState _zombie == "WBK_Middle_GetUpUnconscious_1") or (animationState _zombie == "WBK_Middle_tryingtocatch") or (animationState _zombie == "WBK_Middle_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_3")) exitwith {};
    _enemy = _this select 1;
    
    if (!(isplayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
        [_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
    };
    if (!(isnil {
        _zombie getVariable "WBK_Zombie_CustomSounds"
    })) then {
        _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
        [_zombie, selectRandom _snds, 50] call CBA_fnc_Globalsay3D;
    } else {
        [_zombie, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6"], 50] call CBA_fnc_Globalsay3D;
    };
    _rndcatch = selectRandom ["WBK_Middle_tryingtocatch_1", "WBK_Middle_tryingtocatch"];
    [_zombie, _rndcatch] remoteExec ["switchMove", 0];
    [_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _zombie disableAI "move";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
            _unit enableAI "ANIM";
            _unit enableAI "move";
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, _rndcatch]] call CBA_fnc_addPerFrameHandler;
    sleep 0.6;
    _zombie allowdamage true;
    if ((isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and !(animationState _enemy == "WBK_catchedByZombie_Front") and !(animationState _enemy == "WBK_catchedByZombie_Back") and ((_zombie distance _enemy) <= 2.6) and (animationState _zombie == _rndcatch) and (alive _zombie)) exitwith {
        _rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
        [_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
        _zombie enableAI "move";
        [_enemy, _zombie] remoteExec ["WBK_ZombieGrab", _enemy];
    };
    sleep 0.5;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    _zombie enableAI "move";
    sleep 0.4;
    _pos = ASLtoAGL getPosASLVisual _enemy;
    _zombie domove _pos;
};

WBK_ZombietryingtoGrab_fast = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Middle_GetUpUnconscious") or (animationState _zombie == "WBK_Middle_GetUpUnconscious_1") or (animationState _zombie == "WBK_Middle_tryingtocatch") or (animationState _zombie == "WBK_Middle_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_3")) exitwith {};
    _enemy = _this select 1;
    
    if (!(isplayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
        [_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
    };
    if (!(isnil {
        _zombie getVariable "WBK_Zombie_CustomSounds"
    })) then {
        _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
        [_zombie, selectRandom _snds, 50] call CBA_fnc_Globalsay3D;
    } else {
        [_zombie, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6"], 50] call CBA_fnc_Globalsay3D;
    };
    _rndcatch = "WBK_Runner_tryingtocatch";
    [_zombie, _rndcatch] remoteExec ["switchMove", 0];
    [_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _zombie disableAI "move";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
            _unit enableAI "ANIM";
            _unit enableAI "move";
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, _rndcatch]] call CBA_fnc_addPerFrameHandler;
    sleep 0.4;
    _zombie spawn {
        sleep 0.4;
        _this allowdamage true;
    };
    if ((isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and !(animationState _enemy == "WBK_catchedByZombie_Front") and !(animationState _enemy == "WBK_catchedByZombie_Back") and ((_zombie distance _enemy) <= 2.6) and (animationState _zombie == _rndcatch) and (alive _zombie)) exitwith {
        _rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
        [_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
        _zombie enableAI "move";
        [_enemy, _zombie] remoteExec ["WBK_ZombieGrab", _enemy];
    };
    sleep 0.7;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (animationState _zombie == _rndcatch) then {
        _rndmove = selectRandom ["WBK_Zombie_Evade_B", "WBK_Zombie_Evade_L", "WBK_Zombie_Evade_R"];
        [_zombie, _rndmove] remoteExec ["switchMove", 0];
        [_zombie, _rndmove] remoteExec ["playMoveNow", 0];
    };
    sleep 0.4;
    _zombie enableAI "ANIM";
    _zombie enableAI "move";
    _pos = ASLtoAGL getPosASLVisual _enemy;
    _zombie domove _pos;
};

WBK_ZombieAttack_gesture = {
    _zombie = _this select 0;
    _enemy = _this select 1;
    if (!(isplayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
        [_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
    };
    if (!(isnil {
        _zombie getVariable "WBK_Zombie_CustomSounds"
    })) then {
        _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
        [_zombie, selectRandom _snds, 50] call CBA_fnc_Globalsay3D;
    } else {
        [_zombie, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6"], 50] call CBA_fnc_Globalsay3D;
    };
    _rndcatch = selectRandom ["WBK_Zombie_attack_Left", "WBK_Zombie_attack_Right"];
    [_zombie, _rndcatch] remoteExec ["playActionNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(gestureState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, _rndcatch]] call CBA_fnc_addPerFrameHandler;
    sleep 0.3;
    _rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
    [_zombie, _rndEquip, 55, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 0.2;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    sleep 0.1;
    _zombie allowdamage true;
    if ((isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and ((_zombie distance _enemy) <= 2.4) and (gestureState _zombie == _rndcatch) and (alive _zombie) and (alive _enemy)) exitwith {
        [_enemy, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        if ((_enemy isKindOf "WBK_doS_Squig_Normal") or (_enemy isKindOf "WBK_doS_Huge_orK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_catchedByZombie_Front") or (animationState _enemy == "WBK_catchedByZombie_Back")) then {
            _personWhoIsGrabbed = _enemy;
            if (!(((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitwith {
                [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
                    _rndSnd = selectRandom ["sword_on_wood_shield01", "sword_on_wood_shield02", "sword_on_wood_shield03"];
                    [_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                } else {
                    [_personWhoIsGrabbed, selectRandom ["leg_hit1", "leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                };
                if !(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") then {
                    [_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationtoZero", _personWhoIsGrabbed, false];
                };
                [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0];
                sleep 0.7;
                [_zombie, true] remoteExec ["setUnconscious", _zombie];
                sleep 5;
                [_zombie, false] remoteExec ["setUnconscious", _zombie];
            };
            [_enemy, 0.01, _zombie] remoteExec ["WBK_Createdamage", _enemy];
        } else {
            if (!(isnil {
                _enemy getVariable "WBK_AI_ISZombie"
            })) then {
                [_enemy, _zombie, 0.2, "Fists"] remoteExec ["WBK_ZombiesProcessdamage", _enemy];
            } else {
                [_enemy, 0.1, _zombie] remoteExec ["WBK_Createdamage", _enemy];
                [_enemy, _zombie] remoteExec ["WBK_CreateMeleeHitanim", _enemy];
            };
        };
    };
    sleep 0.9;
    _pos = ASLtoAGL getPosASLVisual _enemy;
    _zombie domove _pos;
};

WBK_ZombieAttack = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_2") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_3") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_3")) exitwith {};
    _enemy = _this select 1;
    if (!(isplayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
        [_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
    };
    if (!(isnil {
        _zombie getVariable "WBK_Zombie_CustomSounds"
    })) then {
        _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
        [_zombie, selectRandom _snds, 50] call CBA_fnc_Globalsay3D;
    } else {
        [_zombie, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6"], 50] call CBA_fnc_Globalsay3D;
    };
    _rndcatch = selectRandom ["WBK_Walker_Idle_1_attack", "WBK_Walker_Idle_2_attack"];
    [_zombie, _rndcatch] remoteExec ["switchMove", 0];
    [_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, _rndcatch]] call CBA_fnc_addPerFrameHandler;
    sleep 0.5;
    _rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
    [_zombie, _rndEquip, 55, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    sleep 0.1;
    _zombie allowdamage true;
    if ((isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and ((_zombie distance _enemy) <= 2.9) and (animationState _zombie == _rndcatch) and (alive _zombie) and (alive _enemy)) exitwith {
        [_enemy, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        if ((_enemy isKindOf "WBK_doS_Squig_Normal") or (_enemy isKindOf "WBK_doS_Huge_orK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_catchedByZombie_Front") or (animationState _enemy == "WBK_catchedByZombie_Back")) then {
            _personWhoIsGrabbed = _enemy;
            if (!(((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitwith {
                [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
                    _rndSnd = selectRandom ["sword_on_wood_shield01", "sword_on_wood_shield02", "sword_on_wood_shield03"];
                    [_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                } else {
                    [_personWhoIsGrabbed, selectRandom ["leg_hit1", "leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                };
                if !(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") then {
                    [_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationtoZero", _personWhoIsGrabbed, false];
                };
                [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0];
                [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0];
                sleep 0.7;
                [_zombie, true] remoteExec ["setUnconscious", _zombie];
                sleep 5;
                [_zombie, false] remoteExec ["setUnconscious", _zombie];
            };
            [_enemy, 0.01, _zombie] remoteExec ["WBK_Createdamage", _enemy];
        } else {
            if (!(isnil {
                _enemy getVariable "WBK_AI_ISZombie"
            })) then {
                [_enemy, _zombie, 0.2, "Fists"] remoteExec ["WBK_ZombiesProcessdamage", _enemy];
            } else {
                [_enemy, 0.1, _zombie] remoteExec ["WBK_Createdamage", _enemy];
                [_enemy, _zombie] remoteExec ["WBK_CreateMeleeHitanim", _enemy];
            };
        };
    };
    sleep 0.9;
    _pos = ASLtoAGL getPosASLVisual _enemy;
    _zombie domove _pos;
};

WBK_ZombieAttack_Crawler = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_3") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_2") or (animationState _zombie == "WBK_Walker_GetUpUnconscious_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_3") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_success_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_1") or (animationState _zombie == "WBK_Walker_tryingtocatch_2") or (animationState _zombie == "WBK_Walker_tryingtocatch_3")) exitwith {};
    _enemy = _this select 1;
    if (!(isnil {
        _zombie getVariable "WBK_Zombie_CustomSounds"
    })) then {
        _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
        [_zombie, selectRandom _snds, 50] call CBA_fnc_Globalsay3D;
    } else {
        [_zombie, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6"], 50] call CBA_fnc_Globalsay3D;
    };
    [_zombie, "WBK_Crawler_Attack"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Crawler_Attack"] remoteExec ["playMoveNow", 0];
    _rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
    [_zombie, _rndEquip, 55, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Crawler_Attack"]] call CBA_fnc_addPerFrameHandler;
    sleep 0.5;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    sleep 0.1;
    _zombie allowdamage true;
    if ((isnil {
        _enemy getVariable "IMS_IsUnitinvicibleScripted"
    }) and ((_zombie distance _enemy) <= 2.2) and (animationState _zombie == "WBK_Crawler_Attack") and (alive _zombie) and (alive _enemy)) exitwith {
        [_enemy, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        if ((_enemy isKindOf "WBK_doS_Squig_Normal") or (_enemy isKindOf "WBK_doS_Huge_orK") or (_enemy isKindOf "TIOWSpaceMarine_Base") or (animationState _enemy == "WBK_catchedByZombie_Front") or (animationState _enemy == "WBK_catchedByZombie_Back")) then {
            [_enemy, 0.01, _zombie] remoteExec ["WBK_Createdamage", _enemy];
        } else {
            if (!(isnil {
                _enemy getVariable "WBK_AI_ISZombie"
            })) then {
                [_enemy, _zombie, 0.2, "Fists"] remoteExec ["WBK_ZombiesProcessdamage", _enemy];
            } else {
                [_enemy, 0.1, _zombie] remoteExec ["WBK_Createdamage", _enemy];
                [_enemy, _zombie] remoteExec ["WBK_CreateMeleeHitanim", _enemy];
            };
        };
    };
    sleep 0.9;
    _pos = ASLtoAGL getPosASLVisual _enemy;
    _zombie domove _pos;
};

if ("ace_medical_engine" in activatedAddons) then {
    WBK_ZombieGrab = {
        _personWhoIsGrabbed = _this select 0;
        _zombie = _this select 1;
        if (!(((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) and ((_personWhoIsGrabbed isKindOf "WBK_doS_Squig_Normal") or (_personWhoIsGrabbed isKindOf "WBK_doS_Huge_orK") or (_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") or (gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3"))) exitwith {
            [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
                _rndSnd = selectRandom ["sword_on_wood_shield01", "sword_on_wood_shield02", "sword_on_wood_shield03"];
                [_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            } else {
                [_personWhoIsGrabbed, selectRandom ["leg_hit1", "leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            };
            if (!(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") and !(_personWhoIsGrabbed isKindOf "WBK_doS_Huge_orK") and !(_personWhoIsGrabbed isKindOf "WBK_doS_Squig_Normal")) then {
                [_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationtoZero", _personWhoIsGrabbed, false];
            };
            [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0];
            sleep 0.7;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            sleep 5;
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        [_zombie, false] remoteExec ["setUnconscious", _zombie];
        if (!(isnil {
            _zombie getVariable "WBK_Zombie_CustomSounds"
        })) then {
            _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
            [_zombie, selectRandom _snds, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        } else {
            [_zombie, selectRandom ["plagued_rage_attack_1", "plagued_rage_attack_1", "plagued_rage_attack_3"], 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        };
        _rndcatch = selectRandom ["WBK_Walker_tryingtocatch_success_1", "WBK_Walker_tryingtocatch_success_2", "WBK_Walker_tryingtocatch_success_3"];
        [_zombie, _rndcatch] remoteExec ["switchMove", 0];
        [_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
        _personWhoIsGrabbed setVariable ["actualSwordBlock", 0, true];
        _personWhoIsGrabbed setVariable ["canMakeAttack", 1, true];
        _personWhoIsGrabbed setVariable ["AI_CanTurn", 1, true];
        _zombie setVariable ["canMakeAttack", 1, true];
        if (((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) then {
            _zombie attachto [_personWhoIsGrabbed, [-0.3, -0.01, 0]];
            [_zombie, 180] remoteExec ["setDir", 0];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Back"] remoteExec ["switchMove", 0];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Back"] remoteExec ["playMoveNow", 0];
        } else {
            _zombie attachto [_personWhoIsGrabbed, [0, 0, 0]];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Front"] remoteExec ["switchMove", 0];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Front"] remoteExec ["playMoveNow", 0];
        };
        [_personWhoIsGrabbed, "Disable_Gesture"] remoteExec ["playActionNow", 0];
        sleep 0.2;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        [_zombie, "plagued_grab", 65, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_personWhoIsGrabbed, 0.2, "head", "stab"] remoteExec ["ace_medical_fnc_adddamagetoUnit", _personWhoIsGrabbed];
        if (!(isnil "WBK_NecroplagueDetected")) then {
            [_personWhoIsGrabbed, side group _zombie] remoteExec ["dev_fnc_infect", _personWhoIsGrabbed];
        };
        [_personWhoIsGrabbed, selectRandom ["start_bayonetCharge_2", "start_bayonetCharge_1"], 10, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        sleep 0.2;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        [_personWhoIsGrabbed, 0.16, "head", "stab"] remoteExec ["ace_medical_fnc_adddamagetoUnit", _personWhoIsGrabbed];
        [_personWhoIsGrabbed, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_personWhoIsGrabbed, selectRandom ["New_Death_5", "New_Death_9"], 40, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        sleep 0.5;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        sleep 0.2;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        [_personWhoIsGrabbed, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_zombie, selectRandom ["plagued_attack_7", "plagued_attack_8"], 50] call CBA_fnc_Globalsay3D;
        sleep 1;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        if (animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") then {
            [_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1", "melee_swing_equipment_2", "melee_swing_equipment_3", "melee_swing_equipment_4"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        } else {
            [_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1", "melee_swing_equipment_2", "melee_swing_equipment_3", "melee_swing_equipment_4"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_personWhoIsGrabbed, "leg_punch", 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        };
        sleep 0.8;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0, true];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        if (_zombie getVariable "WBK_AI_Zombiemoveset" == "WBK_Runner_Angry_Idle") exitwith {
            _zombie disableAI "ANIM";
            _zombie disableAI "move";
            if (animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") then {
                _zombie attachto [_personWhoIsGrabbed, [0, -1, 0]];
                [_zombie, 0] remoteExec ["setDir", 0];
            } else {
                _zombie attachto [_personWhoIsGrabbed, [0, 1, 0]];
                [_zombie, 180] remoteExec ["setDir", 0];
            };
            [_zombie, "WBK_Zombie_Evade_B"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Zombie_Evade_B"] remoteExec ["playMoveNow", 0];
            sleep 0.1;
            detach _zombie;
            _personWhoIsGrabbed setVariable ["actualSwordBlock", 0, true];
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0, true];
            if (alive _personWhoIsGrabbed) then {
                if (currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons) then {
                    [_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
                } else {
                    [_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0];
                };
            };
            sleep 1;
            _zombie enableAI "ANIM";
            _zombie enableAI "move";
        };
        _personWhoIsGrabbed setVariable ["actualSwordBlock", 0, true];
        _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
        _personWhoIsGrabbed setVariable ["AI_CanTurn", 0, true];
        if (alive _personWhoIsGrabbed) then {
            if (currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons) then {
                [_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
            } else {
                [_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0];
            };
        };
        detach _zombie;
        [_zombie, [_zombie vectorModelToWorld [0, 100, 0], _zombie selectionPosition "head"]] remoteExec ["addforce", _zombie];
        [_zombie, true] remoteExec ["setUnconscious", _zombie];
        sleep 0.2;
        [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        sleep 6;
        if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
        [_zombie, false] remoteExec ["setUnconscious", _zombie];
    };
} else {
    WBK_ZombieGrab = {
        _personWhoIsGrabbed = _this select 0;
        _zombie = _this select 1;
        if ((gettext (configFile >> 'Cfgvehicles' >> typeOf _personWhoIsGrabbed >> 'moves') != 'CfgmovesMaleSdr') or (_personWhoIsGrabbed isKindOf "WBK_doS_Squig_Normal") or (_personWhoIsGrabbed isKindOf "WBK_doS_Huge_orK") or (_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") or (!(((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) and ((gestureState _personWhoIsGrabbed == "STAR_WARS_twoHandBlock") or (gestureState _personWhoIsGrabbed == "shield_block") or (gestureState _personWhoIsGrabbed == "twoHanded_block") or (gestureState _personWhoIsGrabbed == "starWars_lightsaber_block_loop") or (gestureState _personWhoIsGrabbed == "STAR_WARS_FIGHT_Alebarda_block_gesture") or (_personWhoIsGrabbed getVariable "actualSwordBlock" == 1) or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_heavy") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_1") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_2") or (animationState _personWhoIsGrabbed == "starWars_lightsaber_block_3")))) exitwith {
            [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            if (hmd _personWhoIsGrabbed in IMS_Sheilds) then {
                _rndSnd = selectRandom ["sword_on_wood_shield01", "sword_on_wood_shield02", "sword_on_wood_shield03"];
                [_personWhoIsGrabbed, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            } else {
                [_personWhoIsGrabbed, selectRandom ["leg_hit1", "leg_hit2"], 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            };
            if (!(_personWhoIsGrabbed isKindOf "TIOWSpaceMarine_Base") and !(_personWhoIsGrabbed isKindOf "WBK_doS_Huge_orK") and !(_personWhoIsGrabbed isKindOf "WBK_doS_Squig_Normal")) then {
                [_personWhoIsGrabbed, 228, _zombie] remoteExec ["concentrationtoZero", _personWhoIsGrabbed, false];
            };
            [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Runner_hit_f_2"] remoteExec ["playMoveNow", 0];
            sleep 0.7;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            sleep 5;
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        [_zombie, false] remoteExec ["setUnconscious", _zombie];
        if (!(isnil {
            _zombie getVariable "WBK_Zombie_CustomSounds"
        })) then {
            _snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 2;
            [_zombie, selectRandom _snds, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        } else {
            [_zombie, selectRandom ["plagued_rage_attack_1", "plagued_rage_attack_1", "plagued_rage_attack_3"], 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        };
        _rndcatch = selectRandom ["WBK_Walker_tryingtocatch_success_1", "WBK_Walker_tryingtocatch_success_2", "WBK_Walker_tryingtocatch_success_3"];
        [_zombie, _rndcatch] remoteExec ["switchMove", 0];
        [_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
        _personWhoIsGrabbed setVariable ["actualSwordBlock", 0, true];
        _personWhoIsGrabbed setVariable ["canMakeAttack", 1, true];
        _personWhoIsGrabbed setVariable ["AI_CanTurn", 1, true];
        _zombie setVariable ["canMakeAttack", 1, true];
        if (((_personWhoIsGrabbed worldToModel (_zombie modeltoWorld [0, 0, 0])) select 1) < 0) then {
            _zombie attachto [_personWhoIsGrabbed, [-0.3, -0.01, 0]];
            [_zombie, 180] remoteExec ["setDir", 0];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Back"] remoteExec ["switchMove", 0];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Back"] remoteExec ["playMoveNow", 0];
        } else {
            _zombie attachto [_personWhoIsGrabbed, [0, 0, 0]];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Front"] remoteExec ["switchMove", 0];
            [_personWhoIsGrabbed, "WBK_catchedByZombie_Front"] remoteExec ["playMoveNow", 0];
        };
        [_personWhoIsGrabbed, "Disable_Gesture"] remoteExec ["playActionNow", 0];
        sleep 0.2;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        [_zombie, "plagued_grab", 65, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        _personWhoIsGrabbed setDamage ((damage _personWhoIsGrabbed) + 0.1);
        if (!(isnil "WBK_NecroplagueDetected")) then {
            [_personWhoIsGrabbed, side group _zombie] remoteExec ["dev_fnc_infect", _personWhoIsGrabbed];
        };
        [_personWhoIsGrabbed, selectRandom ["start_bayonetCharge_2", "start_bayonetCharge_1"], 10, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        sleep 0.2;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        _personWhoIsGrabbed setDamage ((damage _personWhoIsGrabbed) + 0.1);
        [_personWhoIsGrabbed, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_personWhoIsGrabbed, selectRandom ["New_Death_5", "New_Death_9"], 40, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        sleep 0.5;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        sleep 0.2;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        _personWhoIsGrabbed setDamage ((damage _personWhoIsGrabbed) + 0.1);
        [_personWhoIsGrabbed, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_zombie, selectRandom ["plagued_attack_7", "plagued_attack_8"], 50] call CBA_fnc_Globalsay3D;
        sleep 1;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        if (animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") then {
            [_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1", "melee_swing_equipment_2", "melee_swing_equipment_3", "melee_swing_equipment_4"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_personWhoIsGrabbed, selectRandom ["PF_Hit_1", "PF_Hit_2"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        } else {
            [_personWhoIsGrabbed, selectRandom ["melee_swing_equipment_1", "melee_swing_equipment_2", "melee_swing_equipment_3", "melee_swing_equipment_4"], 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_personWhoIsGrabbed, "leg_punch", 60, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        };
        sleep 0.8;
        if (!(alive _personWhoIsGrabbed) or !(animationState _zombie == _rndcatch) or (!(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") and !(animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Front"))) exitwith {
            detach _zombie;
            [_zombie, true] remoteExec ["setUnconscious", _zombie];
            _zombie setVariable ["AI_CanTurn", 0, true];
            _zombie setVariable ["canMakeAttack", 1, true];
            _personWhoIsGrabbed spawn {
                _personWhoIsGrabbed = _this;
                if (!(alive _personWhoIsGrabbed)) exitwith {};
                if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
                };
                if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                    [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
                };
                [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
                sleep 0.2;
                [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
                sleep 1;
                [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            };
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0, true];
            _personWhoIsGrabbed enableAI "ALL";
            sleep 6;
            if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
            [_zombie, false] remoteExec ["setUnconscious", _zombie];
        };
        if (_zombie getVariable "WBK_AI_Zombiemoveset" == "WBK_Runner_Angry_Idle") exitwith {
            _zombie disableAI "ANIM";
            _zombie disableAI "move";
            if (animationState _personWhoIsGrabbed == "WBK_catchedByZombie_Back") then {
                _zombie attachto [_personWhoIsGrabbed, [0, -1, 0]];
                [_zombie, 0] remoteExec ["setDir", 0];
            } else {
                _zombie attachto [_personWhoIsGrabbed, [0, 1, 0]];
                [_zombie, 180] remoteExec ["setDir", 0];
            };
            [_zombie, "WBK_Zombie_Evade_B"] remoteExec ["switchMove", 0];
            [_zombie, "WBK_Zombie_Evade_B"] remoteExec ["playMoveNow", 0];
            sleep 0.1;
            detach _zombie;
            _personWhoIsGrabbed setVariable ["actualSwordBlock", 0, true];
            _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
            _personWhoIsGrabbed setVariable ["AI_CanTurn", 0, true];
            if (alive _personWhoIsGrabbed) then {
                if (currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons) then {
                    [_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
                } else {
                    [_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0];
                };
            };
            sleep 1;
            _zombie enableAI "ANIM";
            _zombie enableAI "move";
        };
        _personWhoIsGrabbed setVariable ["actualSwordBlock", 0, true];
        _personWhoIsGrabbed setVariable ["canMakeAttack", 0, true];
        _personWhoIsGrabbed setVariable ["AI_CanTurn", 0, true];
        if (alive _personWhoIsGrabbed) then {
            if (currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons) then {
                [_personWhoIsGrabbed, "melee_armed_idle"] remoteExec ["switchMove", 0, false];
            } else {
                [_personWhoIsGrabbed, "AmovPercMstpSnonWnonDnon"] remoteExec ["playMoveNow", 0];
            };
        };
        detach _zombie;
        [_zombie, [_zombie vectorModelToWorld [0, 100, 0], _zombie selectionPosition "head"]] remoteExec ["addforce", _zombie];
        [_zombie, true] remoteExec ["setUnconscious", _zombie];
        sleep 0.2;
        [_zombie, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        sleep 6;
        if (!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie)) exitwith {};
        [_zombie, false] remoteExec ["setUnconscious", _zombie];
    };
};

WBK_Smasher_MakeRoar = {
    _zombie = _this select 0;
    _enemy = _this select 1;
    _zombie setVariable ["WBK_CanMakeRoar", 1];
    _zombie enableAI "move";
    _zombie spawn {
        uiSleep 60;
        _this setVariable ["WBK_CanMakeRoar", nil];
    };
    _zombie setFormDir (_zombie getDir _enemy);
    [_zombie, "WBK_Smasher_Roar"] remoteExec ["switchMove", 0];
    _zombie spawn WBK_Smasher_CreateCamShake;
    _zombie playMove "WBK_Smasher_Roar";
    [_zombie, "Smasher_Roar", 345, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    dostop _zombie;
    uiSleep 0.1;
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {};
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2)],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2)],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Roar"]] call CBA_fnc_addPerFrameHandler;
    uiSleep 4;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
};

WBK_Smasher_vehicleAttack = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_vehicle") or (animationState _zombie == "WBK_Smasher_execution")) exitwith {};
    _enemy = _this select 1;
    [_zombie, "WBK_Smasher_Attack_vehicle"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Smasher_Attack_vehicle"] remoteExec ["playMoveNow", 0];
    dostop _zombie;
    uiSleep 0.1;
    if (!(animationState _zombie == "WBK_Smasher_Attack_vehicle") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {};
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2)],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2)],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_vehicle"]] call CBA_fnc_addPerFrameHandler;
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 1;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (!(animationState _zombie == "WBK_Smasher_Attack_vehicle") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _zombie spawn {
        sleep 1;
        if ((isNull _this) or !(alive _this)) exitwith {};
        [_this, selectRandom ["Smasher_scream_1", "Smasher_scream_2"], 320, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    };
    _zombie spawn WBK_Smasher_CreateCamShake;
    [_zombie, selectRandom ["Smasher_attack_4", "Smasher_attack_6", "Smasher_attack_7"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie enableAI "move";
    if (((_zombie distance _enemy) > 7) or !(animationState _zombie == "WBK_Smasher_Attack_vehicle") or !(alive _zombie)) exitwith {};
    [_zombie, "Smasher_hit", 245, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _dir = getDirVisual _zombie;
    _vel = velocity _enemy;
    [_enemy, [(_vel select 0)+(sin _dir*15), (_vel select 1)+(cos _dir*15), 5]] remoteExec ["setvelocity", _enemy];
    if ((_enemy isKindOf "CAR") or (_enemy isKindOf "Helicopter") or (_enemy isKindOf "StaticWeapon")) then {
        _enemy setDamage 1;
    } else {
        [_enemy, "Smasher_hit_vehicle", 245, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        _enemy setDamage ((damage _enemy) + 0.5);
    };
};

WBK_Smasher_HumanoidAttack_1 = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_vehicle") or (animationState _zombie == "WBK_Smasher_execution")) exitwith {};
    _enemy = _this select 1;
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_zombie, "WBK_Smasher_Attack_1"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Smasher_Attack_1"] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_1"]] call CBA_fnc_addPerFrameHandler;
    sleep 0.8;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _rndEquip = selectRandom ["Smasher_swoosh_1", "Smasher_swoosh_2"];
    [_zombie, _rndEquip, 80, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie spawn WBK_Smasher_CreateCamShake;
    sleep 0.3;
    if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x, 0.5, 3.75] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 3.75];
    sleep 0.6;
    if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_1"]] call CBA_fnc_addPerFrameHandler;
    sleep 0.6;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_zombie, selectRandom ["Smasher_swoosh_1", "Smasher_swoosh_2"], 80, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie spawn WBK_Smasher_CreateCamShake;
    sleep 0.1;
    if (!(animationState _zombie == "WBK_Smasher_Attack_1") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x, 1, 3.9] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 3.9];
    _zombie enableAI "ANIM";
};

WBK_Smasher_HumanoidAttack_2 = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_vehicle") or (animationState _zombie == "WBK_Smasher_execution")) exitwith {};
    _enemy = _this select 1;
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_zombie, "WBK_Smasher_Attack_2"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Smasher_Attack_2"] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_2"]] call CBA_fnc_addPerFrameHandler;
    sleep 1;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (!(animationState _zombie == "WBK_Smasher_Attack_2") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _rndEquip = selectRandom ["Smasher_swoosh_1", "Smasher_swoosh_2"];
    [_zombie, _rndEquip, 80, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 0.6;
    if (!(animationState _zombie == "WBK_Smasher_Attack_2") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    [_zombie, "Smasher_hit", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie spawn WBK_Smasher_CreateCamShake;
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 3.9];
    _zombie enableAI "ANIM";
    _electra = "#particlesource" createvehicle position _zombie;
    _electra setParticleClass "HDustVtoL1";
    _electra attachto [_zombie, [0, 0, 0]];
    sleep 1;
    deletevehicle _electra;
};

WBK_Smasher_HumanoidAttack_3 = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_vehicle") or (animationState _zombie == "WBK_Smasher_execution")) exitwith {};
    _enemy = _this select 1;
    [_zombie, "WBK_Smasher_Attack_vehicle"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Smasher_Attack_vehicle"] remoteExec ["playMoveNow", 0];
    _zombie enableAI "ANIM";
    dostop _zombie;
    uiSleep 0.1;
    if (!(animationState _zombie == "WBK_Smasher_Attack_vehicle") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {};
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2)],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2)],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_vehicle"]] call CBA_fnc_addPerFrameHandler;
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    
    sleep 1;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (!(animationState _zombie == "WBK_Smasher_Attack_vehicle") or !(alive _zombie)) exitwith {
        _zombie enableAI "ANIM";
    };
    _zombie spawn {
        sleep 1;
        if ((isNull _this) or !(alive _this)) exitwith {};
        [_this, selectRandom ["Smasher_scream_1", "Smasher_scream_2"], 320, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    };
    [_zombie, selectRandom ["Smasher_attack_4", "Smasher_attack_6", "Smasher_attack_7"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie enableAI "move";
    _zombie spawn WBK_Smasher_CreateCamShake;
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x] spawn {
                _zombie = _this select 0;
                _enemy = _this select 1;
                if ((animationState _enemy == "starWars_landRoll_b") or (animationState _enemy == "starWars_landRoll") or (animationState _enemy == "STAR_WARS_FIGHT_doDGE_RIGHT") or (animationState _enemy == "STAR_WARS_FIGHT_doDGE_LEFT") or !(animationState _zombie == "WBK_Smasher_Attack_vehicle") or !(alive _zombie) or !(isnil {
                    _enemy getVariable "IMS_IsUnitinvicibleScripted"
                })) exitwith {};
                [_zombie, "Smasher_hit", 245, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                [_enemy, selectRandom ["decapetadet_sound_1", "decapetadet_sound_2"], 140, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                _enemy setDamage 1;
                uiSleep 0.05;
                [_enemy, [_zombie vectorModelToWorld [0, 3000, 800], _enemy selectionPosition "head"]] remoteExec ["addforce", _enemy];
            };
        };
    } forEach nearestobjects [_zombie, ["MAN"], 4.5];
};

WBK_Smasher_HumanoidAttack_4 = {
    _zombie = _this select 0;
    if ((animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_vehicle") or (animationState _zombie == "WBK_Smasher_execution")) exitwith {};
    _enemy = _this select 1;
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_zombie, "WBK_Smasher_Attack_3"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Smasher_Attack_3"] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_Attack_3"]] call CBA_fnc_addPerFrameHandler;
    sleep 0.5;
    if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitwith {
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
    };
    _zombie spawn WBK_Smasher_CreateCamShake;
    [_zombie, "Smasher_hit", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 3.9];
    _zombie enableAI "ANIM";
    _electra = "#particlesource" createvehicle position _zombie;
    _electra setParticleClass "HDustVtoL1";
    _electra attachto [_zombie, [0, 0, 0]];
    detach _electra;
    _electra spawn {
        sleep 1;
        deletevehicle _this;
    };
    sleep 0.4;
    if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitwith {
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
    };
    [_zombie, selectRandom ["Smasher_swoosh_1", "Smasher_swoosh_2"], 140, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 0.3;
    if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitwith {
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
    };
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.2];
    _zombie spawn WBK_Smasher_CreateCamShake;
    sleep 0.3;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    if (!(animationState _zombie == "WBK_Smasher_Attack_3") or !(alive _zombie)) exitwith {};
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};

WBK_Smasher_executionFnc = {
    _main = _this select 0;
    _main spawn {
        uiSleep 60;
        _this setVariable ["WBK_CanEatSomebody", nil];
    };
    _victim = _this select 1;
    _victim setVariable ["AI_CanTurn", 1, true];
    _victim setVariable ["canMakeAttack", 1, true];
    _main setVariable ["canMakeAttack", 1];
    _main setVariable ["AI_CanTurn", 1];
    _main setVariable ["actualSwordBlock", 0, true];
    [_main, _victim] remoteExecCall ["disableCollisionwith", 0, _main];
    [_victim, _main] remoteExecCall ["disableCollisionwith", 0, _victim];
    [_main, "WBK_Smasher_execution"] remoteExec ["switchMove", 0, false];
    [_main, "WBK_Smasher_execution"] remoteExec ["playMoveNow", 0, false];
    [_victim, "WBK_Smasher_execution"] remoteExec ["switchMove", 0, true];
    [_victim, "WBK_Smasher_execution"] remoteExec ["switchMove", 0, true];
    [_victim, "Disable_Gesture"] remoteExec ["playActionNow", _victim];
    _victim attachto [_main, [0, 3.51, 0]];
    _victim setDamage 0;
    _main setDamage 0;
    [_victim, 180] remoteExec ["setDir", 0];
    [_victim, "dead"] remoteExec ["setMimic", 0];
    sleep 0.1;
    [_main, selectRandom ["Smasher_attack_8", "Smasher_attack_9"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "PF_Hit_2", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "dobi_fall_2", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    if (isnil {
        _victim getVariable "WBK_AI_ISZombie"
    }) then {
        [_victim, selectRandom ["Smasher_human_scream_1", "Smasher_human_scream_2", "Smasher_human_scream_3"], 110, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    };
    sleep 1.9;
    _victim setDamage 1;
    [_victim, 1.25] remoteExec ["setanimspeedCoef", 0];
    [_main, selectRandom ["Smasher_attack_6", "Smasher_attack_7"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "dobi_CriticalHit", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _main spawn WBK_Smasher_CreateCamShake;
    if (isnil {
        _victim getVariable "WBK_AI_ISZombie"
    }) then {
        [_victim, selectRandom ["New_Death_1", "New_Death_2", "New_Death_3", "New_Death_4", "New_Death_5", "New_Death_6", "New_Death_7", "New_Death_8", "New_Death_9"], 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    };
    [_victim, {
        _object = _this;
        if (!(WBK_Zombies_EnableHeadShotsParticles)) exitwith {};
        _breath = "#particlesource" createvehiclelocal (getPosATL _object);
        _breath setParticleParams
        [
            ["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], // shape name
            "", // anim name
            "spaceObject",
            0.5, 12, // timer period & life time
            [0, 0, 0], // pos
            [3 + random -3, 2 + random -2, random 3], // moveVel
            1, 1.275, 0.2, 0, // rotation vel, weight, volume, rubbing
            [1.6, 0], // size transform
            [[0.005, 0, 0, 0.05], [0.006, 0, 0, 0.06], [0.2, 0, 0, 0]],
            [1000], // animationPhase (speed in config)
            1, // randomdirection period
            0.1, // random direction intensity
            "", // ontimer
            "", // before destroy
            "", // object
            0, // angle
            false, // on surface
            0.0 // bounce on surface
        ];
        _breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
        _breath setDropInterval 0.01;
        _breath attachto [_object, [0, 0, 0.2], "head"];
        sleep 0.25;
        deletevehicle _breath;
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
    {
        if (!(_x == _victim) and !(_x == _main) and (alive _main) and (alive _x)) then {
            [_main, _x, 0.2, 5.5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_victim, ["MAN"], 5.5];
    sleep 1.5;
    [_main, "Smasher_eat_voice", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_main, "Smasher_Eat", 100, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "PF_Hit_1", 40, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "decapetadet_sound_1", 50, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _victim unlinkItem hmd _victim;
    removeGoggles _victim;
    removeHeadgear _victim;
    [_victim, {
        // Ensuring headless clients aren't caught by this
		if (!hasinterface) exitwith {};
		[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
    sleep 2.5;
    [_main, "Smasher_execution_end", 90, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 0.2;
    [_victim, "decapetadet_sound_2", 120, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _victim spawn WBK_Smasher_CreateCamShake;
    [_victim, {
        _object = _this;
        if (!(WBK_Zombies_EnableHeadShotsParticles)) exitwith {};
        _blood = "#particlesource" createvehiclelocal (getPosATL _object);
        _blood attachto [_object, [0, 0, 0], "head"];
        _blood setParticleParams [
            ["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 13, 1, 32], // model name
            "", // animation
            "billboard", // type
            0.1, 2, // period and lifecycle
            [0, 0, 0], // position
            
            [3 + random -6, 3 + random -6, 2], // movement vector
            5, 6, 0.4, 0.4, // rotation, weight, volume, rubbing
            [0.05, 1.4], // size transform
            [[0.5, 0, 0, 0.6], [0.8, 0, 0, 0.1], [0.1, 0, 0, 0.03]],
            [0.00001],
            0.4,
            0.4,
            "",
            "",
            "",
            360, // angle
            false, // on surface
            0 // bounce on surface
        ];
        _blood setDropInterval 0.01;
        _breath = "#particlesource" createvehiclelocal (getPosATL _object);
        _breath setParticleParams
        [
            ["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], // shape name
            "", // anim name
            "spaceObject",
            0.5, 12, // timer period & life time
            [0, 0, 0], // pos
            [3 + random -3, 2 + random -2, random 3], // moveVel
            1, 1.275, 0.2, 0, // rotation vel, weight, volume, rubbing
            [1.6, 0], // size transform
            [[0.005, 0, 0, 0.05], [0.006, 0, 0, 0.06], [0.2, 0, 0, 0]],
            [1000], // animationPhase (speed in config)
            1, // randomdirection period
            0.1, // random direction intensity
            "", // ontimer
            "", // before destroy
            "", // object
            0, // angle
            false, // on surface
            0.0 // bounce on surface
        ];
        _breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
        _breath setDropInterval 0.01;
        _breath attachto [_object, [0, 0, 0.2], "head"];
        sleep 0.15;
        deletevehicle _breath;
        sleep 0.9;
        deletevehicle _blood;
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
    {
        if (!(_x == _victim) and !(_x == _main) and (alive _main) and (alive _x)) then {
            [_main, _x, 0.2, 5.5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_victim, ["MAN"], 5.5];
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
    if (!(alive _zombie)) exitwith {};
    _enemy = _this select 1;
    _dist = _this select 2;
    _positions = [
        getPosASLVisual _zombie,
        getPosASLVisual _enemy
    ];
    _centroid = _positions call QS_fnc_geomPolygonCentroid;
    _arrow = "#particlesource" createvehiclelocal [0, 0, 0];
    _arrow setPosASL [_centroid select 0, _centroid select 1, (getPosASLVisual _enemy select 2) + 3];
    _geometryforward = lineIntersectsSurfaces [
        getPosASLVisual _zombie,
        getPosASLVisual _arrow,
        _zombie,
        _arrow,
        true,
        1,
        "GEOM",
        "fire"
    ];
    _geometryforward_1 = lineIntersectsSurfaces [
        getPosASLVisual _arrow,
        getPosASLVisual _enemy,
        _enemy,
        _arrow,
        true,
        1,
        "GEOM",
        "fire"
    ];
    if ((count _geometryforward > 0) or (count _geometryforward_1 > 0)) exitwith {
        deletevehicle _arrow;
    };
    _zombie disableAI "move";
    _zombie setVariable ["CanFly", 1];
    _zombie allowdamage false;
    [_zombie, "WBK_Smasher_inAir_start"] remoteExec ["switchMove", 0, false];
    [_zombie, "WBK_Smasher_inAir_start"] remoteExec ["playMoveNow", 0, false];
    _zombie setFormDir (_zombie getDir _enemy);
    dostop _zombie;
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {};
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2)],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2)],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_inAir_start"]] call CBA_fnc_addPerFrameHandler;
    uiSleep 0.55;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    if (!(alive _zombie)) exitwith {
        deletevehicle _arrow;
    };
    uiSleep 0.1;
    if (!(alive _zombie)) exitwith {
        deletevehicle _arrow;
    };
    _zombie setDir (_zombie getDir _enemy);
    _pos = (getPosATL _enemy) select 2;
    _pos1 = (getPosATL _zombie) select 2;
    _actPos = _pos - _pos1;
    [_zombie, [0, (_zombie distance _enemy) * 0.9, _actPos + 7]] remoteExec ["setvelocityModelSpace", _zombie];
    [_zombie, selectRandom ["Smasher_swoosh_1", "Smasher_swoosh_2"], 160, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie spawn {
        _zombie = _this;
        uiSleep 0.6;
        if (istouchingGround _zombie) exitwith {};
        [_zombie, [0, 13, -10]] remoteExec ["setvelocityModelSpace", _zombie];
    };
    uiSleep 0.3;
    if (!(alive _zombie)) exitwith {
        deletevehicle _arrow;
    };
    deletevehicle _arrow;
    waitUntil {
        if ((isNull _zombie) or !(alive _zombie)) exitwith {
            true
        };
        (istouchingGround _zombie)
    };
    if (!(alive _zombie)) exitwith {};
    _zombie enableAI "move";
    [_zombie, "WBK_Smasher_inAir_end"] remoteExec ["switchMove", 0, false];
    [_zombie, "WBK_Smasher_inAir_end"] remoteExec ["playMoveNow", 0, false];
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    sleep 0.4;
    if (!(alive _zombie) or !(animationState _zombie == "WBK_Smasher_inAir_end")) exitwith {
        deletevehicle _arrow;
    };
    _zombie spawn WBK_Smasher_CreateCamShake;
    _electra = "#particlesource" createvehicle position _zombie;
    _electra setParticleClass "HDustVtoL1";
    _electra attachto [_zombie, [0, 0, 0]];
    detach _electra;
    _electra spawn {
        sleep 1;
        deletevehicle _this;
    };
    [_zombie, "Smasher_execution_end", 140, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_zombie, "Smasher_hit", 160, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            if (vehicle _x isKindOf "MAN") then {
                [_zombie, _x, 1, 5.5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
            } else {
                _x setDamage 1;
            };
        };
    } forEach nearestobjects [_zombie, ["MAN", "CAR", "tanK", "HELI", "StaticWeapon"], 5.5];
    uiSleep (15 + random 5);
    _zombie setVariable ["CanFly", nil];
};

WBK_Smasher_Rockthrowing = {
    _zombie = _this select 0;
    if (!(isnil {
        _zombie getVariable "CanthrowRocks"
    }) or (animationState _zombie == "WBK_Smasher_throw") or (animationState _zombie == "WBK_Smasher_Attack_3") or (animationState _zombie == "WBK_Smasher_Attack_1") or (animationState _zombie == "WBK_Smasher_Attack_2") or (animationState _zombie == "WBK_Smasher_Attack_vehicle") or (animationState _zombie == "WBK_Smasher_execution")) exitwith {};
    _zombie setVariable ["CanthrowRocks", 1];
    _zombie spawn {
        uiSleep 45;
        _this setVariable ["CanthrowRocks", nil];
    };
    _enemy = _this select 1;
    {
        if (!(_x == _zombie) and !(isplayer _x) and (alive _x)) then {
            [_x, 2, _zombie] remoteExec ["IMS_MeleeFunction", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 5.9];
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_zombie, "WBK_Smasher_throw"] remoteExec ["switchMove", 0];
    [_zombie, "WBK_Smasher_throw"] remoteExec ["playMoveNow", 0];
    _zombie allowdamage false;
    dostop _zombie;
    _zombie disableAI "ANIM";
    _throwableItem = "Smasher_RockGrenade" createvehicle [0, 0, 6000];
    _loopPathfinddomove = [{
        _array = _this select 0;
        _unit = _array select 0;
        _nearEnemy = _array select 1;
        _anim = _array select 2;
        if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
            _unit allowdamage true;
        };
        _dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
        _unit setvelocityTransformation [
            getPosASL _unit,
            getPosASL _unit,
            [0, 0, (velocity _unit select 2) - 1],
            [(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
            vectorDir _unit,
            _dir,
            vectorUp _unit,
            vectorUp _unit,
            0.1
        ];
    }, 0.01, [_zombie, _enemy, "WBK_Smasher_throw"]] call CBA_fnc_addPerFrameHandler;
    sleep 0.5;
    if (!(animationState _zombie == "WBK_Smasher_throw") or !(alive _zombie)) exitwith {
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
        deletevehicle _throwableItem;
    };
    [_zombie, "Smasher_hit", 120, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _zombie spawn WBK_Smasher_CreateCamShake;
    {
        if (!(_x == _zombie) and (alive _zombie) and (alive _x)) then {
            [_zombie, _x, 0.5, 5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
        };
    } forEach nearestobjects [_zombie, ["MAN"], 3.9];
    _zombie enableAI "ANIM";
    _electra = "#particlesource" createvehicle position _zombie;
    _electra setParticleClass "HDustVtoL1";
    _electra attachto [_zombie, [0, 0, 0]];
    detach _electra;
    _electra spawn {
        sleep 2;
        deletevehicle _this;
    };
    sleep 0.95;
    if (!(animationState _zombie == "WBK_Smasher_throw") or !(alive _zombie)) exitwith {
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
        deletevehicle _throwableItem;
    };
    _throwableItem attachto [_zombie, [0, -1, 0], "Smash_Hand_R", true];
    [_zombie, "Smasher_hit", 150, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 0.65;
    if (!(animationState _zombie == "WBK_Smasher_throw") or !(alive _zombie)) exitwith {
        [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
        _zombie enableAI "ANIM";
        deletevehicle _throwableItem;
    };
    [_zombie, selectRandom ["Smasher_swoosh_1", "Smasher_swoosh_2"], 340, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 0.1;
    detach _throwableItem;
    _dir = (_zombie getDir _enemy);
    _vel = velocity _zombie;
    _distance = (_zombie distance _enemy) * 0.8;
    _pos = (getPosASL _enemy) select 2;
    _pos1 = (getPosASL _zombie) select 2;
    _actPos = _pos - _pos1;
    if (_actPos < 0) then {
        _throwableItem setvelocity [(_vel select 0)+(sin _dir*_distance), (_vel select 1)+(cos _dir*_distance), _actPos + 6.2];
    } else {
        if (_actPos > 4) then {
            _throwableItem setvelocity [(_vel select 0)+(sin _dir*_distance), (_vel select 1)+(cos _dir*_distance), _actPos + 3];
        } else {
            _distance = (_zombie distance _enemy) * 0.86;
            _throwableItem setvelocity [(_vel select 0)+(sin _dir*_distance), (_vel select 1)+(cos _dir*_distance), _actPos + 4.6];
        };
    };
    sleep 0.1;
    [_throwableItem, _zombie] spawn {
        _grenade = _this select 0;
        _actualHitClass = "#particlesource" createvehicle position _grenade;
        _actualHitClass attachto [_grenade, [0, 0, 0]];
        _zombie = _this select 1;
        while {alive _grenade} do {
            {
                if ((alive _x) and !(_x == _zombie)) then {
                    [_grenade, _x, 0.1, 5] remoteExec ["WBK_Smasher_VictimdamageProceed", _x];
                };
            } forEach nearestobjects [_grenade, ["MAN"], 5];
            uiSleep 0.1;
        };
        {
            if ((alive _x) and !(_x == _zombie)) then {
                [_x, 228, _actualHitClass] remoteExec ["concentrationtoZero", _x, false];
            };
        } forEach nearestobjects [_actualHitClass, ["MAN"], 15];
        [_actualHitClass, "Smash_rockHit", 450] call CBA_fnc_Globalsay3D;
        _actualHitClass spawn WBK_Smasher_CreateCamShake;
        [_actualHitClass, {
            _aslLoc = _this;
            _col = [0, 0, 0];
            _c1 = _col select 0;
            _c2 = _col select 1;
            _c3 = _col select 2;
            
            _rocks1 = "#particlesource" createvehiclelocal getPosASL _aslLoc;
            _rocks1 setPosASL getPosASL _aslLoc;
            _rocks1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.45, .45], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc, 0, false, 0.3];
            _rocks1 setParticleRandom [0, [1, 1, 0], [20, 20, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
            _rocks1 setDropInterval 0.01;
            _rocks1 setParticleCircle [0, [0, 0, 0]];
            
            _rocks2 = "#particlesource" createvehiclelocal getPosASL _aslLoc;
            _rocks2 setPosASL getPosASL _aslLoc;
            _rocks2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.27, .27], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc, 0, false, 0.3];
            _rocks2 setParticleRandom [0, [1, 1, 0], [25, 25, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
            _rocks2 setDropInterval 0.01;
            _rocks2 setParticleCircle [0, [0, 0, 0]];
            
            _rocks3 = "#particlesource" createvehiclelocal getPosASL _aslLoc;
            _rocks3 setPosASL getPosASL _aslLoc;
            _rocks3 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 12.5, [0, 0, 0], [0, 0, 15], 5, 100, 7.9, 1, [.09, .09], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _aslLoc, 0, false, 0.3];
            _rocks3 setParticleRandom [0, [1, 1, 0], [30, 30, 15], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
            _rocks3 setDropInterval 0.01;
            _rocks3 setParticleCircle [0, [0, 0, 0]];
            _rocks = [_rocks1, _rocks2, _rocks3];
            sleep 0.3;
            {
                deletevehicle _x;
            } forEach _rocks;
        }] remoteExec ["spawn", [0, -2] select isDedicated, false];
        uiSleep 15;
        deletevehicle _actualHitClass;
    };
    sleep 0.1;
    [_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
    _zombie enableAI "ANIM";
    if (!(animationState _zombie == "WBK_Smasher_throw") or !(alive _zombie)) exitwith {};
    [_zombie, selectRandom ["Smasher_attack_1", "Smasher_attack_2", "Smasher_attack_3", "Smasher_attack_4", "Smasher_attack_5", "Smasher_attack_6", "Smasher_attack_7", "Smasher_attack_8", "Smasher_attack_9"], 120, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
};

WBK_Smasher_CreateCamShake = {
    _obj = _this;
    [_obj, {
        _unit = missionnamespace getVariable["bis_fnc_moduleremoteControl_unit", player];
        if ((_unit distance _this) <= 20) then {
            enableCamShake true;
            addCamShake [5, 5, 25];
        };
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
};

WBK_CorruptedAttack_Success = {
    _main = _this select 0;
    _victim = _this select 1;
    _victim setVariable ['IMS_IsUnitinvicibleScripted', 1, true];
    _victim setVariable ["AI_CanTurn", 1, true];
    _victim setVariable ["canMakeAttack", 1, true];
    _main setVariable ["canMakeAttack", 1];
    _main setVariable ["AI_CanTurn", 1];
    _main disableAI "radIOPROtoCOL";
    _main setVariable ["actualSwordBlock", 0, true];
    [_main, _victim] remoteExecCall ["disableCollisionwith", 0, _main];
    [_victim, _main] remoteExecCall ["disableCollisionwith", 0, _victim];
    if (((_victim worldToModel (_main modeltoWorld [0, 0, 0])) select 1) > 0) then {
        [_main, "Corrupted_attack_success_front"] remoteExec ["switchMove", 0, false];
        [_main, "Corrupted_attack_success_front"] remoteExec ["playMoveNow", 0, false];
    } else {
        [_main, "Corrupted_attack_success_back"] remoteExec ["switchMove", 0, false];
        [_main, "Corrupted_attack_success_back"] remoteExec ["playMoveNow", 0, false];
    };
    [_victim, "Corrupted_Attack_victim"] remoteExec ["switchMove", 0, true];
    [_victim, "Corrupted_Attack_victim"] remoteExec ["playMoveNow", 0, true];
    [_victim, "WBK_Runner_Angry_Idle"] remoteExec ["playMove", _victim, true];
    [_victim, "Disable_Gesture"] remoteExec ["playActionNow", _victim];
    _main attachto [_victim, [0, 0, 0]];
    _victim setDamage 0;
    _main setDamage 0;
    [_victim, "dead"] remoteExec ["setMimic", 0];
    _main setVariable ["WBK_ZombieAttachedParasite", _victim, true];
    _main addEventHandler ["Killed", {
        _main = _this select 0;
        detach _main;
        _main removeAllEventHandlers "Killed";
        _victim = _main getVariable "WBK_ZombieAttachedParasite";
        _victim removeAllEventHandlers "Killed";
        [_main, "Corrupted_attack_success_dying"] remoteExec ["switchMove", 0, false];
        [_main, "Corrupted_attack_success_dying"] remoteExec ["playMoveNow", 0, false];
        _victim spawn {
            _personWhoIsGrabbed = _this;
            if (!(alive _personWhoIsGrabbed)) exitwith {};
            [_personWhoIsGrabbed, "angry"] remoteExec ["setMimic", 0];
            if ((currentWeapon _personWhoIsGrabbed in IMS_Melee_weapons)) exitwith {
                [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["switchMove", 0, false];
                [_personWhoIsGrabbed, "Melee_Evade_B"] remoteExec ["playMoveNow", 0, false];
            };
            if ((currentWeapon _personWhoIsGrabbed == primaryWeapon _personWhoIsGrabbed) and !(currentWeapon _personWhoIsGrabbed == "")) exitwith {
                [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["switchMove", 0, false];
                [_personWhoIsGrabbed, "starWars_lightsaber_hit_rifle_2"] remoteExec ["playMoveNow", 0, false];
            };
            [_personWhoIsGrabbed, "A_playerDeathAnim_9"] remoteExec ["switchMove", 0, false];
            sleep 0.2;
            [_personWhoIsGrabbed, true] remoteExec ["setUnconscious", _personWhoIsGrabbed];
            sleep 1;
            [_personWhoIsGrabbed, false] remoteExec ["setUnconscious", _personWhoIsGrabbed];
        };
        _victim setVariable ["canMakeAttack", 0, true];
        _victim setVariable ["AI_CanTurn", 0, true];
        _victim enableAI "ALL";
        _victim setVariable ['IMS_IsUnitinvicibleScripted', nil, true];
    }];
    _victim setVariable ["WBK_ZombieAttachedParasite", _main, true];
    _victim addEventHandler ["Killed", {
        _unit = _this select 0;
        _unit removeAllEventHandlers "Killed";
        _main = _unit getVariable "WBK_ZombieAttachedParasite";
        detach _main;
        [_main, "Corrupted_attack_success_failed"] remoteExec ["switchMove", 0, false];
        [_main, "Corrupted_attack_success_failed"] remoteExec ["playMoveNow", 0, false];
    }];
    sleep 1;
    if (!(alive _main) or !(alive _victim) or !(animationState _victim == "Corrupted_Attack_victim") or (!(animationState _main == "Corrupted_attack_success_back") and !(animationState _main == "Corrupted_attack_success_front"))) exitwith {};
    if (isnil {
        _victim getVariable "WBK_AI_ISZombie"
    }) then {
        [_victim, selectRandom ["Smasher_human_scream_1", "Smasher_human_scream_2", "Smasher_human_scream_3"], 110, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    };
    [_victim, selectRandom ["corrupted_head_attack_1", "corrupted_head_attack_2", "corrupted_head_attack_3", "corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 1.8;
    if (!(alive _main) or !(alive _victim) or !(animationState _victim == "Corrupted_Attack_victim") or (!(animationState _main == "Corrupted_attack_success_back") and !(animationState _main == "Corrupted_attack_success_front"))) exitwith {};
    [_victim, selectRandom ["corrupted_head_attack_1", "corrupted_head_attack_2", "corrupted_head_attack_3", "corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _main allowdamage false;
    _main removeAllEventHandlers "Killed";
    [_victim, false] remoteExec ["allowdamage", 0];
    [_victim, "radIOPROtoCOL"] remoteExec ["disableAI", 0];
    [_victim, "PF_Hit_2", 40, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    if (isplayer _victim) then {
        [_victim, {
            _player_unit = player;
            _player_unit enableAI "move";
            _player_unit enableAI "AUtoTARGET";
            _player_unit enableAI "TARGET";
            _player_name = name _player_unit;
            _player_face = face _player_unit;
            _unit_for_select = ((creategroup (side _player_unit)) createUnit [typeOf _player_unit, [0, 0, 0], [], 0, "NONE"]);
            selectPlayer _unit_for_select;
            _player_unit switchCamera "EXTERNAL";
            _player_unit setskill 1;
            _player_unit setFace _player_face;
            _player_unit setName _player_name;
            removeswitchableUnit _player_unit;
            unassignvehicle _player_unit;
            sleep 5;
            _unit_for_select setVariable ["actualSwordBlock", 0, true];
            _unit_for_select setVariable ["canMakeAttack", 0, true];
            _unit_for_select setVariable ["candeflectBullets", 0, true];
            _unit_for_select setVariable ["concentrationparam", 0.5, true];
            _unit_for_select setVariable ["Blockcountdown", 1, true];
            _unit_for_select setVariable ["IMS_StaminaRegenerationparam", 0.0016];
            _unit_for_select setVariable ["SM_CanUseskill", nil];
            _unit_for_select setVariable ["IMS_LaF_ShotstoTakeOutoneGuy", 50, true];
            _unit_for_select setVariable ["inBlock", 0, true];
            _unit_for_select setVariable ["IMS_LaF_forceMana", 0.5, true];
            [_unit_for_select] execVM "\WebKnight_StarWars_Mechanic\lighsaber_moveset.sqf";
            _unit_for_select addEventHandler ["Respawn", {
                if (IMS_IsAddAweapontoplrRsp) then {
                    if (side player == west) then {
                        player addItem "Knife_m3";
                    };
                    if (side player == east) then {
                        player addItem "Weap_melee_knife";
                    };
                    if (side player == resistance) then {
                        player addItem "Knife_kukri";
                    };
                };
                inDeflectingBullets = 0;
                jumpUpparam = 0;
                jumpFwrdparam = 0;
                playerforceMana = 0;
                PowerChokeKillornot = 0;
                inUsingChoke = false;
                jumpdirection = "forward";
                SupaPunch = 1;
                player setVariable ["actualSwordBlock", 0, true];
                player setVariable ["canMakeAttack", 0, true];
                player setVariable ["candeflectBullets", 0, true];
                player setVariable ["concentrationparam", 0.5, true];
                player setVariable ["SM_CanUseskill", nil];
                player setVariable ["IMS_LaF_ShotstoTakeOutoneGuy", 50, true];
                player setVariable ["IMS_LaF_forceMana", 0.5, true];
                player setVariable ["inBlock", 0, true];
                nextMeleeAttack = "woodaxe_attack1";
                attackStyle = "Light";
                [player] execVM "\WebKnight_StarWars_Mechanic\lighsaber_moveset.sqf";
            }];
            sleep 5;
            _unit_for_select setDamage 1;
        }] remoteExec ["spawn", _victim];
    };
    [_victim, {
        _object = _this;
        if (!(WBK_Zombies_EnableHeadShotsParticles)) exitwith {};
        _breath = "#particlesource" createvehiclelocal (getPosATL _object);
        _breath setParticleParams
        [
            ["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], // shape name
            "", // anim name
            "spaceObject",
            0.5, 12, // timer period & life time
            [0, 0, 0], // pos
            [3 + random -3, 2 + random -2, random 3], // moveVel
            1, 1.275, 0.2, 0, // rotation vel, weight, volume, rubbing
            [1.6, 0], // size transform
            [[0.005, 0, 0, 0.05], [0.006, 0, 0, 0.06], [0.2, 0, 0, 0]],
            [1000], // animationPhase (speed in config)
            1, // randomdirection period
            0.1, // random direction intensity
            "", // ontimer
            "", // before destroy
            "", // object
            0, // angle
            false, // on surface
            -1 // bounce on surface
        ];
        _breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
        _breath setDropInterval 0.01;
        _breath attachto [_object, [0, 0, 0.2], "head"];
        sleep 0.25;
        deletevehicle _breath;
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
    sleep 0.95;
    [[_victim, _main], {
        _victim = _this select 0;
        _main = _this select 1;
        removeAllweapons _victim;
        [_victim] joinSilent (group _main);
    }] remoteExec ["spawn", _victim];
    [_victim, selectRandom ["corrupted_head_attack_1", "corrupted_head_attack_2", "corrupted_head_attack_3", "corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "PF_Hit_1", 40, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "decapetadet_sound_1", 50, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    _victim unlinkItem hmd _victim;
    removeGoggles _victim;
    removeHeadgear _victim;
    [_victim, {
        // Ensuring headless clients aren't caught by this
		if (!hasinterface) exitwith {};
		[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
    sleep 1.5;
    [_victim, selectRandom ["corrupted_head_attack_1", "corrupted_head_attack_2", "corrupted_head_attack_3", "corrupted_head_attack_4"], 45, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, selectRandom ["dobi_blood_1", "dobi_blood_2"], 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "decapetadet_sound_2", 50, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, "Smasher_Eat", 80, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_victim, {
        // Ensuring headless clients aren't caught by this
		if (!hasinterface) exitwith {};
		[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
    }] remoteExec ["spawn", [0, -2] select isDedicated, false];
    sleep 1.3;
    [_victim, "corrupted_transformed", 150, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 1;
    deletevehicle _main;
    [_victim, {
        _this execVM "\saef_wbk_cnz_performance_patch\AI\WBK_AI_Corrupted.sqf";
        _this allowdamage true;
        _this setVariable ['IMS_IsUnitinvicibleScripted', nil, true];
    }] remoteExec ["spawn", _victim];
    _victim setVariable ["WBK_Zombie_CustomSounds",
	[
		["corrupted_idle_1", "corrupted_idle_2", "corrupted_idle_3", "corrupted_idle_4"],
		["corrupted_idle_1", "corrupted_idle_2", "corrupted_idle_3", "corrupted_idle_4"],
		["corrupted_idle_1", "corrupted_idle_2", "corrupted_idle_3", "corrupted_idle_4"],
		["corrupted_dead_1", "corrupted_dead_2", "corrupted_dead_3"],
		["corrupted_dead_1", "corrupted_dead_2", "corrupted_dead_3"]
	], true];

	if !(isnil {
		_victim getVariable "WBK_AI_ISZombie"
	}) then {
		[_victim, "WBK_dosHead_Corrupted"] remoteExec ["setFace", 0, true];
	};
	[_victim, "dobi_blood_1", 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	[_victim, {
		// Ensuring headless clients aren't caught by this
		if (!hasinterface) exitwith {};

		_object = _this;
		if (!(WBK_Zombies_EnableHeadShotsParticles)) exitwith {};
		_breath = "#particlesource" createvehiclelocal (getPosATL _object);
		_breath setParticleParams
		[
			["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], // shape name
			"", // anim name
			"spaceObject",
			0.5, 12, // timer period & life time
			[0, 0, 0], // pos
			[3 + random -3, 2 + random -2, random 3], // moveVel
			1, 1.275, 0.2, 0, // rotation vel, weight, volume, rubbing
			[1.6, 0], // size transform
			[[0.005, 0, 0, 0.05], [0.006, 0, 0, 0.06], [0.2, 0, 0, 0]],
			[1000], // animationPhase (speed in config)
			1, // randomdirection period
			0.1, // random direction intensity
			"", // ontimer
			"", // before destroy
			"", // object
			0, // angle
			false, // on surface
			-1 // bounce on surface
		];
		_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
		_breath setDropInterval 0.01;
		_breath attachto [_object, [0, 0, 0.2], "head"];
		sleep 0.15;
		deletevehicle _breath;
	}] remoteExec ["spawn", [0, -2] select isDedicated, false];
};
    
WBK_HeadTryingToGrab = {
	_zombie = _this select 0;
	if (animationState _zombie == "Corrupted_Attack") exitwith {};
	_enemy = _this select 1;
	if (!(isplayer _enemy) and ((_zombie distance _enemy) <= 5)) then {
		[_enemy, 2, _zombie] remoteExec ["IMS_MeleeFunction", _enemy];
	};
	[_zombie, selectRandom ["corrupted_head_attack_1", "corrupted_head_attack_2", "corrupted_head_attack_3", "corrupted_head_attack_4"], 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	_rndcatch = "Corrupted_Attack";
	[_zombie, _rndcatch] remoteExec ["switchMove", 0];
	[_zombie, _rndcatch] remoteExec ["playMoveNow", 0];
	_zombie allowdamage false;
	dostop _zombie;
	_zombie disableAI "ANIM";
	_loopPathfinddomove = [{
		_array = _this select 0;
		_unit = _array select 0;
		_nearEnemy = _array select 1;
		_anim = _array select 2;
		if (!(animationState _unit == _anim) or (lifeState _unit == "inCAPACITATED") or !(alive _unit)) exitwith {
			_unit allowdamage true;
		};
		_dir = [[0, 1, 0], -([_unit, _nearEnemy] call BIS_fnc_dirto)] call BIS_fnc_rotateVector2D;
		_unit setvelocityTransformation [
			getPosASL _unit,
			getPosASL _unit,
			[0, 0, (velocity _unit select 2) - 1],
			[(velocity _unit select 0), (velocity _unit select 1), (velocity _unit select 2) - 1],
			vectorDir _unit,
			_dir,
			vectorUp _unit,
			vectorUp _unit,
			0.1
		];
	}, 0.01, [_zombie, _enemy, _rndcatch]] call CBA_fnc_addPerFrameHandler;
	sleep 0.7;
	_rndEquip = selectRandom ["melee_whoosh_00", "melee_whoosh_01", "melee_whoosh_02"];
	[_zombie, _rndEquip, 35, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	[_loopPathfinddomove] call CBA_fnc_removePerFrameHandler;
	_zombie enableAI "ANIM";
	sleep 0.1;
	_zombie allowdamage true;
	if (!(animationState _enemy == "Corrupted_Attack_victim") and (isnil {
		_enemy getVariable "IMS_IsUnitinvicibleScripted"
	}) and !(animationState _enemy == "Corrupted_Attack") and !(animationState _enemy == "WBK_catchedByZombie_Back") and ((_zombie distance _enemy) <= 2.3) and (animationState _zombie == _rndcatch) and (alive _zombie)) exitwith {
		[_zombie, _enemy] spawn WBK_CorruptedAttack_success;
	};
	sleep 0.9;
	_pos = ASLtoAGL getPosASLVisual _enemy;
	_zombie domove _pos;
};

WBK_SpawnCorruptedHead = {
	_unit = _this;
	[_unit, selectRandom ["decapetadet_sound_1", "decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	_unit unlinkItem hmd _unit;
	removeGoggles _unit;
	removeHeadgear _unit;
	[_unit, {
		// Ensuring headless clients aren't caught by this
		if (!hasinterface) exitwith {};
		[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
	}] remoteExec ["spawn", [0, -2] select isDedicated, false];
	if (side group _unit == resistance) exitwith {
		_headcrab = group _unit createUnit ["WBK_SpecialZombie_Corrupted_1", [0, 0, 100], [], 0, "forM"];
		_headcrab attachto [_unit, [0, 0, 0], "head"];
		detach _headcrab;
		_headcrab setspeaker "NoVoice";
	};
	if (side group _unit == west) exitwith {
		_headcrab = group _unit createUnit ["WBK_SpecialZombie_Corrupted_2", [0, 0, 100], [], 0, "forM"];
		_headcrab attachto [_unit, [0, 0, 0], "head"];
		detach _headcrab;
		_headcrab setspeaker "NoVoice";
	};
	if (side group _unit == east) exitwith {
		_headcrab = group _unit createUnit ["WBK_SpecialZombie_Corrupted_3", [0, 0, 100], [], 0, "forM"];
		_headcrab attachto [_unit, [0, 0, 0], "head"];
		detach _headcrab;
		_headcrab setspeaker "NoVoice";
	};
};

WBK_HeadDestruction = {
	params
	[
		"_object",
		"_holetype"
	];
	
	_object setFace _holetype;
	
	if (!(WBK_Zombies_EnableHeadShotsParticles)) exitwith {};
	
	private
	[
		"_breath"
	];
	
	_breath = "#particlesource" createvehiclelocal (getPosATL _object);
	_breath setParticleParams
	[
		["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], // shape name
		"", // anim name
		"spaceObject",
		0.5, 12, // timer period & life time
		[0, 0, 0], // pos
		[3 + random -3, 2 + random -2, random 3], // moveVel
		1, 1.275, 0.2, 0, // rotation vel, weight, volume, rubbing
		[1.6, 0], // size transform
		[[0.005, 0, 0, 0.05], [0.006, 0, 0, 0.06], [0.2, 0, 0, 0]],
		[1000], // animationPhase (speed in config)
		1, // randomdirection period
		0.1, // random direction intensity
		"", // ontimer
		"", // before destroy
		"", // object
		0, // angle
		false, // on surface
		0.0 // bounce on surface
	];
	
	_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
	_breath setDropInterval 0.01;
	_breath attachto [_object, [0, 0, 0.2], "head"];
	
	sleep 0.25;
	deletevehicle _breath;
};

WBK_HeadDestructionWithBlood = {
	params
	[
		"_object",
		"_holetype"
	];
	
	_object setFace _holetype;
	
	if (!(WBK_Zombies_EnableHeadShotsParticles)) exitwith {};
	
	private
	[
		"_blood",
		"_breath"
	];
	
	_blood = "#particlesource" createvehiclelocal (getPosATL _object);
	_blood attachto [_object, [0, 0, 0], "head"];
	_blood setParticleParams
	[
		["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 13, 1, 32], // model name
		"", // animation
		"billboard", // type
		0.1, 2, // period and lifecycle
		[0, 0, 0], // position
		
		[3 + random -6, 3 + random -6, 2], // movement vector
		5, 6, 0.4, 0.4, // rotation, weight, volume, rubbing
		[0.05, 1.4], // size transform
		[[0.5, 0, 0, 0.6], [0.8, 0, 0, 0.1], [0.1, 0, 0, 0.03]],
		[0.00001],
		0.4,
		0.4,
		"",
		"",
		"",
		360, // angle
		false, // on surface
		0 // bounce on surface
	];
	_blood setDropInterval 0.01;
	
	_breath = "#particlesource" createvehiclelocal (getPosATL _object);
	_breath setParticleParams
	[
		["\a3\Data_f\ParticleEffects\Universal\meat_ca", 1, 0, 1], // shape name
		"", // anim name
		"spaceObject",
		0.5, 12, // timer period & life time
		[0, 0, 0], // pos
		[3 + random -3, 2 + random -2, random 3], // moveVel
		1, 1.275, 0.2, 0, // rotation vel, weight, volume, rubbing
		[1.6, 0], // size transform
		[[0.005, 0, 0, 0.05], [0.006, 0, 0, 0.06], [0.2, 0, 0, 0]],
		[1000], // animationPhase (speed in config)
		1, // randomdirection period
		0.1, // random direction intensity
		"", // ontimer
		"", // before destroy
		"", // object
		0, // angle
		false, // on surface
		0.0 // bounce on surface
	];
	_breath setParticleRandom [0.5, [0, 0, 0], [3.25, 0.25, 2.25], 1, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
	_breath setDropInterval 0.01;
	_breath attachto [_object, [0, 0, 0.2], "head"];
	
	sleep 0.15;
	deletevehicle _breath;
	sleep 0.9;
	deletevehicle _blood;
};

WBK_AI_AddDefaulEventHandlers = {
	params
	[
		"_unitwithSword"
	];
	
	_unitwithSword addEventHandler ["Suppressed", {
		params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoclassname", "_ammoConfig"];
		if (!(alive _unit)) exitwith {};
		_unit reveal [_instigator, 4];
	}];
	
	_unitwithSword addEventHandler ["firedNear", {
		params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
		if (!(alive _unit)) exitwith {};
		_unit reveal [_firer, 4];
	}];
};

WBK_AI_DefaultUnconStandUp = {
	params
	[
		"_zombie",
		["_evadegetUp", false]
	];
	
	while {(alive _zombie)} do {
		if (!(alive _zombie)) exitwith {};
		
		waitUntil {
			sleep 0.2;
			if (isNull _zombie) exitwith {
				true
			};
			((lifeState _zombie == "inCAPACITATED") or !(alive _zombie))
		};
		
		if (!(alive _zombie)) exitwith {};
		
		sleep 0.1;
		waitUntil {
			sleep 0.2;
			if (isNull _zombie) exitwith {
				true
			};
			(!(lifeState _zombie == "inCAPACITATED") or !(alive _zombie))
		};
		
		if (!(alive _zombie)) exitwith {};
		
		[_zombie, _evadegetUp] spawn {
			params
			[
				"_zombie",
				["_evadegetUp", false]
			];
			
			if (!(isnil {
				_zombie getVariable "WBK_ZombieswitchtoCrawler"
			})) exitwith
			{
				[_zombie, "WBK_Crawler_to_Idle"] remoteExec ["switchMove", 0];
				[_zombie, "WBK_Crawler_to_Idle"] remoteExec ["playMoveNow", 0];
			};
			
			private
			[
				"_rndStandUp"
			];
			
			_rndStandUp = selectRandom ["WBK_Middle_GetUpUnconscious", "WBK_Middle_GetUpUnconscious_1"];
			[_zombie, _rndStandUp] remoteExec ["switchMove", 0];
			[_zombie, _rndStandUp] remoteExec ["playMoveNow", 0];
			
			if (_evadegetUp) then {
				sleep 1.9;
				
				if (!(animationState _zombie == _rndStandUp)) exitwith {};
				
				_zombie disableAI "ANIM";
				_zombie disableAI "move";
				
				private
				[
					"_rndmove"
				];
				
				_rndmove = selectRandom ["WBK_Zombie_Evade_B", "WBK_Zombie_Evade_L", "WBK_Zombie_Evade_R"];
				
				[_zombie, _rndmove] remoteExec ["switchMove", 0];
				[_zombie, _rndmove] remoteExec ["playMoveNow", 0];
				
				sleep 0.8;
				
				_zombie enableAI "ANIM";
				_zombie enableAI "move";
			};
		};
		
		sleep 0.1;
	};
};

WBK_AI_SetWW2CustomSounds = {
	params
	[
		"_unitwithSword"
	];
	
	if ((gettext (configFile >> "Cfgvehicles" >> typeOf _unitwithSword >> "editorSubcategory") == "LIB_US_ARMY") or
	(gettext (configFile >> "Cfgvehicles" >> typeOf _unitwithSword >> "editorSubcategory") == "LIB_RKKA") or
	(gettext (configFile >> "Cfgvehicles" >> typeOf _unitwithSword >> "editorSubcategory") == "LIB_WEHRMACHT") or
	(gettext (configFile >> "Cfgvehicles" >> typeOf _unitwithSword >> "editorSubcategory") == "WBK_Zombies_WW2_German") or
	(gettext (configFile >> "Cfgvehicles" >> typeOf _unitwithSword >> "editorSubcategory") == "WBK_Zombies_WW2_RKKA") or
	(gettext (configFile >> "Cfgvehicles" >> typeOf _unitwithSword >> "editorSubcategory") == "WBK_Zombies_WW2_US"))
	then
	{
		_unitwithSword setVariable ["WBK_Zombie_CustomSounds",
		[
			["WW2_Zombie_walker1", "WW2_Zombie_walker2", "WW2_Zombie_walker3", "WW2_Zombie_walker4", "WW2_Zombie_walker5"],
			["WW2_Zombie_sprinter1", "WW2_Zombie_sprinter2", "WW2_Zombie_sprinter3", "WW2_Zombie_sprinter4", "WW2_Zombie_sprinter5", "WW2_Zombie_sprinter6", "WW2_Zombie_sprinter7", "WW2_Zombie_sprinter8", "WW2_Zombie_sprinter9"],
			["WW2_Zombie_attack1", "WW2_Zombie_attack2", "WW2_Zombie_attack3", "WW2_Zombie_attack4", "WW2_Zombie_attack5"],
			["WW2_Zombie_death1", "WW2_Zombie_death2", "WW2_Zombie_death3", "WW2_Zombie_death4", "WW2_Zombie_death5"],
			["WW2_Zombie_burning1", "WW2_Zombie_burning2", "WW2_Zombie_burning3"]
		], true];
	};
};
        
WBK_AI_DefaultKilledEventHandler = {
	params
	[
		"_zombie",
		"_killer"
	];
	
	if !(isnil {
		_zombie getVariable "WBK_AI_Zombie_DecapHead_BEHinD"
	}) exitwith
	{
		[_zombie, selectRandom ["decapetadet_sound_1", "decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		
		_zombie unlinkItem hmd _zombie;
		removeGoggles _zombie;
		removeHeadgear _zombie;
		
		[_zombie, {
			// Ensuring headless clients aren't caught by this
			if (!hasinterface) exitwith {};
			[_this, "WBK_dosHead_BackHole"] spawn WBK_HeadDestruction;
		}] remoteExec ["spawn", [0, -2] select isDedicated, false];
	};
	
	if !(isnil {
		_zombie getVariable "WBK_AI_Zombie_DecapHead_FRONT"
	}) exitwith
	{
		[_zombie, selectRandom ["decapetadet_sound_1", "decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		
		removeGoggles _zombie;
		
		[_zombie, {
			// Ensuring headless clients aren't caught by this
			if (!hasinterface) exitwith {};
			[_this, "WBK_dosHead_FrontHole"] spawn WBK_HeadDestruction;
		}] remoteExec ["spawn", [0, -2] select isDedicated, false];
	};
	
	if !(isnil {
		_zombie getVariable "WBK_AI_Zombie_DecapHead"
	}) exitwith
	{
		[_zombie, selectRandom ["decapetadet_sound_1", "decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		
		_zombie unlinkItem hmd _zombie;
		removeGoggles _zombie;
		removeHeadgear _zombie;
		
		[_zombie, {
			// Ensuring headless clients aren't caught by this
			if (!hasinterface) exitwith {};
			[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
		}] remoteExec ["spawn", [0, -2] select isDedicated, false];
	};
	
	if (isBurning _zombie) exitwith {
		[_zombie, selectRandom ["flamethrower_burning_1", "flamethrower_burning_2", "flamethrower_burning_3", "flamethrower_burning_4", "flamethrower_burning_7"]] remoteExec ["switchMove", 0, false];
		
		if (!(isnil {
			_zombie getVariable "WBK_Zombie_CustomSounds"
		})) then
		{
			private
			[
				"_snds"
			];
			
			_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 4;
			[_zombie, selectRandom _snds, 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		} else {
			[_zombie, selectRandom ["plagued_burn_1", "plagued_burn_2", "plagued_burn_3"], 70, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		};
	};
	
	if (!(isnil {
		_zombie getVariable "WBK_Zombie_CustomSounds"
	})) then
	{
		private
		[
			"_snds"
		];
		
		_snds = (_zombie getVariable "WBK_Zombie_CustomSounds") select 3;
		[_zombie, selectRandom _snds, 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	} else {
		[_zombie, selectRandom ["plagued_death_1", "plagued_death_2", "plagued_death_3", "plagued_death_4", "plagued_death_5", "plagued_death_6", "plagued_death_7", "plagued_death_8", "plagued_death_9"], 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	};
	
	if ((isnil {
		_zombie getVariable "WBK_ZombieswitchtoCrawler"
	}) and (WBK_Zombies_EnableStaticAnimations) and !(_zombie == _killer) and !(isNull _killer)) exitwith
	{
		[_zombie, _killer] spawn {
			params
			[
				"_victim",
				"_shooter"
			];
			
			_victim spawn {
				sleep 0.02;
				
				// playActionNow has a global effect (https://community.bistudio.com/wiki/playActionNow) no need to execute on all machines
				_this playActionNow "Disable_Gesture";
			};
			
			if (((_victim worldToModel (_shooter modeltoWorld [0, 0, 0])) select 1) > 0) then {
				_rndAnim = selectRandom ["IMS_Die_Spec_1", "A_playerDeathAnim_19", "A_playerDeathAnim_17", "A_playerDeathAnim_14", "A_playerDeathAnim_15", "A_playerDeathAnim_1", "A_playerDeathAnim_2", "A_playerDeathAnim_3", "A_playerDeathAnim_5", "A_playerDeathAnim_7", "A_playerDeathAnim_8", "A_playerDeathAnim_9", "A_playerDeathAnim_10", "A_playerDeathAnim_11", "A_playerDeathAnim_12", "A_playerDeathAnim_13"];
				[_victim, _rndAnim] remoteExec ["switchMove", 0];
				
				if (_rndAnim == "A_playerDeathAnim_17") exitwith {
					sleep 1.95;
					
					// setvelocity has a global effect (https://community.bistudio.com/wiki/setvelocity) no need to execute on all machines
					_victim setvelocity [-4 * (sin (getDir _victim )), -4 * (cos (getDir _victim)), 1];
				};
				
				if (_rndAnim == "A_playerDeathAnim_19") exitwith {
					sleep 0.2;
					
					// setvelocity has a global effect (https://community.bistudio.com/wiki/setvelocity) no need to execute on all machines
					_victim setvelocity [-5 * (sin (getDir _victim )), -5 * (cos (getDir _victim)), 0.5];
				};
				
				if ((_rndAnim == "A_playerDeathAnim_3") or (_rndAnim == "A_playerDeathAnim_5")) exitwith {
					// setvelocity has a global effect (https://community.bistudio.com/wiki/setvelocity) no need to execute on all machines
					_victim setvelocity [-5 * (sin (getDir _victim )), -5 * (cos (getDir _victim)), 1.35];
				};
				
				if ((_rndAnim == "A_playerDeathAnim_13")) exitwith {
					// setvelocityModelSpace has a global effect (https://community.bistudio.com/wiki/setvelocityModelSpace) no need to execute on all machines
					
					sleep 0.3;
					_victim setvelocityModelSpace [1.2, 0, 0.1];
					sleep 0.2;
					_victim setvelocityModelSpace [2, 0, 0.3];
					sleep 0.2;
					_victim setvelocityModelSpace [1, 0, 0.3];
					sleep 0.2;
					_victim setvelocityModelSpace [1, 0, 0.3];
				};
				
				if ((_rndAnim == "A_playerDeathAnim_12")) exitwith {
					sleep 1.5;
					
					// setvelocityModelSpace has a global effect (https://community.bistudio.com/wiki/setvelocityModelSpace) no need to execute on all machines
					_victim setvelocityModelSpace [0, 2, 0.5];
				};
			} else {
				[_victim, selectRandom ["IMS_Die_Spec_2", "A_playerDeathAnim_18", "A_playerDeathAnim_20", "A_playerDeathAnim_4", "A_playerDeathAnim_6"]] remoteExec ["switchMove", 0];
				
				// setvelocity has a global effect (https://community.bistudio.com/wiki/setvelocity) no need to execute on all machines
				_victim setvelocity [5 * (sin (getDir _victim )), 5 * (cos (getDir _victim)), 1.35];
				[_victim, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
			};
		};
	};
};

WBK_AI_DefaultHitPartEventHandler = {
	// Ensuring headless clients don't fall into this
	if (!hasinterface) exitwith {};
	
	_this removeAllEventHandlers "HitPart";
	_this addEventHandler [
		"HitPart",
		{
			(_this select 0) params ["_target", "_shooter", "_bullet", "_position", "_velocity", "_selection", "_ammo", "_direction", "_radius", "_surface", "_direct"];
			
			if ((_target == _shooter) or (isNull _shooter) or !(alive _target) or (lifeState _target == "inCAPACITATED")) exitwith {};
			
			if !(isnil {
				_target getVariable "WBK_ZombieswitchtoCrawler"
			}) exitwith
			{
				if (gestureState _target == "WBK_ZombieHitgest_2") exitwith {
					[_target, "WBK_ZombieHitgest_3"] remoteExec ["playActionNow", _target];
				};
				
				if (gestureState _target == "WBK_ZombieHitgest_1") exitwith {
					[_target, "WBK_ZombieHitgest_2"] remoteExec ["playActionNow", _target];
				};
				
				[_target, "WBK_ZombieHitgest_1"] remoteExec ["playActionNow", _target];
			};
			
			private
			[
				"_isexplosive"
			];
			
			_isexplosive = _ammo select 3;
			
			if (_isexplosive == 1) exitwith {
				private
				[
					"_anim"
				];
				
				_anim = selectRandom ["WBK_Middle_Fall_forward", "WBK_Middle_Fall_forward_1", "WBK_Middle_Fall_Back", "WBK_Middle_Fall_Back_1"];
				[_target, _anim] remoteExec ["switchMove", 0];
				[_target, _anim] remoteExec ["playMoveNow", 0];
			};
			
			private
			[
				"_isEnoughdamage",
				"_partofTheBody",
				"_allowedPartsOfBody"
			];
			
			_isEnoughdamage = _ammo select 0;
			_partofTheBody = _selection select 0;
			_allowedPartsOfBody = ["leftfoot", "lefttoebase", "leftleg", "leftlegroll", "leftupleg", "leftuplegroll",
			"rightupleg", "rightuplegroll", "rightleg", "rightlegroll", "rightfoot", "righttoebase"];
			
			if ((_partofTheBody in _allowedPartsOfBody) and (_isEnoughdamage >= 10)) exitwith {
				[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
				
				_target spawn {
					_this setVariable ["WBK_ZombieswitchtoCrawler", 1, true];
					sleep 0.6;
					
					[_this, true] remoteExec ["setUnconscious", _this];
					sleep 8;
					
					if (!(lifeState _this == "inCAPACITATED") or !(alive _this)) exitwith {};
					[_this, false] remoteExec ["setUnconscious", _this];
				};
				
				if (((_target worldToModel (_shooter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
					[_target, "WBK_Middle_Fall_Back"] remoteExec ["switchMove", 0];
					[_target, "WBK_Middle_Fall_Back"] remoteExec ["playMoveNow", 0];
				};
				
				[_target, "WBK_Middle_Fall_forward"] remoteExec ["switchMove", 0];
				[_target, "WBK_Middle_Fall_forward"] remoteExec ["playMoveNow", 0];
			};
			
			if (((_partofTheBody == "head") or (_partofTheBody == "neck")) and (_isEnoughdamage >= 9)) exitwith {
				if (_isEnoughdamage >= 14) exitwith {
					_target setVariable ["WBK_AI_Zombie_DecapHead", 1, true];
					_target setDamage 1;
					
					if !(WBK_Zombies_EnableStaticAnimations) exitwith
					{
						if (((_target worldToModel (_shooter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
							[_target, [_target vectorModelToWorld [0, 300, 0], _target selectionPosition "head"]] remoteExec ["addforce", _target];
						};
						
						[_target, [_target vectorModelToWorld [0, -300, 0], _target selectionPosition "head"]] remoteExec ["addforce", _target];
					};
					
					[_target, selectRandom ["A_playerDeathAnim_17", "A_playerDeathAnim_10", "A_playerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
				};
				
				if (_isEnoughdamage >= 10.5) exitwith {
					if !(WBK_Zombies_EnableStaticAnimations) exitwith
					{
						if (((_target worldToModel (_shooter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
							[_target, [_target vectorModelToWorld [0, 300, 0], _target selectionPosition "head"]] remoteExec ["addforce", _target];
							_target setVariable ["WBK_AI_Zombie_DecapHead_BEHinD", 1, true];
							_target setDamage 1;
						};
						
						[_target, [_target vectorModelToWorld [0, -300, 0], _target selectionPosition "head"]] remoteExec ["addforce", _target];
						_target setVariable ["WBK_AI_Zombie_DecapHead_FRONT", 1, true];
						_target setDamage 1;
					};
					
					if (((_target worldToModel (_shooter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
						_target setVariable ["WBK_AI_Zombie_DecapHead_BEHinD", 1, true];
						_target setDamage 1;
						[_target, selectRandom ["A_playerDeathAnim_18", "A_playerDeathAnim_4", "A_playerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
					};
					
					_target setVariable ["WBK_AI_Zombie_DecapHead_FRONT", 1, true];
					_target setDamage 1;
					[_target, selectRandom ["A_playerDeathAnim_17", "A_playerDeathAnim_10", "A_playerDeathAnim_11"]] remoteExec ["switchMove", 0, false];
				};
				
				if (((_target worldToModel (_shooter modeltoWorld [0, 0, 0])) select 1) < 0) exitwith {
					_anim = selectRandom ["WBK_Middle_Fall_forward", "WBK_Middle_Fall_forward_1"];
					[_target, _anim] remoteExec ["switchMove", 0];
					[_target, _anim] remoteExec ["playMoveNow", 0];
					[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
				};
				
				_anim = selectRandom ["WBK_Middle_Fall_Back", "WBK_Middle_Fall_Back_1"];
				[_target, _anim] remoteExec ["switchMove", 0];
				[_target, _anim] remoteExec ["playMoveNow", 0];
				[_target, "dobi_fall_2", 50, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
			};
			
			if (gestureState _target == "WBK_ZombieHitgest_2") exitwith {
				[_target, "WBK_ZombieHitgest_3"] remoteExec ["playActionNow", _target];
			};
			
			if (gestureState _target == "WBK_ZombieHitgest_1") exitwith {
				[_target, "WBK_ZombieHitgest_2"] remoteExec ["playActionNow", _target];
			};
			
			[_target, "WBK_ZombieHitgest_1"] remoteExec ["playActionNow", _target];
		}
	];
};

WBK_AI_SetupDefaultZombieBehaviour = {
	params
	[
		"_unitwithSword"
	];
	
	removeAllweapons _unitwithSword;
	_unitwithSword action ["switchWeapon", _unitwithSword, _unitwithSword, 100];
	_unitwithSword disableAI "minEDETECTION";
	_unitwithSword disableAI "WEAPONAIM";
	_unitwithSword disableAI "SUPPRESSION";
	_unitwithSword disableAI "COVER";
	_unitwithSword disableAI "AIminGERRor";
	_unitwithSword disableAI "TARGET";
	_unitwithSword disableAI "AUtoCOMBAT";
	_unitwithSword disableAI "FSM";
	_unitwithSword setBehaviour "CARELESS";
	_unitwithSword setspeaker "NoVoice";
	_unitwithSword setunitPos "UP";
	_unitwithSword disableConversation true;
};

WBK_AI_SetupDefaultZombieVariables = {
	params
	[
		"_unitwithSword"
	];
	
	_unitwithSword setVariable ["WBK_AI_ISZombie", 0, true];
	_unitwithSword setVariable ['isMutant', true];
	_unitwithSword setVariable ["dam_ignore_hit0", true, true];
	_unitwithSword setVariable ["dam_ignore_effect0", true, true];
};

WBK_AI_SetupDefaultAttackAnimations = {
	params
	[
		"_mutant",
		"_forbiddenCrawlerAnimStates",
		"_forbiddenAnimStates",
		"_forbiddenGestureStates",
		"_allowedAnimStates",
		"_bitedistances",
		"_overrideAttackGesture",
		["_defaultAttackGesture", WBK_ZombieAttack_gesture]
	];
	
	if ((lifeState _mutant == "inCAPACITATED") or !(alive _mutant)) exitwith {};
	
	// find nearest enemy
	private
	[
		"_en"
	];
	
	_en = _mutant findNearestEnemy _mutant;
	
	if (!(_en isKindOf "MAN") or !(isnil {
		_en getVariable "IMS_IsUnitinvicibleScripted"
	}) or (_en isKindOf "WBK_C_exportClass") or (_en isKindOf "WBK_Horses_exportClass")) exitwith {};
	
	_bitedistances params
	[
		"_crawlerBitedistance",
		"_normalBitedistance"
	];
	
	// Ensuring distance between nearest enemy and zombie is done first, so that we do not have to waste resources executing the rest of this code
	if ((_en distance _mutant) > _crawlerBitedistance) exitwith {};
	
	if !(isnil {
		_mutant getVariable "WBK_ZombieswitchtoCrawler"
	}) exitwith
	{
		if (!((animationState _mutant) in _forbiddenCrawlerAnimStates) and ((_mutant distance _en) <= _crawlerBitedistance)) exitwith {
			[_mutant, _en] spawn WBK_ZombieAttack_Crawler;
		};
	};
	
	// Ensuring distance between nearest enemy and zombie is done first, so that we do not have to waste resources executing the rest of this code
	if ((_en distance _mutant) > _normalBitedistance) exitwith {};
	
	if (((_mutant distance _en) <= _normalBitedistance) and
	!((animationState _mutant) in _forbiddenAnimStates) and
	!((gestureState _mutant) in _forbiddenGestureStates) and
	((_mutant getVariable ["canMakeAttack", 0]) == 0)) exitwith
	{
		if ((((animationState _en) in _allowedAnimStates) or
		(((_mutant worldToModel (_en modeltoWorld [0, 0, 0])) select 1) < 0) or
		(speed _en >= 13) or
		(_en isKindOf "TIOWSpaceMarine_Base") or
		!(isnil {
			_en getVariable "WBK_AI_ISZombie"
		}) or
		!(WBK_Zombies_EnableBitingMechanic)) and
		((_mutant distance _en) <= _normalBitedistance)) exitwith
		{
			[_mutant, _en] spawn _defaultAttackGesture;
		};
		
		[_mutant, _en] spawn _overrideAttackGesture;
	};
};

WBK_AI_DefaultLoopPathfindDoMove = {
	params ["_array"];
	_array params ["_unit"];
	
	private
	[
		"_nearEnemy"
	];
	
	_nearEnemy = _unit findNearestEnemy _unit;
	
	if ((isNull _nearEnemy) or !(alive _nearEnemy) or !(alive _unit) or !(_unit checkAifeature "move")) exitwith {
		if (!(isnil {
			_unit getVariable "WBK_Zombie_CustomSounds"
		})) then
		{
			private
			[
				"_snds"
			];
			
			_snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 0;
			[_unit, selectRandom _snds, 20] call CBA_fnc_Globalsay3D;
		} else {
			[_unit, selectRandom ["runned_or_middle_idle_1", "runned_or_middle_idle_2", "runned_or_middle_idle_3", "runned_or_middle_idle_4"], 25] call CBA_fnc_Globalsay3D;
		};
	};
	
	if (((animationState _unit) == "WBK_Runner_Calm_Idle") or ((animationState _unit) == "WBK_Runner_Calm_Walk")) then {
		[_unit, "WBK_Runner_Calm_to_Angry"] remoteExec ["switchMove", 0, true];
		[_unit, "WBK_Runner_Calm_to_Angry"] remoteExec ["playMoveNow", 0, true];
	};
	
	private
	[
		"_pos"
	];
	
	_pos = ASLtoAGL getPosASLVisual _nearEnemy;
	_unit domove _pos;
	
	if (!(isnil {
		_unit getVariable "WBK_Zombie_CustomSounds"
	})) then
	{
		private
		[
			"_snds"
		];
		
		_snds = (_unit getVariable "WBK_Zombie_CustomSounds") select 1;
		[_unit, selectRandom _snds, 20] call CBA_fnc_Globalsay3D;
	} else {
		[_unit, selectRandom ["plagued_attack_1", "plagued_attack_2", "plagued_attack_3", "plagued_attack_4", "plagued_attack_5", "plagued_attack_6", "plagued_attack_9"], 20] call CBA_fnc_Globalsay3D;
	};
};