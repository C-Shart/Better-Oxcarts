local hotkeys = require("Hotkeys/Hotkeys")

-- Hotkeys for testing

local hotkey_config = {}
hotkey_config.Hotkeys = {
    ["OxcartStatus"] = "I"
}
hotkeys.setup_hotkeys(hotkey_config.Hotkeys)


local function get_oxcart_status(oid)
    local oxcart_status = _NPCManager["OxcartManager"]:getStatus(oid)
    print("oxcart_status")

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


re.on_application_entry("LateUpdateBehavior", function()
    if hotkeys.check_hotkey("OxcartStatus", true, false) then
        print("")
        print("==== OXCART STATUS ====")
        get_oxcart_status(this_ox_id)
    end
end
) 