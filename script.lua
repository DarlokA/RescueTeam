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

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, one, two, three, four, five)

	if (command == "?help")
	then
		server.announce("[HELP]", "?help - show this help");
		server.announce("[HELP]", "?hire - hire new worker in to you team.");
	end

end
