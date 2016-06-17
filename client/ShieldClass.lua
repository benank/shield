class 'ShieldInstance'

function ShieldInstance:__init(wno)

	self.wno = wno
	self.destroyed = false
	self.id = self.wno:GetId()
	self.pos = self.wno:GetPosition()
	self.angle = self.wno:GetAngle()
	self.obj = ClientStaticObject.Create({
		position = self.pos,
		angle = self.angle,
		--model = "km02.towercomplex.flz/key013_01-g.lod",
		model = " ",
		collision = "km02.towercomplex.flz/key013_01_lod1-g_col.pfx"
		})
	self.img = Image.Create(AssetLocation.Resource, "Hexagon_IMG")
	self.model = self:CreateSprite(self.img)
	self.delta = 0

	self.sub1 = Events:Subscribe("GameRender", self, self.Render)
	self.sub2 = Events:Subscribe("WorldNetworkObjectDestroy", self, self.Destroy)

end

function ShieldInstance:Destroy(args)

	if args.object:GetId() == self.id then
	
		if IsValid(self.obj) then self.obj:Remove() end
		Events:Unsubscribe(self.sub2)
		self.sub2 = nil
		self.obj = nil
		self.img = nil
		self.destroyed = true
		self.delta = 1
		
	end
	
end

function ShieldInstance:Render(args)

	if not self.destroyed then
		self.delta = self.delta + args.delta
	else
		self.delta = self.delta - args.delta
	end

	for r = 1, 7 do
		local numHexagons = 23
		if r % 2 == 0 then numHexagons = 24 end
		for i = 1, numHexagons do
			local rotateAngle = Angle(0,0,0)
			local adjust = 0
			if r % 2 == 0 then adjust = 0.2 end
			local transition
			if not self.destroyed then
				transition = self.delta * 2 - math.sin(math.abs(i - numHexagons / 2) / numHexagons / 2 * math.pi * 2) * 0.7 - math.sin(math.abs(r - 7 / 2) / 7 / 2 * math.pi * 2) / 2
				if transition > 0.4 then transition = 0.4 end
				if transition < 0 then transition = 0 end
			else
				transition = self.delta * 2 - math.sin(math.abs(i - numHexagons / 2) / numHexagons / 2 * math.pi * 2) * 0.7 - math.sin(math.abs(r - 7 / 2) / 7 / 2 * math.pi * 2) / 2
				if transition > 0.4 then transition = 0.4 end
				if transition < 0 then transition = 0 end
			end
			local t = Transform3()
			local offset = self.angle * Vector3(adjust + 4.8 - 0.4 * i, 0.4 * r - 0.25,0)
			t:Translate(self.pos + offset):Rotate(self.angle):Rotate(rotateAngle):Scale(transition)
			Render:SetTransform(t)
			self.model:Draw()
		end
	end
	
	if self.destroyed and self.delta <= 0 then
		Events:Unsubscribe(self.sub1)
		self.sub1 = nil
	end

end

function ShieldInstance:CreateSprite(image)
   local imageSize = image:GetSize()
   local size = Vector2(imageSize.x / imageSize.y, 1) / 2
   local uv1, uv2 = image:GetUV()

   local sprite = Model.Create({
      Vertex(Vector2(-size.x, size.y), Vector2(uv1.x, uv1.y)),
      Vertex(Vector2(-size.x,-size.y), Vector2(uv1.x, uv2.y)),
      Vertex(Vector2( size.x,-size.y), Vector2(uv2.x, uv2.y)),
      Vertex(Vector2( size.x,-size.y), Vector2(uv2.x, uv2.y)),
      Vertex(Vector2( size.x, size.y), Vector2(uv2.x, uv1.y)),
      Vertex(Vector2(-size.x, size.y), Vector2(uv1.x, uv1.y))
   })

   sprite:SetTexture(image)
   sprite:SetTopology(Topology.TriangleList)

   return sprite
end