class 'ShieldManager'

function ShieldManager:__init()

	self.shields = {}
	self.shieldTimeout = 30 -- Shield uptime
	
	Network:Subscribe("PlaceShield", self, self.PlaceShield)
	Events:Subscribe("ModuleUnload", self, self.Unload)

end

function ShieldManager:Unload()

	for index, wno in pairs(self.shields) do
	
		if IsValid(wno) then wno:Remove() end
		
	end

end

function ShieldManager:PlaceShield(args, player)

	local pos = player:GetPosition() + player:GetAngle() * Vector3.Forward * 3
	local wno = WorldNetworkObject.Create({position = pos, angle = player:GetAngle(), Shield = true})
	wno:SetNetworkValue("Shield", true)
	table.insert(self.shields, wno)
	Timer.SetTimeout(self.shieldTimeout * 1000, function()
		if IsValid(wno) then wno:Remove() end
    end)
	
end

ShieldManager = ShieldManager()