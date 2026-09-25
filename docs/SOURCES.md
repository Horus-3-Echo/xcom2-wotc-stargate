# Primární zdroje — ověřeno 2026-09-25

- Signatury a význam DLC lifecycle:
  https://github.com/X2CommunityCore/X2WOTCCommunityHighlander/blob/master/X2WOTCCommunityHighlander/Src/XComGame/Classes/X2DownloadableContentInfo.uc
  Blob ac975992a4af6ec5361251a81ff7ca0b36b37ad7, začátek souboru.
- Referenční uspořádání WotC projektu a konfigurací:
  https://github.com/X2CommunityCore/X2CommunityPromotionScreen/tree/master/X2WOTCCommunityPromotionScreen
  XComEditor.ini b31d5bea3c4116908bba2adc704cda2d4f1fc027,
  XComEngine.ini a300e49a56ed30501a8f31d53791e5da9b9cfc00,
  XComGame.ini d4d2df499427601e389f4970ef5746c684dd6435.
- Formát řešení: X2WOTCCommunityPromotionScreen.XCOM_sln,
  blob 932d35b27df87306d02b116bdba529362079cc09, v témže repozitáři.
- Původní SDK návod (základní XCOM 2, ne zaměnit za potvrzení WotC cest):
  https://downloads.2kgames.com/xcom2/uploads/pdfs/XCOM2_SDK_QuickStart_2.pdf
- Budoucí build automatizace: https://github.com/X2CommunityCore/X2ModBuildCommon
  README blob bc738fdad431c8db23a218b277656266fb229180.

## WSG-004A — mise ze strategie

Připnutý commit zrcadla Firaxisích WotC SDK zdrojů:
https://github.com/daakru/xcom2-wotc-modding/tree/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1

- `X2MissionSourceTemplate.uc` blob `20cab219587e60f4fc8725618fcbe17e8b9120bb`:
  příznak dopravy a výsledkové delegáty.
- `XComGameState_MissionSite.uc` blob `add671468c736149030438e0485d3b67288f0e69`:
  BuildMission, SelectSquad, ConfirmMission a spuštění taktické vrstvy.
- `UISquadSelect.uc` blob `75d8eeb74cd9e546d446710e13d80054d1104ed3`:
  přímý ConfirmMission při `bRequiresSkyrangerTravel=false`.
- `XGStrategy.uc` blob `f0227aa6d12a96ed3a768684d2348d01beb85261`:
  vytvoření BattleData, vazba m_iMissionID a přechod bez Skyrangeru.
- `XComGameStateContext_StrategyGameRule.uc` blob
  `35b2885140bd59ea1c6220322b37f18a534b2de8`: výsledkové callbacky a standardní
  převod družstva zpět do strategie.
- `XComGameState_BattleData.uc` blob `d6ff9b390c34f2e465c540b23bbd6fbc3ea4e7c2`:
  m_iMissionID, bLocalPlayerWon a WasMissionSuccessfulFn.
- `XComGameState_AlienNetworkComponent.uc` blob
  `e4c20abd7702d5d9b77f74958f345638a53643c9`: konkrétní vytvoření odměny,
  MissionSite a volání BuildMission; jeho Avatar/Doom logika se nepřebírá.
- `XComMissionSources.ini` blob `6d3f4bbcd28ed0981793bbe03160d412c49af44c`
  a `XComTacticalMissionManager.uc` blob
  `58656a21b2407a9befc061f645d193da38189b4f`: source/reward/family kontrakt.

Úplné odkazy a vyhodnocení jsou v docs/MISSION-PATH.md. Veřejné zrcadlo není
náhradou porovnání se skutečným cílovým WotC SDK; kompilace a hra neproběhly.

Nejsou přebírány herní zdroje ani obsahové balíčky; vlastní loader pouze používá
rozhraní. Zdroje neprokazují, že jej zde neprovedený build přijme.
