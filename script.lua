g_savedata = {
	["player"] = { name = nil, peer_id = nil, id = -1, team_name=nil},
	["team"] = {},
}
need_seat_player = false;
tgt_player_vehicle_id = -1;
tgt_player_seat_name = nil;
player_seat_ticks = 0;

need_seat_worker = false;
tgt_worker_vehicle_id = -1;
tgt_worker_seat_name = nil;
set_worker_id = -1;
worker_seat_ticks = 0;

none = {id = 0, name="noname"};
worker = {id = 1, name="worker"};
fishing = {id = 2, name="fisher"};
waiter = {id = 3, name="waiter"};
swimsuit = {id = 4, name="swimmer"};
military = {id = 5, name="military"};
office = {id = 6, name="employee"};
police = {id = 7, name="policeman"};
science = {id = 8, name="scientist"};
medical = {id = 9, name="doctor"};
wetsuit = {id = 10, name="diver"};
civilian = {id = 11, name="citizen"};


function onTick(game_ticks)

end

function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	g_savedata.player.name = name;
	g_savedata.player.peer_id = peer_id;
	g_savedata.player.team_name = name.. " RS team";
	local object_id, is_success = server.getPlayerCharacterID(peer_id);
	savedata.player.id = object_id;
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
	
end

function printHelp()
	server.announce("[HELP]", "?help - show this help");
	server.announce("[HELP]", "?hire - hire new worker in to you team.");
end;

function nameFromOutFit( outfit)
	if none.id == outFit then return none.name; end;
	if worker.id == outFit then return worker.name; end;
	if fishing.id == outFit then return fishing.name; end;
	if waiter.id == outFit then return waiter.name; end;
	if swimsuit.id == outFit then return swimsuit.name; end;
	if military.id == outFit then return military.name; end;
	if office.id == outFit then return office.name; end;
	if police.id == outFit then return police.name; end;
	if science.id == outFit then return science.name; end;
	if medical.id == outFit then return medical.name; end;
	if wetsuit.id == outFit then return wetsuit.name; end;
	if civilian.id == outFit then return wetsuit.name; end;
	return "noname";
end;


function outFitFromName( name )
	if none.name == name then return none.id; end;
	if worker.name == name then return worker.id; end;
	if fishing.name == name then return fishing.id; end;
	if waiter.name == name then return waiter.id; end;
	if swimsuit.name == name then return swimsuit.id; end;
	if military.name == name then return military.id; end;
	if office.name == name then return office.id; end;
	if police.name == name then return police.id; end;
	if science.name == name then return science.id; end;
	if medical.name == name then return medical.id; end;
	if wetsuit.name == name then return wetsuit.id; end;
	if civilian.name == name then return wetsuit.id; end;
	return 0;
end;

function hire( arg1, arg2 )
	local outfit = 1;
	local name = "worker";
	if (arg1 ~= nil and type(arg1) == "string") then name = arg1; outfit = outFitFromName; end;
	if (arg1 ~= nil and type(arg1) == "number") then 
		outfit = arg1; 
		if arg2 ~= nil then 
			name = arg2;
		else
			name = nameFromOutFit(outfit);
		end;
	end;


end;


function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, arg1, arg2, arg3, arg4, arg5)

	if (command == "?help")	then printHelp(); end;
	if (commmnd == "?hire") then hire(arg1); end;

end