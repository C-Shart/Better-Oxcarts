local modname="[BetterOxcarts]"

local _NPCManager = sdk.get_managed_singleton("app.NPCManager")
local top_char_ids = {}
local this_ox_id = 0
-- All currently known (06/05) driver and guard IDs to tables.
local top_drivers = {
    "ch300795",
    "ch300298",
    "ch300291",
    "ch300793",
    "ch300367",
    "ch300794"
}
local top_guards = {
    "ch300802",
    "ch300803",
    "ch300804",
    "ch300260",
    "ch300383",
    "ch300258",
    "ch300056",
    "ch300055",
    "ch300057",
    "ch300797",
    "ch300796",
    "ch300798",
    "ch300558",
    "ch300369",
    "ch300545",
    "ch300801",
    "ch300800",
    "ch300799"
}

for i=0,20 do
    print("")
end

----------------------
-- HELPER FUNCTIONS --
----------------------

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

-- Checks if character ID is in top_char_ids and sets index value if so
local function has_character_id(tbl, val)
    for k,v in ipairs(tbl) do
        if v == val then
            top_cids_index = k
            return true 
        end
    end
    return false
end

-- Checks if table tbl has a given value val
local function is_value_in_table(tbl, val)
    for k,v in ipairs(tbl) do
        if v == val then
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

-- Takes an app.Character object and makes it invincible
local function make_invincible(obj)
    print("Character   : " .. tostring(char_ids[obj["CharacterID"]]))
    local obj_hit_ctrl = obj["<Hit>k__BackingField"]
    if obj_hit_ctrl then
        local is_invincible = obj_hit_ctrl["<IsInvincible>k__BackingField"]
        if is_invincible ~= true then
            obj_hit_ctrl:set_field("<IsInvincible>k__BackingField", true)
        end
        print(" - IsInvinc : " .. tostring(obj_hit_ctrl["<IsInvincible>k__BackingField"]))
    end
end




local function make_cart_and_parts_invincible()
    local gimmicks_list = sdk.get_managed_singleton("app.GimmickManager")["<ManagedGimmicks>k__BackingField"]
    local g_mgr_items = gimmicks_list._items
    local g_mgr_size = gimmicks_list._size
    local parts_list_size = 0

    for i=0,g_mgr_size-1 do
        local item_name = g_mgr_items[i]:get_type_definition():get_name()
        if item_name == "Sm80_042_Parts" or item_name == "Gm80_042" then
            local comp_hit_isinvinc = nil

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
            if g_mgr_items[i]._IsUnbreakable == false then
                g_mgr_items[i]:set_IsUnbreakable(true)
            end

            print("================ " .. tostring(item_name))
            if has_cage then print("!  HasCage  : " .. tostring(has_cage)) end
            if parts_list then print("!  PartsList: " .. tostring(parts_list)) end
            if parts_list then print("!  ---  Size: " .. tostring(parts_list_size)) end
            if gimmick_id ~= 0 then print("!  GimmickId: " .. tostring(gimmick_id)) end
            if comp_hit then print("!  ---Invinc: " .. tostring(g_mgr_items[i].CompHit["<IsInvincible>k__BackingField"])) end
            if hit_ctrl then print("!  ---Invinc: " .. tostring(g_mgr_items[i]["<CompHitCtrl>k__BackingField"]["<IsInvincible>k__BackingField"])) end
            if unique_id ~= 0 then print("!  UNIQUE ID: " .. tostring(unique_id)) end
            print("!  UNBREAK  : " .. tostring(g_mgr_items[i]._IsUnbreakable))
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
        -- Do things to the ox
        if ox_object then
            -- OX LOGIC
            local ox_character = ox_object["<Chara>k__BackingField"]
            this_ox_id = ox_character["CharacterID"]
            make_invincible(ox_character)
        end
        -- Do things to the driver/guards
        if this_ox_id ~= 0 then
            -- DRIVER GUARDS LOGIC
            make_driver_and_guards_invincible(this_ox_id)
        end
        if cart_object then
            -- Do thing to the cart/parts
            -- CART LOGIC
            make_cart_and_parts_invincible()
        end
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

