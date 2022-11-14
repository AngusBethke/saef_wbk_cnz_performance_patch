/*
	WBK_AI_Tatzelwurm.sqf

	Description:
		Handles Tatzelwurm Zombie AI
*/

if (!isNil "RS_fnc_LoggingHelper") then
{
	["WBK_AI_Tatzelwurm", 0, "Loaded SAEF optimised version..."] call RS_fnc_LoggingHelper;
};

private
[
	"_unitWithSword"
];

_unitWithSword = _this;

if (getText (configfile >> 'CfgVehicles' >> typeOf _unitWithSword >> 'moves') != 'CfgMovesMaleSdr') exitWith 
{
	systemChat "Wrong skeleton type. Cannot load AI.";
};

if ((isPlayer _unitWithSword) or !(isNil {_unitWithSword getVariable "WBK_AI_ISZombie"}) or !(alive _unitWithSword)) exitWith {};

removeAllWeapons _unitWithSword; 
removeAllItems _unitWithSword; 
removeAllAssignedItems _unitWithSword; 
removeUniform _unitWithSword; 
removeVest _unitWithSword; 
removeBackpack _unitWithSword; 
removeHeadgear _unitWithSword; 
removeGoggles _unitWithSword; 

_unitWithSword forceAddUniform selectRandom ["Zombie_BioHazard","Zombie3_BioHazard"];

