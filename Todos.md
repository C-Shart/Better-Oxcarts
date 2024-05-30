## NOW
+ User configurability
    + UI
+ BUG: Game loads same oxcart & guards
    + Find a way to refresh the cart. Finding this should enable me to also allow cart configuration
+ BUG: Wandering too far from cart makes cart fall apart & disappear
    + Making the cart truly invincible & unbroken should resolve this
    + Also ensuring the cart is fresh when loaded

## SOON
+ Faster ox
+ Guard buffs (advanced abilities, buffed stats, better equipment)
+ Ox buffs (buffed stats)
+ BUG: Sm_80_042_Parts not completely being set invincible yet
    + Find way to iterate through the current cart's PartsList

 
## LATER
+ Driver behavior alteration (join fights, add player classes/abilities)
+ Driver appearance alteration (glowing eyes in combat, see about using the Medusa glare for this)
+ Driver BGM (nuDoom music plays when drivers get into fight)
+ Option - much faster cart outside of combat, play yakety sax
 
### DONE
+ "set invincible" logic to its own function
+ Set cart parts invincible too (app.Gm80_042.PartsList[], app.Sm80_042_Parts.CompHit.IsInvincible)


### NOTES

_IsUnbreakable                  0x200
RegionData                      0x258
<IsInvincible>k__BackingField   0x132
<CompHitCtrl>k__BackingField    0xC0

Destinations
+ 1: Vernworth
+ 2: Checkpoint Rest Town
+ 3: Melve
+ 4: Bakbattahl

Dest + _BoardingRouteNumber combos
+ Use to determine guard loadouts
+ E-W
    + 3,1 Melve-Vernworth (lightest.M)
    + 1,2 Vernworth-Checkpoint (medium.V)
    + 2,4 Checkpoint-Bakbattahl (heavy.C)
+ W-E
    + 4,2 Bakbattahl-Checkpoint (heaviest.B)
    + 2,1 Checkpoint-Vernworth (medium.C)
    + 1,3 Vernworth-Melve (light.V)

app.GimmickManager

    ["<ManagedGimmicks>k__BackingField"]._items


app.OxcartConnecter
    .getOxcartGimmickID(app.CharacterID)
    .getOxcartUniqueID(app.CharacterID)
    ["OxcartCharaIDArray"]
    ["_OxcartUniqueID"]
    ["_Oxcart"]

app.OxcartConnecter.requestOxcart()
    ._Oxcart
        ._GameObject._Name
    ._OxcartUniqueID._Index

app.Gm80_042
    .IsSetup
    .HasCage
    ._IsUnbreakable == true
    .GimmickId == 124
    ["<UniqId>k__BackingField"]._Index

app.Sm80_042_Parts (app.Gm80_042.PartsList)

app.GimmickManager
    .register(app.GimmickBase gimmick)
app.GimmickBase
    ["GimmickId"] == 124
    ["<CompHitCtrl>k__BackingField"]
        ["<IsInvincible>k__BackingField"] == true
    ["<UniqId>k__BackingField"] (app.UniqueID)
    app.Gm80_042["<ParentId>k__BackingField"] == OxcartStatus.OxcartID
        -- app.GimmickBase.<UniqId>k__BackingField = app.UniqueID



app.OxcartStatus
    .registerOxcart(app.CharacterID oxcart, app.OxcartAI obj, System.Boolean IsDummyUpdate)
    .registerOxcart(app.CharacterID oxcart, app.DummyDataOxcart obj)
    .setScheduleState_Oxcart()
    .getDestinationID()
    .get_oxcartAI()
    .set_oxcartAI(app.OxcartAI value)
    Route
    <oxcartAI>k__BackingField


app.OxcartManager
    .getSchedule()
    .getOxcartStatusfromAssign()
    .getStatus(oxcart id)
    .getSchedule(app.CharacterID charaID)
    .getSchedule_BaseInfo(app.CharacterID)
    .setSchedule(app.CharacterID, app.OxcartSchedule)

app.OxcartSchedule
    OxcartBaseInfos
    Routes
    Members

app.OxcartCondition
    .Evaluate()

app.OxcartUtil
    .getOxcartStatus(app.CharacterID oxcartID)
    .getOxcartStatus_AssignCharacterID(app.ChracterID)
    .getOxcartScheduleData()
    .getOxcartStatus_Entity()
    .getStatusList()

app.NPCManager
    .setScheduleState_Oxcart(app.CharacterID, app.OxcartStatus)


app.OxcartAI
    ["DriverAction"]


app.Character:
    app.CharacterInput                  <Input>k__BackingField
    app.WeaponandItemHolder             <WeaponAndItemHolder>k__BackingField
    app.StaminaManager                  <StaminaManager>k__BackingField
    app.DangerController                DangerCtrl
    app.CharacterAIStateController      CharaAIStateCtrl
    app.BattleStateController           BattleStateCtrl
    app.SetTempStatusTrack
    app.Human                           <Human>k__BackingField

app.Human:
    app.HumanJobChanger
        :setup(app.Human)
    app.JobContext
        ["CurrentJob"]
        ["MaxEquipList"]
        ["EquipedArmors"]
    app.JobMagicUserContext
    app.HumanStatuscontext
    app.HumanSkillContext
    app.AbilityContext
    .getJobChanger()
    .getSpellStockCtrl()
    .get_AbilityContext()

app.NPCManager:
    .get_NPCList()
    .getNPCConfig()
    .getNPCCharacterData()
    .setupCharacterData()

app.Ch299003
    ["RunRate"]
    ["MotSpeedMax"]
    ["MotSpeedMin"]
    .setNoDieFlag(bool)
    app.Ch299
        app.Ch200000
            <Chara>k__BackingField
            <Monster>k__BackingField


app.Gm80_042
    .get_BoardingRouteNum()
    .setupObjects()



EXXXcellent — 05/21/2024 12:17 PM
Do what I do as a more global approach so that you can ignore stamina recovery/consumption with any ability, set a flag and hook the StaminaController like so:

sdk.hook(
        sdk.find_type_definition("app.HumanStaminaController"):get_method("recoverStamina"),
        function(args)
            -- do checks to make sure it's the player's stamina controller here
            if not no_recover_flag then return end
            return sdk.PreHookResult.SKIP_ORIGINAL
        end
)









-- Hooks the cart itself because OxcartAI.update() apparently sets the cart breakable always
-- unless you're paused
sdk.hook(
    sdk.find_type_definition("app.GimmickBase"):get_method("set_IsUnbreakable"),
    function(args)
        local bool = nil
        local obj = sdk.to_managed_object(args[2])
        if obj:get_type_definition():get_name() == "Gm80_042" then
            bool = sdk.to_ptr(args[3])
            bool = true
        end
    end
)