-- Hooks methods to avoid the cart and its parts taking damage
local cart_typedef = sdk.find_type_definition("app.Gm80_042")
local parts_typedef = sdk.find_type_definition("app.Sm80_042_Parts")
sdk.hook(cart_typedef:get_method("onDamageHit"), skip_execution)
sdk.hook(cart_typedef:get_method("onCalcDamageEnd"), skip_execution)
sdk.hook(cart_typedef:get_method("executeBreak"), skip_execution)
sdk.hook(parts_typedef:get_method("executeBreak"), skip_execution)
sdk.hook(parts_typedef:get_method("callbackDamageHit"), skip_execution)



sdk.hook(
    sdk.find_type_definition("app.DamageCalculator"):get_method("setup"),
    function(args)
        local char_name = tostring(sdk.to_managed_object(args[3]):get_Name())
        local is_oxcart_guard = is_value_in_table(top_guards, char_name)
        if is_oxcart_guard then
            print(":::::: DamageCalculator ::::::")
            print(char_name)
            print(is_oxcart_guard)

            local damage_calculator = sdk.to_managed_object(args[2])

            -- Logic to apply new values based on criteria
            local ch2 = damage_calculator["<Ch2>k__BackingField"]
            local r_stat_ctrl = damage_calculator["<RegionStatusCtrl>k__BackingField"]
            local attack = damage_calculator["<Attack>k__BackingField"]
            local magic_attack = damage_calculator["<MagicAttack>k__BackingField"]
            local react_attack = damage_calculator["<ReactionAttack>k__BackingField"]
            local stam_attack = damage_calculator["<StaminaAttack>k__BackingField"]
            local enchant_phys = damage_calculator["<EnchantPhsycalFactor>k__BackingField"]
            local enchant_mag = damage_calculator["<EnchantMagicalFactor>k__BackingField"]
            local defense = damage_calculator["<Defence>k__BackingField"]
            local magic_defense = damage_calculator["<MagicDefence>k__BackingField"]
        end
    end
)


sdk.hook(
    sdk.find_type_definition("app.EquipItemController"):get_method("setup"),
    function(args)
        local weapon_item_hodler = sdk.to_managed_object(args[4])                   -- typo but I'm leaving it
        local owning_char = tostring(char_ids[weapon_item_hodler.Owner.CharacterID])
        local is_oxcart_guard = is_value_in_table(top_guards, owning_char)

        if is_oxcart_guard then
            local lt_wep_obj = weapon_item_hodler["<LeftWeapon>k__BackingField"]
            local rt_wep_obj = weapon_item_hodler["<RightWeapon>k__BackingField"]

            print(":::::: EquipItemController ::::::")
            print(": Owner  : " .. tostring(owning_char))
            print(": RightWp: " .. tostring(lt_wep_obj))
            print(": Left Wp: " .. tostring(rt_wep_obj))


            local left_weapon = weapon_item_hodler["<LeftWeapon>k__BackingField"]
            local right_weapon = weapon_item_hodler["<RightWeapon>k__BackingField"]
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
    ["OxcartStatus"] = "I",
    ["PartsChecker"] = "O"
}
hotkeys.setup_hotkeys(hotkey_config.Hotkeys)



local function get_regionstatus(character)
    local region_data = character["<Hit>k__BackingField"].RegionData._items[0]
    region_data = {
        hp = region_data.Hp,
        maxhp = region_data.MaxHp,
        oldhp = region_data.OldHp,
        guard = region_data.ReduceRateGuard,
        hproot = region_data.HpRootInfluenceRate,
        threshold = region_data.DamageReactionThreshold.PerChar.Threshold[0].m_value,
        lean = region_data.DamageReactionThreshold.PerChar.Lean[0].m_value,
        blown = region_data.DamageReactionThreshold.PerChar.Blown[0].m_value
    }
    return region_data
