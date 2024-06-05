## NOW
+ User configurability
    + UI
+ BUG: Game loads same oxcart & guards
    + Find a way to refresh the cart. Finding this should enable me to also allow cart configuration
+ BUG: Wandering too far from cart makes cart fall apart & disappear
    + Making the cart truly invincible & unbroken should resolve this
    + Also ensuring the cart is fresh when loaded

## SOON
+ Equip and stat tables
+ (configurable) Faster ox
+ (configurable) Guard buffs (advanced abilities, buffed stats, better equipment)
+ (configurable) Ox buffs (buffed stats)

 
## LATER
+ Driver behavior alteration (join fights, add player classes/abilities)
+ Driver appearance alteration (glowing eyes in combat, see about using the Medusa glare for this)
+ Driver BGM (nuDoom music plays when drivers get into fight)
+ Option - much faster cart outside of combat, play yakety sax
+ Melve Fighter > Warrior if Warrior maister quest completed
+ V-C Fighter % chance to be Warrior
+ 
 
### DONE
+ BUG: Sm_80_042_Parts not completely being set invincible yet
    + Find way to iterate through the current cart's PartsList
    + Turned out PartsList isn't necessary as of yet, but I do know how to iterate through it now if needed


### NOTES





**************************************
app.Human.start()
    


    Called methods:
        app.DamageCalculator.setup(via.GameObject)
            args[3]: via.GameObject
                ._Name          (e.g. ch300803)
            args[2]: app.DamageCalculator
                <Ch2>k__BackingField
                <RegionStatusCtrl>k__BackingField
                <Attack>k__BackingField
                <MagicAttack>k__BackingField
                <ReactionAttack>k__BackingField
                <StaminaAttack>k__BackingField
                <EnchantPhsycalFactor>k__BackingField
                <EnchantMagicalFactor>k__BackingField
                <Defence>k__BackingField
                <MagicDefence>k__BackingField
                    app.CharacterDamageCalculator
                    <Chara>k__BackingField

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









app.Ch299003
    .setNoDieFlag(bool)
    <IsInvincible>k__BackingField       0x132
    MotSpeedMax                         0x238
    MotSpeedMin                         0x23C
    RunRangeCenter
    RunRageDist
    RunRate
    app.Ch299
        app.Ch200000
            <Chara>k__BackingField      0x60

            <Monster>k__BackingField    0x68

app.Gm80_042
    .IsSetup
    .HasCage
    .GimmickId
    ["<UniqId>k__BackingField"]._Index
    .get_BoardingRouteNum()
    .setupObjects()
    _IsUnbreakable                  0x200
    <CompHitCtrl>k__BackingField    0xC0
        RegionData._items           0x258
            Hp
            MaxHp
            OldHp
    RegionStatusCtrl                0xA0


app.OxcartManager
    *.getSchedule_BaseInfo(app.CharacterID)
        1       thread
        2       (this.)app.OxcartManager
        3*      app.CharacterID charaID
        4       ID
        5       ID
        Return: app.OxcartSchedule.OxcartBaseInfo
                    OxcartID
    *.getSchedule(app.CharacterID charaID)
        1       thread
        2       (this.)app.OxcartManager
        3*      app.CharacterID charaID
        4       ?charaID
        5       app.OxcartStatus
        Return: app.OxcartSchedule

    *.getStatus(oxcart id)
        1       thread
        2       (this.)app.OxcartManager
        3*      app.CharacterID oxcartID
        4       ID
        5       ID
        Return: app.OxcartStatus
                    .Route
                    .<oxcartdummy>k__BackingField
                    .MoveSpeed
                    .OxcartID
                    .DriverID
                    ._Guards
                    .Driver (app.OxcartNPC)
                    .ALLCharaID

    .setSchedule(app.CharacterID, app.OxcartSchedule)

app.OxcartSchedule
    OxcartBaseInfos
    Routes
    Members


app.OxcartUtil
    .getOxcartStatus(app.CharacterID oxcartID)
    .getOxcartStatus_AssignCharacterID(app.ChracterID)
    .getOxcartScheduleData()
    .getOxcartStatus_Entity()
    .getStatusList()

app.OxcartCondition
    .Evaluate()

app.OxcartStatus
    .registerOxcart(app.CharacterID oxcart, app.OxcartAI obj, System.Boolean IsDummyUpdate)
    .registerOxcart(app.CharacterID oxcart, app.DummyDataOxcart obj)
    .setScheduleState_Oxcart()
    .getDestinationID()
    .get_oxcartAI()
    .set_oxcartAI(app.OxcartAI value)
    Route
    <oxcartAI>k__BackingField

app.OxcartConnecter
    .getOxcartGimmickID(app.CharacterID)
    .getOxcartUniqueID(app.CharacterID)
    ["OxcartCharaIDArray"]
    ["_OxcartUniqueID"]
    ["_Oxcart"]

app.OxcartConnecter.requestOxcart()
    1       thread
    2       (this.)app.Oxcartconnecter
                ._Oxcart
                    ._BoardingRouteNum
                    .MaxHp
                    .GenerateParent
                    ._GameObject._Name
                ._OxcartUniqueID._Index
    3       app.Oxcartconnecter
    4       ID


