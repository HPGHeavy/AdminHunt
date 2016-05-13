
waitUntil{uiSleep 1; ExileClientPlayerIsSpawned};

uiSleep 10;
if (getPlayerUID player in adminlist) then {
	if (debug_adminhunt) then {diag_log "#AdminHunt: Player is admin";};
	systemChat "Loading Admin Hunt Menu...";
	missionmenu = player addaction [("" + ("Admin Hunt Menu") +""),"scripts\AdminHunt\adminhunt_client.sqf","",-97,false,false,"",""];

while {true} do 
	{
		waitUntil {!alive player};
		waitUntil {alive player};
		diag_log "#AdminHunt: Player is admin";
		missionmenu = player addaction [("" + ("Admin Hunt Menu") +""),"scripts\AdminHunt\adminhunt_client.sqf","",-97,false,false,"",""];
	};     		
} 	
else 
{
	if (debug_adminhunt) then {diag_log "#AdminHunt: Player is not admin";};
};
