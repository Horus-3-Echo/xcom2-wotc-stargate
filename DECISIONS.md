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