app.GenerateManager
    <DictCharacterID>k__BackingField._entries
        key, value
    <DictGimmickID>k__BackingField._entries
        key, value
    _GenerateDefaultParam
        .getStatus(app.CharacterID charaID)
        .getInitSetting(app.CharacterID charaID, app.GenerateDefine.InitSetTypeEnum initType)


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
300802  Melve   Fighter >Warrior once Warrior quest complete
300803  Melve   Archer
300804  Melve   Mage

300260  V-C     Fighter
300383  V-C     Archer
300258  V-C     Fighter >Warrior

300056  V-M     Archer
300055  V-M     Fighter (no shield)
300057  V-M     Mage

300797  C-V     Archer
300796  C-V     Fighter
300798  C-V     Mage

300558  C-B     Fighter
300369  C-B     Archer
300545  C-B     Archer

300801  B-C     Mage    >Sorceror
300800  B-C     Archer
300799  B-C     Fighter


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

ch2 = damage_calculator["<Ch2>k__BackingField"]
r_stat_ctrl = damage_calculator["<RegionStatusCtrl>k__BackingField"]
attack = damage_calculator["<Attack>k__BackingField"]
magic_attack = damage_calculator["<MagicAttack>k__BackingField"]
react_attack = damage_calculator["<ReactionAttack>k__BackingField"]
stam_attack = damage_calculator["<StaminaAttack>k__BackingField"]
enchant_phys = damage_calculator["<EnchantPhsycalFactor>k__BackingField"]
enchant_mag = damage_calculator["<EnchantMagicalFactor>k__BackingField"]
defense = damage_calculator["<Defence>k__BackingField"]
magic_defense = damage_calculator["<MagicDefence>k__BackingField"]



app.Sm80_042_Parts (app.Gm80_042.PartsList)

app.GimmickManager
    ["<ManagedGimmicks>k__BackingField"]._items
    .register(app.GimmickBase gimmick)
app.GimmickBase
    ["GimmickId"] == 124
    ["<CompHitCtrl>k__BackingField"]
        ["<IsInvincible>k__BackingField"] == true
    ["<UniqId>k__BackingField"] (app.UniqueID)
    app.Gm80_042["<ParentId>k__BackingField"] == OxcartStatus.OxcartID
        -- app.GimmickBase.<UniqId>k__BackingField = app.UniqueID


app.NPCManager
    (all oxcart schedule methods are dupes)
    .setScheduleState_Oxcart(app.CharacterID, app.OxcartStatus)


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


app.NPCManager:
    .get_NPCList()
    .getNPCConfig()
    .getNPCCharacterData()
    .setupCharacterData()

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
*   get_Hp()
    get_ReducedMaxHp()
    get_ReducedHpRate()
*   get_OriginalMaxHp()
    get_ElapsedSecond()
    get_IsDrawedWeapon()
        set_IsDrawedWeapon(System.Boolean)
*   get_RightWeapon()
*   get_RightWeaponID()
*   get_IsEquipRightWeapon()
*   get_LeftWeapon()
*   get_IsEquipLeftWeapon()
*   get_IsEquipRightWeapon()
    setInputProcessor(app.CharacterInputProcessor)
    setActionSelector(app.CharacterCommonActionSelector)
    isKindOf(app.Character.CharacterKindEnum)
    isKindOf(app.CharacterID)
    resetActionAndAI(app.Character.ResetActionAndAIOption)
    addContexts()
    setupContexts()
    convertContextBeforeStore()
    setupUserVariables()
**  .addAndEquipItems(app.WeaponID, app.WeaponID, app.CharacterEditDefine.MetaData)
**  .setEquipItemStorage(app.ItemCommonParam)
    onInitializeCharacterBegin(app.CharacterID)
    onInitializeCharacterEnd(app.CharacterID)
    awake()
    start()
    update()
    getJobIndex(app.Character.JobEnum)
    getWeaponJob(app.Character chara)

***
    <WeaponAndItemHolder>k__BackingField    0x270
        <LeftWeapon>k__BackingField
        <RightWeapon>k__BackingField
            changeWeapon(app.Weapon)
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


    WeaponContext                           0x688


app.Weapon
    get_IDProp()
    get_JobProp()
    get_Owner()
        set_Owner(via.GameObject)
    <Owner>k__BackingField
    <PartSwapper>k__BackingField
    ID
    Job


app.EquipmentManager
    setWeaponSetting(app.WeaponSetting weaponSetting)
    registerWeapon(app.WeaponCatalogData)
    registerEquipItem(app.EquipItemCatalogData)
    unregisterWeapon(app.WeaponCatalogData)
    unregisterEquipItem(app.EquipItemCatalogData)
    requestInstantiate(app.WeaponID, via.Component, System.Action`1<app.PrefabInstantiateResults>, System.Func`1<System.Boolean>)
    requestInstantiate(app.EquipItemID, via.Component, System.Action`1<app.PrefabInstantiateResults>, System.Func`1<System.Boolean>)
    getQuiverID(app.WeaponID)
    setupWeapon(app.PrefabInstantiateResults, System.Action`1<app.PrefabInstantiateResults>, System.Func`1<System.Boolean>)
    setupEquipItem(app.PrefabInstantiateResults, System.Action`1<app.PrefabInstantiateResults>, System.Func`1<System.Boolean>)
    WeaponSetting
    WeaponCatalog
    EquipItemCatalog


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