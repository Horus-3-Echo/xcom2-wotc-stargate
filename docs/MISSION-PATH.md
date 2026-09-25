# WSG-004A — cesta vlastní mise ze strategie

Vstupní `main`: `2c3834df11098e50e765717d8c4e6e0b4d49d454`.
Výsledek je návrhový kontrakt pro WSG-004B, nikoli sestavená nebo spuštěná mise.

## Ověřený řetězec

1. Vlastní třída odvozená od `X2StrategyElement` vrátí
   `X2MissionSourceTemplate` s jedinečným `DataName`.
   Pro bránu má zdroj nastavit `bRequiresSkyrangerTravel=false`.
   Výchozí hodnota je `true`; nejde tedy o kosmetickou volbu.
2. Konfigurace `XComMissionSources.ini` musí mapovat trojici
   `MissionSource + RewardType -> MissionFamily`. `XComTacticalMissionManager`
   načítá toto pole jako `arrSourceRewardMissionTypes`.
3. V jednom `XComGameState` vznikne instance odměny a
   `XComGameState_MissionSite`; `BuildMission(..., true, false)` nastaví
   zdroj, region, dostupnost, odměny a `GeneratedMission`.
   Firaxisí `XComGameState_AlienNetworkComponent.PostCreateInit` je konkrétní
   příklad tohoto konstrukčního vzoru. Stargate nesmí převzít jeho Avatar/Doom
   chování ani identitu `MissionSource_AlienNetwork`.
4. Dostupný `XComGameState_MissionSite` je strategická entita. Běžná cesta UI
   vede přes potvrzení místa, `SelectSquad()` a
   `XGStrategy.PrepareTacticalBattle(ObjectID)`.
5. Po zavření výběru družstva volá `UISquadSelect` při
   `bRequiresSkyrangerTravel=false` přímo `MissionState.ConfirmMission()`;
   nevolá `SquadSelectionCompleted()`, nenaloží tým do Skyrangeru a nečeká
   na jeho let. `ConfirmMission()` přesto volá
   `XGStrategy.LaunchTacticalBattle(ObjectID)`. V `XGStrategy` se taková
   mise otevře příkazem `open <PlotMap>?game=XComGame.XComTacticalGame`.
   To je vhodný transportní kontrakt brány, nikoli vlastní letecký boj.
6. `PrepareTacticalBattle` uloží ID mise do
   `XComGameState_BattleData.m_iMissionID`. Při konci taktické vrstvy může
   `X2MissionSourceTemplate.WasMissionSuccessfulFn` určit
   `bLocalPlayerWon`; návrat do strategie podle něj volá
   `OnSuccessFn` nebo `OnFailureFn`.
7. Po výsledkovém callbacku běžná cesta provede
   `SquadTacticalToStrategyTransfer()`: zachová návrat přeživších, smrt či
   zajetí, zranění, léčení a přesun vybavení/kořisti. Stargate tuto cestu nemá
   nahrazovat vlastním kopírováním vojáků.

## Ukládaný stav a vlastnictví

| Stav | Vlastník | Vazba |
| --- | --- | --- |
| existence a definice nabídnuté mise | `XComGameState_MissionSite` | `Source`, `Available`, `GeneratedMission`, `Rewards`, `ObjectID` |
| zvolená mise a družstvo | `XComGameState_HeadquartersXCom` | `MissionRef`, `Squad` |
| taktický výsledek | `XComGameState_BattleData` | `m_iMissionID`, `bLocalPlayerWon`, cíle a kořist |
| návrat vojáků a výbavy | standardní post-mission převod | stejné `XComGameState_Unit` reference, žádné paralelní kopie |
| jednorázovost expedice a odměny | budoucí vlastní game-state objekt | stabilní ID expedice a příznak udělené odměny, změněné v témže výsledkovém game state |

`OnLoadedSavedGameToStrategy` zůstává místem pro kontrolu/reconciliaci po
načtení strategie. Nesmí samo udělovat odměnu: callback výsledku musí zapsat
výsledek a příznak jednorázovosti atomicky do verzovaného game state.
Konkrétní třída tohoto stavu náleží WSG-004B/WSG-007 a dosud neexistuje.

## Přesný rozsah WSG-004B

Nejmenší implementace má přidat vlastní mission-source template, samostatný
factory pro jednu `XComGameState_MissionSite`, potřebnou source/reward/family
mapu a validní WotC mission definition. Spouštěcí okamžik musí být ověřen proti
skutečnému WotC SDK; samotná existence `InstallNewCampaign(StartState)`
neprokazuje, že v něm už je dostupný požadovaný region a kompletní strategický
stav. Vytvoření mise musí mít guard proti duplicitě.

WSG-004B nesmí zatím tvrdit artefakt, extrakční bránu ani jednorázovou odměnu.
Jeho důkazem bude úspěšný build, jedna nabídka mise ve strategii, výběr týmu,
přímý přechod bez letu Skyrangeru, návrat do strategie a úplný log.

## Zdroje a mez důkazu

Použit byl připnutý commit `75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1`
zrcadla Firaxisích WotC SDK zdrojů:

- [X2MissionSourceTemplate.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/X2MissionSourceTemplate.uc),
  blob `20cab219587e60f4fc8725618fcbe17e8b9120bb`;
- [XComGameState_MissionSite.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_MissionSite.uc),
  blob `add671468c736149030438e0485d3b67288f0e69`;
- [UISquadSelect.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/UISquadSelect.uc),
  blob `75d8eeb74cd9e546d446710e13d80054d1104ed3`;
- [XGStrategy.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XGStrategy.uc),
  blob `f0227aa6d12a96ed3a768684d2348d01beb85261`;
- [XComGameStateContext_StrategyGameRule.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameStateContext_StrategyGameRule.uc),
  blob `35b2885140bd59ea1c6220322b37f18a534b2de8`;
- [XComGameState_BattleData.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_BattleData.uc),
  blob `d6ff9b390c34f2e465c540b23bbd6fbc3ea4e7c2`;
- [XComGameState_AlienNetworkComponent.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComGameState_AlienNetworkComponent.uc),
  blob `e4c20abd7702d5d9b77f74958f345638a53643c9`;
- [XComMissionSources.ini](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/XCOM%202%20Config/XComMissionSources.ini),
  blob `6d3f4bbcd28ed0981793bbe03160d412c49af44c`;
- [XComTacticalMissionManager.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/XComGame/Classes/XComTacticalMissionManager.uc),
  blob `58656a21b2407a9befc061f645d193da38189b4f`.

Jde o připnuté veřejné zrcadlo souborů s hlavičkami Firaxis, nikoli o lokálně
ověřenou instalaci SDK. Typy, pole a volání jsou doložené; kompatibilita
projektu, konfigurace a chování cílového buildu zůstávají BLOCKED do porovnání
se skutečným WotC SDK, kompilace a herního testu.
