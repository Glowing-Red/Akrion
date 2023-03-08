for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do
	if v:IsA("BasePart")
		v.Material = "Plastic"
	end
end
