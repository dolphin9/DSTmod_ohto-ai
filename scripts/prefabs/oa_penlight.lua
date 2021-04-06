local assets = {
    Asset("ANIM","anim/oa_penlight.zip"),
    Asset("IMAGE","images/weapons/oa_penlight.tex"),
    Asset("ATLAS","images/weapons/oa_penlight.xml"),
}

local prefabs = {
    "oa_openlightfire", --光照特效
}

local function onremovefire(fire)   
    fire.oa_penlight.fire = nil
end

local function OnRemoveEntity(inst)     
    if inst.fire ~= nil then
        inst.fire:Remove()
    end
end

local function turnoff(inst)    --关灯
    local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
    if owner ~= nil and inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then

    end
    inst.components.fueled:StopConsuming()
    if inst.fire ~= nil then
        if inst.fire and inst.fire:IsValid() then
            inst.fire:Remove()
        end
        inst.fire = nil
    end
end

local function onfuelchange(newsection, oldsection, inst)   ---?
    if newsection <= 0 then
        --when we burn out
        if inst.components.burnable ~= nil then
            inst.components.burnable:Extinguish()
        end
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                    announce = "ANNOUNCE_TORCH_OUT",
                }
                turnoff(inst)
                owner:PushEvent("itemranout", data)
                return
            end
        end
        inst:Remove()
    end
end

local function onequip(inst, owner) --装备

    inst.components.burnable:Ignite()

    owner.AnimState:OverrideSymbol("swap_object","oa_penlight","swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.fire == nil then    --装备点亮
        inst.fire = SpawnPrefab("oa_penlightfire")
        inst.fire.oa_penlight = inst
        inst:ListenForEvent("onremove", onremovefire, inst.fire)
    end

    inst.fire.entity:SetParent(owner.entity)

end    

local function onunequip(inst, owner) --卸下
    if inst.fire ~= nil then
        inst.fire:Remove()
    end

    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function penlightdepleted(inst)
    local equippable = inst.components.equippable
    if equippable ~= nil and equippable:IsEquipped() then    
        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
        if owner ~= nil then
            local data = {
                prefab = inst.prefab,
                equipslot = equippable.equipslot,
            }
            turnoff(inst)
            owner:PushEvent("torchranout", data)                
        end
    end
    turnoff(inst)
end    

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("oa_penlight")  --地上动画
    inst.AnimState:SetBuild("oa_penlight")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddTag("wildfireprotected")
    inst:AddTag("sharp") --锐器
    
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(75)
    ---

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/weapons/oa_penlight.xml"     --贴图

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil

    inst:AddComponent("fueled")    
    inst.components.fueled.fueltype = FUELTYPE.CAVE
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.NIGHTSTICK_FUEL)
    inst.components.fueled:SetDepletedFn(penlightdepleted)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true

    MakeHauntableLaunch(inst)

    inst.OnRemoveEntity = OnRemoveEntity

    return inst
end

return Prefab("oa_penlight",fn,assets)
