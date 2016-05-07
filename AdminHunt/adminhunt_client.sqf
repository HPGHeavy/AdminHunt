/* --- All credits to 5nine and NibbleGaming for initial release --- */
/* --- Ported/modified by Heavy for A3 Exile --- */

private ["_marker","_crate","_start","_stop","_exit","_hint","_nameadmin","_reinforcements","_reinforce","_markercolor","_markertext","_markername","_markeradmin"];

_nameadmin = name player;
player setCaptive false;
starthunt = false;  //needs to be a global variable for addaction to work
stophunt = false;	//needs to be a global variable for addaction to work
exitmenu = false;	//needs to be a global variable for addaction to work
reinforce = false;	//needs to be a global variable for addaction to work
_reinforcements = false;
player removeAction missionmenu;
	
	/* --- Give admin the mission menu --- */
	
_start = player addaction ["<t color='#00FF00'>Start Admin Hunt</t><t color='#30FF00'> - Get Ready - </t>",{starthunt = true;},"",-93,false,false,"",""]; 
_exit = player addaction ["<t color='#FFFFFF'>Exit Hunt Menu</t>",{exitmenu = true;},"",-95,false,false,"",""];
	
	/* --- Wait for admins to activate mission --- */
	
waitUntil {starthunt or exitmenu};
if (exitmenu) then {
	player removeAction _start; 
	player removeAction _exit;
};

