function GetPlayer(PLAYER_NAME)
	for i,v in pairs (Players:GetPlayers()) do
		if string.lower(PLAYER_NAME):match("^" .. string.lower(v.Name)) then
			return v
		end
	end
	return nil
end
