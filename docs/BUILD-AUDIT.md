# WSG-003 — audit balení, 2026-09-25

Vstup projektu: `db3b1fe042e535829b028e1f6ef40844c856b2b4`.
Výsledek: konkrétní build/packaging kontrakt doložen, kandidát není sestaven.
WSG-003 zůstává BLOCKED pro ověření původním WotC SDK; další nezávislý krok 004A.

## Primární zdroje a zjištění

1. [WotC referenční řešení](https://github.com/X2CommunityCore/X2CommunityPromotionScreen/blob/34439925a59004bec17ea9a3c34a3164f6a459a5/X2WOTCCommunityPromotionScreen.XCOM_sln),
   blob `932d35b27df87306d02b116bdba529362079cc09`:
   formát 12.00, typ projektu {5DAE07AF-E217-45C1-8DE7-FF99D6011E8A},
   Debug/Default a platforma XCOM 2 odpovídají kandidátu.
   Platformu nepřejmenovávat na domnělé WotC.
2. [WotC referenční .x2proj](https://github.com/X2CommunityCore/X2CommunityPromotionScreen/blob/34439925a59004bec17ea9a3c34a3164f6a459a5/X2WOTCCommunityPromotionScreen/X2WOTCCommunityPromotionScreen.x2proj),
   blob `20deed7fbddc9675924763efb2542cb8952eb328`:
   ToolsVersion=12.0, DefaultTargets=Default, metadata a Content položky.
   Jeho import je ale X2ModBuildCommon, nikoli původní SDK. Nejde o důkaz,
   že zdejší kandidát již prošel původním WotC ModBuddy.
3. [README X2ModBuildCommon](https://github.com/X2CommunityCore/X2ModBuildCommon/blob/14e97e10260295b6900c7b2da0ab6e7b7da29e5d/README.md),
   blob `bc738fdad431c8db23a218b277656266fb229180`:
   dokumentuje nahrazení původního importu MSBuildLocalExtensionPath/XCOM2.targets.
   Vlastní cesta vyžaduje build.ps1, BuildProject(modName, srcDirectory, sdkPath,
   gamePath), EnableDebug() pro debug a InvokeBuild(). Není zde integrována.
4. [Implementace build_common.ps1](https://github.com/X2CommunityCore/X2ModBuildCommon/blob/14e97e10260295b6900c7b2da0ab6e7b7da29e5d/build_common.ps1),
   blob `0486b01c94f943ca80e9e27da902deb72b9ef383`:
   _SetupUtils() určuje staging jako SDK/XComGame/Mods/modName a výstup
   pod gamePath/XComGame/Mods/modName (lze přesměrovat X2MBC_MODS_ROOT).
   _CopyModToSdk() čte Name, Description a SteamPublishID z .x2proj
   a generuje .XComMod sekci [mod]. RequiresXPACK=true přidává podle
   case-sensitive podmínky sdkPath -clike "*Chosen*". Je to křehká heuristika
   tohoto nástroje, nikoli ověření edice SDK. Proto kontrolovat skutečný výstup.
   Neodvozovat z toho neověřenou vlastnost RequiresXPACK v .x2proj.
   _RunMakeMod() volá SDK commandlet s make -nopause -mods; nenativní
   zkompilované balíčky se kopírují do Script/name.u.
5. [X2ModBuildCommon targets](https://github.com/X2CommunityCore/X2ModBuildCommon/blob/14e97e10260295b6900c7b2da0ab6e7b7da29e5d/XCOM2.targets),
   blob `b3d0bd666aab96b5d755b7d3b4dcd59735377761`:
   Default/Debug mapuje na default/debug, předává SDK a hru odvozené
   z XCOM2_UserPath a XCOM2_GamePath. Tyto vlastnosti patří integraci
   ModBuddy; nejsou zaměnitelné za absolutní cesty cizí instalace.

Revize zdrojů byly načteny a soubory znovu ověřeny na uvedených commitech.
Žádné SDK, targets ani cizí herní zdroje nejsou přibaleny.
Pouhé čtení Highlander/community zdrojů nezavádí runtime závislost.

## Změna a hranice důkazu

Kandidátní .x2proj/.XCOM_sln ponechány beze změny: audit neodhalil doloženou
chybu, která by opravňovala spekulativní změnu formátu/importu.
T00 nyní hlídá import, konfigurace, metadata a povinné Content položky;
dříve mohl projít i po odstranění registrace ze seznamu Content.
Nový check_package.py odmítá chybějící WotC marker, cizí identitu,
chybné INI a chybějící/prázdný skript. Podporuje UTF-8/BOM a UTF-16/BOM.
publishedFileId=0 je projektové pravidlo této nepublikované fáze,
nikoli obecný požadavek WotC. Popisný Title je zde rovněž projektově pevný.

Syntetický neprázdný .u záměrně projde: nástroj nečte Unreal bytecode,
nekontroluje jeho stáří ani neprokazuje T01. Stejně neprokazuje spuštění,
mise, přepravu, Avenger, Avatar, příběhové spouštěče nebo save/load.
Tyto vazby náleží dalším WSG úkolům. Postup T01–T04 je v BUILD.md.
