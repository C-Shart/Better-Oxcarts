## NOW
+ BUG: Game loads same oxcart & guards
    + Find a way to refresh the cart. Finding this should enable me to also allow cart configuration
+ BUG: Wandering too far from cart makes cart fall apart & disappear
    + Making the cart truly invincible & unbroken should resolve this

## SOON
+ Faster ox
+ Guard buffs (advanced abilities, buffed stats, better equipment)
+ Ox buffs (buffed stats)
+ User configurability
 
## LATER
+ Driver behavior alteration (join fights, add player classes/abilities)
+ Driver appearance alteration (glowing eyes in combat, see about using the Medusa glare for this)
+ Driver BGM (nuDoom music plays when drivers get into fight)
+ Option - much faster cart outside of combat, play yakety sax
 
### DONE
+ "set invincible" logic to its own function
+ Set cart parts invincible too (app.Gm80_042.PartsList[], app.Sm80_042_Parts.CompHit.IsInvincible)




app.OxcartManager.getSchedule()
                  getOxcartStatusfromAssign()
                  getStatus(oxcart id)

app.Oxcartstatus.setDriver
                    args[3] (characterID)
                .addGuard()
                    args[3] (characterID)


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

app.Ch299003:
    ["RunRate"]
    ["MotSpeedMax"]
    ["MotSpeedMin"]

app.OxcartUtil
    getOxcartStatus(app.CharacterID)
    getOxcartStatus_AssignCharacterID(app.ChracterID)
    getOxcartScheduleData
    getOxcartStatus_Entity

app.OxcartAI
app.OxcartAI.DriverAction


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