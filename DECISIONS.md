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
