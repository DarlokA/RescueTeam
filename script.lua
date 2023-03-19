g_savedata = {
	["player"] = { name = nil, peer_id = nil, id = -1, team_name=nil, is_sit = false, vehicle_id = -1, seat_name= nil, map_marker = nil },
	["workers"] = {},
	["day"] = 0,
	["settings"] = false,
	["vehicles"] = {},
	["no_pay_sw_items"] = false,
	["PlayerVehicles"]= {},
	["GenericVehicles"] = {},
	["Enemy_AI"] = {},
	["Waypoints"] = {},
}
temp = {}
need_seat_player = false;
tgt_player_vehicle_id = -1;
tgt_player_seat_name = nil;
player_seat_ticks = 0;
player_tp_ticks = 0;
player_tp_matrix = nil;

need_seat_worker = false;
tgt_worker_vehicle_id = -1;
tgt_worker_seat_name = nil;
sit_worker_id = -1;
worker_seat_ticks = 0;

dismiss_pay = 2000;

second = 60;

map_opened = false;

offsetType = {};
eq_items = {};

--g_savedata.vehicles[vehicle_id] = { peer_id = peer_id, name = name, transform, dx = 0, dy = 0, dz= 0, ticks = 0 };


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
	if g_savedata["Waypoints"] == nil then
		g_savedata.Waypoints = {};
	end


	offsetType[1] = { name = "worker", pay = 100}
	offsetType[2] = { name = "fishing", pay = 100 }
	offsetType[3] = { name = "waiter", pay = 100 }
	offsetType[4] = { name = "swimsuit", pay = 100 }
	offsetType[5] = { name = "military", pay = 100 }
	offsetType[6] = { name = "office", pay = 100 }
	offsetType[7] = { name = "police", pay = 100 }
	offsetType[8] = { name = "science", pay = 100 }
	offsetType[9] = { name = "medical", pay = 100 }
	offsetType[10] = { name = "wetsuit", pay = 100 }
	offsetType[11] = { name = "civilian", pay = 100 }
	--[[
	OUTFIT_TYPE |
	0 = none,
	1 = worker,
	2 = fishing,
	3 = waiter,
	4 = swimsuit,
	5 = military,
	6 = office,
	7 = police,
	8 = science,
	9 = medical,
	10 = wetsuit,
	11 = civilian
	
	Outfits
	0 = none,
	1 = diving,
	2 = firefighter,
	3 = scuba,
	4 = parachute, [int = {0 = deployed, 1 = ready}]
	5 = arctic,
	29 = hazmat,
	74 = bomb_disposal,
	75 = chest_rig,
	76 = black_hawk_vest
	77 = plate_vest,
	78 = armor_vest,
Items
	6 = binoculars,
	7 = cable,
	8 = compass,
	9 = defibrillator, [int = charges]
	10 = fire_extinguisher, [float = ammo]
	11 = first_aid, [int = charges]
	12 = flare, [int = charges]
	13 = flaregun, [int = ammo]
	14 = flaregun_ammo, [int = ammo]
	15 = flashlight, [float = battery]
	16 = hose, [int = {0 = hose off, 1 = hose on}]
	17 = night_vision_binoculars, [float = battery]
	18 = oxygen_mask, [float = oxygen]
	19 = radio, [int = channel] [float = battery]
	20 = radio_signal_locator, [float = battery]
	21 = remote_control, [int = channel] [float = battery]
	22 = rope,
	23 = strobe_light, [int = {0 = off, 1 = on}] [float = battery]
	24 = strobe_light_infrared, [int = {0 = off, 1 = on}] [float = battery]
	25 = transponder, [int = {0 = off, 1 = on}] [float = battery]
	26 = underwater_welding_torch, [float = charge]
	27 = welding_torch, [float = charge]
	28 = coal,
	30 = radiation_detector, [float = battery]
	31 = c4, [int = ammo]
	32 = c4_detonator,
	33 = speargun, [int = ammo]
	34 = speargun_ammo,
	35 = pistol, [int = ammo]
	36 = pistol_ammo,
	37 = smg, [int = ammo]
	38 = smg_ammo,
	39 = rifle, [int = ammo]
	40 = rifle_ammo,
	41 = grenade, [int = ammo]
	42 = machine_gun_ammo_box_k,
	43 = machine_gun_ammo_box_he,
	44 = machine_gun_ammo_box_he_frag,
	45 = machine_gun_ammo_box_ap,
	46 = machine_gun_ammo_box_i,
	47 = light_auto_ammo_box_k,
	48 = light_auto_ammo_box_he,
	49 = light_auto_ammo_box_he_frag,
	50 = light_auto_ammo_box_ap,
	51 = light_auto_ammo_box_i,
	52 = rotary_auto_ammo_box_k,
	53 = rotary_auto_ammo_box_he,
	54 = rotary_auto_ammo_box_he_frag,
	55 = rotary_auto_ammo_box_ap,
	56 = rotary_auto_ammo_box_i,
	57 = heavy_auto_ammo_box_k,
	58 = heavy_auto_ammo_box_he,
	59 = heavy_auto_ammo_box_he_frag,
	60 = heavy_auto_ammo_box_ap,
	61 = heavy_auto_ammo_box_i,
	62 = battle_shell_k,
	63 = battle_shell_he,
	64 = battle_shell_he_frag,
	65 = battle_shell_ap,
	66 = battle_shell_i,
	67 = artillery_shell_k,
	68 = artillery_shell_he,
	69 = artillery_shell_he_frag,
	70 = artillery_shell_ap,
	71 = artillery_shell_i,
	72 = glowstick,
	73 = dog_whistle,

	
	
	--]]
	
	
