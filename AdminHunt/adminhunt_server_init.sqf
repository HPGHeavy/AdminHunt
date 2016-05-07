/* --- All credits to 5nine and NibbleGaming for initial release --- */
/* --- Ported/modified by Heavy for A3 Exile --- */

diag_log "#AdminHunt: Mission initialized";

"reinforceme" addPublicVariableEventHandler {
	[_this select 1] execVM "scripts\AdminHunt\reinforcements.sqf";
};