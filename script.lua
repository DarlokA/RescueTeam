g_savedata = {
	["player"] = { name = nil, peer_id = nil, id = -1, team_name=nil, is_sit = false, vehicle_id = -1, seat_name= nil },
	["workers"] = {},
	["day"] = 0,
	["settings"] = false,
}
need_seat_player = false;
tgt_player_vehicle_id = -1;
tgt_player_seat_name = nil;
player_seat_ticks = 0;

need_seat_worker = false;
tgt_worker_vehicle_id = -1;
tgt_worker_seat_name = nil;
sit_worker_id = -1;
worker_seat_ticks = 0;

dismiss_pay = 2000;

second = 60;

vihicles = {};

offsetType = {};
eq_items = {};

--[[local worker = { 
	name = worker_name, 
	outfit = outfit, 
	is_powered = true, 
	isPlayer = false, 
	id=rescuer_id, 
	is_sit = false, 
	vehicle_id = -1, 
	seat_name= nil, 
	pop_up=server.getMapID(), 
	powered_time = server.getDateValue(), 
	pay = pay}
--]]
function onCreate(is_world_create)
	offsetType[1] = { name = "worker", pay = 100 }
	--[[offsetType[2] = { name = "fisher", pay = 100 }
	offsetType[3] = { name = "waiter", pay = 100 }
	offsetType[4] = { name = "swimmer", pay = 100 }
	offsetType[5] = { name = "military", pay = 100 }
	offsetType[6] = { name = "office", pay = 100 }
	offsetType[7] = { name = "police", pay = 100 }
	offsetType[8] = { name = "scientist", pay = 100 }
	offsetType[9] = { name = "medical", pay = 100 }
	offsetType[10] = { name = "diver", pay = 100 }
	offsetType[11] = { name = "citizen", pay = 100 }
	--]]
	
	
--Outfits
	eq_items[0] = { name="none", ival = nil, fval = nil, pay= 0 };
	eq_items[1] = { name="diving", ival = nil, fval = nil, pay= 0};
	eq_items[2] = { name="firefighter", ival = nil, fval = nil, pay= 0};
	eq_items[3] = { name="scuba", ival = nil, fval = nil, pay= 0};
	eq_items[4] = { name="parachute", ival = 1, fval = nil, pay= 0};-- = {0 = deployed, 1 = ready}]
	eq_items[5] = { name="arctic", ival = nil, fval = nil, pay= 0};
	eq_items[29] = { name="hazmat", ival = nil, fval = nil, pay= 0};