// Set up zombie variables
[_unitWithSword] call WBK_AI_SetupDefaultZombieVariables;
[_unitWithSword, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
_unitWithSword setVariable ["WBK_AI_ZombieMoveSet", "Star_Wars_KaaTirs_idle", true];
_unitWithSword setVariable ["IMS_IsAnimPlayed", 0, true];
_unitWithSword setVariable ["actualSwordBlock", 0, true];
_unitWithSword setVariable ["canMakeAttack", 0, true];
_unitWithSword setVariable ["AI_CanTurn", 0];
_unitWithSword setVariable ["AI_IsTatzelwurm", 0, true];
_unitWithSword setVariable ["canMakeSpecialAttack", 0];
_unitWithSword setVariable ["concentrationParam", 100, true];
_unitWithSword setVariable ["IMS_ISAI", 1, true];
_unitWithSword setVariable ["WBK_SynthHP", WBK_Zombies_LeaperHP,true];

// Set up hit part event handler
[_unitWithSword, {
	_this removeAllEventHandlers "HitPart";
	_this addEventHandler [
		"HitPart",
		{
			(_this select 0) params ["_target","_shooter","_bullet","_position","_velocity","_selection","_ammo","_direction","_radius","_surface","_direct"];
			
			if ((_target == _shooter) or (isNull _shooter) or !(alive _target)) exitWith {};

			_ammo params
			[
				"_isEnoughDamage",
				"_someSecondVar",
				"_someThirdVar",
				"_isExplosive"
			];
			
			if !(isNil "WBK_ZombiesShowDebugDamage") then 
			{
				systemChat str _isEnoughDamage;
			};

			private
			[
				"_vv",
				"_new_vv"
			];

			_vv = _target getVariable "WBK_SynthHP";
			_new_vv = _vv - _isEnoughDamage;

			if (_new_vv <= 0) exitWith 
			{
				_target removeAllEventHandlers "HitPart"; 
				_target setDamage 1;
				_rndAnim = selectRandom ["WBK_Leaper_Death_1","WBK_Leaper_Death_2"];
				[_target, _rndAnim] remoteExec ["switchMove", 0]; 
			};

			_target setVariable ["WBK_SynthHP",_new_vv,true];
			_target enableAI "MOVE";
		}
	];
}] remoteExec ["spawn", [0,-2] select isDedicated,true];

// Set up killed event handler
_unitWithSword addEventHandler ["Killed", {
	params
	[
		"_creature",
		"_killer"
	];

	if (!(isNil {_creature getVariable "WBK_Zombie_CustomSounds"})) then 
	{
		private
		[
			"_snds"
		];

		_snds = (_creature getVariable "WBK_Zombie_CustomSounds") select 3;
		[_creature, selectRandom _snds, 80, 6] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	}
	else
	{
		private
		[
			"_rndSnd"
		];

		_rndSnd = ["leaper_death_1","leaper_death_2"] call BIS_fnc_SelectRandom;
		[_creature, _rndSnd, 80, 10] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	};
}];

_unitWithSword spawn {
	sleep 0.5;
	_this doMove (getPos _this);
};

Rakghul_setHitOrDeflect = {
	params
	[
		"_unit",
		"_unitToPlay",
		"_animation"
	];

	sleep 0.01;

	if (!(_unit isKindOf "WBK_Horses_ExportClass") and 
		!(_unit isKindOf "WBK_C_ExportClass") and 
		(isNil {_unit getVariable "IMS_IsUnitInvicibleScripted"}) and 
		((_unit distance _unitToPlay) <= 2.5) and 
		(alive _unit) and 
		(alive _unitToPlay) and 
		(simulationEnabled _unitToPlay) and 
		(animationState _unitToPlay == _animation)) then 
	{
		private
		[
			"_isBehindGeometry"
		];

		_isBehindGeometry = lineIntersects [ eyePos _unitToPlay, eyePos _unit, _unitToPlay, _unit];

		if (!_isBehindGeometry) then 
		{
			if (!(((_unitToPlay worldToModel (_unit modelToWorld [0, 0, 0])) select 1) < 0)) then 
			{
				if ((_unit getVariable "actualSwordBlock" == 1) and (hmd _unit in IMS_Sheilds)) then 
				{
					if (((_unit worldToModel (_unitToPlay modelToWorld [0, 0, 0])) select 1) < 0) then 
					{
						private
						[
							"_rndSnd"
						];

						_rndSnd = selectRandom ["sword_hit_2","sword_hit_3"];  
						[_unit, _rndSnd, 50, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

						if ((_animation == "Star_Wars_KaaTirs_attack_1") and !(_unit isKindOf "TIOWSpaceMarine_Base")) exitWith 
						{
							[_unit, selectRandom ["A_PlayerDeathAnim_17","A_PlayerDeathAnim_10","A_PlayerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
							_unit setDamage 1;

							[_unit, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
							_unit unlinkItem hmd _unit;
							removeGoggles _unit;
							removeHeadgear _unit;
							
							[_unit, {
								// Ensuring headless clients aren't caught by this
								if (!hasInterface) exitWith {};
								[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
							}] remoteExec ["spawn", [0,-2] select isDedicated,false];
						};

						[_unit, 0.1, _unitToPlay] remoteExec ["WBK_CreateDamage", _unit, false];  
						[_unit, _unitToPlay] remoteExec ["WBK_CreateMeleeHitAnim", _unit, false]; 
					}
					else
					{
						if ((animationState _unit == "starWars_force_landRoll") or (animationState _unit == "starWars_force_landRoll_b")) exitWith {};

						[_unit, 228, _unitToPlay] remoteExec ["concentrationToZero", _unit, false];  
						[_unitToPlay, "WBK_ZombieHitGest_3"] remoteExec ["playActionNow", _unitToPlay]; 
						[_unitToPlay] spawn Rakghul_Dodge;

						private
						[
							"_rndSnd"
						];

						_rndSnd = selectRandom ["wood_block_1","wood_block_2","wood_block_3"];  
						[_unit, _rndSnd, 50, 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
					};
				}
				else
				{
					private
					[
						"_rndSnd"
					];

					_rndSnd = selectRandom ["sword_hit_2","sword_hit_3"];  
					[_unit, _rndSnd, 50, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  

					if ((_animation == "Star_Wars_KaaTirs_attack_1") and !(_unit isKindOf "TIOWSpaceMarine_Base")) exitWith 
					{
						[_unit, selectRandom ["A_PlayerDeathAnim_17","A_PlayerDeathAnim_10","A_PlayerDeathAnim_20"]] remoteExec ["switchMove", 0, false];
						_unit setDamage 1;

						[_unit, selectRandom ["decapetadet_sound_1","decapetadet_sound_2"], 60, 4] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
						_unit unlinkItem hmd _unit;
						removeGoggles _unit;
						removeHeadgear _unit;

						[_unit, {
							// Ensuring headless clients aren't caught by this
							if (!hasInterface) exitWith {};
							[_this, "WBK_DecapatedHead_Normal"] spawn WBK_HeadDestructionWithBlood;
						}] remoteExec ["spawn", [0,-2] select isDedicated,false];
					};

					[_unit, 0.1, _unitToPlay] remoteExec ["WBK_CreateDamage", _unit, false]; 
					[_unit, _unitToPlay] remoteExec ["WBK_CreateMeleeHitAnim", _unit, false];  
				};
			};
		};
	};
};

Rakghul_Attack = {
	params
	[
		"_creature"
	];

	if (!(alive _creature) or 
		!(_creature getVariable "canMakeAttack" == 0) or 
		(animationState _creature == "Star_Wars_KaaTirs_scream") or 
		(animationState _creature == "Star_Wars_KaaTirs_attack_execution_creature") or 
		(animationState _creature == "Star_Wars_KaaTirs_stanned")) exitWith {};

	if (!(isNil {_creature getVariable "WBK_Zombie_CustomSounds"})) then 
	{
		private
		[
			"_snds"
		];

		_snds = (_creature getVariable "WBK_Zombie_CustomSounds") select 1;
		[_creature, selectRandom _snds, 70] call CBA_fnc_GlobalSay3D;
	}
	else
	{
		[_creature, selectRandom ["leaper_attack_1","leaper_attack_2","leaper_attack_3","leaper_attack_4","leaper_attack_5"], 80] call CBA_fnc_GlobalSay3D;
	};

	if (animationState _creature == "Star_Wars_KaaTirs_dodge") exitWith 
	{
		[_creature, "Star_Wars_KaaTirs_attack_1"] remoteExec ["switchMove", 0];
		_creature setVariable ["canMakeAttack",1, true];
		sleep 0.1;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_1") or !(alive _creature)) exitWith 
		{
			_creature setVariable ["AI_CanTurn",0, true];
			_creature setVariable ["canMakeAttack",0, true];
		};

		[_creature, [13 * (sin (getdir _creature )), 13 * (cos (getdir _creature)), 1.9]] remoteExec ["setvelocity", _creature];
		_creature setVariable ["AI_CanTurn",1, true];
		_rndSnd = selectRandom ["axe_punch_empty_1","axe_punch_empty_2","axe_punch_empty_3"];  
		[_creature, _rndSnd, 50, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
		sleep 0.3;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_1") or !(alive _creature)) exitWith {};

		[_creature findNearestEnemy _creature, _creature,  "Star_Wars_KaaTirs_attack_1"] spawn Rakghul_setHitOrDeflect;
		sleep 0.8;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_1") or !(alive _creature)) exitWith {};

		_creature setVariable ["AI_CanTurn",0, true];
		_creature setVariable ["canMakeAttack",0, true];
		[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
	};

	if ((animationState _creature == "Star_Wars_KaaTirs_attack_2")) exitWith 
	{
		[_creature, "Star_Wars_KaaTirs_attack_3"] remoteExec ["switchMove", 0];
		_creature setVariable ["canMakeAttack",1, true];
		sleep 0.1;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_3") or !(alive _creature)) exitWith 
		{
			_creature setVariable ["AI_CanTurn",0, true];
			_creature setVariable ["canMakeAttack",0, true];
		};

		[_creature, [7 * (sin (getdir _creature )), 7 * (cos (getdir _creature)), 1.4]] remoteExec ["setvelocity", _creature];
		_creature setVariable ["AI_CanTurn",1, true];
		_rndSnd = selectRandom ["axe_punch_empty_1","axe_punch_empty_2","axe_punch_empty_3"];  
		[_creature, _rndSnd, 50, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  

		sleep 0.2;
		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_3") or !(alive _creature)) exitWith {};

		[_creature findNearestEnemy _creature, _creature,  "Star_Wars_KaaTirs_attack_3"] spawn Rakghul_setHitOrDeflect;
		sleep 0.4;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_3") or !(alive _creature)) exitWith {};

		_creature setVariable ["AI_CanTurn",0, true];
		_creature setVariable ["canMakeAttack",0, true];
		sleep 0.8;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_3") or !(alive _creature)) exitWith {};

		[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
	};

	if ((animationState _creature == "Star_Wars_KaaTirs_attack_3")) exitWith 
	{
		[_creature, "Star_Wars_KaaTirs_attack_4"] remoteExec ["switchMove", 0];
		_creature setVariable ["canMakeAttack",1, true];
		sleep 0.3;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_4") or !(alive _creature)) exitWith 
		{
			_creature setVariable ["AI_CanTurn",0, true];
			_creature setVariable ["canMakeAttack",0, true];
		};

		[_creature, [7 * (sin (getdir _creature )), 7 * (cos (getdir _creature)), 1.4]] remoteExec ["setvelocity", _creature];
		_creature setVariable ["AI_CanTurn",1, true];
		_rndSnd = selectRandom ["axe_punch_empty_1","axe_punch_empty_2","axe_punch_empty_3"];  
		[_creature, _rndSnd, 50, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
		sleep 0.2;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_4") or !(alive _creature)) exitWith {};

		[_creature findNearestEnemy _creature, _creature,  "Star_Wars_KaaTirs_attack_4"] spawn Rakghul_setHitOrDeflect;
		sleep 0.8;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_4") or !(alive _creature)) exitWith {};
		
		_creature setVariable ["AI_CanTurn",0, true];
		_creature setVariable ["canMakeAttack",0, true];
		sleep 0.4;

		if (!(animationState _creature == "Star_Wars_KaaTirs_attack_4") or !(alive _creature)) exitWith {};

		[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
	};

	[_creature, "Star_Wars_KaaTirs_attack_2"] remoteExec ["switchMove", 0];
	_creature setVariable ["canMakeAttack",1, true];
	sleep 0.3;

	if (!(animationState _creature == "Star_Wars_KaaTirs_attack_2") or !(alive _creature)) exitWith 
	{
		_creature setVariable ["AI_CanTurn",0, true];
		_creature setVariable ["canMakeAttack",0, true];
	};

	[_creature, [7 * (sin (getdir _creature )), 7 * (cos (getdir _creature)), 1.4]] remoteExec ["setvelocity", _creature];
	_creature setVariable ["AI_CanTurn",1, true];
	_rndSnd = selectRandom ["axe_punch_empty_1","axe_punch_empty_2","axe_punch_empty_3"];  
	[_creature, _rndSnd, 50, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
	sleep 0.2;

	if (!(animationState _creature == "Star_Wars_KaaTirs_attack_2") or !(alive _creature)) exitWith {};

	[_creature findNearestEnemy _creature, _creature,  "Star_Wars_KaaTirs_attack_2"] spawn Rakghul_setHitOrDeflect;
	sleep 0.5;

	if (!(animationState _creature == "Star_Wars_KaaTirs_attack_2") or !(alive _creature)) exitWith {};

	_creature setVariable ["AI_CanTurn",0, true];
	_creature setVariable ["canMakeAttack",0, true];
	sleep 0.4;

	if (!(animationState _creature == "Star_Wars_KaaTirs_attack_2") or !(alive _creature)) exitWith {};

	[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
};

Rakghul_Scream = {
	params
	[
		"_creature"
	];
	
	if ((alive _creature) and (_creature getVariable "canMakeAttack" == 0) and !(animationState _creature == "Star_Wars_KaaTirs_scream")) then 
	{
		_creature allowDamage false;
		_creature setVariable ["AI_CanTurn",1, true];
		_creature setVariable ["canMakeAttack",1, true];
		[_creature, "Star_Wars_KaaTirs_scream"] remoteExec ["switchMove", 0];

		if (!(isNil {_creature getVariable "WBK_Zombie_CustomSounds"})) then 
		{
			private
			[
				"_snds"
			];

			_snds = (_creature getVariable "WBK_Zombie_CustomSounds") select 2;
			[_creature, selectRandom _snds, 360, 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		}
		else
		{
			[_creature, "leaper_scream", 360, 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
		};

		sleep 0.6;

		if (!(animationState _creature == "Star_Wars_KaaTirs_scream") or !(alive _creature)) exitWith {};

		{ 
			if (!(uniform _x == "Zombie_BioHazard") and 
				!(uniform _x == "Zombie2_BioHazard") and 
				!(uniform _x == "Zombie3_BioHazard") and 
				!(animationState _x == "starWars_force_landRoll_weapon") and 
				!(animationState _x == "starWars_force_landRoll_b_weapon") and 
				!(animationState _x == "starWars_force_landRoll_b") and 
				!(animationState _x == "starWars_force_landRoll") and 
				(alive _x) and 
				!(_x == _creature) and 
				(alive _creature) and 
				(simulationEnabled _creature)) then 
			{
				_isBehindGeometry = lineIntersects [ eyePos _creature, eyePos _x, _creature, _x];

				if (!_isBehindGeometry) then 
				{
					if (!(((_creature worldToModel (_x modelToWorld [0, 0, 0])) select 1) < 0)) then 
					{
						[_x, 228, _creature] spawn concentrationToZero;
					};
				};
			};
		} forEach nearestObjects [getPosATL  _creature, ["MAN"], 5.3];

		sleep 1;

		if (!(animationState _creature == "Star_Wars_KaaTirs_scream") or !(alive _creature)) exitWith {};

		_creature setVariable ["AI_CanTurn",0, true];
		_creature setVariable ["canMakeAttack",0, true];
		sleep 0.3;

		if (!(animationState _creature == "Star_Wars_KaaTirs_scream") or !(alive _creature)) exitWith {};

		[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
	};
};

Rakghul_Dodge = {
	params
	[
		"_creature"
	];

	if ((alive _creature) and (_creature getVariable "canMakeAttack" == 0) and !(animationState _creature == "Star_Wars_KaaTirs_dodge") and !(animationState _creature == "plagued_armed_run_dodge")) then 
	{
		_creature allowDamage false;
		_creature setVariable ["actualSwordBlock",1, true];
		_creature setVariable ["AI_CanTurn",1, true];
		_creature setVariable ["canMakeAttack",1, true];
		_creature setVariable ["IMS_IsUnitInvicibleScripted",1, true];
		[_creature, "Star_Wars_KaaTirs_dodge"] remoteExec ["switchMove", 0];
		sleep 0.3;

		if (!(animationState _creature == "Star_Wars_KaaTirs_dodge") or !(alive _creature)) exitWith {};
		
		[_creature, [-10 * (sin (getdir _creature )), -10 * (cos (getdir _creature)), 1.7]] remoteExec ["setvelocity", _creature];
		sleep 0.5;

		if (!(animationState _creature == "Star_Wars_KaaTirs_dodge") or !(alive _creature)) exitWith {};

		_creature setVariable ["actualSwordBlock",0, true];
		_creature setVariable ["AI_CanTurn",0, true];
		_creature setVariable ["canMakeAttack",0, true];
		_creature setVariable ["IMS_IsUnitInvicibleScripted",nil, true];
		sleep 0.25;

		if (!(animationState _creature == "Star_Wars_KaaTirs_dodge") or !(alive _creature)) exitWith {};

		[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
	};
};

Rakghul_Execution_Victim = {
	params
	[
		"_creature",
		"_unit"
	];

	_creature setVariable ["canMakeSpecialAttack",1];
	
	{ 
		deleteVehicle _x;
	} forEach nearestObjects [_creature, ["Land_HelipadEmpty_F"], 2]; 

	_creature setDamage 0;
	_unit setDamage 1;
	_unit setVariable ["actualSwordBlock",0, true];
	_unit setVariable ["AI_CanTurn",1, true];
	_unit setVariable ["canMakeAttack",1, true];
	_unit disableAI "ALL";
	_creature setVariable ["actualSwordBlock",0, true];
	_creature setVariable ["AI_CanTurn",1, true];
	_creature setVariable ["canMakeAttack",1, true];
	[_creature, _unit] remoteExecCall ["disableCollisionWith", 0, _unit];
	removeAllWeapons _creature; 
	_creature attachTo [_unit,[0,1.1,0]]; 
	[_unit, "dead"] remoteExec ["setMimic", 0];
	[_unit, "Disable_Gesture"] remoteExec ["playActionNow", 0];
	[_creature, "Disable_Gesture"] remoteExec ["playActionNow", 0];
	[_unit, "Star_Wars_KaaTirs_attack_execution_victim"] remoteExec ["switchMove", 0];
	[_creature, "Star_Wars_KaaTirs_attack_execution_creature"] remoteExec ["switchMove", 0];
	[_unit, "rakgul_specAttack_victim", 50, 8] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

	if (isNil {_creature getVariable "WBK_Zombie_CustomSounds"}) then 
	{
		[_creature, "rakgul_specAttack_attacker", 50, 8] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
	};

	sleep 4;

	_unit setDamage 1;
	detach _creature;
	_creature setVariable ["actualSwordBlock",0, true];
	_creature setVariable ["AI_CanTurn",0, true];
	_creature setVariable ["canMakeAttack",0, true];

	if (animationState _creature == "Star_Wars_KaaTirs_attack_execution_creature") then 
	{
		[_creature, "Star_Wars_KaaTirs_idle"] remoteExec ["switchMove", 0];
		_creature setVariable ["canMakeSpecialAttack",0];
		[_creature, ((getDir _creature) - 180)] remoteExec ["setDir", 0];
	};
};

animPush = {
	params
	[
		"_unit",
		"_anim"
	];

	_myNearestEnemy = _unit findNearestEnemy _unit;
	_ifInter = lineIntersectsSurfaces [
			AGLToASL (_myNearestEnemy modelToWorld [0,0,0.1]), 
			AGLToASL (_unit modelToWorld [0,0,0.1]), 
			_unit,
			_myNearestEnemy,
			true,
			1,
			"GEOM",
			"NONE"
		];

	if ((_unit getVariable "IMS_IsAnimPlayed" == 0) and 
		(alive _unit) and 
		(_unit getVariable "canMakeAttack" == 0) and 
		(isTouchingGround _unit) and 
		(count _ifInter == 0) and 
		!(animationState _unit == "starWars_lightsaber_block_1") and 
		!(animationState _unit == "starWars_lightsaber_block_2") and 
		!(animationState _unit == "starWars_lightsaber_block_3") and 
		!(animationState _unit == "starWars_lightsaber_hit_1") and 
		!(animationState _unit == "starWars_lightsaber_hit_2") and 
		!(animationState _unit == "starWars_lightsaber_blockPursuit")) then 
	{
		_unit setVariable ["IMS_IsAnimPlayed",1, true];
		sleep 0.5;

		if ((_unit getVariable "canMakeAttack" == 0)) then 
		{
			_unit playMoveNow _anim;
		};

		sleep 1;
		_unit setVariable ["IMS_IsAnimPlayed",0, true];
	};
};

rakgul_DodgeAndScream = {
	params
	[
		"_mutant"
	];

	[_mutant] spawn Rakghul_Dodge;
	_mutant setVariable ["canMakeSpecialAttack",1];
	sleep 1;
	[_mutant] spawn Rakghul_Scream;
	sleep 20;
	_mutant setVariable ["canMakeSpecialAttack",0];
};

rakgul_DodgeAndAttack = {
	params
	[
		"_mutant"
	];

	[_mutant] spawn Rakghul_Dodge;
	_mutant setVariable ["canMakeSpecialAttack",1];
	sleep 0.84;
	[_mutant] spawn Rakghul_Attack;
	sleep 10;
	_mutant setVariable ["canMakeSpecialAttack",0];
};

_actFr = [{
    params ["_array"];
	_array params ["_mutant"];

    _mutant action ["SwitchWeapon", _mutant, _mutant, 100]; 
	_mutant allowDamage false;
	_mutant disableAI "MINEDETECTION";
	_mutant disableAI "WEAPONAIM";
	_mutant disableAI "SUPPRESSION";
	_mutant disableAI "COVER";
	_mutant disableAI "AIMINGERROR";
	_mutant disableAI "TARGET";
	_mutant disableAI "AUTOCOMBAT";
	_mutant disableAI "FSM";
	_mutant setBehaviour "CARELESS";  
	
	{ 
		_ifInter = lineIntersects [ getPosASL _mutant, eyePos _x, _mutant, _x];

		if (!(_ifInter)) then {
			 _mutant reveal [_x, 4]; 
		};
	} forEach nearestObjects [_mutant, ["Man"], 40];  

	_myNearestEnemy = _mutant findNearestEnemy _mutant;

	if (!(gestureState _mutant == "WBK_ZombieHitGest_3") and 
		!(gestureState _mutant == "WBK_ZombieHitGest_1") and 
		!(gestureState _mutant == "WBK_ZombieHitGest_2") and 
		(_mutant getVariable "canMakeAttack" == 0) and 
		((_myNearestEnemy distance _mutant) <= 3.8) and 
		(alive _mutant) and 
		!(animationState _mutant == "Star_Wars_KaaTirs_stanned") and 
		!(animationState _mutant == "starWars_lightsaber_hit_1") and 
		!(animationState _mutant == "starWars_lightsaber_hit_2") and 
		!(animationState _mutant == "Star_Wars_KaaTirs_executionOnCreature_creature")) then 
	{
		if (_mutant getVariable "canMakeSpecialAttack" == 0) exitWith 
		{
			_rndFnc = selectRandom [rakgul_DodgeAndScream,rakgul_DodgeAndAttack];
			[_mutant] spawn _rndFnc;
		};

		if (((damage _myNearestEnemy) >= 0.4) and 
			(isNil {_myNearestEnemy getVariable "IMS_IsUnitInvicibleScripted"}) and 
			!(_myNearestEnemy isKindOf "TIOWSpaceMarine_Base")) exitWith 
		{
			[_mutant, _myNearestEnemy] spawn Rakghul_Execution_Victim;
		};

		[_mutant] spawn Rakghul_Attack;
	};
}, 0.2, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

_loopPathfind = [{
    params ["_array"];
	_array params ["_unit"];

	_nearEnemy = _unit findNearestEnemy _unit; 
    if (!(isNull _nearEnemy) and (alive _nearEnemy) and (alive _unit)) then 
	{
		// Ensuring hard work is not done on each frame
		if ((_unit distance _nearEnemy >= 40)) exitWith {};

		_ifInter = lineIntersectsSurfaces [
			AGLToASL (_nearEnemy modelToWorld [0,0,0.9]), 
			AGLToASL (_unit modelToWorld [0,0,0.9]), 
			_unit,
			_nearEnemy,
			true,
			1,
			"GEOM",
			"NONE"
		];

		if ((_unit getVariable "AI_CanTurn" == 0) and 
			(isTouchingGround _unit) and
			(count _ifInter == 0) and 
			(_unit distance _nearEnemy < 40) and
			((getPosATL _nearEnemy select 2) < 1.45)) exitWith 
		{
			_unit disableAI "PATH";
			_unit disableAI "ANIM";
			doStop _unit;
			[_unit, selectRandom ["Star_Wars_KaaTirs_RunF","Star_Wars_KaaTirs_RunLF","Star_Wars_KaaTirs_RunRF"]] spawn animPush;

			private
			[
				"_dir"
			];

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
		};
	}; 
}, 0.01, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

_loopPathfindDoMove = [{
    params ["_array"];
	_array params ["_unit"];

	_nearEnemy = _unit findNearestEnemy _unit; 

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
		[_unit, selectRandom ["leaper_idle_1","leaper_idle_2"], 20] call CBA_fnc_GlobalSay3D;
	};

    if (!(isNull _nearEnemy) and (alive _nearEnemy) and (alive _unit)) then 
	{
		_ifInter = lineIntersectsSurfaces [
			AGLToASL (_nearEnemy modelToWorld [0,0,0.1]), 
			AGLToASL (_unit modelToWorld [0,0,0.1]), 
			_unit,
			_nearEnemy,
			true,
			1,
			"GEOM",
			"NONE"
		];

		if ((_unit distance _nearEnemy > 40) or (!(count _ifInter == 0)) or ((getPosATL _nearEnemy select 2) >= 1.45)) exitWith {
			_unit enableAI "PATH";
			_unit enableAI "ANIM";
			_unit enableAI "MOVE";
			_unit doMove [getPos _nearEnemy select 0, getPos _nearEnemy select 1, 0];
		};
	}; 
}, 3, [_unitWithSword]] call CBA_fnc_addPerFrameHandler;

waitUntil {
	sleep 0.5; 
	!(alive _unitWithSword)
};

[_actFr] call CBA_fnc_removePerFrameHandler;
[_loopPathfind] call CBA_fnc_removePerFrameHandler;
[_loopPathfindDoMove] call CBA_fnc_removePerFrameHandler;
_unitWithSword removeAllEventHandlers "HandleDamage";