
private ["_movposadmin","_combatgrp","_AI_init","_rifleman","_posadmin","_nameadmin"];
_posadmin 	= (_this select 0 select 0);
_nameadmin 	= (_this select 0 select 1);

stopreinforceme = "string";
iamdead = "string";
if (debug_adminhunt) then {diag_log format ["#AdminHunt: Admin %1 called in reinforcements at %2", _nameadmin, _posadmin];};

EAST setFriend[RESISTANCE,0];
EAST setFriend[INDEPENDENT,0];
EAST setFriend[WEST,1];
EAST setFriend[EAST,1];

_combatgrp = createGroup EAST;
_combatgrp setCombatMode "RED";

_AI_init = {
	(_this select 0) enableAI "TARGET";
	(_this select 0) enableAI "AUTOTARGET";
	(_this select 0) enableAI "MOVE";
	(_this select 0) enableAI "ANIM";
	(_this select 0) enableAI "FSM";
	(_this select 0) setskill 1;
	(_this select 0) allowDammage true;
	removeUniform 	 (_this select 0);
	removeHeadgear 	 (_this select 0);
	removeBackpack 	 (_this select 0);
	removeallitems 	 (_this select 0);
	removeAllWeapons (_this select 0);
	(_this select 0) forceAddUniform "U_C_Driver_3";
	(_this select 0) addVest "V_TacVest_blk_POLICE";
	(_this select 0) addHeadgear "H_CrewHelmetHeli_B";
	(_this select 0) addMagazines ["11Rnd_45ACP_Mag", 3];
	(_this select 0) addWeapon "hgun_Pistol_heavy_01_F";
	(_this select 0) addHandgunItem "optic_MRD";
};	

_rifleman = _combatgrp createUnit ["I_Soldier_TL_F", _posadmin, [], 5, "FORM"];
[_rifleman] call _AI_init;
_rifleman addWeapon "arifle_MX_SW_Black_F"; 
_rifleman addMagazines ["100Rnd_65x39_caseless_mag",6]; 
_rifleman addPrimaryWeaponItem "optic_Hamr";
_rifleman addPrimaryWeaponItem "acc_pointer_IR";  
_rifleman selectWeapon "arifle_MX_SW_Black_F";

/*  //-NOT IN USE-//
_sniper = _combatgrp createUnit ["I_Soldier_TL_F", _posadmin, [], 5, "FORM"];
[_sniper] call _AI_init;
_sniper addWeapon "srifle_DMR_05_blk_F"; 
_sniper addMagazines ["10Rnd_93x64_DMR_05_Mag",6]; 
_sniper addPrimaryWeaponItem "optic_DMS"; 
_sniper selectWeapon "srifle_DMR_05_blk_F";

_machinegunner = _combatgrp createUnit ["I_Soldier_TL_F", _posadmin, [], 5, "FORM"];
[_machinegunner] call _AI_init;
_machinegunner addWeapon "MMG_02_black_F"; 
_machinegunner addMagazines ["130Rnd_338_Mag",3]; 
_machinegunner addPrimaryWeaponItem "optic_Hamr";
_machinegunner addPrimaryWeaponItem "acc_pointer_IR";  
_machinegunner selectWeapon "MMG_02_black_F";
*/  //-NOT IN USE-//

_combatgrp selectLeader _rifleman;

while {true} do {
	if ((movingadmin select 1) == (_nameadmin)) then {
		_movposadmin = (movingadmin select 0);
	};
	_combatgrp move _movposadmin;
	
	if ((stopreinforceme) == (_nameadmin)) exitWith {
		diag_log format ["#AdminHunt: Admin %1 stopped the AdminHunt, deleting AI's", _nameadmin];
		deleteVehicle _rifleman;
		//deleteVehicle _sniper;
		//deleteVehicle _machinegunner;
	};

	if ((iamdead) == (_nameadmin)) exitWith {
		if (debug_adminhunt) then {diag_log format ["#AdminHunt: Admin %1 died, cleaning up AI's in 10 minutes", _nameadmin];};
		uiSleep 600;
		deleteVehicle _rifleman;
		//deleteVehicle _sniper;
		//deleteVehicle _machinegunner;
		if (debug_adminhunt) then {diag_log format ["#AdminHunt: Admin %1 died, cleaning up AI's now", _nameadmin];};
	};
	uiSleep 5;
};
