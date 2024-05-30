local modname="[BetterOxcarts]"

local _NPCManager = sdk.get_managed_singleton("app.NPCManager")
local top_char_ids = {}
local this_ox_id = 0

----------------------
-- HELPER FUNCTIONS --
----------------------

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

--------------------
-- MAIN FUNCTIONS --
--------------------

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

local function make_cart_and_parts_invincible()
    print("")
    print("!!!!!!!!!!!! TESTING PARTS")
    local gimmicks_list = sdk.get_managed_singleton("app.GimmickManager")["<ManagedGimmicks>k__BackingField"]
    local g_mgr_items = gimmicks_list._items
    local g_mgr_size = gimmicks_list._size
    local parts_list_size = 0
    local comp_hit_isinvinc = nil
    local hit_ctrl_isinvinc = nil

    for i=0,g_mgr_size-1 do
        local item_name = g_mgr_items[i]:get_type_definition():get_name()
        local parts_check = item_name == "Sm80_042_Parts" or item_name == "Gm80_042"
        if parts_check then
            local comp_hit_isinvinc = nil
            local hit_ctrl_isinvinc = nil
            local parts_list_size = nil

            local has_cage = g_mgr_items[i].HasCage
            local parts_list = g_mgr_items[i].PartsList
            if parts_list then
                parts_list_items = parts_list._items
                parts_list_size = parts_list._size
                end
            local gimmick_id = g_mgr_items[i].GimmickId
            local comp_hit = g_mgr_items[i].CompHit
            if comp_hit then
                if comp_hit["<IsInvincible>k__BackingField"] == false then
                    g_mgr_items[i].CompHit["<IsInvincible>k__BackingField"] = true
                end
            end
            local hit_ctrl = g_mgr_items[i]["<CompHitCtrl>k__BackingField"]
            if hit_ctrl then
                if hit_ctrl["<IsInvincible>k__BackingField"] == false then
                    g_mgr_items[i]["<CompHitCtrl>k__BackingField"]["<IsInvincible>k__BackingField"] = true
                end
            end
            local unique_id = g_mgr_items[i]["<UniqId>k__BackingField"]._Index
            local is_unbreak = g_mgr_items[i]._IsUnbreakable
            if is_unbreak == false then
                g_mgr_items[i]:set_IsUnbreakable(true)
            end

            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            print("!!!!!!!!!!!! PART FOUND!  " .. tostring(item_name))
            if has_cage then print("!!!!!!!!!!!! HasCage  : " .. tostring(has_cage)) end
            if parts_list then print("!!!!!!!!!!!! PartsList: " .. tostring(parts_list)) end
            if parts_list then print("!!!!!!!!!!!! ---  Size: " .. tostring(parts_list_size)) end
            if gimmick_id ~= 0 then print("!!!!!!!!!!!! GimmickId: " .. tostring(gimmick_id)) end
            if comp_hit then print("!!!!!!!!!!!! CompHit  : " .. tostring(comp_hit)) end
            if comp_hit then print("!!!!!!!!!!!! ---Invinc: " .. tostring(g_mgr_items[i].CompHit["<IsInvincible>k__BackingField"])) end
            if hit_ctrl then print("!!!!!!!!!!!! CompHitBF: " .. tostring(hit_ctrl)) end
            if hit_ctrl then print("!!!!!!!!!!!! ---Invinc: " .. tostring(g_mgr_items[i]["<CompHitCtrl>k__BackingField"]["<IsInvincible>k__BackingField"])) end
            if unique_id ~= 0 then print("!!!!!!!!!!!! UNIQUE ID: " .. tostring(unique_id)) end
            print("!!!!!!!!!!!! UNBREAK  : " .. tostring(is_unbreak))
        end
    end
end









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


-----------
-- HOOKS --
-----------

