require("ts3defs")
require("ts3errors")

-- Run with "/lua run muteclient.muteByUid HS96yTGyseRNgSfvJ7kGVK6yCYk="
local function muteByUid(serverConnectionHandlerID, uid)
	local clients, error = ts3.getClientList(serverConnectionHandlerID)
	if error == ts3errors.ERROR_not_connected then
		ts3.printMessageToCurrentTab("Not connected")
		ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
		return
	elseif error ~= ts3errors.ERROR_ok then
		print("Error getting client list: " .. error)
		ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
		return
	end

	for i=1, #clients do
		local clientUID, error = ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)
		if error == ts3errors.ERROR_ok then
			if clientUID == uid then
				local muteStatus, error = ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_IS_MUTED)
				if error == ts3errors.ERROR_ok then
					if muteStatus == "0" then
						local error = ts3.requestMuteClients(serverConnectionHandlerID, { clients[i] })
						if error == ts3errors.ERROR_ok then
							ts3.printMessageToCurrentTab("Client " .. clients[i] .. " muted")
							ts3.playWaveFile(serverConnectionHandlerID, "sound/default/talkpower_revoked.wav")
							return
						else
							print("Error requesting client mute: " .. error)
							ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
							return
						end
					else
						local error = ts3.requestUnmuteClients(serverConnectionHandlerID, { clients[i] })
						if error == ts3errors.ERROR_ok then
							ts3.printMessageToCurrentTab("Client " .. clients[i] .. " unmuted")
							ts3.playWaveFile(serverConnectionHandlerID, "sound/default/talkpower_granted.wav")
							return
						else
							print("Error requesting client unmute: " .. error)
							ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
							return
						end
					end
				else
					print("Error requesting client mute: " .. error)
					ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
					return
				end
			end
		else
			print("Error requesting CLIENT_UNIQUE_IDENTIFIER: " .. error)
			ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
			return
		end
	end
	ts3.printMessageToCurrentTab("user with uid=" .. uid .. " is not connected to this server")
	ts3.playWaveFile(serverConnectionHandlerID, "sound/default/error.wav")
end

-- Run with "/lua run muteclient.showClients"
local function showClients(serverConnectionHandlerID)
	local clients, error = ts3.getClientList(serverConnectionHandlerID)
	if error == ts3errors.ERROR_not_connected then
		ts3.printMessageToCurrentTab("Not connected")
		return
	elseif error ~= ts3errors.ERROR_ok then
		print("Error getting client list: " .. error)
		return
	end

	local msg = ("There are currently " .. #clients .. " visible clients:")
	for i=1, #clients do
		local clientName, error = ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_NICKNAME)
		if error == ts3errors.ERROR_ok then
			msg = msg .. "\n " .. clients[i] .. " " .. clientName
		else
			clientName = "Error getting client name"
		end

		local clientName, error = ts3.getClientVariableAsString(serverConnectionHandlerID, clients[i], ts3defs.ClientProperties.CLIENT_UNIQUE_IDENTIFIER)
		if error == ts3errors.ERROR_ok then
			msg = msg .. "\n uid=" .. clientName
		else
			clientName = "Error getting CLIENT_UNIQUE_IDENTIFIER"
		end
	end
	ts3.printMessageToCurrentTab(msg)
end

muteclient = {
	muteByUid = muteByUid,
	showClients = showClients
}
