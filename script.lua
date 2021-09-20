g_savedata = {
	["player"] = { name = nil, peer_id = nil, id = -1, team_name=nil},
	["workers"] = {},
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
		server.announce("[HELP]", "?rn old_name new_name - give a new name to your team member.", g_savedata.player.peer_id);
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
	local worker_name = nil;
	
	if type(arg1) == "number" then
		worker_name = nameFromOutFit( arg1 );
		worker_name = outFitFromName( worker_name );
	end;
	
	if type(arg1) == "string" then
		outfit = outFitFromName( arg1 );
		worker_name = nameFromOutFit( outfit );
	end;
	
	if outfit == nil or name == nil then
		printHelp( "hire" );
	else
		local player_pos, success = server.getPlayerPos(g_savedata.player.peer_id);
		local x,y,z = matrix.position(player_pos);
		x = x + lx*2
		z = z + lz*2
		local rescuer_pos = matrix.translation(x, y, z)
		local rescuer_id = server.spawnCharacter(rescuer_pos, outfit);
		local worker = { name = worker_name, outfit = outfit, is_powered = true, isPlayer = false, id=rescuer_id, is_sit = false, vehicle_id = -1, seat_name= nil, pop_up=server.getMapID(), powered_time = server.getDateValue()}
		g_savedata.workers[rescuer_id] = worker;
		local text = worker_name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[rescuer_id].pop_up, g_savedata.workers[rescuer_id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[rescuer_id].id);
	end;
end;

function renameW(arg1, arg2)
	if arg1 == nil or arg2 == nil then return; end;
	local worker = nil
	local best_ditance = 25;
	local player_matrix, _ = server.getPlayerPos(g_savedata.player.peer_id)
	for _, h in pairs(g_savedata.workers) do
			if (arg1 == nil or (type(arg1) == "string" and h.name == arg1) or (type(arg1) == "number" and h.id == arg1)) then
				worker_matrix, success = server.getObjectPos(h.id)
				if (success) then
					local distSQ = distQ(worker_matrix, player_matrix);
					if (best_ditance == nil or best_ditance > distSQ) then
						best_ditance = distSQ;
						worker = h;
					end
				end
			end
	end
	if (worker ~= nil) then
		worker.name = arg2;
		g_savedata.workers[worker.id] = worker;
		local text = new_name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[worker.id].pop_up, g_savedata.workers[worker.id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[worker.id].id);
	end
end;

function distQ( m1, m2)
	local x1, y1, z1 = matrix.position(m1);
	local x2, y2, z2 = matrix.position(m2);
	return ((x2 - x1)^2) + ((y2 - y1)^2) + ((z2 - z1)^2);
end;



function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, arg1, arg2, arg3, arg4, arg5)

	if (command == "?help")	then printHelp(arg1); end;
	if (commmnd == "?hire") then hire(arg1); end;
	if (command == "?rn") then renameW(arg1, arg2); end;
end