end



local oxcart_manager = _NPCManager["OxcartManager"]
local function get_oxcart_status(oid)
    local oxcart_status = oxcart_manager:getStatus(oid)

    local driver_id = oxcart_status.DriverID.CharaID
    local driver_char = _NPCManager:getCharacter(driver_id)
    local driver_invinc = driver_char["<Hit>k__BackingField"]["<IsInvincible>k__BackingField"]
    local driver_regiondata = get_regionstatus(driver_char)

    print("")
    print("========== OXCART STATUS ==========")
    print("| OX and CART")
    print("|- OX ID : " .. tostring(char_ids[oxcart_status.OxcartID]))
    print("|- CARTID: " .. tostring(""))
    print("|--INVNC : " .. tostring(""))
    print("|--DEST  : " .. tostring(oxcart_status.Route.DestinationID))
    print("|--SPEED : " .. tostring(oxcart_status.MoveSpeed))
    print("|--ID    : " .. tostring(""))
    print("|----------------------------------")
    print("| DRIVER")
    print("|- ID        : " .. tostring(char_ids[driver_id]))
    print("|- INVNC     : " .. tostring(driver_invinc))
    print("|- HP        : " .. tostring(driver_regiondata.hp))
    print("|- MAXHP     : " .. tostring(driver_regiondata.maxhp))
    print("|- OLDHP     : " .. tostring(driver_regiondata.oldhp))
    print("|- GUARD     : " .. tostring(driver_regiondata.guard))
    print("|- HPROOT    : " .. tostring(driver_regiondata.hproot))
    print("|- DMG THRESH: " .. tostring(driver_regiondata.threshold))
    print("|- LEAN      : " .. tostring(driver_regiondata.lean))
    print("|- BLOWN     : " .. tostring(driver_regiondata.blown))
    print("|-------------")
    print("|- R WEAPON  : " .. tostring(""))
    print("|- R WEAPONID: " .. tostring(""))
    print("|- L WEAPON  : " .. tostring(""))
    print("|- L WEAPONID: " .. tostring(""))
    print("|----------------------------------")

    local guards_list = oxcart_status["_Guards"]
    local guards_length = guards_list._items:get_size()
    for i=0, guards_length do
        if guards_list[i] then
            print("| GUARD " .. tostring(i))
            local guard_id = guards_list[i].CharaID
            if not _NPCManager:getCharacter(guard_id) then
                print("|- NO GUARD FOUND")
                print("|----------------------------------")
            else
                local guard_char = _NPCManager:getCharacter(guard_id)
                local guard_regiondata = get_regionstatus(guard_char)
                print("|- ID        : " .. tostring(char_ids[guard_id]))
                print("|- INVNC     : " .. tostring(guard_char["<Hit>k__BackingField"]["<IsInvincible>k__BackingField"]))
                print("|- HP        : " .. tostring(guard_regiondata.hp))
                print("|- MAXHP     : " .. tostring(guard_regiondata.maxhp))
                print("|- OLDHP     : " .. tostring(guard_regiondata.oldhp))
                print("|- GUARD     : " .. tostring(guard_regiondata.guard))
                print("|- HPROOT    : " .. tostring(guard_regiondata.hproot))
                print("|- DMG THRESH: " .. tostring(guard_regiondata.threshold))
                print("|- LEAN      : " .. tostring(guard_regiondata.lean))
                print("|- BLOWN     : " .. tostring(guard_regiondata.blown))
                print("|----------------------------------")
                print("|- RWEP  : " .. tostring(""))
                print("|- RWEPID: " .. tostring(""))
                print("|- LWEP  : " .. tostring(""))
                print("|- LWEPID: " .. tostring(""))
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