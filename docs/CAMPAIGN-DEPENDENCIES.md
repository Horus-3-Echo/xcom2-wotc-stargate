# WSG-008A — vazby na původní kampaň WotC

Datum auditu: 2026-09-26. Vstupní main:
`d620189c3e25751538ebeec9f00d182e426b8bda`.
Výsledek: zdrojový audit pro WSG-004B/008B. Žádný runtime zásah,
kompilace ani herní ověření. Zadání docs/BRIEF.md v1 se nemění.

## Co musí zůstat a co oddělit

| Oblast | Ověřená vazba | Kontrakt pro první prototyp |
| --- | --- | --- |
| Avenger a návrat | `ProcessMissionResults()` načítá XCom HQ, `MissionRef`, Alien HQ a Fortress mission; standardní převod spravuje družstvo. `ConfirmMission()` nastavuje cestu zpět na HQ. [S1, S2] | Zachovat HQ i standardní návrat. Brána mění transport mise, nenahrazuje strategickou infrastrukturu. SGC je zatím zamýšlené herní zastoupení, nikoli hotová přestavba Avengeru. |
| Doprava | `bRequiresSkyrangerTravel=false` řeší větev popsanou v MISSION-PATH.md. HQ má samostatnou logiku letu Avengeru i Skyrangeru. [S8, S10] | Nepovažovat vynechání letu Skyrangeru za vypnutí pohybu Avengeru, jeho obrany nebo strategických hodin. |
| Avatar při vytváření mise | `BuildMission()` přebírá `bMakesDoom`, volá volitelné `CalculateStartingDoomFn` a `CalculateDoomRemovalFn`; losuje `bSpawnUFO` z `SpawnUFOChance`. [S1] | Vlastní template bez Doom delegátů, s `bMakesDoom=false`, `SpawnUFOChance=0`; ověřit `Doom=0` a `FixedDoomToRemove=0` na instanci. |
| Avatar po návratu | Ještě před vlastním výsledkovým callbackem běžná cesta zpracovává `PendingDoomData` a může volat `StopAcceleratingDoom()`. [S2] | Nelze slibovat nulový zápis do Alien HQ. Test porovnává legitimní společné zpracování s nežádoucí odměnou za Stargate misi. Nikdy nemaže globální pending frontu. |
| Příběhové callbacky | `GoldenPathMissionOnSuccess()` volá `SpawnUFO()`, odměny a `RemoveGPDoom()`. Obrana Avengeru má při prohře `FinalMissionOnFailure()`. [S3] | Vlastní OnSuccess/OnFailure; nekopírovat callbacky Golden Path ani AvengerDefense pouze kvůli podobnému transportu. |
| Obtížnost | `ProcessMissionResults()` volá `IncreaseForceLevel()`, ale pomocník mění sílu jen při `bIncreasesForceLevel`. [S2, S3] | Vlastní source nastaví `bIncreasesForceLevel=false`. Nejde o vypnutí časového růstu obtížnosti. |
| Příběhové události | `ConfirmMission()` vždy vyvolá `LaunchMissionSelected`. Objektivy poslouchají CompletionEvent a následně ověřují své požadavky. [S1, S6] | Jedinečné jméno source ani `bGoldenPath=false` obecnou událost neodfiltrují. Stargate nabídku nepouštět do aktivního tutoriálového řetězce. |
| Kalendář | Geoscape aktualizuje Alien AI a mission calendar odděleně. [S9] | Vlastní jednorázová nabídka nepřepisuje standardní mission decks a nevypíná celý Update; tím by se zasáhly i jiné systémy. |

## Doložené kolize příběhu

1. `T0_M3_WelcomeToHQ` je tutorial-only objektiv s
   `CompletionEvent='LaunchMissionSelected'` a
   `CompleteObjectiveFn=FlightDeviceFastForward`. Tento callback posune
   strategický čas k další GuerillaOp. `T0_M7_WelcomeToGeoscape` poslouchá
   stejnou událost. [S7] Proto nestačí nevolat vlastní příběhový event:
   běžné spuštění mise jej již vysílá.
2. `T0_M8_ReturnToAvengerPt2` reaguje na `PostMissionDone` a může aktivovat
   Resistance HQ. `T2_M3_CompleteForgeMission` používá tentýž completion event,
   ale navíc požaduje předmět `StasisSuitComponent`. [S7]
   Vlastní artefakt nesmí převzít tuto identitu. Událost sama o sobě nemusí
   cíl splnit: `CheckObjectiveCompletion()` kontroluje
   `MeetsAllStrategyRequirements()`, případný `ObjectiveRequirementsMetFn`
   a podcíle. [S6]
