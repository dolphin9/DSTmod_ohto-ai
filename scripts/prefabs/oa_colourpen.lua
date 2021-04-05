local assets = {
    Asset("ANIM","anim/oa_colourpen.zip"),
    Asset("IMAGE","images/weapons/oa_colourpen.tex"),
    Asset("ATLAS","images/weapons/oa_colourpen.xml"),
}

local function onequip(inst, owner) --装备
    owner.AnimState:OverrideSymbol("swap_object","oa_colourpen","swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end    

local function onunequip(inst, owner) --卸下
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("oa_colourpen")  --地上动画
    inst.AnimState:SetBuild("oa_colourpen")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("dull") --钝器
    
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(150)
    ---

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/weapons/oa_colourpen.xml"     --贴图

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("oa_colourpen", fn, assets)
