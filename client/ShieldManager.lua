class 'ShieldManager'

function ShieldManager:__init()

	self.shields = {}
	
	self.key = "K"
	
	Timer.SetTimeout(1000, function()
		--More WNO bugs.
		Events:Subscribe("WorldNetworkObjectCreate", self, self.WNOCreate)
    end)
	Events:Subscribe("WorldNetworkObjectDestroy", self, self.WNODestroy)
	
	Events:Subscribe("KeyUp", self, self.TempPlace)

end

function ShieldManager:TempPlace(args)

	if args.key == string.byte(self.key) then
	
		Network:Send("PlaceShield")
		
	end
	
end

function ShieldManager:WNODestroy(args)

	self.shields[args.object:GetId()] = nil

end

function ShieldManager:WNOCreate(args)

	if args.object:GetValue("Shield") and not self.shields[args.object:GetId()] then
	
		local weapon = ShieldInstance(args.object)
		self.shields[args.object:GetId()] = weapon
		
	end
	
end

ShieldManager = ShieldManager()