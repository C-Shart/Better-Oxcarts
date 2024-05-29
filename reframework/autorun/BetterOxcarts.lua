local modname="[BetterOxcarts]"

local _NPCManager = sdk.get_managed_singleton("app.NPCManager")
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

-- Takes an object and makes it invincible
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

-- Hooks Ch299003.connectOxcart and makes ox invincible
sdk.hook(
    sdk.find_type_definition("app.Ch299003"):get_method("connectOxcart"),
    function(args)
        this_ox_id = 0
        local ox_object = sdk.to_managed_object(args[2])
        if ox_object then
            local ox_character = ox_object["<Chara>k__BackingField"]
            this_ox_id = ox_character["CharacterID"]
            make_invincible(ox_character)
        end
    end,
    nil
)
-- Hooks OxcartStatus.setDriver and makes driver invincible
sdk.hook(
    sdk.find_type_definition("app.OxcartStatus"):get_method("setDriver"),
    function(args)
        local driver = _NPCManager:getCharacter(args[3])
        if driver then
            make_invincible(driver)
        end
    end
)
-- Hook OxcartStatus.addGuard and makes guard invincible
sdk.hook(
    sdk.find_type_definition("app.OxcartStatus"):get_method("addGuard"),
    function(args)
        local guard = _NPCManager:getCharacter(args[3])
        if guard then
            make_invincible(guard)
        end
    end
)

-- Takes the cart parts and makes them invincible
sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("start"),
    function(args)
        local this_part = sdk.to_managed_object(args[2])
        local part_hitctrl = this_part["<CompHitCtrl>k__BackingField"]
        if part_hitctrl then
            local is_invincible = part_hitctrl["<IsInvincible>k__BackingField"]
            if is_invincible ~= true then
                part_hitctrl:set_field("<IsInvincible>k__BackingField", true)
            end
        end
    end
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

-- REMOVE ON RELEASES
local hotkeys = require("Hotkeys/Hotkeys")

-- Hotkeys for testing

local hotkey_config = {}
hotkey_config.Hotkeys = {
    ["OxcartStatus"] = "I"
}
hotkeys.setup_hotkeys(hotkey_config.Hotkeys)


local function get_oxcart_status(oid)
    local oxcart_status = _NPCManager["OxcartManager"]:getStatus(oid)
    local driver_field = oxcart_status["DriverID"]
    local driver_id = driver_field.CharaID
    local driver = _NPCManager:getCharacter(driver_id)
    local guards_list = oxcart_status["_Guards"]
    local guards_length = guards_list._items:get_size()
    print("")
    print("========== OXCART STATUS ==========")
    print("|DRIVER")
    print("|- ID    : " .. tostring(driver_id))
    print("|- CLASS : " .. tostring(""))
    print("|- INVNC : " .. tostring(""))
    print("|- STATE : " .. tostring(""))
    print("|----------------------------------")
    for i=0, guards_length do
        if guards_list[i] then
            print("|GUARD " .. tostring(i))
            local guard = guards_list[i].CharaID
            if not _NPCManager:getCharacter(guard) then
                print("|- NO GUARD FOUND")
                print("|----------------------------------")
            else
                local guard_char = _NPCManager:getCharacter(guard)
                print("|- ID    : " .. tostring(guard))
                print("|- CLASS : " .. tostring(""))
                print("|- INVNC : " .. tostring(""))
                print("|- STATE : " .. tostring(""))
                print("|----------------------------------")
                
            end
        end
    end
end

re.on_application_entry("LateUpdateBehavior",
    function()
        if hotkeys.check_hotkey("OxcartStatus", true, false) then
            get_oxcart_status(this_ox_id)
        end
    end
    )