class CfgPatches
{
	class SAEF_WBK_ZombieCreatures_PerfPatch
	{
		name="SAEF_WBK_ZombieCreatures_PerfPatch";
		author="Rabid Squirrel";
		requiredVersion=1.6;
		requiredAddons[]=
		{
			"WBK_ZombieCreatures"
		};
		units[]=
		{
			
		};
	};
};
class Extended_InitPost_EventHandlers
{
	class Zombie_Special_OPFOR_Leaper_1
	{
		class ZombieSpecial_Leaper_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit execVM ""\saef_wbk_cnz_performance_patch\AI\WBK_AI_Tatzelwurm.sqf"";};";
		};
	};
	class Zombie_Special_OPFOR_Screamer
	{
		class ZombieSpecial_Screamer_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit execVM ""\saef_wbk_cnz_performance_patch\AI\WBK_AI_Stunden.sqf"";};";
		};
	};
	class Zombie_Special_OPFOR_Boomer
	{
		class ZombieSpecial_Blower_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit execVM ""\saef_wbk_cnz_performance_patch\AI\WBK_AI_ZombieExplosion.sqf"";};";
		};
	};
	class Zombie_O_Crawler_CSAT
	{
		class Zombie_Crawler_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit spawn {[_this, getText (configFile >> 'CfgVehicles' >> typeOf _this >> 'WBK_ZombiesOriginalFactionClass')] spawn WBK_ZombiesRandomEquipment; sleep 0.1; [_this, true] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Walker.sqf';};};";
		};
	};
	class Zombie_O_Walker_CSAT
	{
		class Zombie_Walker_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit spawn {[_this, getText (configFile >> 'CfgVehicles' >> typeOf _this >> 'WBK_ZombiesOriginalFactionClass')] spawn WBK_ZombiesRandomEquipment; sleep 0.1; [_this, false] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Walker.sqf';};};";
		};
	};
	class Zombie_O_Shambler_CSAT
	{
		class Zombie_Shambler_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit spawn {[_this, getText (configFile >> 'CfgVehicles' >> typeOf _this >> 'WBK_ZombiesOriginalFactionClass')] spawn WBK_ZombiesRandomEquipment; sleep 0.1; _this execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Middle.sqf';};};";
		};
	};
	class Zombie_O_RunnerCalm_CSAT
	{
		class Zombie_RunnerCalm_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit spawn {[_this, getText (configFile >> 'CfgVehicles' >> typeOf _this >> 'WBK_ZombiesOriginalFactionClass')] spawn WBK_ZombiesRandomEquipment; sleep 0.1; [_this, true] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Runner.sqf';};};";
		};
	};
	class Zombie_O_RunnerAngry_CSAT
	{
		class Zombie_RunnerAngry_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit spawn {[_this, getText (configFile >> 'CfgVehicles' >> typeOf _this >> 'WBK_ZombiesOriginalFactionClass')] spawn WBK_ZombiesRandomEquipment; sleep 0.1; [_this, false] execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Runner.sqf';};};";
		};
	};
	class Zombie_O_Shooter_CSAT
	{
		class Zombie_Shooter_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit spawn {[_this, getText (configFile >> 'CfgVehicles' >> typeOf _this >> 'WBK_ZombiesOriginalFactionClass')] spawn WBK_ZombiesRandomEquipment; sleep 0.1; _this execVM '\saef_wbk_cnz_performance_patch\AI\WBK_ShooterZombie.sqf';};};";
		};
	};
	class WBK_SpecialZombie_Smasher_1
	{
		class Zombie_Smasher_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_Smasher.sqf';};";
		};
	};
	class WBK_SpecialZombie_Corrupted_1
	{
		class Zombie_CorruptedHead_Init
		{
			init="_unit = _this select 0; if (local _unit) then {_unit execVM '\saef_wbk_cnz_performance_patch\AI\WBK_AI_CorruptedHead.sqf';};";
		};
	};
};
class Extended_PreInit_EventHandlers
{
	class WBK_Zombies_PreInit
	{
		init="call compile preprocessFileLineNumbers '\saef_wbk_cnz_performance_patch\bootstrap\XEH_preInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers
{
	class WBK_Zombies_PostInit
	{
		init="call compile preprocessFileLineNumbers '\saef_wbk_cnz_performance_patch\bootstrap\XEH_postInit.sqf'";
	};
};
