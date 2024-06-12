## NOW
+ User configurability
    + UI
+ Guard buffs
    + ~~Change equipment~~
        + Add items to inventories (special arrows > archers)
    + ~~Change abilities~~
    + ~~Buff stats~~
    + Logic to change equipment based on tables
    + Configurable
+ BUG: Wandering too far from cart makes cart fall apart & disappear.
    + Making the cart truly invincible & unbroken should resolve this
    + Also ensuring the cart is fresh when loaded

## SOON
+ Faster ox
    + Configurable
+ Ox buffs
    + Buffed stats
    + Configurable
+ Double-check and test against oxcart quests
    + Tension on the High Road (Raghnall)
    + Phantom Oxcart
    + early game, ride oxcart to deliver letter
    + opening game, ride oxcart with whatshisname
 
## LATER
+ Driver behavior alteration (join fights, add player classes/abilities)
+ Driver appearance alteration (glowing eyes in combat, see about using the Medusa glare for this)
+ Driver BGM (nuDoom music plays when drivers get into fight)
+ Option - much faster cart outside of combat, play yakety sax
+ Immersive changes
    + Melve Fighter (300802) to Warrior after Warrior maister quest
    + V-C Fighter % chance to be Warrior? Just make him a warrior?
    + Bakbattahl guard equip gets dwarven infusion after Sara quest
+ Get info 
 
### DONE
+ BUG: Game loads same oxcart & guards
    + Find a way to refresh the cart. Finding this should enable me to also allow cart configuration
    + Closed, by design. The game only has so many carts and guards.


### SPECIAL THANKS
+ EXXXcellent, Nickesponja, shadowcookie, [], for all the help and advice
+ praydog & alphaZomega for their excellent tools
+ Arctal's Simple Weapon Swap mod, which helped me wrap my head around how to switch weapons
+ 


### NOTES

app.HumanEnemyController
    :getCombatParam(app.Character, app.HumanEnemyController.HumanType, app.Character.JobEnum) (ret CommonHitParam)
    :applyStatus(app.HumanEnemyParameterBase, app.HumanEnemyParameterBase, app.DamageCalculator)


app.CommonHitParam
    .RegionData[]

app.RegionStatusData


app.RegionStatusData

app.HumanEnemyManager
    get_DefaultNPCCombatParameter()
       +app.HumanEnemyCombatParameterData
        _TemplateID
           +app.HumanEnemyParameterBase.HumanEnemyCombatParamTemplate *(static enum)
    getNPCCombatParameter(app.HumanEnemyParameterBase.NPCCombatParamTemplate) - returns app.NPCCombatParameterData
       +app.HumanEnemyManager.NPCJobParamSet
        get_Param()

    get_DefaultHumanEnemyParameter()
    getHumanEnemyCombatParameter(app.HumanEnemyParameterBase.HumanEnemyCombatParamTemplate)
        returns app.HumanEnemyCombatParameterData

    get_TalkManager()
    getSkillSet(app.HumanEnemyParameterBase.HumanEnemySkillSetID)
    setNPCCombatDirector(app.Qu010180NPCCombatDirector)
    getNPCThinkTableData(app.HumanEnemyParameterBase.NPCCombatParamTemplate) - returns app.ThinkTableData


app.HumanEnemyParameterBase
    get_CommonHitParam()
    get_RegionStatusData()


    _Attack, _Defence, etc


app.HumanEnemyCom


app.NPCCombatParameterData


app.NPCCombatParameterData.JobCombatParamPair


app.NPCCombatThinkTableData
    .TemplateID
    .CombatTableData


app.ThinkTableData
    get_TableDataID()
    CharaID
    ThinkVariableData
    ThinkTableList
    _TableDataID


app.ThinkTable
    TableName
    CommandList

app.ThinkTableController