--Outfits
	eq_items[0] = { name="none", active = false, ival = nil, fval = nil, pay= 0 };
	eq_items[1] = { name="diving", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[2] = { name="firefighter", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[3] = { name="scuba", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[4] = { name="parachute", active = false,  ival = 1, fval = nil, pay= 0};-- = {0 = deployed, 1 = ready}]
	eq_items[5] = { name="arctic", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[29] = { name="hazmat", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[74] = { name="bomb_disposal", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[75] = { name="chest_rig", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[76] = { name="black_hawk_vest", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[77] = { name="plate_vest", active = false,  ival = nil, fval = nil, pay= 0};
	eq_items[78] = { name="armor_vest", active = false,  ival = nil, fval = nil, pay= 0};
--Items
	eq_items[6] = {  name="binoculars", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[7] = {  name="cable", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[8] = {  name="compass", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[9] = {  name="defibrillator", active = false,  ival = 4, fval = nil, pay= 0 };-- [int = charges]
	eq_items[10] = { name="fire_extinguisher", active = false,  ival = nil, fval = 9.0, pay= 500 };-- [float = ammo]
	eq_items[11] = { name="first_aid", active = false,  ival = 4, fval = nil, pay= 100 };-- [int = charges]
	eq_items[12] = { name="flare", active = true,  ival = 4, fval = nil, pay= 100 };-- [int = charges]
	eq_items[13] = { name="flaregun", active = false,  ival = 1, fval = nil, pay= 50 };-- [int = ammo]
	eq_items[14] = { name="flaregun_ammo", active = false,  ival = 4, fval = nil, pay= 200 };-- [int = ammo]
	eq_items[15] = { name="flashlight", active = false,  ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	eq_items[16] = { name="hose", active = false,  ival = 0, fval = nil, pay= 0 };-- [int = {0 = hose off, 1 = hose on}]
	eq_items[17] = { name="night_vision_binoculars", active = false,  ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	eq_items[18] = { name="oxygen_mask", active = false,  ival = nil, fval = 100.0, pay= 0 };-- [float = oxygen]
	eq_items[19] = { name="radio", active = true,  ival = 0, fval = 100.0, pay= 0 };-- [int = channel] [float = battery]
	eq_items[20] = { name="radio_signal_locator", active = false,  ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	eq_items[21] = { name="remote_control", active = false,  ival = 1, fval = 100.0, pay= 0 };-- [int = channel] [float = battery]
	eq_items[22] = { name="rope", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[23] = { name="strobe_light", active = true,  ival = 0, fval = 100.0, pay= 0 };-- [int = {0 = off, 1 = on}] [float = battery]
	eq_items[24] = { name="strobe_light_infrared", active = true,  ival = 0, fval = 100.0, pay= 0 };-- [int = {0 = off, 1 = on}] [float = battery]
	eq_items[25] = { name="transponder", active = true,  ival = 0, fval = 100.0, pay= 0 };-- [int = {0 = off, 1 = on}] [float = battery]
	eq_items[26] = { name="underwater_welding_torch", active = false,  ival = nil, fval = 250.0, pay= 1000 };-- [float = charge]
	eq_items[27] = { name="welding_torch", active = false,  ival = nil, fval = 400.0, pay= 500 };-- [float = charge]
	eq_items[28] = { name="coal", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[30] = { name="radiation_detector", active = true,  ival = nil, fval = 100.0, pay= 0 };-- [float = battery]
	
	
	eq_items[31] = { name="c4", active = false,  ival = 1, fval = nil, pay= 0 }; --[int = ammo]
	eq_items[32] = { name="c4_detonator", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[33] = { name="speargun", active = false,  ival = 1, fval = nil, pay= 0 }; --[int = ammo]
	eq_items[34] = { name="speargun_ammo", active = false,  ival = 8, fval = nil, pay= 0 };
	eq_items[35] = { name="pistol", active = false,  ival = 17, fval = nil, pay= 0 }; --[int = ammo]
	eq_items[36] = { name="pistol_ammo", active = false,  ival = 17, fval = nil, pay= 0 };
	eq_items[37] = { name="smg", active = false,  ival = 40, fval = nil, pay= 0 }; --[int = ammo]
	eq_items[38] = { name="smg_ammo", active = false,  ival = 40, fval = nil, pay= 0 };
	eq_items[39] = { name="rifle", active = false,  ival = 30, fval = nil, pay= 0 }; --[int = ammo]
	eq_items[40] = { name="rifle_ammo", active = false,  ival = 30, fval = nil, pay= 0 };
	eq_items[41] = { name="grenade", active = false,  ival = 1, fval = nil, pay= 0 }; --[int = ammo]
	eq_items[42] = { name="machine_gun_ammo_box_k", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[43] = { name="machine_gun_ammo_box_he", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[44] = { name="machine_gun_ammo_box_he_frag", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[45] = { name="machine_gun_ammo_box_ap", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[46] = { name="machine_gun_ammo_box_i", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[47] = { name="light_auto_ammo_box_k", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[48] = { name="light_auto_ammo_box_he", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[49] = { name="light_auto_ammo_box_he_frag", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[50] = { name="light_auto_ammo_box_ap", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[51] = { name="light_auto_ammo_box_i", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[52] = { name="rotary_auto_ammo_box_k", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[53] = { name="rotary_auto_ammo_box_he", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[54] = { name="rotary_auto_ammo_box_he_frag", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[55] = { name="rotary_auto_ammo_box_ap", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[56] = { name="rotary_auto_ammo_box_i", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[57] = { name="heavy_auto_ammo_box_k", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[58] = { name="heavy_auto_ammo_box_he", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[59] = { name="heavy_auto_ammo_box_he_frag", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[60] = { name="heavy_auto_ammo_box_ap", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[61] = { name="heavy_auto_ammo_box_i", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[62] = { name="battle_shell_k", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[63] = { name="battle_shell_he", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[64] = { name="battle_shell_he_frag", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[65] = { name="battle_shell_ap", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[66] = { name="battle_shell_i", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[67] = { name="artillery_shell_k", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[68] = { name="artillery_shell_he", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[69] = { name="artillery_shell_he_frag", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[70] = { name="artillery_shell_ap", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[71] = { name="artillery_shell_i", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[72] = { name="glowstick", active = false,  ival = nil, fval = nil, pay= 0 };
	eq_items[73] = { name="dog_whistle", active = false,  ival = nil, fval = nil, pay= 0 };
	
	if g_savedata.settings == false then
		on_restore_settings();
	end;
	
end;

function onToggleMap(peer_id, is_open)
	map_opened = is_open;
	local is_settings = server.getGameSettings()["settings_menu"];
	if not is_settings then
		if is_open then--open map
			for i = 2, 9 do
				local eq_id, success = server.getCharacterItem(g_savedata.player.id, i);
				if success then 
					if eq_id == 19 then --radio
						server.setGameSetting("map_show_players", true);
					end;
				end;
			end;
			
			for id, worker in pairs (g_savedata.workers) do
				for i = 2, 9 do
				local eq_id, success = server.getCharacterItem(id, i);
				if success then 
					if eq_id == 19 then --radio
						local ui_id = server.getMapID();
						worker.map_marker = ui_id;
						--[[
						POSITION_TYPE |
						0 = fixed,
						1 = vehicle,
						2 = object

						MARKER_TYPE |
						0 = delivery_target,
						1 = survivor,
						2 = object,
						3 = waypoint,
						4 = tutorial,
						5 = fire,
						6 = shark,
						7 = ice,
						8 = search_radius
						--]]
						
						local worker_matrix, success = server.getObjectPos(worker.id);
						local x, y, z = matrix.position(worker_matrix);
						local text = worker.name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
						server.addMapObject(peer_id, ui_id, 2, 4, x, z, 0, 0, nil, worker.id, worker.name, 0, text);
					end;
				end;
			end;
			end;
			
		else --close map
			server.setGameSetting("map_show_players", false);
			for id, worker in pairs (g_savedata.workers) do
				if (worker.map_marker ~= nil) then
					server.removeMapObject(peer_id, worker.map_marker);
				end;
				worker.map_marker = nil;
			end;
		end;
	end;
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
--local worker = { name = worker_name, 
					--outfit = outfit, 
					--is_powered = true, 
					--isPlayer = false, 
					--id=rescuer_id, 
					--is_sit = false, 
					--vehicle_id = -1, 
					--seat_name= nil, 
					--pop_up=server.getMapID(), 
					--powered_time = server.getDateValue(), 
					--pay = pay}

function isVehicleSit( vehicle_id )
	for _wid, worker in pairs(g_savedata.workers) do
		if worker ~= nil and worker.vehicle_id == vehicle_id then
			need_seat_worker = true;
			tgt_worker_vehicle_id = vehicle_id;
			tgt_worker_seat_name = worker.seat_name;
			sit_worker_id = _wid;
			--server.announce("[" ..worker.name.. "]", "Sit to vehicle_id: "..tgt_worker_vehicle_id.. ", seatName: " ..tgt_worker_seat_name, g_savedata.player.peer_id);
			worker_seat_ticks = 0;
			return true;
		end
	end
	return false;
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


function isPlayerVehicle(vehicle_id)
	local v = g_savedata.vehicles[vehicle_id];
	if (v == nil) then 
		return false; 
	else
		return v.peer_id > -1;
	end;
end;

function nearestVehicle()
	local tgt_vid = -1;
	local bestD = 100;
	local player_matrix, _ = server.getPlayerPos(g_savedata.player.peer_id);
	for id, vehicle in pairs (g_savedata.vehicles) do
		local transform_matrix, is_success = server.getVehiclePos(id);
		if is_success then
			local distSQ = distQ(transform_matrix, player_matrix);
			if (bestD > distSQ) then
				bestD = distSQ;
				tgt_vid = id;
			end;
		end
	end
	return tgt_vid;
end

function onCharacterUnsit(object_id, vehicle_id, seat_name)
	if object_id == g_savedata.player.id and not need_seat_player then
		g_savedata.player.is_sit = false;
		g_savedata.player.vehicle_id = -1;
		g_savedata.player.seat_name = nil;
	end
	if not need_seat_worker then
		for id, h in pairs(g_savedata.workers) do
			if id == object_id then
				g_savedata.workers[id].is_sit = false;
				g_savedata.workers[id].vehicle_id = -1;
				g_savedata.workers[id].seat_name = nil;
			end
		end
	end
end

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

function on_restore_settings( )
	server.setGameSetting("third_person", true)
	server.setGameSetting("third_person_vehicle", true)
	server.setGameSetting("vehicle_damage", true)
	server.setGameSetting("player_damage", true)
	server.setGameSetting("npc_damage", true)
	server.setGameSetting("sharks", true)
	server.setGameSetting("fast_travel", false)
	server.setGameSetting("teleport_vehicle", false)
	server.setGameSetting("rogue_mode", false)
	server.setGameSetting("auto_refuel", true)
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
	server.setGameSetting("despawn_on_leave", false)
end;


function onVehicleSpawn(vehicle_id, peer_id, x, y, z, cost) 
	
	
	if (peer_id == g_savedata.player.peer_id) then
		if g_savedata.settings == false then
			on_restore_settings();
			g_savedata.settings = true;
		end;
		local name, is_success = server.getVehicleName(vehicle_id);
		if is_success then
			local days_survived = server.getDateValue();
			local pos = matrix.translation(x, y, z);
			local vdata, is_success = server.getVehicleData(vehicle_id);
			g_savedata.vehicles[vehicle_id] = 
				{ peer_id = peer_id, 
					name = name, 
					transform = pos, 
					dx = 0, 
					dy = 0, 
					dz= 0, 
					ticks = 0, 
					state = "SPAWNED", 
					cost = cost, 
					spawn_time=days_survived, 
					file = vdata.filename
				};
			--server.setVehicleEditable(vehicle_id, false);
		end;
	end;
	local name = (server.getVehicleName(vehicle_id))
	if peer_id ~= -1 then
		g_savedata["PlayerVehicles"][vehicle_id] = name
		g_savedata["GenericVehicles"][vehicle_id] = name
	else
		temp[vehicle_id] = (server.getVehicleData(vehicle_id))
	end
	
end;

function onVehicleDespawn(vehicle_id, peer_id)
	g_savedata.vehicles[vehicle_id] = nil;
	g_savedata["PlayerVehicles"][vehicle_id] = nil
	g_savedata["GenericVehicles"][vehicle_id] = nil
	g_savedata["Enemy_AI"][vehicle_id] = nil
end;

function onVehicleUnload(vehicle_id)
	local vehicle = g_savedata.vehicles[vehicle_id];
	if vehicle ~= nil then
		vehicle.state = "AI_TRAFFIC";
		vehicle.ticks = 0;
	end;
end;

function onVehicleLoad(vehicle_id)
	local vehicle = g_savedata.vehicles[vehicle_id];
	if vehicle ~= nil then
		--if vehicle.state == "AI_TRAFFIC" then
			--server.resetVehicleState(vehicle_id);
		--end;
		vehicle.state = "SIMULATED";
	end;
	if (isVehicleSit(vehicle_id)) then	
		checkSit();
	end;
	
	if need_seat_player and vehicle_id == tgt_player_vehicle_id then
		tryingSitPlayer();
	end;
	if need_seat_worker and vehicle_id == tgt_worker_vehicle_id then
		tryingSitWorker();
	end;
end;

function Traffic(  )
	for vehicle_id, vehicle in pairs (g_savedata.vehicles) do
		local pos_matrix, is_success = server.getVehiclePos(vehicle_id);
		local x1, y1, z1 = matrix.position(vehicle.transform);
		local x2, y2, z2 = matrix.position(pos_matrix);
		

--		if vehicle.state == "AI_TRAFFIC" then
--			vehicle.ticks = vehicle.ticks + 1;
--			if vehicle.ticks > 100 then
--				local dx = vehicle.dx * vehicle.ticks;
--				local dz = vehicle.dz * vehicle.ticks;
--				x2 = x1 + dx;
--				y2 = y1;
--				z2 = z1 + dz;
--				
--				local length_xz = math.sqrt((dx * dx) + (dz * dz));
--				local movement_x = dx / length_xz;
--               local movement_z = dz / length_xz;
--				
--				local rotation_matrix = matrix.rotationToFaceXZ(movement_x, movement_z);
--                local new_pos = matrix.multiply(matrix.translation(x2, y2, z2), rotation_matrix);
--				
--				g_savedata.vehicles[vehicle_id].transform = new_pos;
--				server.setVehiclePos(vehicle_id, new_pos);
--				
--				
--				for id, h in pairs(g_savedata.workers) do
--					if h.vehicle_id == vehicle_id then
--						local workerpos = matrix.translation(x2, y2 + 2, z2);
--						server.setObjectPos(id, workerpos);
--						if map_opened then
--							if (h.map_marker ~= nil) then
--								server.removeMapObject(vehicle.peer_id, h.map_marker);
--								local worker_matrix, success = server.getObjectPos(id);
--								local x, y, z = matrix.position(worker_matrix);
--								local text = h.name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
--								local ui_id = server.getMapID();
--								h.map_marker = ui_id;
--								server.addMapObject(peer_id, h.map_marker, 2, 4, x, z, 0, 0, nil, h.id, h.name, 0, text);
--							end;
--						end;
--						break;
--					end;
--				end;
--				
--				
--				vehicle.ticks = 0;
--			end;
--		end;
		if vehicle.state == "SIMULATED" then
			--if tgt_player_vehicle_id == vehicle_id and need_seat_player then
			--	pos_matrix = matrix.translation(x1, y1, z1);
			--	server.setVehiclePos(vehicle_id, pos_matrix);
			--	server.resetVehicleState(vehicle_id);
			--else
				g_savedata.vehicles[vehicle_id].dx = x2 - x1;
				g_savedata.vehicles[vehicle_id].dy = 0;
				g_savedata.vehicles[vehicle_id].dz = z2 - z1;
				g_savedata.vehicles[vehicle_id].transform = pos_matrix;
				
				
				for id, h in pairs(g_savedata.workers) do
					if h.vehicle_id == vehicle_id then
						if map_opened then
							if (h.map_marker ~= nil) then
								server.removeMapObject(vehicle.peer_id, h.map_marker);
								local worker_matrix, success = server.getObjectPos(id);
								local x, y, z = matrix.position(worker_matrix);
								local text = h.name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
								local ui_id = server.getMapID();
								h.map_marker = ui_id;
								server.addMapObject(peer_id, h.map_marker, 2, 4, x, z, 0, 0, nil, h.id, h.name, 0, text);
							end;
						end;
						
						break;
					end;
				end;
				
			--end;
		end;
	end;
end;

function tryingSitPlayer()
	if (need_seat_player) then
		local is_simulating, is_success = server.getVehicleSimulating(tgt_player_vehicle_id);
		if not is_simulating then
			local tgt, success = server.getVehiclePos(tgt_player_vehicle_id);
			if success then
				local tx, ty, tz = matrix.position(tgt);
				tgt = matrix.translation(tx, ty+2, tz);
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
			tgt = matrix.translation(tx, ty+2, tz);
			server.setPlayerPos(g_savedata.player.peer_id, tgt);
			server.setCharacterSeated(g_savedata.player.id, tgt_player_vehicle_id, tgt_player_seat_name);
		end;
		
		success, vid = isSit(g_savedata.player.id);
		if success and (vid == tgt_player_vehicle_id) then 
			need_seat_player = false;
		end;
		--local is_player_vehicle = isPlayerVehicle(tgt_player_vehicle_id);
		local is_simulating, is_success = server.getVehicleSimulating(tgt_player_vehicle_id);
		if not is_success then need_seat_player = false; end;
		if need_seat_player then 
			player_seat_ticks = player_seat_ticks + 1;
		end;
		if is_simulating and player_seat_ticks > 5 * second then 
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
				tgt = matrix.translation(tx, ty+2, tz);
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
		
		--local is_player_vehicle = isPlayerVehicle(tgt_player_vehicle_id);
		
		if not is_success then need_seat_worker = false; end;
		if need_seat_worker then
			worker_seat_ticks = worker_seat_ticks + 1;
		end;
		if is_simulating and worker_seat_ticks > 5*second then
			worker_seat_ticks = 0;
			need_seat_worker = false;
		end;
	end;
end;

function onTick(game_ticks)

	local days_survived = server.getDateValue();
	if (days_survived > g_savedata.day) then
		dailyPay();
	end;
	g_savedata.day = days_survived;
	if (player_tp_matrix ~= nil) and not need_seat_player then
		player_tp_ticks = player_tp_ticks + 1;
		server.setPlayerPos(g_savedata.player.peer_id, player_tp_matrix);
		if player_tp_ticks > 5*second then
			player_tp_ticks = 0;
			player_tp_matrix = nil;
		end;
	end;
	checkSit();
	tryingSitWorker();
	tryingSitPlayer();
	Traffic();
	
	for a,b in pairs(temp) do
		if b["tags"][1] == "type=dlc_weapons" then
			g_savedata["Enemy_AI"][a] = (server.getVehicleName(a))
		end
		g_savedata["GenericVehicles"][a] = (server.getVehicleName(a))
		temp[a] = nil
	end
	
end



function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	g_savedata.player.name = name;
	g_savedata.player.peer_id = peer_id;
	g_savedata.player.team_name = name.. " RS team";
	local object_id, is_success = server.getPlayerCharacterID(peer_id);
	g_savedata.player.id = object_id;
	printHelp(nil);
	for _, worker in pairs(g_savedata.workers) do
		local text = worker.name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[worker.id].pop_up, g_savedata.workers[worker.id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[worker.id].id);
	end
	
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
	
end

function onPlayerDie(steam_id, name, peer_id, is_admin, is_auth)
	
	local my_currency = server.getCurrency();
	local my_research_points = server.getResearchPoints();
	my_currency = my_currency - 2000;
	local text = "Player saved for 2000$";
	server.announce(g_savedata.player.team_name, text, g_savedata.player.peer_id);
	server.setCurrency(my_currency, my_research_points);
end

function WorkerFromName( name )
	for _id, h in pairs(g_savedata.workers) do
		if name == h.name then
			return _id, h;
		end
	end
	return nil, nil;
end;

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
	if (command == "?refuel") then 
		if (server.getGameSettings()["auto_refuel"]) then
			server.setGameSetting("auto_refuel", false);
			server.announce(g_savedata.player.team_name, "refuel next vehicle DISABLED", g_savedata.player.peer_id);
		else
			server.setGameSetting("auto_refuel", true);
			server.announce(g_savedata.player.team_name, "refuel next vehicle ENABLED", g_savedata.player.peer_id);
		end	
	end;
	if (command == "?unlock_all_components") then 
		if server.getGameSettings()["unlock_all_components"] == true then
			server.setGameSetting("unlock_all_components", false);
			server.announce(g_savedata.player.team_name, "unlock_all_components DISABLED", g_savedata.player.peer_id);
		else
			server.setGameSetting("unlock_all_components", true);
			server.announce(g_savedata.player.team_name, "unlock_all_components ENABLED", g_savedata.player.peer_id);
		end	
	end;
	if (command == "?activate_items") then ativate_items(arg1); end;
	if (command == "?no_pay_sw_items") then g_savedata.no_pay_sw_items = true; end;
	if (command == "?pay_sw_items") then g_savedata.no_pay_sw_items = false; end;
	if (command == "?sell_vehicle") then sellVehicle(); end;
	if (command == "?edit_vehicle") then editVehicle(); end;
	if (command == "?set_waypoint") then set_waypoint(arg1, arg2, arg3); end;
	if (command == "?reset_waypoint") then reset_waipoint(arg1); end;
	if (command == "?ai_stop") then ai_stop(arg1); end;
	if (command == "?ai_path") then ai_path(arg1, arg2, arg3); end;
end

function ai_path(arg1, arg2, arg3)
	local id, worker = WorkerFromName(arg1);
	local pathing = false;
	local wp_pos, success = server.getPlayerPos(g_savedata.player.peer_id);
	local x,y,z = matrix.position(wp_pos);
	if (id ~= nil and worker ~= nil) then
		local x = tonumber(arg2);
		local z = tonumber(arg3);
		if x ~= nil and z ~= nil then
			wp_pos = matrix.translation(x, y, z);
			pathing = wp_pos ~= nil;
		else
			local wname = arg2;
			if wname ~= nil then
				local wp = g_savedata["Waypoints"][wname];
				if wp ~= nil then
					wp_pos = wp.position;
					patching = wp_pos ~= nil;
				end;
			end
		end
	end;
	if patching then
		server.setAITarget(id, wp_pos);
		server.setAIState(id, 1);
		g_savedata.workers[id].ai_state = "path";
		server.announce(g_savedata.player.team_name, worker.name.." pathing", g_savedata.player.peer_id);
	end;
end;

function ai_stop(arg1)
		local id, worker = WorkerFromName(arg1);
		if (id ~= nil and worker ~= nil) then
			server.setAIState(id, 0);
			g_savedata.workers[id].ai_state = nil;
			server.announce(g_savedata.player.team_name, worker.name.." stopped", g_savedata.player.peer_id);
		end;
end;

function set_waypoint( arg1, arg2, arg3 )
	local wp_pos, success = server.getPlayerPos(g_savedata.player.peer_id);
	local x,y,z = matrix.position(wp_pos);
	local wname = arg1;
	local add = false;
	if arg1 ~= nil then
		if arg2 ~= nil and arg3 ~= nil then
			x = tonumber(arg1);
			z = tonumber(arg2);
			wname = arg3;
			if x ~= nil and z ~= nil then
				wp_pos = matrix.translation(x, y, z);
				add = true;
			end		
		else
			wname = arg1;
			add = true;
		end;
	end;
	if add then
		local wp = g_savedata["Waypoints"][wname];
		if (wp ~= nil and wp.mapid ~= nil) then
			server.removeMapObject(g_savedata.player.peer_id, wp.mapid);
			g_savedata["Waypoints"][wname] = nil;
		end;
		local ui_id = server.getMapID();
		local text = "Waypoint : "..wname;
		server.addMapLabel(g_savedata.player.peer_id, ui_id, 1, wname, x, z);
		g_savedata["Waypoints"][wname] = {position = wp_pos, mapid = ui_id };
		server.announce(g_savedata.player.team_name, "Add waipoint "..wname.." to map", g_savedata.player.peer_id);
	end;
end;

function reset_waipoint( arg1 )
	if arg1 ~= nil then
		local wname = arg1;
		local wp = g_savedata["Waypoints"][wname];
		if (wp ~= nil and wp.mapid ~= nil) then
			server.removeMapObject(g_savedata.player.peer_id, wp.mapid);
			g_savedata["Waypoints"][wname] = nil;
			server.announce(g_savedata.player.team_name, "Waipoint "..wname.." removed from map", g_savedata.player.peer_id);
		end;
	end;
end;

function sellVehicle()
	local vehicle_id = nearestVehicle();
	if vehicle_id >= 0 then
		if isPlayerVehicle(vehicle_id) then
			local my_currency = server.getCurrency();
			local my_research_points = server.getResearchPoints();
			--[[
			g_savedata.vehicles[vehicle_id] = 
		{ peer_id = peer_id, 
			name = name, 
			transform = pos, 
			dx = 0, 
			dy = 0, 
			dz= 0, 
			ticks = 0, 
			state = "SPAWNED", 
			cost = cost, 
			spawn_time=days_survived, 
			file = vdata.filename
		};
			]]--
			local vehicle = g_savedata.vehicles[vehicle_id];
			local days_survived = server.getDateValue();
			local days = days_survived - vehicle.spawn_time;
			local cash = vehicle.cost - vehicle.cost * days * 0.1;
			my_currency = my_currency + cash;
			local text = "Vehicle selling for "..cash .."$";
			server.announce(g_savedata.player.team_name, text, g_savedata.player.peer_id);
			server.setCurrency(my_currency, my_research_points);
			server.despawnVehicle(vehicle_id, false);
			g_savedata.vehicles[vehicle_id] = nil;
		else
			server.announce("[HELP]", "Error Not a Player Vehile!", g_savedata.player.peer_id);
		end
	else
		server.announce("[HELP]", "Error No Vehile for Sale!", g_savedata.player.peer_id);
	end
end

function editVehicle()
	local vehicle_id = nearestVehicle();
	if vehicle_id >= 0 then
		if isPlayerVehicle(vehicle_id) then
			local VEHICLE_DATA, is_success = server.getVehicleData(vehicle_id);
			if is_success then
				local editable = not VEHICLE_DATA.editable;
				server.setVehicleEditable(vehicle_id, editable);
				if editable then 
					server.announce(g_savedata.player.team_name, "Vehicle is EDITABLE", g_savedata.player.peer_id);
				else
					server.announce(g_savedata.player.team_name, "Vehicle is NOT EDITABLE", g_savedata.player.peer_id);
				end
			end	
		else
			server.announce("[HELP]", "Error Not a Player Vehile!", g_savedata.player.peer_id);
		end
	else
		server.announce("[HELP]", "Error No a Vehile for Edit!", g_savedata.player.peer_id);
	end
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
		server.announce("[HELP]", "?activate_items worker_name - activate character items.", g_savedata.player.peer_id);
		server.announce("[HELP]", "Use the Radio to show player or worker markers on the map.", g_savedata.player.peer_id);
		server.announce("[HELP]", "?no_pay_sw_items", g_savedata.player.peer_id);
		server.announce("[HELP]", "?pay_sw_items", g_savedata.player.peer_id);
		server.announce("[HELP]", "?refuel", g_savedata.player.peer_id);
		server.announce("[HELP]", "?unlock_all_components", g_savedata.player.peer_id);
		server.announce("[HELP]", "?sell_vehicle", g_savedata.player.peer_id);
		server.announce("[HELP]", "?edit_vehicle", g_savedata.player.peer_id);
		server.announce("[HELP]", "?set_waypoint x z name or ?set_waypoint name", g_savedata.player.peer_id);
		server.announce("[HELP]", "?reset_waypoint name", g_savedata.player.peer_id);
		server.announce("[HELP]", "?ai_stop worker", g_savedata.player.peer_id);
		server.announce("[HELP]", "?ai_path worker_name waypoint_name or ?ai_path worker_name x z", g_savedata.player.peer_id);
		--server.command("?ai_summon_hospital_ship "..mission.data.zone_x.." "..mission.data.zone_z)
		
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
		server.command("?set_gunner "..rescuer_id);
		local worker = { name = worker_name, outfit = outfit, is_powered = true, isPlayer = false, id=rescuer_id, is_sit = false, vehicle_id = -1, seat_name= nil, pop_up=server.getMapID(), powered_time = server.getDateValue(), pay = pay}
		g_savedata.workers[rescuer_id] = worker;
		local text = worker_name.. " powered by " ..server.getPlayerName(g_savedata.player.peer_id);
		server.setPopup(-1, g_savedata.workers[rescuer_id].pop_up, g_savedata.workers[rescuer_id].name, true, text, 0, 1.0, 0, 5, 0, g_savedata.workers[rescuer_id].id);
		local my_currency = server.getCurrency() - (pay * 10);
		local my_research_points = server.getResearchPoints();
		local cost = 
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
		ai_stop(worker.name);
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
	for i = 1, 10 do
		local eq_id, success = server.getCharacterItem(id, i);
		if success then 
			items[i] = { eq_id = eq_id };
		else
			items[i] = { eq_id = 0 };
		end;
	end;
	return items;
end;

function SetCharacterItems(id, items, need_pay, activate)
	local my_currency = server.getCurrency();
	local my_research_points = server.getResearchPoints();
	for idx, e in pairs (items) do
		local item = eq_items[e.eq_id];
		if item == nil then
			item = { name="unknown item", active = false,  ival = nil, fval = nil, pay= 0 };
		end;
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
		if (activate == nil or activate == false) then 
			local is_success = server.setCharacterItem(id, idx, e.eq_id, false, ival, fval);
		else
			local activate = item.active;
			local is_success = server.setCharacterItem(id, idx, e.eq_id, activate, ival, fval);
		end;
			
	end;
end;

function ativate_items(arg1)
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
					--if best_distance < 1000000 then 
						worker = h;
					--end;
				end;
			end;
		end;
	end;
	if worker ~= nil then
		local worker_items = GrabCharacterItems(worker.id);
		SetCharacterItems(worker.id, worker_items, false, true, arg2);
	else
		server.announce("[NO WORKER FOUNDED]", "?activate_items worker_name- activate character items.");
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
					--if best_distance < 1000000 then 
						worker = h;
					--end;
				end;
			end;
		end;
	end;
	if worker ~= nil then
		ai_stop(worker.name);
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
			if g_savedata.no_pay_sw_items == nil or g_savedata.no_pay_sw_items == false then 
				SetCharacterItems(g_savedata.player.id, worker_items, true, false);
			else
				SetCharacterItems(g_savedata.player.id, worker_items, false, false);
			end;
		end;
		if (player_items ~= nil) then
			SetCharacterItems(worker.id, player_items, false, false);
		end;
		
		local px, py, pz = matrix.position(player_matrix);
		local wx, wy, wz = matrix.position(worker_matrix);
		
		if (need_seat_worker) then
			player_matrix = matrix.translation(px, py + 2, pz);
			player_matrix_tmp = matrix.translation(px, py + 4, pz);
			server.setPlayerPos(g_savedata.player.peer_id, player_matrix_tmp);
			server.setCharacterSeated(sit_worker_id, tgt_worker_vehicle_id, tgt_worker_seat_name);
		end;
		
		if (need_seat_player) then
			worker_matrix = matrix.translation(wx, wy + 2, wz);
		end;	
		
		
		server.setObjectPos(worker.id, player_matrix);
		if not need_seat_player then
			player_tp_matrix = worker_matrix;
			player_tp_ticks = 0;
		end;
		--server.setPlayerPos(g_savedata.player.peer_id, worker_matrix);
		g_savedata.workers[worker.id].is_sit = false;
		g_savedata.workers[worker.id].seat_name = nil;
		g_savedata.workers[worker.id].vehicle_id = -1;
		g_savedata.player.is_sit = false;
		g_savedata.player.vehicle_id = -1;
		g_savedata.player.seat_name = nil;
		
		
		--if (need_seat_player) then
		--	server.setCharacterSeated(g_savedata.player.id, tgt_player_vehicle_id, tgt_player_seat_name);
		--end;
		
		--if (need_seat_worker) then
		--	server.setCharacterSeated(sit_worker_id, tgt_worker_vehicle_id, tgt_worker_seat_name);
		--end;
	end;
end;

function dailyPay()
	for _, worker in pairs(g_savedata.workers) do
		local my_currency = server.getCurrency() - worker.pay;
		local my_research_points = server.getResearchPoints();
		server.setCurrency(my_currency, my_research_points);
		server.announce(g_savedata.player.team_name, "daly payment for " ..worker.name.. " $" ..(worker.pay).. ". Balance: $" ..my_currency, g_savedata.player.peer_id);		
	end;
end;

function renameW(arg1, arg2)
	if arg1 == nil or arg2 == nil then return; end;
	local worker = nil
	local best_ditance = 999999999;
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

function calculate_distance_to_next_waypoint(path_pos, vehicle_pos)
    local vehicle_x, vehicle_y, vehicle_z = matrix.position(vehicle_pos)

    local vector_x = path_pos.x - vehicle_x
    local vector_z = path_pos.z - vehicle_z

    return math.sqrt( (vector_x * vector_x) + (vector_z * vector_z))
end


function distQ( m1, m2)
	local x1, y1, z1 = matrix.position(m1);
	local x2, y2, z2 = matrix.position(m2);
	return ((x2 - x1)^2) + ((y2 - y1)^2) + ((z2 - z1)^2);
end;