3. Vlastní source musí mít jedinečný DataName, `bGoldenPath=false`,
   `bAlienNetwork=false`, `bStart=false`; nesmí se vydávat za
   MissionSource_Final, Blacksite, Forge, PsiGate či AvengerDefense.
   Všechna uvedená pole jsou členy `X2MissionSourceTemplate`. [S10]

Implementační hranice pro 004B/008B: nabídnout misi až v normálně otevřené
strategii po úvodu, pro první test použít novou kampaň bez tutoriálu.
To je testovací omezení, nikoli důkaz podpory všech variant úvodu.
Konkrétní moment vytvoření nabídky musí stále projít kontrolou v cílovém SDK;
`InstallNewCampaign` není tímto auditem schválen jako bezpečný okamžik.
Globální odregistrování příběhových posluchačů ani nucené dokončení původních
objektivů není součástí řešení.

## Proč pouhé zastavení Avatar časovačů nestačí

`XComGameState_HeadquartersAlien.GetCurrentDoom()` sčítá vlastní Doom a Doom
dostupných MissionSite a zohledňuje pending hodnoty. Samotné
`bMakesDoom=false` na Stargate misi proto nevypíná Avatar projekt. [S4]

`StopGeneratingFacilityDoom()` a `StopGeneratingFortressDoom()` vypnou
příznak generování a posunou konec příslušného intervalu. Strategická AI však
obsahuje akce AlienAI_StartGeneratingFacilityDoom a
AlienAI_StartGeneratingFortressDoom: v StartPhase při negenerování může
generování znovu zapnout (facility navíc vyžaduje dostupnou facility). [S4, S5]

Odděleně existuje `NeedToStartLoseTimer()`:
`NotInLoseMode() && DoomMeterFull()`. `StartLoseTimerAction()` přepne
`AIMode="Lose"`, nastaví `AIModeIntervalEndTime` a pozastaví běžné Doom
časovače. `AlienAI_PlayerLoss` kontroluje Lose režim a dokončení tohoto
intervalu; `PlayerLossAction()` nastaví `bAlienFullGameVictory` a vysílá
`XComLoss`. [S5] PauseDoomTimers tedy není pauza tohoto odpočtu do porážky.

Rozhodnutí pro omezený M1: ponechat původní Avatar/AI a infrastrukturu kampaně,
izolovat vlastní misi a ověřit soužití. Nahrazení celé kampaně SGC nebo
globální potlačení Avataru by vyžadovalo samostatně schválený a ověřený zásah
do restartovacích akcí, Lose režimu, pending efektů i save/load; není nutnou
podmínkou jedné testovací výpravy a zde není implementováno.
Highlander ani jiná runtime závislost tímto nálezem není doložena jako potřebná.

## T14 — přesný budoucí test soužití kampaně

Stav: NOT_RUN. Vykonatelné až po T01–T04 a sestavené misi z WSG-004B/005–007.
Následující body jsou přejímací postup pro 008B, nikoli nynější žádost o
hraní neexistujícího sestavení.

1. Zapiš commit, build hry/SDK, obtížnost a povolené módy. V nové testovací
   kampani bez tutoriálu dokonči standardní úvod a otevři strategii.
   Ulož pozici A před nabídnutím výpravy. Pořiď screenshot cílů, Avatar
   ukazatele (pokud je odhalen) a času.
2. Vývojové diagnostické logování musí před nabídkou, před startem, po návratu
   a po loadu zaznamenat: MissionSite ObjectID/Source/Doom/FixedDoomToRemove,
   HQ MissionRef a Squad, AlienHQ GetCurrentDoom(true), PendingDoomData,
   AIMode a AIModeIntervalEndTime, ForceLevel, oba příznaky generování, aktivní
   XComGameState_Objective (jméno/ObjState) a herní čas.
   Toto logování dosud není implementováno; bez něj nelze interní shodu
   hodnot označit PASS. Neodvozovat ji pouze z HUD.
