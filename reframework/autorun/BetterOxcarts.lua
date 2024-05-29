local modname="[BetterOxcarts]"

local _NPCManager = sdk.get_managed_singleton("app.NPCManager")
local top_char_ids = {}
--local top_parts_list = {}
local this_ox_id = 0

-- Hotkeys for testing
--[[
local hotkey_config = {}
hotkey_config.Hotkeys = {
    ["OxcartStatus"] = "I"
}
hotkeys.setup_hotkeys(hotkey_config.Hotkeys)
]]


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

-- Skips execution of any hooked method.
local function skip_execution(args)
    return sdk.PreHookResult.SKIP_ORIGINAL
end

-- Makes things invincible
local function make_invincible(obj)
    print("Character   : " .. tostring(obj["CharacterID"]))
    local obj_hit_ctrl = obj["<Hit>k__BackingField"]
    if obj_hit_ctrl then
        local is_invincible = obj_hit_ctrl["<IsInvincible>k__BackingField"]
        print(" - IsInvinc : " .. tostring(is_invincible))
        if is_invincible ~= true then
            obj_hit_ctrl:set_field("<IsInvincible>k__BackingField", true)
            print(" - IsInvinc : " .. tostring(obj_hit_ctrl["<IsInvincible>k__BackingField"]))
        end
    end
end

-- Makes ox invincible
local function make_ox_invincible(oxobj)
    this_ox_id = 0
    local ox_object = sdk.to_managed_object(oxobj)
    if ox_object then
        local ox_character = ox_object["<Chara>k__BackingField"]
        this_ox_id = ox_character["CharacterID"]
        make_invincible(ox_character)
    end
end

 -- Gets driver & guards & does stuff to them >:3
local function make_driver_and_guards_invincible(oid)
    local oxcart_status = _NPCManager["OxcartManager"]:getStatus(oid)
    local driver_field = oxcart_status["DriverID"]
    local driver_id = driver_field.CharaID
    local driver = _NPCManager:getCharacter(driver_id)
    if driver then
        make_invincible(driver)
    else
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
                make_invincible(guard_char)
            end
        end
    end
end

-- Hooks Ch299003.connectOxcart and makes ox, cart, driver, guards invincible
sdk.hook(
    sdk.find_type_definition("app.Ch299003"):get_method("connectOxcart"),
    function(args)
        print("")
        print("")
        print("====== BEGINNING INVINC CHECK/SET =======")
        make_ox_invincible(args[2])
        --make_cart_invincible(args[3])
        make_driver_and_guards_invincible(this_ox_id)
        -- top_cart_obj = sdk.to_managed_object(args[3])
    end,
    nil
)

-- Hooks methods to avoid the cart and its parts taking damage
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("onDamageHit"),
    skip_execution
)
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("onCalcDamageEnd"),
    skip_execution
)
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("executeBreak"),
    skip_execution
)
sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("executeBreak"),
    skip_execution
)
sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("callbackDamageHit"),
    skip_execution
)

-- Takes the cart parts and makes them invincible
 sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("start"),
    function(args)
        local this_part = sdk.to_managed_object(args[2])
        print(" --CARTPART : " .. tostring(this_part))
        local part_hitctrl = this_part["<CompHitCtrl>k__BackingField"]
        if part_hitctrl then
            local is_invincible = part_hitctrl["<IsInvincible>k__BackingField"]
            print(" - IsInvinc : " .. tostring(is_invincible))
            if is_invincible ~= true then
                part_hitctrl:set_field("<IsInvincible>k__BackingField", true)
                print(" - IsInvinc : " .. tostring(part_hitctrl["<IsInvincible>k__BackingField"]))
            end
        end
    end
)

-- Hooks registNPC and checks if the character is in top_char_ids, then sets invuln if so.
sdk.hook(
    _NPCManager:get_type_definition():get_method("registNPC"),
    function(args)
        if #top_char_ids > 0 then
            npc_object = sdk.to_managed_object(args[3])
            if has_character_id(top_char_ids, npc_object["CharacterID"]) then
                make_invincible(npc_object)
                table.remove(top_char_ids, top_cids_index)
            end
        end
    end
)

local function get_oxcart_status(oid)
    local status = _NPCManager["OxcartManager"]:getStatus(oid)

    ----- CHANGE
    local driver_field = oxcart_status["DriverID"]
    local driver_id = driver_field.CharaID
    local driver = _NPCManager:getCharacter(driver_id)
    if driver then
        make_invincible(driver)
    else
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
                make_invincible(guard_char)
            end
        end
    end

end

--[[
re.on_application_entry("LateUpdateBehavior", function()
    if hotkeys.check_hotkey("OxcartStatus", true, false) then
        print("")
        print("==== OXCART STATUS ====")
        get_oxcart_status(this_ox_id)
    end
end
) 
]]
