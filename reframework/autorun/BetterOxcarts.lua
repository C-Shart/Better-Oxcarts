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
        -- TODO: CART OBJECT INVINCIBILITY AND OTHER SETTINGS RIGHT FUCKIN HERE
        if cart_object then
            print("")
            print("CART OBJECT CART OBJECT CART OBJECT")
            print(cart_object["<UniqId>k__BackingField"]._Index)
            print(cart_object.HasCage)
            print(cart_object._IsUnbreakable)
            if cart_object._IsUnbreakable ~= true then
                cart_object._IsUnbreakable = true
                print(cart_object._IsUnbreakable)
            end
        end
    end,
    nil
)

-----------
-- HOOKS --
-----------

-- Hooks the cart parts and makes them invincible, supposedly
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

--Hook app.GimmickManager.registerGimmick and check for cart+parts
sdk.hook(
    sdk.find_type_definition("app.GimmickManager"):get_method("register"),
    function(args)
        local gm_base = sdk.to_managed_object(args[3])

        if gm_base.GimmickId == 124 then
            local hitctrl = gm_base["<CompHitCtrl>k__BackingField"]
            local isinvinc = hitctrl["<IsInvincible>k__BackingField"]
            local parent_cart = gm_base["<ParentId>k__BackingField"]
            local unbreakable = gm_base._IsUnbreakable

            print("===== GimmickManager.register check =====")
            print("ID CHECK : " .. tostring(gm_base.GimmickId))
            print("HITCTRL  : " .. tostring(hitctrl))
            print("INVINCIBL: " .. tostring(isinvinc))
            print("PRNT CART: " .. tostring(parent_cart))
            print("UNBREAK  : " .. tostring(unbreakable))
            print("")
            if isinvinc ~= true then
                hitctrl["<IsInvincible>k__BackingField"] = true
                print("INVINCIBL: " .. tostring(hitctrl["<IsInvincible>k__BackingField"]))
            end
            if unbreakable ~= true then
                gm_base._IsUnbreakable = true
                print("UNBREAK  : " .. tostring(gm_base._IsUnbreakable))
            end
            print("=========================================")
        end
    end
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
    ["OxcartStatus"] = "I"
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
    end
    )