--Items
	eq_items[6] = {  name="binoculars", ival = nil, fval = nil, pay= 0 };
	eq_items[7] = {  name="cable", ival = nil, fval = nil, pay= 0 };
	eq_items[8] = {  name="compass", ival = nil, fval = nil, pay= 0 };
	eq_items[9] = {  name="defibrillator", ival = 4, fval = nil, pay= 0 };-- [int = charges]
	eq_items[10] = { name="fire_extinguisher", ival = nil, fval = 9.0, pay= 500 };-- [float = ammo]
	eq_items[11] = { name="first_aid", ival = 4, fval = nil, pay= 100 };-- [int = charges]
	eq_items[12] = { name="flare", ival = 4, fval = nil, pay= 100 };-- [int = charges]
	eq_items[13] = { name="flaregun", ival = 1, fval = nil, pay= 50 };-- [int = ammo]
	eq_items[14] = { name="flaregun_ammo", ival = 4, fval = nil, pay= 200 };-- [int = ammo]
	eq_items[15] = { name="flashlight", ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	eq_items[16] = { name="hose", ival = 0, fval = nil, pay= 0 };-- [int = {0 = hose off, 1 = hose on}]
	eq_items[17] = { name="night_vision_binoculars", ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	eq_items[18] = { name="oxygen_mask", ival = nil, fval = 100.0, pay= 0 };-- [float = oxygen]
	eq_items[19] = { name="radio", ival = 1, fval = 100.0, pay= 0 };-- [int = channel] [float = battery]
	eq_items[20] = { name="radio_signal_locator", ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	eq_items[21] = { name="remote_control", ival = 1, fval = 100.0, pay= 0 };-- [int = channel] [float = battery]
	eq_items[22] = { name="rope", ival = nil, fval = nil, pay= 0 };
	eq_items[23] = { name="strobe_light", ival = 0, fval = 100.0, pay= 0 };-- [int = {0 = off, 1 = on}] [float = battery]
	eq_items[24] = { name="strobe_light_infrared", ival = 0, fval = 100.0, pay= 0 };-- [int = {0 = off, 1 = on}] [float = battery]
	eq_items[25] = { name="transponder", ival = 0, fval = 100.0, pay= 0 };-- [int = {0 = off, 1 = on}] [float = battery]
	eq_items[26] = { name="underwater_welding_torch", ival = nil, fval = 250.0, pay= 1000 };-- [float = charge]
	eq_items[27] = { name="welding_torch", ival = nil, fval = 400.0, pay= 500 };-- [float = charge]
	eq_items[28] = { name="coal", ival = nil, fval = nil, pay= 0 };
	eq_items[30] = { name="radiation_detector", ival = nil, fval = 100.0, pay= 0 };-- [float = battery]

	
end;

function onSpawnAddonComponent(id, name, type, playlist_index)
	
end;

function isSit(object_id)
	if g_savedata.player.id == object_id then
		return g_savedata.player.is_sit, g_savedata.player.vehicle_id;
	end;
	local h = g_savedata.workers[object_id];
	if h ~= nil then
		return h.is_sit, h.vehicle_id;
	end;
	return false, nil;
end;

function isSimulatedSit(object_id)
	local vehicle_id, is_success = server.getCharacterVehicle(object_id)
	if (is_success) then
		local vdata, is_success = server.getVehicleData(vehicle_id)
		if (is_success) then
			for _, id in pairs(vdata.characters) do
				if (object_id == id) then
					return true, vehicle_id;
				end
			end
		end
	end
	return false, nil
end


function checkSit()
	if need_seat_player then 
		return; 
	end;
	
	if g_savedata.player.is_sit then
		local player_matrix, success = server.getPlayerPos(g_savedata.player.peer_id);
		local id_matrinx, success = server.getObjectPos(g_savedata.player.id);
		local distSQ = distQ(id_matrinx, player_matrix);
		if distSQ < 2 then
			local sit, vid = isSimulatedSit(g_savedata.player.id);
			g_savedata.player.is_sit = sit;
			if not sit then
				--printD("On Player UNSIT");
			end;
		end;
	end;
	
	for id, h in pairs(g_savedata.workers) do
		if id == sit_worker_id and need_seat_worker then
			local is_simulating, is_success = server.getVehicleSimulating(tgt_worker_vehicle_id);
			if is_simulating and is_success then
				local player_matrix, success = server.getPlayerPos(g_savedata.player.peer_id);
				if success then
					worker_matrix, success = server.getObjectPos(h.id)
					if (success) then
						local distSQ = distQ(worker_matrix, player_matrix);
						if (distSQ <= 2) then
							local sit, vid = isSimulatedSit(id);
							g_savedata.workers[id].is_sit = sit;
							--printD("On Worker UNSIT");
						end;
					end;
				end;
			else
				onCharacterSit(id, tgt_worker_vehicle_id, tgt_worker_seat_name);
			end;
		else
			if h.is_sit then
				local is_simulating, is_success = server.getVehicleSimulating(h.vehicle_id);
				if not is_success then 
					g_savedata.workers[id].is_sit = false; 
					--printD("On Worker UNSIT reason not worker vehicle");
				else
					if is_simulating then
						local player_matrix, success = server.getPlayerPos(g_savedata.player.peer_id);
						if success then
							worker_matrix, success = server.getObjectPos(h.id)
							if (success) then
								local distSQ = distQ(worker_matrix, player_matrix);
								if (distSQ <= 2) then
									local sit, vid = isSimulatedSit(id);
									g_savedata.workers[id].is_sit = sit;
									--printD("On Worker UNSIT");
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	
end;


function onCharacterSit(object_id, vehicle_id, seat_name)
	if object_id == g_savedata.player.id then
		--printD("On Player SIT to " ..vehicle_id.. " " ..seat_name);
		g_savedata.player.is_sit = true;
		g_savedata.player.vehicle_id = vehicle_id;
		g_savedata.player.seat_name = seat_name;
		--server.announce("[" ..g_savedata.player.name.. "]", "Sit to vehicle_id: "..g_savedata.player.vehicle_id.. ", seatName: " ..g_savedata.player.seat_name, g_savedata.player.peer_id);
		if need_seat_player then
			local sit, vid = isSit(g_savedata.player.id);
			if sit then
				need_seat_player = vid ~= tgt_player_vehicle_id;
			end;
		end;
		return;
	end;
	
	for id, h in pairs(g_savedata.workers) do
		if id == object_id then
			--printD("On Worker " ..id.. " SIT to " ..vehicle_id.. " " ..seat_name);
			g_savedata.workers[id].is_sit = true;
			g_savedata.workers[id].vehicle_id = vehicle_id;
			g_savedata.workers[id].seat_name = seat_name;
			--server.announce("[" ..g_savedata.workers[id].name.. "]", "Sit to vehicle_id: "..g_savedata.workers[id].vehicle_id.. ", seatName: " ..g_savedata.workers[id].seat_name, g_savedata.player.peer_id);
			if need_seat_worker and object_id == sit_worker_id then
				local sit, vid = isSit(sit_worker_id);
				if sit then
					need_seat_worker = vid ~= tgt_worker_vehicle_id;
				end;
			end;
			return;
		end;
	end;	
end;

function on_restore_settings()
	server.setGameSetting("third_person", true)
	server.setGameSetting("third_person_vehicle", true)
	server.setGameSetting("vehicle_damage", true)
	server.setGameSetting("player_damage", true)
	server.setGameSetting("npc_damage", true)
	server.setGameSetting("sharks", true)
	server.setGameSetting("fast_travel", false)
	server.setGameSetting("teleport_vehicle", false)
	server.setGameSetting("rogue_mode", false)
	server.setGameSetting("auto_refuel", false)
	server.setGameSetting("megalodon", true)
	server.setGameSetting("map_show_players", false)
	server.setGameSetting("map_show_vehicles", false)
	server.setGameSetting("show_3d_waypoints", false)
	server.setGameSetting("show_name_plates", true)
	server.setGameSetting("infinite_money", false)
	server.setGameSetting("settings_menu", false)
	server.setGameSetting("unlock_all_islands", false)
	server.setGameSetting("unlock_all_components", false)
	server.setGameSetting("infinite_batteries", false)
	server.setGameSetting("infinite_fuel", false)
	server.setGameSetting("engine_overheating", true)
	server.setGameSetting("no_clip", true)
	server.setGameSetting("map_teleport", false)
	server.setGameSetting("cleanup_veicle", true)
	server.setGameSetting("vehicle_spawning", true)
	server.setGameSetting("photo_mode", true)
	server.setGameSetting("respawning", true)
	server.setGameSetting("settings_menu_lock", true)
	server.setGameSetting("despawn_on_leave", true)
end;

function onVehicleUnload(vehicle_id)
	
end;

function onVehicleLoad(vehicle_id)
	if need_seat_player and vehicle_id == tgt_player_vehicle_id then
		tryingSitPlayer();
	end;
	if need_seat_worker and vehicle_id == tgt_worker_vehicle_id then
		tryingSitWorker();
	end;
end;

function tryingSitPlayer()
	if (need_seat_player) then
		local is_simulating, is_success = server.getVehicleSimulating(tgt_player_vehicle_id);
		if not is_simulating then
			local tgt, success = server.getVehiclePos(tgt_player_vehicle_id);
			if success then
				local tx, ty, tz = matrix.position(tgt);
				tgt = matrix.translation(tx, ty+20, tz);
				server.setPlayerPos(g_savedata.player.peer_id, tgt);			
			end;
			return; 
		end;
		if not is_success then need_seat_player = false; end;
		local success, vid = isSit(g_savedata.player.id);
		if success and (vid == tgt_player_vehicle_id) then 
			need_seat_player = false;
		end;
		
		local tgt, success = server.getVehiclePos(tgt_player_vehicle_id);
		if success then
			local tx, ty, tz = matrix.position(tgt);
			tgt = matrix.translation(tx, ty+20, tz);
			server.setPlayerPos(g_savedata.player.peer_id, tgt);
			server.setCharacterSeated(g_savedata.player.id, tgt_player_vehicle_id, tgt_player_seat_name);
		end;
		
		success, vid = isSit(g_savedata.player.id);
		if success and (vid == tgt_player_vehicle_id) then 
			need_seat_player = false;
		end;
		local is_simulating, is_success = server.getVehicleSimulating(tgt_player_vehicle_id);
		if not is_success then need_seat_player = false; end;
		if need_seat_player then 
			player_seat_ticks = player_seat_ticks + 1;
		end;
		if is_simulating and player_seat_ticks > 1200 then 
			player_seat_ticks = 0;
			need_seat_player = false;
		end;
	end;
end;

function tryingSitWorker()
	if (need_seat_worker) then
		local is_simulating, is_success = server.getVehicleSimulating(tgt_worker_vehicle_id);
		if not is_success then need_seat_worker = false; end;
		if not is_simulating then
			local tgt, success = server.getVehiclePos(tgt_worker_vehicle_id);
			if success then
				local tx, ty, tz = matrix.position(tgt);
				tgt = matrix.translation(tx, ty+20, tz);
				server.setObjectPos(sit_worker_id, tgt);
			end;
			return; 
		end;
		local success, vid = isSit(sit_worker_id);
		if success and (vid == tgt_worker_vehicle_id) then 
			need_seat_worker = false;
		end;
		
		local tgt, success = server.getVehiclePos(tgt_worker_vehicle_id);
		if success then
			local tx, ty, tz = matrix.position(tgt);
			tgt = matrix.translation(tx, ty+2, tz);
			server.setObjectPos(sit_worker_id, tgt);
			server.setCharacterSeated(sit_worker_id, tgt_worker_vehicle_id, tgt_worker_seat_name);
		end;
		
		local success, vid = isSit(sit_worker_id);
		if success and (vid == tgt_worker_vehicle_id) then 
			need_seat_worker = false;
		end;
		
		if not is_success then need_seat_worker = false; end;
		if need_seat_worker then
			worker_seat_ticks = worker_seat_ticks + 1;
		end;
		if is_simulating and worker_seat_ticks > 1200 then
			worker_seat_ticks = 0;
			need_seat_worker = false;
		end;
	end;
end;

function onTick(game_ticks)
	if not g_savedata.settings then
		on_restore_settings();
		g_savedata.settings = true;
	end;

	local days_survived = server.getDateValue();
	if (days_survived > g_savedata.day) then
		dailyPay();
	end;
	g_savedata.day = days_survived;
	checkSit();
	tryingSitPlayer();
	tryingSitWorker();
end



function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	g_savedata.player.name = name;
	g_savedata.player.peer_id = peer_id;
	g_savedata.player.team_name = name.. " RS team";
	local object_id, is_success = server.getPlayerCharacterID(peer_id);
	g_savedata.player.id = object_id;
	printHelp(nil);
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
	
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, arg1, arg2, arg3, arg4, arg5)
	if (command == "?help")	then printHelp(arg1); end;
	if (command == "?hire") then 
		hire(arg1); 
	end;
	if (command == "?rn") then renameW(arg1, arg2); end;
	if (command == "?dismiss") then dismissW(arg1); end;
	if (command == "?sw") then switch2W(arg1); end;
	if (command == "?settings") then server.setGameSetting("settings_menu", true); end;
	if (command == "?restore_settings") then on_restore_settings(); end;
end


function printHelp(arg1)
	if arg1 == nil then
		server.announce("[HELP]", "?help - show this help", g_savedata.player.peer_id);
		server.announce("[HELP]", "?hire - hire new worker in to you team. Type ?help hire for details.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?rn old_name new_name - give a new name to your team member.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?dismiss worker_name - dismiss a worker. Type ?help dismiss for details.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?sw worker_name - switch to worker with name.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?settings - enable settings menu in game.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?restore_settings - restore default addon settings.", g_savedata.player.peer_id);
	end;
	if arg1 == "hire" or arg1 == "?hire" then
		server.announce("[HELP]", "?hire professions:", g_savedata.player.peer_id);
		for i, data in pairs(offsetType) do
			server.announce("", "- " ..data.name.. ". payment of $ " ..(10 * data.pay).. " and $" ..data.pay.. " every day.", g_savedata.player.peer_id);
		end;
	end;
	if arg1 == "dismiss" or arg1 == "?dismiss" then
		server.announce("[HELP]", "?dismiss name by profession cost:", g_savedata.player.peer_id);
		for i, data in pairs(offsetType) do
			server.announce("", "- " ..data.name.. ". severance pay $ " ..(10 * data.pay), g_savedata.player.peer_id);
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
		local worker = { name = worker_name, outfit = outfit, is_powered = true, isPlayer = false, id=rescuer_id, is_sit = false, vehicle_id = -1, seat_name= nil, pop_up=server.getMapID(), powered_time = server.getDateValue(), pay = pay}
		g_savedata.workers[rescuer_id] = worker;
		local text = worker_name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[rescuer_id].pop_up, g_savedata.workers[rescuer_id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[rescuer_id].id);
		local my_currency = server.getCurrency() - (pay * 10);
		local my_research_points = server.getResearchPoints();
		server.setCurrency(my_currency, my_research_points);
		server.announce(g_savedata.player.team_name, "Pay for new worker $" ..(pay *10).. ". Balance: $" ..my_currency, g_savedata.player.peer_id);		
	end;
end;

function dismissW(arg1)
	if arg1 == nil then
		printHelp( "dismiss" );
		return; 
	end;
	local worker = nil
	local best_ditance = 25;
	local player_matrix, _ = server.getPlayerPos(g_savedata.player.peer_id);
	for _, h in pairs(g_savedata.workers) do
		worker_matrix, success = server.getObjectPos(h.id)
		if (success) then
			local distSQ = distQ(worker_matrix, player_matrix);
			if (best_ditance == nil or best_ditance > distSQ) then
				best_ditance = distSQ;
				worker = h;
			end;
		end;
	end;
	if worker ~= nil then
		server.removePopup(g_savedata.player.peer_id, worker.pop_up);
		local w_data = server.getCharacterData(worker.id);
		--{["hp"] = hp, ["incapacitated"] = is_incapacitated, ["dead"] = is_dead, ["interactible"] = is_interactable, ["ai"] = is_ai, ["name"] = name} = server.getCharacterData(object_id)
		server.setCharacterData(worker.id, w_data.hp, false, true);
		server.despawnObject(worker.id, false);
		
		local my_currency = server.getCurrency() - (worker.pay * 10);
		local my_research_points = server.getResearchPoints();
		server.setCurrency(my_currency, my_research_points);
		server.announce(g_savedata.player.team_name, "severance pay for " ..worker.name.. " $" ..(worker.pay * 10).. ". Balance: $" ..my_currency, g_savedata.player.peer_id);		
		
		g_savedata.workers[worker.id] = nil;
	else
		printHelp( "dismiss" );
	end;
	
end;

function GrabCharacterItems(id)
	local items = {};
	for i = 1, 6 do
		local eq_id, success = server.getCharacterItem(id, i);
		if success then 
			items[i] = { eq_id = eq_id };
		else
			items[i] = { eq_id = 0 };
		end;
	end;
	return items;
end;

function SetCharacterItems(id, items, need_pay)
	local my_currency = server.getCurrency();
	local my_research_points = server.getResearchPoints;
	for idx, e in pairs (items) do
		local item = eq_items[e.eq_id];
		local ival = item.ival;
		local fval = item.fval;
		if (item.pay > 0 and my_currency < item.pay and need_pay) then 
			ival = nil;
			fval = nil;
		end;
		if ((item.pay > 0 and my_currency >= item.pay) or need_pay == false) then
			if need_pay then 
				my_currency = my_currency - item.pay; 
				server.setCurrency(my_currency, my_research_points);
				server.announce(g_savedata.player.team_name, "payment of the cost of new " ..item.name.. " $" ..(item.pay).. ". Balance: $" ..my_currency, g_savedata.player.peer_id);
			end;
		end;
		local is_success = server.setCharacterItem(id, idx, e.eq_id, false, ival, fval);
	end;
end;

function switch2W(arg1)
	local worker = nil
	local best_ditance = nil;
	local player_matrix, _ = server.getPlayerPos(g_savedata.player.peer_id);
	for _, h in pairs(g_savedata.workers) do
		worker_matrix, success = server.getObjectPos(h.id)
		if (success) then
			if arg1 == nil or arg1 == h.name then
				local distSQ = distQ(worker_matrix, player_matrix);
				if (best_ditance == nil or best_ditance > distSQ) then
					best_ditance = distSQ;
					worker = h;
				end;
			end;
		end;
	end;
	if worker ~= nil then
		need_seat_player = isSit(worker.id);
		if (need_seat_player) then
			tgt_player_vehicle_id = worker.vehicle_id;
			tgt_player_seat_name = worker.seat_name;
			--server.announce("[" ..g_savedata.player.name.. "]", "Sit to vehicle_id: "..tgt_player_vehicle_id.. ", seatName: " ..tgt_player_seat_name, g_savedata.player.peer_id);
			player_seat_ticks = 0;
		end;

		need_seat_worker = isSit(g_savedata.player.id);
		if (need_seat_worker) then
			tgt_worker_vehicle_id = g_savedata.player.vehicle_id;
			tgt_worker_seat_name = g_savedata.player.seat_name;
			sit_worker_id = worker.id;
			--server.announce("[" ..worker.name.. "]", "Sit to vehicle_id: "..tgt_worker_vehicle_id.. ", seatName: " ..tgt_worker_seat_name, g_savedata.player.peer_id);
			worker_seat_ticks = 0;
		end;
		local worker_matrix, success = server.getObjectPos(worker.id);
		
		local my_data = server.getCharacterData(g_savedata.player.id);
		local w_data = server.getCharacterData(worker.id);
		local player_items = GrabCharacterItems(g_savedata.player.id);
		local worker_items = GrabCharacterItems(worker.id);
		
		server.setCharacterData(g_savedata.player.id, w_data.hp, true, true);
		server.setCharacterData(worker.id, my_data.hp, true, true);
		
		if (worker_items ~= nil) then
			SetCharacterItems(g_savedata.player.id, worker_items, true);
		end;
		if (player_items ~= nil) then
			SetCharacterItems(worker.id, player_items, false);
		end;
		
		local px, py, pz = matrix.position(player_matrix);
		local wx, wy, wz = matrix.position(worker_matrix);
		
		if (need_seat_worker) then
			player_matrix = matrix.translation(px, py + 2, pz);
		end;
		
		if (need_seat_player) then
			worker_matrix = matrix.translation(wx, wy + 2, wz);
		end;	
		
		
		server.setObjectPos(worker.id, player_matrix);
		server.setPlayerPos(g_savedata.player.peer_id, worker_matrix);
		g_savedata.workers[worker.id].is_sit = false;
		g_savedata.workers[worker.id].seat_name = nil;
		g_savedata.workers[worker.id].vehicle_id = -1;
		g_savedata.player.is_sit = false;
		g_savedata.player.vehicle_id = -1;
		g_savedata.player.seat_name = nil;
		
		
		if (need_seat_player) then
			server.setCharacterSeated(g_savedata.player.id, tgt_player_vehicle_id, tgt_player_seat_name);
		end;
		
		if (need_seat_worker) then
			server.setCharacterSeated(sit_worker_id, tgt_worker_vehicle_id, tgt_worker_seat_name);
		end;
	end;
end;

function dailyPay()
	for _, worker in pairs(g_savedata.workers) do
		local my_currency = server.getCurrency() - worker.pay;
		local my_research_points = server.getResearchPoints;
		server.setCurrency(my_currency, my_research_points);
		server.announce(g_savedata.player.team_name, "daly payment for " ..worker.name.. " $" ..(worker.pay).. ". Balance: $" ..my_currency, g_savedata.player.peer_id);		
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