3. Spusť a úspěšně dokonči výpravu se čtyřmi vojáky. Očekávání: přímý vstup
   bez letu Skyrangeru, standardní návrat a správný tým; žádné splnění
   tutorial/Forge/Blacksite cíle pouze kvůli Stargate artefaktu; žádné UFO,
   Doom snížení či růst ForceLevel vyvolaný vlastním callbackem.
   Případné společné pending Doom efekty musí být vysvětleny z logu.
4. Ulož B po návratu, načti B dvakrát. Očekávání: stejný tým a uložený postup,
   jedna odměna, žádný další Stargate MissionSite ani duplicitní příběhová
   událost způsobená load hookem.
5. Z B nech proběhnout 24 strategických hodin včetně běžných přerušení,
   zaznamenej čas a události. Avatar ani standardní mise se nemají globálně
   zastavit kvůli módu. Běžný růst Avataru není chyba izolace.
   Kontrolní větev ze zálohy A se stejným časovým intervalem pomůže rozlišit
   původní dění od zásahu módu; náhodné události nemusí být bitově totožné.
6. Samostatně z A ověř ústup a ztrátu nosiče; očekávej žádnou odměnu a
   zachování standardního návratu přeživších. M1 tím nesmí spustit
   AvengerDefense/FinalMission prohru celé kampaně.

Dodat celý build log, herní logy pro obě větve včetně dvou loadů, výsledky
T14 PASS/FAIL s prvním nesouladem, pozice A/B pokud je lze sdílet a screenshoty
cílů/Avataru/času před a po. Redigovat osobní lokální údaje.
T14 nepokrývá dlouhodobou kampaň, aktivní tutoriál, všechny WotC narativní
řetězce ani všechny DLC. Počet dostupných hooků není důkaz funkční expedice.

## Primární kód a mez důkazu

Veřejné zrcadlo souborů Firaxis, commit
`75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1`, načtené 2026-09-26.
Odkazy jsou připnuté; nejde o potvrzení shody s dosud nedodaným cílovým SDK.

| ID | Soubor, relevantní řádky | Blob SHA |
| --- | --- | --- |
| S1 | [XComGameState_MissionSite.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_MissionSite.uc), 274–343, 1424–1460 | `add671468c736149030438e0485d3b67288f0e69` |
| S2 | [XComGameStateContext_StrategyGameRule.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameStateContext_StrategyGameRule.uc), 371–480, 488 a dále | `35b2885140bd59ea1c6220322b37f18a534b2de8` |
| S3 | [X2StrategyElement_DefaultMissionSources.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/X2StrategyElement_DefaultMissionSources.uc), 1590–1634, 1888–1903, 1998–2020, 2255–2279 | `2209cfabebb849317e7e1eea5a205456a0669397` |
| S4 | [XComGameState_HeadquartersAlien.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_HeadquartersAlien.uc), 392–426, 491–515, 750–806 | `99d8db96b03bc3c5664949373791aad74cc264ab` |
| S5 | [X2StrategyElement_DefaultAlienAI.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/X2StrategyElement_DefaultAlienAI.uc), 88–129, 192–278, 282–300, 374–386, 782–817 | `f3051da2e1c5bf5cacc5f83bb6551174edfeed0f` |
| S6 | [XComGameState_Objective.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_Objective.uc), 245–289, 420–449, 1020–1090 | `4fc083772a6341afcb5a330daac0cd057f67dd04` |
| S7 | [X2StrategyElement_DefaultObjectives.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/X2StrategyElement_DefaultObjectives.uc), 1373–1414, 1612–1666, 3186–3200 | `2ec6a2c65b4f29999539fa8773e4edf716292721` |
| S8 | [XComGameState_HeadquartersXCom.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_HeadquartersXCom.uc), 33–40, 255, 8236–8325 | `67d97db72ed16f4143b5f88ee078dff1c56a48b4` |
| S9 | [XGGeoscape.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XGGeoscape.uc), 260–307, 380–388 | `9a3efec6f6b3b64d30851781869752601c371f64` |
| S10 | [X2MissionSourceTemplate.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/X2MissionSourceTemplate.uc), 10–43, 56–95 | `20cab219587e60f4fc8725618fcbe17e8b9120bb` |

Ověřeny názvy polí, signatury a uvedené návaznosti přímo v těchto souborech.
Herní zdroje nejsou přidávány do projektu; runtime kód módu se nemění.
Závěry o potřebném omezení prototypu jsou naše návrhové odvození z těchto
vazeb, nikoli výsledky běhu hry.
