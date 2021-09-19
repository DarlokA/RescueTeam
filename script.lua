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

worker = {id = 1, name="worker", pay = 100};
fishing = {id = 2, name="fisher", pay = 150};
swimsuit = {id = 4, name="swimmer", pay = 150};
military = {id = 5, name="military", pay = 250};
office = {id = 6, name="employee", pay = 100};
police = {id = 7, name="policeman", pay = 250};
science = {id = 8, name="scientist", pay = 500};
medical = {id = 9, name="doctor", pay = 150};
wetsuit = {id = 10, name="diver", pay = 150};
civilian = {id = 11, name="citizen", pay = 100};

function onSpawnAddonComponent(id, name, type, playlist_index)
	
end;


function onTick(game_ticks)

end

function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	g_savedata.player.name = name;
	g_savedata.player.peer_id = peer_id;
	g_savedata.player.team_name = name.. " RS team";
	local object_id, is_success = server.getPlayerCharacterID(peer_id);
	g_savedata.player.id = object_id;
	server.setGameSetting("settings_menu", true);--TODO: remove this
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
	
end

function printHelp(arg1)
	if arg1 == nil then
		server.announce("[HELP]", "?help - show this help", g_savedata.player.peer_id);
		server.announce("[HELP]", "?hire profession - hire new worker in to you team.", g_savedata.player.peer_id);
	end;
	if arg1 == "hire" or arg1 == "?hire" then
		server.announce("[HELP]", "     - ?hire professions:", g_savedata.player.peer_id);
		server.announce("", "     - ?hire worker. payment of $ " ..(10 * worker.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire fisher. payment of $ " ..(10 * fishing.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire military. payment of $ " ..(10 * military.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire employee. payment of $ " ..(10 * office.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire scientist. payment of $ " ..(10 * science.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire doctor. payment of $ " ..(10 * medical.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire diver. payment of $ " ..(10 * wetsuit.pay), g_savedata.player.peer_id);
		server.announce("", "     - ?hire citizen. payment of $ " ..(10 * civilian.pay), g_savedata.player.peer_id);
	end;
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
	if civilian.id == outFit then return civilian.name; end;
	return nil;
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
	if civilian.name == name then return civilian.id; end;
	return nil;
end;

function hire( arg1 )
	if arg1 == nil then 
		printHelp("hire");
	end;
	local outfit = nil;
	local name = nil;
	
	if type(arg1) == "number" then
		name = nameFromOutFit( arg1 );
		outfit = outFitFromName( name );
	end;
	
	if type(arg1) == "string" then
		outfit = outFitFromName( arg1 );
		name = nameFromOutFit( outfit );
	end;
	
	if outfit == nil or name == nil then
		printHelp( "hire" );
	else
		local player_pos, success = server.getPlayerPos(g_savedata.player.peer_id);
	end;
end;

function distQ( m1, m2)
	local x1, y1, z1 = matrix.position(m1);
	local x2, y2, z2 = matrix.position(m2);
	return ((x2 - x1)^2) + ((y2 - y1)^2) + ((z2 - z1)^2);
end;



function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, arg1, arg2, arg3, arg4, arg5)

	if (command == "?help")	then printHelp(arg1); end;
	if (commmnd == "?hire") then hire(arg1); end;

end