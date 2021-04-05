GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})  --GLOBAL相关照抄

PrefabFiles = {
	"oa_colourpen", 
    "oa_penlight",
}

Assets = {
   
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

--四色圆珠笔
STRINGS.NAMES.OA_COLOURPEN = "四色圆珠笔"    --名字
STRINGS.RECIPE_DESC.OA_COLOURPEN = "一支巨大的圆珠笔"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OA_COLOURPEN = "我已经怒不可遏了"  --人物检查的描述


AddRecipe("oa_colourpen",  --添加物品的配方
{Ingredient("featherpencil", 1)},  
RECIPETABS.WAR,  TECH.SCIENCE_ONE,  
nil, nil, nil, nil, nil,  
"images/weapons/oa_colourpen.xml",  --贴图.xml
"oa_colourpen.tex")  --贴图.tex

--荧光棒
STRINGS.NAMES.OA_PENLIGHT= "荧光棒"
STRINGS.RECIPE_DESC.OA_PENLIGHT = "可以照明的武器"  --配方上面的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OA_PENLIGHT = "我已经怒不可遏了"

AddRecipe("oa_penlight",  --添加物品的配方
{Ingredient("lantern", 1),Ingredient("lightninggoathorn", 1)},  --材料
RECIPETABS.WAR,  nil,  
nil, nil, nil, nil, nil, 
"images/weapons/oa_penlight.xml",  --贴图.xml
"oa_penlight.tex")  --贴图.tex