-- Hooks Ch299003.connectOxcart and makes ox invincible
sdk.hook(
    sdk.find_type_definition("app.Ch299003"):get_method("connectOxcart"),
    function(args)
        this_ox_id = 0
        local ox_object = sdk.to_managed_object(args[2])
        local cart_object = sdk.to_managed_object(args[3])
        -- Make ox invincible
        if ox_object then
            local ox_character = ox_object["<Chara>k__BackingField"]
            this_ox_id = ox_character["CharacterID"]
            make_invincible(ox_character)
        end
        -- Make driver/guards invincible
        if this_ox_id ~= 0 then
            make_driver_and_guards_invincible(this_ox_id)
        end
        -- Make cart invincible/unbreakable
        --make_cart_and_parts_invincible()
    end,
    nil
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


--[[ -- Hooks OxcartConnecter.requestOxcart and try to change cart properties
sdk.hook(
    sdk.find_type_definition("app.OxcartConnecter"):get_method("requestOxcart"),
    function(args)
        local connector_object = sdk.to_managed_object(args[3])
        local monster = connector_object._Monster
        local oxcart = connector_object._Oxcart
        local is_connected = connector_object._IsConnected
        local is_loaded = connector_object._IsLoadedOxcart
        local unique_id = connector_object._OxcartUniqueID._Index

        if connector_object and monster and unique_id then
            print("")
            print("===== OxcartConnecter.requestOxcart check =====")
            print("MONSTER : " .. tostring(monster["<Chara>k__BackingField"].CharaIDContext.CharacterID))
            print("OXCART  : " .. tostring(oxcart))
            print("CONNECTD: " .. tostring(is_connected))
            print("LOADED  : " .. tostring(is_loaded))
            print("OC UNQID: " .. tostring(unique_id))
            print("===============================================")
            print("")
        end
    end
)
 ]]

-- Hooks methods to avoid the cart and its parts taking damage
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("onDamageHit"),
    skip_execution()
)
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("onCalcDamageEnd"),
    skip_execution()
)
sdk.hook(
    sdk.find_type_definition("app.Gm80_042"):get_method("executeBreak"),
    skip_execution()
)
sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("executeBreak"),
    skip_execution()
)
sdk.hook(
    sdk.find_type_definition("app.Sm80_042_Parts"):get_method("callbackDamageHit"),
    skip_execution()
)



------------------------
------------------------
-- REMOVE ON RELEASES --
-- REMOVE ON RELEASES --
-- REMOVE ON RELEASES --
-- REMOVE ON RELEASES --
------------------------
------------------------

-- Hotkeys for testing
local hotkeys = require("Hotkeys/Hotkeys")

local hotkey_config = {}
hotkey_config.Hotkeys = {
    ["OxcartStatus"] = "I",
    ["PartsChecker"] = "O"
}
hotkeys.setup_hotkeys(hotkey_config.Hotkeys)


local oxcart_manager = _NPCManager["OxcartManager"]
local function get_oxcart_status(oid)
    local oxcart_status = oxcart_manager:getStatus(oid)

    local driver_id = oxcart_status.DriverID.CharaID
    local driver = _NPCManager:getCharacter(driver_id)
    local driver_invinc = driver["<Hit>k__BackingField"]["<IsInvincible>k__BackingField"]

    print("")
    print("========== OXCART STATUS ==========")
    print("|OX and CART")
    print("|- OX ID : " .. tostring(oxcart_status.OxcartID))
    print("|- CARTID: " .. tostring(""))
    print("|--INVNC : " .. tostring(""))
    print("|--DEST  : " .. tostring(oxcart_status.Route.DestinationID))
    print("|--SPEED : " .. tostring(oxcart_status.MoveSpeed))
    print("|--ID    : " .. tostring(""))
    print("|----------------------------------")
    print("|DRIVER")
    print("|- ID    : " .. tostring(driver_id))
    print("|- CLASS : " .. tostring(""))
    print("|- INVNC : " .. tostring(driver_invinc))
    print("|- STATE : " .. tostring(""))
    print("|----------------------------------")

    local guards_list = oxcart_status["_Guards"]
    local guards_length = guards_list._items:get_size()
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
                print("|- INVNC : " .. tostring(guard_char["<Hit>k__BackingField"]["<IsInvincible>k__BackingField"]))
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
        if hotkeys.check_hotkey("PartsChecker", true, false) then
            make_cart_and_parts_invincible()
        end
    end
    )