if (starthunt) then {
	player removeAction _start;
	player removeAction _exit; 
	_stop = player addaction ["<t color='#FFFF00'>Terminate Admin Hunt</t>",{stophunt = true;},"",-94,false,false,"",""];
	_reinforce = player addaction ["<t color='#55FF00'>Get Reinforcements</t>",{reinforce = true;},"",-93,false,false,"",""];
	if (debug_adminhunt) then {diag_log "#AdminHunt: starting mission";};
			
	/* --- Give players the hint --- */
	
	_hint = format ["<t align='center' size='2.0' color='#f29420'>Mission:<br/>Admin Hunt!</t><br/>
	<t size='1.25' color='#ffff00'>Admin %1 activated the Hunt-An-Admin mission! Check your map for marker and go kill him!</t>",_nameadmin];
	MissionHint = [0, _hint]; publicVariable "MissionHint";

	/* --- Give admin the hint and sound as well, for good measures of course --- */

	hint parseText format["%1", _hint];
	playSound "UAV_05";

	/* --- Create the marker --- */
	
	_markercolor = ["ColorRed","ColorPink"] call BIS_fnc_selectRandom;
	_markertext  = format [" Admin Hunt: %1",_nameadmin];
	_markername  = format ["marker: %1",_nameadmin];
	_markeradmin = createMarker [_markername, getPos player];
	_markeradmin setMarkerShape "ICON";
	_markeradmin setMarkerType "Select";
	_markeradmin setMarkerColor _markercolor;
	_markeradmin setMarkerText _markertext;

	/* ---   The actual mission --- */
	
	if (isNil "marker_refreshtime") then {
		marker_refreshtime = 5;
	};
	
	[_markeradmin] spawn {
	while {alive player} do {
		_markeradmin = _this select 0;
		_markeradmin setMarkerPos getPos player;
		sleep marker_refreshtime;
			if (!alive player) exitWith {
				deletemarker _markeradmin;
			};
		if (stophunt) exitWith {};
		};
	};
	
	while {alive player} do {
		if (reinforce) then {
		
			/* --- Add event handler if something goes wrong when player dies, too make sure AI fire at him after respawn --- */
			
			player addEventHandler ["killed", {
			player setCaptive false; //probably not needed
			}];

			/* --- Spawn AI's --- */
			
			reinforce = false;	
			player setCaptive true;
			_reinforcements = true;
			player removeaction _reinforce;
			movingadmin = [Getpos player,_nameadmin];
			PublicVariableServer "movingadmin";			
			reinforceme = [getpos player,_nameadmin];			
			PublicVariableServer "reinforceme";
			
			_hint = format ["<t align='center' size='2.0' color='#f29420'>Mission:<br/>Reinforcements Spawned!</t><br/>
			<t align='left' size='1.25' color='#ffff00'>Admin %1 feels threatened and requested an AI bodyguard. Kill him and his backup!</t>",_nameadmin];
			MissionHint = [2, _hint]; publicVariable "MissionHint";
			hint parseText format["%1", _hint];
			playSound "UAV_04";
			
			[] spawn {
				while {alive player} do {
					player setCaptive true;
					uiSleep 0.5;
					if (stophunt) exitWith {};
					_plyrdist = getpos player;
					uiSleep 5;
						if ((player distance _plyrdist) > 5) then {
							movingadmin = [Getpos player,name player];
							PublicVariableServer "movingadmin";
						};
					uiSleep 2;
				};
			};
		};

		if (stophunt) exitWith {
		
		/* --- Mission stopped --- */

			_hint = format ["<t align='center' size='2.0' color='#6bab3a'>Mission: Aborted!</t><br/>
			<t align='left' size='1.25' color='#ffff00'>Admin %1 stopped the Hunt-An-Admin! Not to worry, we'll have another event soon.</t>",_nameadmin];
			MissionHint = [1, _hint]; publicVariable "MissionHint";
			hint parseText format["%1", _hint];
			playSound "UAV_01";
			
			deletemarker _markeradmin;
			player removeAction _stop; 	
			player removeaction _reinforce;
			if (_reinforcements) 	then {
				stopreinforceme = _nameadmin;
				PublicvariableServer "stopreinforceme";
			};
			
			player setCaptive false;
			_reinforcements = false;
			missionmenu = player addaction [("" + ("Admin Hunt Menu") +""),"scripts\AdminHunt\adminhunt_client.sqf","",-97,false,false,"",""];
		};
	};
	
	if (!alive player) exitwith {
	
	/* --- Mission success --- */
	
		//////////////////////////////////////////
		/* --- Spawn random reward crate at admins body --- */
		
		_crates = [
		
		"Box_NATO_Wps_F",
		"Box_NATO_WpsSpecial_F",
		"Box_NATO_WpsLaunch_F",
		"Box_East_Wps_F",
		"Box_East_WpsSpecial_F",
		"Box_East_WpsLaunch_F",
		"Box_IND_Wps_F",
		"Box_IND_WpsSpecial_F",
		"Box_IND_WpsLaunch_F"
		
		]; 
		_spawncrate = _crates call BIS_fnc_SelectRandom;
		_crate = createVehicle [_spawncrate, player, [], 0, "CAN_COLLIDE"];
		_crate setDir 0;
		_crate allowDamage false;
		_crate setVariable ["permaLoot",true];
		_cratemarker = "SmokeShell" createVehicle getPosATL _crate;
		_cratemarker setPosATL (getPosATL _crate);
		_cratemarker attachTo [_crate,[0,0,0]];
		//////////////////////////////////////////

		player setCaptive false;
		deleteVehicle player;
		deletemarker _markeradmin;
		player removeAction _stop; 	
		player removeaction _reinforce;
		if (_reinforcements) then {
		
			_hint = format ["<t align='center' size='2.0' color='#6bab3a'>Mission: Success!</t><br/>
			<t align='left' size='1.25' color='#ffff00'>But be careful, %1's bodyguard might still be in the area so stay frosty!</t>",_nameadmin];
			MissionHint = [3, _hint]; publicVariable "MissionHint";
			hint parseText format["%1", _hint];
			playsound "UAV_03";
			
			iamdead = _nameadmin;
			PublicVariableServer "iamdead";	
		} 
		else 
		{
			_hint = format ["<t align='center' size='2.0' color='#6bab3a'>Mission: Success!</t><br/>
			<t align='left' size='1.25' color='#ffff00'>Admin %1 is dead, long live the Admin! Reward crate spawned in, enjoy your spoils!</t>",_nameadmin];					
			MissionHint = [3, _hint]; publicVariable "MissionHint";
			hint parseText format["%1", _hint];
			playsound "UAV_03";
		};
	};
	
	uiSleep 1;					
	if (debug_adminhunt) then {diag_log "#AdminHunt: Ending mission";};
	player setCaptive false;
	
};

diag_log "#AdminHunt: Hunt-An-Admin mission running!";
