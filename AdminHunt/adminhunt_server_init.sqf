
diag_log "#AdminHunt: Mission initialized";

"reinforceme" addPublicVariableEventHandler {
	[_this select 1] execVM "scripts\AdminHunt\reinforcements.sqf";
};
