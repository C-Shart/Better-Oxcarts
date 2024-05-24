local modname="[BetterOxcarts]"

local _NPCManager = sdk.get_managed_singleton("app.NPCManager")
local top_char_ids = {}
local top_cids_index = nil
local this_ox_id = 0

-- 05/14 I don't think I need this anymore actually?
-- 05/16 Keeping it until I'm positive I don't need it for anything anymore
-- Creates an enum of all Character IDs and stores it
local function generate_char_ids()
    local character_ids = sdk.find_type_definition("app.CharacterID")
    if not character_ids then return {} end
    
    local fields = character_ids:get_fields()
    local enum = {}
    
    for i, field in ipairs(fields) do
        local name = field:get_name()
        local raw_value = field:get_data()
        
        if raw_value then
            enum[raw_value] = name
        end    
    end    
    return enum
end    

-- Skips execution of any hooked method.
local function skip_execution(args)
    return sdk.PreHookResult.SKIP_ORIGINAL
end

-- Hooks onDamageHit and onCalcDamageEnd for the oxcart and skips them.
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("onDamageHit"),
    skip_execution
)
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("onCalcDamageEnd"),
    skip_execution
)

-- Hooks executeBreak and skips it so the cart doesn't automatically break in certain circumstances.
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("executeBreak"),
    skip_execution
)
sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("executeBreak"),
    skip_execution
)

local char_ids = generate_char_ids()
-- Checks if table tbl has a given value val
local function has_character_id(tbl, val)
    for k,v in ipairs(tbl) do
        if v == val then
            top_cids_index = k
            return true 
        end        
    end        
    return false
end        

-- Hooks registNPC and checks if the character is in top_char_ids, then sets invuln if so.
sdk.hook(
    _NPCManager:get_type_definition():get_method("registNPC"),
    function(args)
        if #top_char_ids > 0 then
            if has_character_id(top_char_ids, sdk.to_managed_object(args[3])["CharacterID"]) then
                local char = sdk.to_managed_object(args[3])
                local reg_chara_id = char["CharacterID"]
                local char_hitctrl = char["<Hit>k__BackingField"]
                local is_char_invuln = char_hitctrl["<IsInvincible>k__BackingField"]
                --print(" --inv : " .. tostring(is_char_invuln))

                if is_char_invuln ~= true then
                    char_hitctrl:set_field("<IsInvincible>k__BackingField", true)
                    --print(" --inv : " .. tostring(char_hitctrl["<IsInvincible>k__BackingField"]))
                end        
                table.remove(top_char_ids, top_cids_index)
            end        
        end        
    end        
)        

-- Does what it says on the tin
local function make_ox_and_cart_invincible(oxobj)
    this_ox_id = 0
    local ox_object = sdk.to_managed_object(oxobj)
    if ox_object then
        local oxCharaField = ox_object["<Chara>k__BackingField"]
        this_ox_id = oxCharaField["CharacterID"]
        local oxHitCtrl = oxCharaField["<Hit>k__BackingField"]
        if oxHitCtrl then
            local mmIsInvincible = oxHitCtrl["<IsInvincible>k__BackingField"]
            if mmIsInvincible ~= true then
                oxHitCtrl:set_field("<IsInvincible>k__BackingField", true)
            end
        end
    end
end

-- Gets driver & guards & does stuff to them >:3
local function make_driver_and_guards_invincible(oid)
    local oxcart_status = _NPCManager["OxcartManager"]:getStatus(oid)
    local driver_field = oxcart_status["DriverID"]
    local driver_id = driver_field.CharaID
    local driver = _NPCManager:getCharacter(driver_id)
    if not driver then
        table.insert(top_char_ids, driver_id)
    end

    local guards_list = oxcart_status["_Guards"]
    local guards_length = guards_list._items:get_size()
    for i=0, guards_length do
        if guards_list[i] then
            local guard = guards_list[i].CharaID
            if not _NPCManager:getCharacter(guard) then
                table.insert(top_char_ids, guard)
            else
                local guard_char = _NPCManager:getCharacter(guard)
                local guard_hitctrl = guard_char["<Hit>k__BackingField"]
                local is_guard_invuln = guard_hitctrl["<IsInvincible>k__BackingField"]
                if is_guard_invuln ~= true then
                    guard_hitctrl:set_field("<IsInvincible>k__BackingField", true)
                end
            end
        end
    end
end

-- Hooks Ch299003.connectOxcart and makes ox, cart, driver, guards invincible
sdk.hook(
    sdk.find_type_definition("app.Ch299003"):get_method("connectOxcart"),
    function(args)
        make_ox_and_cart_invincible(args[2])
        make_driver_and_guards_invincible(this_ox_id)
    end,
    nil
)