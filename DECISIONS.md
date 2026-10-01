# Rozhodnutí

- 2026-09-25 / W-D001: cílem je výhradně XCOM 2: War of the Chosen.
- W-D002: do založení vzdáleného repozitáře je autoritou verzovaný zdrojový ZIP.
- W-D003: loader používá OnPostTemplatesCreated, InstallNewCampaign a
  OnLoadedSavedGameToStrategy. Signatury ověřeny v primárním zdroji
  X2DownloadableContentInfo.uc, blob ac975992a4af6ec5361251a81ff7ca0b36b37ad7.
- W-D004: OnLoadedSavedGame není událost každého načtení pozice; nevyužíváme
  ji jako test opakovaného loadu. Stav pro expedici se v tomto pokusu nemění.
- W-D005: nejprve ověřit původní build cestu WotC SDK. ModBuddy soubory jsou
  připravené kandidáty; jejich kompatibilita není doložena kompilací.
- W-D006: Highlander bude povinný jen při doložené potřebě konkrétního rozšíření.
- W-D007: pozdější vzdušná obrana zůstává otevřená. Nyní řešit taktickou výpravu.
- 2026-09-25 / W-D008: po založení repozitáře uživatelem přejít na
  `Horus-3-Echo/xcom2-wotc-stargate`, větev `main`, jako jedinou pracovní autoritu.
  Toto nahrazuje dočasné W-D002. Přenést poslední ZIP v0; starý ZIP dále
  nerozvíjet. Zachovat oddělení projektů a zadání v1.
- 2026-09-25 / W-D009: zachovat původní SDK import a platformu XCOM 2;
  reference WotC formát potvrzuje, ale její vlastní X2ModBuildCommon není
  původní toolchain. Bez místního SDK nepřidávat domnělé projektové vlastnosti.
  RequiresXPACK kontrolovat ve vygenerovaném .XComMod. Build audit a přesné
  revize: docs/BUILD-AUDIT.md. X2ModBuildCommon ani Highlander nepřidány.
- 2026-09-25 / W-D010: první Stargate mise použije běžný WotC lifecycle
  `XComGameState_MissionSite`, ale vlastní mission-source template nastaví
  `bRequiresSkyrangerTravel=false`. Výběr družstva tak vede přímo do taktické
  mise bez letu Skyrangeru; nejde o vlastní ani automatický letecký boj.
  Přesný kontrakt a připnuté zdroje: docs/MISSION-PATH.md.
- 2026-09-25 / W-D011: návrat vojáků, zranění a vybavení ponechat standardnímu
  `SquadTacticalToStrategyTransfer`. Vlastní výsledkový callback spravuje jen
  Stargate progres a jednorázovou odměnu. `OnLoadedSavedGameToStrategy` smí
  stav kontrolovat, ne znovu udělovat odměnu.
- 2026-09-26 / W-D012: omezený M1 ponechá HQ/Avenger infrastrukturu a původní
  Avatar/AI. Vlastní source/callbacky nesmí převzít GoldenPath nebo
  AvengerDefense vedlejší účinky; testovací mise se nabídne až po úvodu,
  první test bez tutoriálu. Transportní příznak nezastavuje strategický čas
  ani obecné příběhové události. Globální vypnutí kampaně není implementováno
  ani vyžadováno pro tento omezený prototyp. Důkazy, omezení a T14:
  docs/CAMPAIGN-DEPENDENCIES.md. Nejde o změnu společného zadání v1.
- 2026-09-26 / W-D013: první vlastní model brány bude dekorativní StaticMesh
  s oddělenou oblastí vstupu/extrakce z M1. FBX verzi neodhadovat; exportní
  profil potvrdit zkušebním importem ve skutečném WotC editoru. Kontrolovat
  průchozí otvor a výchozí blokování StaticMeshComponent. UPK zařadit do
  Content až po jeho vytvoření, bez změny build systému a bez předbíhání M1.
  Zdrojový kontrakt a přejímka T20: docs/GATE-IMPORT.md.

- 2026-10-01 / W-D014: původní build cesta loaderu potvrzena (T01–T04 PASS),
  tím je splněna podmínka W-D005 pro tento loader. Pokračovat WSG-004B bez
  výměny toolchainu. SDK/hra u uživatele neznamenají přístup cloudového běhu
  k jeho počítači; další runtime změny vyžadují čerstvý build a herní test.
  InstallNewCampaign se naměřil i v menu: samotný marker nedokládá T03.
  Přejímka, prostředí a limity: reports/2026-10-01-001.md.

- 2026-10-01 / W-D015: WSG-004B vytváří jednu neexpirující
  `XComGameState_MissionSite` až z `UpdateDLC`, když existuje strategická
  mapa, Avenger/Skyranger neletí a není otevřen `UIAlert`. Jde o stejný
  geoscape hook a UI guard, který používá WotC DLC Day 60; jeho připnutý zdroj
  má blob `df0e517f5742e995b9edbbadd02413471f04b5bc`. Vlastní ukládaný
  `XComGameState_StargateProgram` zaručuje jedinou nabídku i po dokončení a
  loadu; nalezenou starší aktivní misi reconciliuje místo duplikace.
  `MissionSource_StargatePrototype + Reward_None` se mapuje na existující
  rodinu `SupplyLineRaid`, jejíž WotC zdroj používá stejný reward i podmínku
  úspěchu. Vlastní callbacky pouze uklidí odměnu/misi a nepřebírají POI,
  Resistance activity, GoldenPath, Avatar ani UFO vedlejší účinky.
  Jde o zdrojový kandidát 0.2.0; build a T05 jsou povinné před DONE.

- 2026-10-01 / W-D016: přejímka balíčku WSG-004B musí vedle descriptoru,
  registračních INI a neprázdného skriptu ověřit také přítomnost
  `Config/XComMissionSources.ini` a přesnou trojici
  `MissionSource_StargatePrototype + Reward_None -> SupplyLineRaid`.
  Bez tohoto INI může být bytecode přítomen, ale `BuildMission` nemá
  doloženou cestu k taktické definici; takový balíček nesmí dostat PASS.

- 2026-10-01 / W-D017: kandidát 0.2.1 přidává pouze čtecí diagnostiku
  `OnPreMission` pro vlastní source. Zapisuje ID mise, počet neprázdných
  referencí v `XComGameState_HeadquartersXCom.Squad`, režim odvozený přímo
  z `bRequiresSkyrangerTravel` a generovaný typ mise. WotC volá tento hook
  po vytvoření battle data a před vložením start state do historie a otevřením
  taktické mapy. Marker zpřesní T05, ale nenahrazuje pozorování, že obrazová
  sekvence letu Skyrangeru skutečně neproběhla.
