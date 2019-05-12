
if not VectorTarget then 
	VectorTarget = class({})
end

function VectorTarget:Init()
	print("[VectorTarget] Initializing...")
	CustomGameEventManager:RegisterListener("send_vector_position", Dynamic_Wrap(VectorTarget, "StartVectorCast"))
	CustomNetTables:SetTableValue( "ability_api", "vector_target", {})
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(VectorTarget, 'OnNPCSpawned'), self)
end

function VectorTarget:StartVectorCast( event )
	local caster = PlayerResource:GetSelectedHeroEntity(event.playerID)
	local position = Vector(event.PosX, event.PosY, event.PosZ)
	local position2 = Vector(event.Pos2X, event.Pos2Y, event.Pos2Z)
	local abilityName = event.abilityName

	local ability = caster:FindAbilityByName(abilityName)
	local direction = -(position - position2):Normalized()
	ability:OnVectorCastStart(position, direction)

end

function VectorTarget:OnNPCSpawned(event)
 	local npc = EntIndexToHScript(event.entindex)

 	if npc:IsRealHero() then
 		self:AddVectorTargetingAbilities(npc)
   	end
end

function VectorTarget:AddVectorTargetingAbilities(hero)
	print("[VT] Search for vector targeting abilities...")
	for i=1, 10 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			if ability:IsVectorTargeting() then
				local abilityTable = {
					name = ability:GetAbilityName(),
					range = ability:GetVectorTargetRange(),
				}
				local vectorAbilities = CustomNetTables:GetTableValue("ability_api", "vector_target")
				if not vectorAbilities then
					vectorAbilities = {}
				end
				table.insert(vectorAbilities, abilityTable)
				CustomNetTables:SetTableValue( "ability_api", "vector_target", vectorAbilities)
			end
		end
	end
end

function CDOTABaseAbility:IsVectorTargeting()
	return false
end

function CDOTABaseAbility:GetVectorTargetRange()
	return 800
end 

function CDOTABaseAbility:OnVectorCastStart(vStartLocation, vDirection)
	print("Vector Cast")
end