app.HumanEnemyController
    set_OverrideCombatParam(app.HumanEnemyParameterBase.NPCCombatParamTemplate)
    set_NPCCombatParam(app.HumanEnemyParameterBase.NPCCombatParamTemplate)
    changeNPCCombatTable(app.HumanEnemyParameterBase.NPCCombatParamTemplate)

    getCombatParam(app.Character, app.HumanEnemyController.HumanType, app.Character.JobEnum)
    getOverwriteHpParam(app.Character)



    applyParameter(app.HumanEnemyParameterBase.NPCCombatParamTemplate, System.Boolean)
**  applySkillSet(app.HumanEnemyParameterBase.HumanEnemySkillSetID)
        2   this.HumanEnemyController
        3   app.HumanEnemyParameterBase.HumanEnemySkillSetID
        4   app.GenerateDefaultParameter
        5   app.ExceptPlayerDamageCalculator

    

app.CharacterManager
    initNPCCombatParameterDict(System.Collections.Generic.Dictionary`2<app.HumanEnemyParameterBase.NPCCombatParamTemplate,app.NPCCombatParameterData>)



app.NPCManager
    get_HumanEnemyThinkTableDataList()
    set_HumanEnemyThinkTableDataList(app.HumanEnemyThinkTableDataList)


app.QuestNpcOverride
    get_QuestID
    get_NpcID
    get_Condition
    get_Generate
    get_Schedule
    get_Job
    get_Combat
    getCharacterData

    _DisplaySettingFlags
    _QuestID
    _NpcID
    _Condition
    _Generate
        _Generate           app.CharacterData.GenerateDefine
    _Job
        _Job                app.CharacterData.JobDefine
   *_Combat                 app.QuestNpcOverride.CombatSetting
        _CombatJob          app.Character.JobEnum
        _CombatParam        app.HumanEnemyParameterBase.NPCCombatParamTemplate
        _IsWeapon
        _LeftWeapon
        _RightWeapon





app.AIManager
    setPersonalityPolicyDB(app.PersonalityPolicyTable)
    doPersonalityPolicyData(System.Action`2<app.AIDecisionDefine.Policy,System.Collections.Generic.Dictionary`2<System.UInt32,System.Single>>)
    registerPersonalityData(app.PersonalityDefine.PersonalityID, app.PersonalityData)
    unregisterPersonalityData(app.PersonalityDefine.PersonalityID)
    getPersonalityData(app.PersonalityDefine.PersonalityID)
    _PersonalityPolicyDB
    _PersonalityPolictDBLock
    _PersonalityDataDB
    _PersonalityDataDBLock


app.AISituationManager


app.CharacterAIStateController
    get_AIState()
    get_IsCautionState()
    get_IsCombatState()
    get_IsDangerState()
    get_IsAngry()
    add_AIStateChangedEvent(System.Action`1<app.AIStateEnum>)
    remove_AIStateChangedEvent(System.Action`1<app.AIStateEnum>)
    requestForceAIState(app.AIStateEnum)
    switchAIState(app.AIStateEnum)
    requestAIState(app.AIStateEnum)
    _AIState
    _PrevAIState
    _FixAIState

app.AIDecisionMaker
    get_DecisionModule()
        set_DecisionModule(app.AIDecisionModule)
    get_Context()
        set_Context(app.ContextHolder)
    get_Character()
    addDecisionPack(app.DecisionPack)
    addDecisionPack(app.AIDecisionDefine.DecisionPackID)
    removeDecisionPack(app.DecisionPack)
    remDecisionPack(app.AIDecisionDefine.DecisionPackID)







setSkill(app.Character.JobEnum job, app.HumanCustomSkillID id, app.HumanSkillContext.SkillSlot no)

app.Human
    <JobContext>k__BackingField         app.JobContext
        CurrentJob
        EquipedArmors


app.GenerateInfo.HumanInfoData
    get_Job()
    set_Job(app.Character.JobEnum)
    get_DecisionPackID()
    set_DecisionPackID(app.AIDecisionDefine.DecisionPackID[])
    get_RightWeaponID()
    set_RightWeaponID(app.WeaponID)
    get_LeftWeaponID()
    set_LeftWeaponID(app.WeaponID)
    get_HumanEnemyCombatParamId()
    set_HumanEnemyCombatParamId(app.HumanEnemyParameterBase.HumanEnemyCombatParamTemplate)
    <Job>k__BackingField
    <DecisionPackID>k__BackingField
    <RightWeaponID>k__BackingField
    <LeftWeaponID>k__BackingField
    <HumanEnemyCombatParamId>k__BackingField
    <CharaEditBuildPriority>k__BackingField




app.HitController.updateDamage
    args    obj                             Notes
    2       this.HitController              Damage receiver
    3       HitController.DamageInfo        Damage giver?
                ._RagdollFactor
                ._LeanReaction
                ._BlownReaction
                ._AttackPosition            XYZ
                ._DamagePosition            XYZ
4           influence                       ?
5           damage                          float
6           isParent                        bool

app.HitController.damageProc
    args    obj                             Notes
    2       this.HitController              Damage receiver
    3       HitController.DamageInfo        Damage giver?
                (same fields)
    





app.Character:
    app.WeaponAndItemHolder             <WeaponAndItemHolder>k__BackingField
            .createItem(app.EquipItemID id, System.Boolean isAutoEquip)
            .set_ItemID(app.EquipItemID value)


    <Human>k__BackingField      0x148
        <Param>k__BackingField  0x430
        Parameter               0x438
            **LVupInfoParam
                DefaultParam
                    Job
                    Hitpoint
                    Stamina
                    Attack
                    Defence
                    MagicAttack
                    MagicDefence
                    Blow
                    BlowResistance

        .get_Param()
        .set_Param(app.HumanParameter value)
        .setHumanParameter (app.HumanParameter param)

app.CharacterListHolder
    .add()
    .getCharacter(app.CharacterID)

app.CharacterListHolder.add()
    args[2]     self, app.CharacterListHolder
    args[3]     app.Character

**************************************
app.Human
    set_HumanStaminaCtrl(app.HumanStaminaController)
    set_JobContext(app.JobContext)
    set_SkillContext(app.HumanSkillContext)
    set_JobMagicUserActionContext(app.JobMagicUserActionContext)
    set_AbilityContext(app.AbilityContext)
    set_StaminaContext(app.StaminaContext)
    set_Param(app.HumanParameter)
    setHumanParameter(app.HumanParameter)
    setupContexts()
    setupItems()
    setupAddtionalWeaponsAndItemsOfBow(app.WeaponID)
    setupAdditionalWeaponsAndItemsOfArrow()
    setupJobContext()
    setupStatusContext()
    setupSkillContext()
    setupAbilityContext()
    setupStaminaContext()
    setMinRateMaxHp()
    setupUserVariables()




app.Human.start()
    
        app.EquipItemController.setup(via.Transform, app.WeaponAndItemHolder, app.SequenceController)
            args[5]: app.Sequencecontroller (get owner)
                ._GameObject._Name
            args[4]: app.WeaponAndItemHolder(.WeaponSlot?)
                <LeftWeapon>k__BackingField     app.WeaponAndItemHolder.WeaponSlot
                <RightWeapon>k__BackingField    app.WeaponAndItemHolder.WeaponSlot
                Owner                           app.Character
                [[[Use: app.WeaponAndItemHolder.WeaponSlot.changeWeapon(app.Weapon weapon)]]]

                app.WeaponAndItemHolder.Slot
                    setEmpty()
                    requestEquipWeapon(app.WeaponID)
                    requestEquipItem(app.EquipItemID)
                    prepareItem(app.EquipItemID)
                    prepareWeapon(app.WeaponID)
                    equipPrepared()
                    setupWeapon()
                    setupItem()
                    applyScale()


                    <WeaponID>k__BackingField





        app.StaminaManager.setMaxValue(System.Single)
        app.HumanStaminaController.create(app.Character, app.Human)

        
        app.HumanMoveSpeedCalculator.setup(app.Character, app.Human, System.Single)
        app.HumanMotionLayerController.setup(app.Character, via.motion.Motion, via.GameObject)
        app.HumanLocomotionControllerHelper.setup(app.Human)
        app.HumanCommonActionController.setup(app.Human)
        app.Human.updateMaxHPAndStamina()
        app.HitController.recoverHpAndMaxHpCompletely(System.Boolean)
        app.HitController.add_DamageHitHandler(app.HitController.EventDamageHit)
        

        app.GimmickHolder.setup(via.GameObject)
        app.Character.get_HumanActionSelector()
        app.Character.getLocomotionParameter()
        app.Character.getLocomotionMotionSetting()







**************************************

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


Drivers
300795  Melve
300298  V-C
300291  V-M
300793  C-V
300367  C-B
300794  B-C

Guards
charid  loc     class       r_wep       l_wep       item1       item2
300802  Melve   Fighter     wp00_050_00 wp01_050_00 Iron Sword
                >Warrior*   wp02_003_00             
300803  Melve   Archer                  wp04_016_00 Hunter's Bow
300804  Melve   Mage        wp07_004_00             Favored Flower

--300260  V-C     Fighter     -----------             Vermundian Brand
--300383  V-C     Archer                  ----------- Predator
300258  V-C     >Warrior    wp02_006_00             

300056  V-M     Archer                  wp04_003_00 
300055  V-M     Fighter     wp00_013_00             
300057  V-M     Mage        wp07_016_00             

300797  C-V     Archer                  wp04_003_00 
300796  C-V     Fighter     wp00_018_00             
300798  C-V     Mage        wp07_015_00             

300558  C-B     Fighter     same but enhanced       
300369  C-B     Archer                  wp04_005_00 
300545  C-B     Archer                  wp04_008_00 

300801  B-C     Mage        wp07_014_00             
                >Sorceror   wp08_011_00             
300800  B-C     Archer                  wp04_008_00 
300799  B-C     Fighter     wp00_017_00             


Equip tables for:
    Melve Fighter
    Melve Archer
    Melve Mage
    Vernworth Fighter
    Vernworth Archer
    Vernworth Mage
    C-V Fighter
    C-V Archer
    C-V Mage
    C-B Fighter
    C-B Archer1
    C-B Archer2
    Bakbattahl Mage
    Bakbattahl Fighter
    Bakbattahl Archer

    SPECIAL CASES:
    Melve Warrior
        + after completing Warrior quest
    Vernworth Warrior
    Bakbattahl Sorceror




app.OxcartAI
    ["DriverAction"]
    driverDecision
    <CachedCharacter>k__BackingField
    <CachedOx>k__BackingField
    <CachedHitController>k__BackingField
    <isInBattle>k__BackingField
    DriverActionReq
    DriverActionNow
    .get_CachedCharacter()



app.Character:
    app.CharacterInput                  <Input>k__BackingField
    app.WeaponandItemHolder             <WeaponAndItemHolder>k__BackingField
    app.StaminaManager                  <StaminaManager>k__BackingField
    app.DangerController                DangerCtrl
    app.CharacterAIStateController      CharaAIStateCtrl
    app.BattleStateController           BattleStateCtrl
    app.SetTempStatusTrack
    app.Human                           <Human>k__BackingField



app.Character
    .get_ActionManager()
        .set_ActionManager(app.ActionManager value)
    .get_Context()
        .set_Context(app.ContextHolder value)
    .get_LockOnTarget()
        .set_LockOnTarget(app.LockOnTarget value)
    .get_Hit()
        .set_Hit(app.HitController value)
    .get_RetargetCtrl()
        .set_RetargetCtrl(app.retarget.RetargetController value)
*   .get_AIDecisionMaker()
        .set_AIDecisionMaker(app.AIDecisionMaker value)
    .get_GenerateInfo()
        .set_GenerateInfo(app.GenerateInfo value)
    .get_Human()
        .set_Human(app.Human value)
    .get_CharaController()
        .set_CharaController(via.physics.CharacterController value)
    .get_WwiseContainer()
        .set_WwiseContainer(app.WWiseContainerApp value)
    .get_BasePartSwapper()
        .set_BasePartSwapper(app.PartSwapperRoot value)
    .get_HumanPartSwapper()
        .set_HumanPartSwapper(app.PartSwapper value)
    .get_CombatStateControl()
        .set_CombatStateControl(app.CombatStateControl)
    get_StatusConditionCtrl()
        set_StatusConditionCtrl(app.StatusConditionCtrl)
    get_CommonActionSelector()
        set_CommonActionSelector(app.CharacterCommonActionSelector)
    get_HumanActionSelector()
    get_AISituation()
        set_AISituation(app.AISituationEntity)
    get_StaminaManager()
        set_StaminaManager(app.StaminaManager)
    get_DangerController()
*   get_CharaAIStateController()
        set_CharaAIStateController(app.CharacterAIStateController)
    get_BattleStateController()
    get_AnimationController()
        set_AnimationController(app.AnimationControllerBehavior)
    get_GroupContext()
        set_GroupContext(app.CharacterGroupContext)
    get_CharaID()
    get_CharaIDString()
    get_CharacterIDInfo()
    get_IsPreparing()
    get_IsPartsSwapperPreparing()
    get_IsExternalPreparing()
    get_IsBuildingPreparing()
    get_IsBuilding()
    get_Hp()
    get_ReducedMaxHp()
    get_ReducedHpRate()
    get_OriginalMaxHp()
    get_ElapsedSecond()
    setInputProcessor(app.CharacterInputProcessor)
    setActionSelector(app.CharacterCommonActionSelector)
    isKindOf(app.Character.CharacterKindEnum)
    isKindOf(app.CharacterID)
    resetActionAndAI(app.Character.ResetActionAndAIOption)
    addContexts()
    setupContexts()
    convertContextBeforeStore()
    setupUserVariables()
    .addAndEquipItems(app.WeaponID, app.WeaponID, app.CharacterEditDefine.MetaData)
    .setEquipItemStorage(app.ItemCommonParam)
    onInitializeCharacterBegin(app.CharacterID)
    onInitializeCharacterEnd(app.CharacterID)
    awake()
    start()
    update()
    getJobIndex(app.Character.JobEnum)
    getWeaponJob(app.Character chara)



app.AIDecisionMaker
    get_InitalSetType()
        set_InitalSetType(app.GenerateDefine.InitSetTypeEnum)
    get_DecisionModule()
        set_DecisionModule(app.AIDecisionModule)
    get_Context()
        set_Context(app.ContextHolder)
    addDecisionPack(app.DecisionPack)
    addDecisionPack(app.AIDecisionDefine.DecisionPackID)
    removeDecisionPack(app.DecisionPack)
    remDecisionPack(app.AIDecisionDefine.DecisionPackID)
    _InitialModuleType
    _UtilityInitSettings
    <InitalSetType>k__BackingField
    <CurrentModuleType>k__BackingField
    <DecisionModule>k__BackingField
    <Context>k__BackingField
    <Character>k__BackingField

app.AIDecisionModule
    get_Owner()
        set_Owner(via.GameObject)
    get_Chara()
        set_Chara(app.Character)
    get_AIDecisionMaker()
        set_AIDecisionMaker(app.AIDecisionMaker)
    <Owner>k__BackingField
    <Chara>k__BackingField
    <AIDecisionMaker>k__BackingField
    <ActionInterface>k__BackingField
    <Blackboard>k__BackingField

app.AIDecisionDefine.DecisionPackID
    OxcartDecisionPack
    Common
    Common_NPC
    Common_Pawn
    SoldierDecisionPack
    Job01_RisingLunge
    Job01_BlinkStrike
    Job02_BasicActions
    Job02_ThreefoldArrow
    Job02_TriadShot
    Job03_BasicActions
    Job03_Firestorm
    Job05_BasicActions
    Job03_ThunderRain
    Job03_Levitate
    Job01_FullMoonSlash
    Job01_CymbalAttack
    Job02_BodyBinder
    Job03_GuardBit

app.AIDecisionDefine
    AITargetFlagValues
    PolicyValues





============================
============================
============================






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




More or less like @_theislander_ said, you need to do 
    get_MainPawn():get_CachedCharacter() 
and then you can get the action manager from that. For side pawns you need 
    PawnManager:get_PartyPawnList():ToArray():get_element(1):get_CachedCharacter()

It's very easy actually! You just do 
    player:get_ActionManager():requestActionCore(0,node_name,layer)
Because you're not setting them in the motion layer, instead of something like Job04.
    Job04_SubNormalAttack.Job04_HeavyAttackMove
the node name must be something like Job04_HeavyAttackMove (so just remove everything before the last dot)

And layer here is just an integer, 0 for full body nodes (most of them) and 1 for upper body nodes


in hitcontroller there are just multipliers for damage rate and attack rate
but they only work if you change them in LateUpdateBehavior




-- Check a quest's status
local function get_game_quest_entity(id)
    if QuestManager.EntityDict:call('ContainsKey', id) then
        return QuestManager.EntityDict:get_Item(id)
    end
    return nil
end
local entity = get_game_quest_entity(questId)
local resultNo = entity:get_ResultNo()
-- if resultNo == -1 then incomplete
-- if resultNo == 0 then finished (I think this is a successful finish)
-- if resultNo == 1 then finished (I think this is unsuccessful finish)


app.QuestManager
    .EntityDict         0x38        {Quest ID, quest object}
        key                         Quest ID
        value                       Object
            get_IsConditionEnd()
            .Context
                <IsConditionEnd>k__BackingField






sdk.hook(sdk.find_type_definition("app.ActionManager"):get_method("requestActionCore(app.ActionManager.Priority, System.String, System.UInt32)"),
function(args)
  
  -- Assuming you want to work with the player, it's a bit more complicated for pawns or other characters
  local player=sdk.get_managed_singleton("app.CharacterManager"):get_ManualPlayer()
  -- args[2] is always the instance of the type that called the method
  local ThisActionManager=sdk.to_managed_object(args[2])
  -- Check that the player is there (meaning you aren't on a loading screen or anything like that) and that this method was called by the player's action manager
  if player and ThisActionManager==player:get_ActionManager() then
    -- args[4] is the node name
    local node_name=sdk.to_managed_object(args[4]):ToString()
    -- This will print the node name in the debug console so you can find the animation you want to prevent from playing. Make sure to comment it out or delete it after you're done
    print(node_name)
    -- Once you find your node name, substitute it here:
    if node_name=="The animation you want to prevent" then
      -- This skips setting that animation
      return sdk.PreHookResult.SKIP_ORIGINAL
    end

  end
 
end)

-- If you want to swap nodes you need to do something like
--A word of caution, most animations are on layer 0 (notable exceptions are bow animations and spells), but if you want to do stuff that mixes layers you may need to add a layer check on top of the node_name check (and maybe use a different variable for the upper body nodes) to prevent weird interactions and get everything to work smoothly
if node_name=="Shield Summons name" then
  args[4]=sdk.to_ptr(sdk.create_managed_string("Blink Strike name"))
end





if (imgui.tree_node("<TREE NAME>") then
  -- UI Code that you want to appear in this tree (>dropdown in the UI)
  imgui.tree_pop()
end