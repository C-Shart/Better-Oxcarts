local modname="[BetterOxcarts]"

local _NPCManager = sdk.get_managed_singleton("app.NPCManager")
local _CharacterListHolder = sdk.get_managed_singleton("app.CharacterListHolder")
local _ItemManager = sdk.get_managed_singleton("app.ItemManager")

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

-- Creates enum of given IDs and stores them
local function generate_enum(type_str)
    local _ids = sdk.find_type_definition(type_str)
    if not _ids then return {} end
    local fields = _ids:get_fields()
    local enum = {}
    for i, field in ipairs(fields) do
        local name = field:get_name()
        local raw_value = field:get_data()
        --print(name .. ", " .. tostring(raw_value))
        if raw_value then
            enum[raw_value] = name
        end
    end
    return enum
end

-- Creates an enum of IDs but with name-data reversed
local function generate_enum_rev(type_str)
    local _ids = sdk.find_type_definition(type_str)
    if not _ids then return {} end
    local fields = _ids:get_fields()
    local enum = {}
    for i, field in ipairs(fields) do
        local name = field:get_name()
        local raw_value = field:get_data()
        if raw_value then
            enum[name] = raw_value
        end
    end
    return enum
end

local char_ids = generate_enum("app.CharacterID")
local action_ids = generate_enum("app.HumanActionID")
local wep_ids = generate_enum_rev("app.WeaponID")

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

-- Skips execution of any hooked method.
local function skip_execution(args)
    return sdk.PreHookResult.SKIP_ORIGINAL
end


--------------------
-- MAIN FUNCTIONS --
--------------------

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


local function equip_guard(char, charID)
    print(":::::: Equipping : " .. tostring(charID))

    local owning_human = char["<Human>k__BackingField"]
    local equip_list = _ItemManager:getEquipData(charID):get_EquipList()

    -- Unequip current left/right weapons
    if equip_list[0]._StorageId > 0 then
        _ItemManager:removeEquipNoLock(_ItemManager:getStorageDataByStorageId(equip_list[0]._StorageId), char, false, true)
    end
    -- Arctal claims the game doesn't unequip shields per comments in Simple Weapon Swap, and I believe them
    -- However, archers seem to be lefties
    if equip_list[1]._StorageId > 0 then
        _ItemManager:removeEquipNoLock(_ItemManager:getStorageDataByStorageId(equip_list[1]._StorageId), char, false, true)
    end

 -- Equip the appropriate weapon IDs
    -- Replace with logic that checks against the stat/equip tables as appropriate
    -- Expand to armor unless better done elsewhere
    if charID == "ch300802" then
        _ItemManager:requestRightEquipWeapon(char, wep_ids["wp00_007_00"], false) --wp00_050_00
    elseif charID == "ch300803" then
        _ItemManager:requestLeftEquipWeapon(char, wep_ids["wp04_016_00"], false)
    elseif charID == "ch300804" then
        _ItemManager:requestRightEquipWeapon(char, wep_ids["wp07_011_00"], false)
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
            local npc_object = sdk.to_managed_object(args[3])
            if has_character_id(top_char_ids, npc_object["CharacterID"]) then
                make_invincible(npc_object)
                table.remove(top_char_ids, top_cids_index)
            end
        end
    end
)

-- Hooks EquipItemController.setup to apply new values
sdk.hook(
    sdk.find_type_definition("app.EquipItemController"):get_method("setup"),
    function(args)
        local weapon_item_hodler = sdk.to_managed_object(args[4])                 -- typo but I'm leaving it
        local owning_char = weapon_item_hodler.Owner
        local owning_char_id = tostring(char_ids[owning_char.CharacterID])
        local is_oxcart_guard = is_value_in_table(top_guards, owning_char_id)

        if is_oxcart_guard then
            equip_guard(owning_char, owning_char_id)
        end
    end
)

