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

offsetType = {};

function onCreate(is_world_create)
	if is_world_create then
		offsetType[1] = { name = "worker", pay = 100 }
		offsetType[2] = { name = "fisher", pay = 100 }
		offsetType[3] = { name = "waiter", pay = 100 }
		offsetType[4] = { name = "swimmer", pay = 100 }
		offsetType[5] = { name = "military", pay = 100 }
		offsetType[6] = { name = "office", pay = 100 }
		offsetType[7] = { name = "police", pay = 100 }
		offsetType[8] = { name = "scientist", pay = 100 }
		offsetType[9] = { name = "medical", pay = 100 }
		offsetType[10] = { name = "diver", pay = 100 }
		offsetType[11] = { name = "citizen", pay = 100 }
	end;
end;

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

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, arg1, arg2, arg3, arg4, arg5)
	if (command == "?help")	then printHelp(arg1); end;
	if (command == "?hire") then 
		hire(arg1); 
	end;
	if (command == "?rn") then renameW(arg1, arg2); end;
	if (command == "?sw") then switch2W(arg1); end;
end

function printHelp(arg1)
	if arg1 == nil then
		server.announce("[HELP]", "?help - show this help", g_savedata.player.peer_id);
		server.announce("[HELP]", "?hire - hire new worker in to you team. Type ?help hire for details.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?rn old_name new_name - give a new name to your team member.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?dismiss worker_name - dismiss a worker.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?sw worker_name - switch to worker with name.", g_savedata.player.peer_id)
	end;
	if arg1 == "hire" or arg1 == "?hire" then
		server.announce("[HELP]", "?hire professions:", g_savedata.player.peer_id);
		for i, data in pairs(offsetType) do
			server.announce("", "- " ..data.name.. ". payment of $ " ..(10 * data.pay).. " and $" ..data.pay.. " every day.", g_savedata.player.peer_id);
		end;
	end;
end;

function nameFromOutFit( outfit )
	if (outfit ~= nil) then
		if outfit > 0 and outfit < 12 then return offsetType[outfit].name, offsetType[outfit].pay; end;
	end;
	return nil;
end;


function outFitFromName( name )
	if name ~= nil then 
		local res = nil;
		local pay = nil;
		for i, data in pairs(offsetType) do
			if (data.name == name)  then
				return i, pay;
			end;
		end;
	end;
	return nil, nil;
end;

function hire( arg1 )
	if arg1 == nil then 
		printHelp("hire");
		return;
	end;
	local outfit = nil;
	local worker_name = nil;
	local pay = 0;
	
	if type(arg1) == "number" then
		worker_name, pay = nameFromOutFit( arg1 );
		worker_name, pay = outFitFromName( worker_name );
	end;
	
	if type(arg1) == "string" then
		outfit, pay = outFitFromName( arg1 );
		worker_name, pay = nameFromOutFit( outfit );
	end;
	
	if outfit == nil or worker_name == nil then
		printHelp( "hire" );
		return;
	else
		local player_pos, success = server.getPlayerPos(g_savedata.player.peer_id);
		local lx, ly, lz, is_look = server.getPlayerLookDirection(g_savedata.player.peer_id)
		local x,y,z = matrix.position(player_pos);
		x = x + lx*2
		z = z + lz*2
		local rescuer_pos = matrix.translation(x, y, z)
		local rescuer_id = server.spawnCharacter(rescuer_pos, outfit);
		local worker = { name = worker_name, outfit = outfit, is_powered = true, isPlayer = false, id=rescuer_id, is_sit = false, vehicle_id = -1, seat_name= nil, pop_up=server.getMapID(), powered_time = server.getDateValue()}
		g_savedata.workers[rescuer_id] = worker;
		local text = worker_name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[rescuer_id].pop_up, g_savedata.workers[rescuer_id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[rescuer_id].id);
		local my_currency = server.getCurrency() - pay;
		local my_research_points = server.getResearchPoints();
		server.setCurrency(my_currency, my_research_points);
		server.announce(g_savedata.player.team_name, "Pay for new worker $" ..pay.. ". Balance: $" ..my_currency, g_savedata.player.peer_id);		
	end;
end;

function switch2W(arg1)
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
		local text = worker.name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[worker.id].pop_up, g_savedata.workers[worker.id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[worker.id].id);
	end
end;

function printD( arg1 )
	server.announce("[debug]", arg1, g_savedata.player.peer_id);
end;

function distQ( m1, m2)
	local x1, y1, z1 = matrix.position(m1);
	local x2, y2, z2 = matrix.position(m2);
	return ((x2 - x1)^2) + ((y2 - y1)^2) + ((z2 - z1)^2);
end;