-- Hooks applySkillSet and changes a character's SkillSetIDs
sdk.hook(
    sdk.find_type_definition("app.HumanEnemyController"):get_method("applySkillSet"),
    function(args)
        local name = tostring(char_ids[sdk.to_managed_object(args[2]):get_Owner():get_CharaID()])
        local is_guard = is_value_in_table(top_guards, name)
        --print(name .. "," .. tostring(is_guard))

        if is_guard then
            local skill_set_id = sdk.to_int64(args[3])
            args[3] = sdk.to_ptr(skill_set_id+1)
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




-------------------- arbitrary line of experimentation --------------------






-- Trying to find/change stats and params --

--sdk.find_type_definition("app.Human"):get_method("setHumanParameter"),
-- args[2] self.Human
-- args[3] app.HumanParameter
-- args[4] list of app.HumanCustomSkillIDs, can be used to set job skills
-- args[5] ExceptPlayerDamageCalculator object

sdk.hook(
    sdk.find_type_definition("app.Human"):get_method("setHumanParameter"),
    function(args)
        local human = sdk.to_managed_object(args[2])
        local job = human:get_JobContext():get_field("CurrentJob")
        local char = human["<Chara>k__BackingField"]
        local charID = char.CharacterID
        local is_guard = is_value_in_table(top_guards, tostring(char_ids[charID]))

        if is_guard then
            local human_parameters = sdk.to_managed_object(args[3])
            --local custom_skill_IDs = sdk.to_managed_object(args[4])
            local damage_calculator = sdk.to_managed_object(args[5])

            local default_params = human_parameters.LVupInfoParam.DefaultParam
            --local skill_list = custom_skill_IDs._items
            --local skill_list_cnt = custom_skill_IDs._size-1
--[[ 
            -- Set new character params here
            print(":::       setHumanParameter       ::::")
            print("::::       Human Parameters        ::::")
            print(":::: " .. tostring(default_params.Hitpoint))
            print(":::: " .. tostring(default_params.Stamina))
            print(":::: " .. tostring(default_params.Attack))
            print(":::: " .. tostring(default_params.Defence))
            print(":::: " .. tostring(default_params.MagicAttack))
            print(":::: " .. tostring(default_params.MagicDefence))
            print(":::: " .. tostring(default_params.Weight))
            print(":::: " .. tostring(default_params.Blow))
            print(":::: " .. tostring(default_params.BlowResistance))

            default_params.Hitpoint = 1000
            default_params.Attack = 100
            default_params.MagicAttack = 100
            default_params.Defence = 100
            default_params.MagicDefence = 100
 ]]

--[[ 
            -- Set guard skills here
            print("::::       Custom Skill IDs        ::::")
            local skill_context = human:call("get_SkillContext")

            for i=0,skill_list_cnt do
                print(":::: SLOT " .. tostring(i) .. " ::::")
                local obj = skill_list[i]
                local value = skill_list[i].value__
                if value>0 and job~=1 then
                    print(":::: " .. obj:ToString())
                    print(":::: " .. tostring(value))
                elseif value>0 and job==1 and i==0 then
                    print(":::: ADDING SKILL 1")
                    skill_context:setSkill(job, 1, i)
                    print(":::: " .. tostring(skill_context:getSkillID(job, i)))
                elseif value>0 and job==1 and i==1 then
                    print(":::: ADDING SKILL 9")
                    skill_context:setSkill(job, 9, i)
                    print(":::: " .. tostring(skill_context:getSkillID(job, i)))
                end
            end
 ]]

--[[ 
            local attack = damage_calculator["<Attack>k__BackingField"]
            local m_attack = damage_calculator["<MagicAttack>k__BackingField"]
            local r_attack = damage_calculator["<ReactionAttack>k__BackingField"]
            local stam_attack = damage_calculator["<StaminaAttack>k__BackingField"]
            local defense = damage_calculator["<Defence>k__BackingField"]
            local m_defense = damage_calculator["<MagicDefence>k__BackingField"]
            print("::::       Damage Calculator       ::::")
            print(":::: " .. tostring(attack))
            print(":::: " .. tostring(m_attack))
            print(":::: " .. tostring(r_attack))
            print(":::: " .. tostring(stam_attack))
            print(":::: " .. tostring(defense))
            print(":::: " .. tostring(m_defense))

            attack = 1000
            m_attack = 1000
 ]]
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
    local region_status1 = character["<Hit>k__BackingField"].RegionData._items[0]
    local region_status2 = character["<Hit>k__BackingField"].RegionData._items[1]
    region_data = {
        hp1 = region_status1.Hp,
        maxhp1 = region_status1.MaxHp,
        oldhp1 = region_status1.OldHp,
        guard1 = region_status1.ReduceRateGuard,
        hproot1 = region_status1.HpRootInfluenceRate,
        threshold1 = region_status1.DamageReactionThreshold.PerChar.Threshold[0].m_value,
        lean1 = region_status1.DamageReactionThreshold.PerChar.Lean[0].m_value,
        blown1 = region_status1.DamageReactionThreshold.PerChar.Blown[0].m_value,
        hp2 = region_status2.Hp,
        maxhp2 = region_status2.MaxHp,
        oldhp2 = region_status2.OldHp,
        guard2 = region_status2.ReduceRateGuard,
        hproot2 = region_status2.HpRootInfluenceRate,
        threshold2 = region_status2.DamageReactionThreshold.PerChar.Threshold[0].m_value,
        lean2 = region_status2.DamageReactionThreshold.PerChar.Lean[0].m_value,
        blown2 = region_status2.DamageReactionThreshold.PerChar.Blown[0].m_value
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
    local driver_params = driver_char["<Human>k__BackingField"].Parameter.LVupInfoParam.DefaultParam

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
    print("|- HP1       : " .. tostring(driver_regiondata.hp1))
    print("|- MAXHP1    : " .. tostring(driver_regiondata.maxhp1))
    print("|- OLDHP1    : " .. tostring(driver_regiondata.oldhp1))
    print("|- HP2       : " .. tostring(driver_regiondata.hp2))
    print("|- MAXHP2    : " .. tostring(driver_regiondata.maxhp2))
    print("|- OLDHP2    : " .. tostring(driver_regiondata.oldhp2))
    print("|----------------------------------")
    print("|- P.Hitpoint: " .. tostring(driver_params.Hitpoint))
    print("|- P.Stamina : " .. tostring(driver_params.Stamina))
    print("|- P.Attack  : " .. tostring(driver_params.Attack))
    print("|- P.Defence : " .. tostring(driver_params.Defence))
    print("|- P.MAttack : " .. tostring(driver_params.MagicAttack))
    print("|- P.MDefence: " .. tostring(driver_params.MagicDefence))
    print("|- P.Weight  : " .. tostring(driver_params.Weight))
    print("|- P.Blow    : " .. tostring(driver_params.Blow))
    print("|- BlowResist: " .. tostring(driver_params.BlowResistance))
    --print("|- GUARD     : " .. tostring(driver_regiondata.guard))
    --print("|- HPROOT    : " .. tostring(driver_regiondata.hproot))
    --print("|- DMG THRESH: " .. tostring(driver_regiondata.threshold))
    --print("|- LEAN      : " .. tostring(driver_regiondata.lean))
    --print("|- BLOWN     : " .. tostring(driver_regiondata.blown))
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
                local guard_params = guard_char["<Human>k__BackingField"].Parameter.LVupInfoParam.DefaultParam                local guard_regiondata = get_regionstatus(guard_char)
                print("|- ID        : " .. tostring(char_ids[guard_id]))
                print("|- INVNC     : " .. tostring(guard_char["<Hit>k__BackingField"]["<IsInvincible>k__BackingField"]))
                print("|- HP1       : " .. tostring(guard_regiondata.hp1))
                print("|- MAXHP1    : " .. tostring(guard_regiondata.maxhp1))
                print("|- OLDHP1    : " .. tostring(guard_regiondata.oldhp1))
                print("|- HP2       : " .. tostring(guard_regiondata.hp2))
                print("|- MAXHP2    : " .. tostring(guard_regiondata.maxhp2))
                print("|- OLDHP2    : " .. tostring(guard_regiondata.oldhp2))
                print("|----------------------------------")
                print("|- P.Hitpoint: " .. tostring(guard_params.Hitpoint))
                print("|- P.Stamina : " .. tostring(guard_params.Stamina))
                print("|- P.Attack  : " .. tostring(guard_params.Attack))
                print("|- P.Defence : " .. tostring(guard_params.Defence))
                print("|- P.MAttack : " .. tostring(guard_params.MagicAttack))
                print("|- P.MDefence: " .. tostring(guard_params.MagicDefence))
                print("|- P.Weight  : " .. tostring(guard_params.Weight))
                print("|- P.Blow    : " .. tostring(guard_params.Blow))
                print("|- BlowResist: " .. tostring(guard_params.BlowResistance))

                --print("|- GUARD     : " .. tostring(guard_regiondata.guard))
                --print("|- HPROOT    : " .. tostring(guard_regiondata.hproot))
                --print("|- DMG THRESH: " .. tostring(guard_regiondata.threshold))
                --print("|- LEAN      : " .. tostring(guard_regiondata.lean))
                --print("|- BLOWN     : " .. tostring(guard_regiondata.blown))
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
            --buff_guards()
        end
    end
    )