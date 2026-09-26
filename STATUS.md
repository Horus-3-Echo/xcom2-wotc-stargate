# Stav — XCOM 2: War of the Chosen

Aktualizováno: 2026-09-26, Europe/Prague.
Fáze: M0, příprava načtení módu. Zdrojový startér: 0.1.0.
Ruční zaváděcí běhy: 1. Dokončené plánované běhy: 3. Běhy bez pokroku: 0.
Ruční migrace na GitHub se do plánovaných běhů nepočítá.

- Připraveno: samostatný projekt, loader s logováním, konfigurace a testovací scénář.
- Statická kontrola T00: PASS dne 2026-09-26, pouze struktura zdrojů.
  Zdrojový kód se nezměnil. Předchozích 11 syntetických testů kontroly balíčku
  PASS (reports/2026-09-25-001.md); v tomto běhu nebyly opakovány.
- Kompilace T01: NOT_RUN, hra/SDK a kompilátor nejsou v pracovním prostředí.
- Hra T02–T04: NOT_RUN. Testovaná verze hry: nezjištěna.
- Herní výprava T10–T14: neimplementována.
- GitHub: `Horus-3-Echo/xcom2-wotc-stargate`, větev `main`, je pracovní autorita.
  Záznam migrace: reports/2026-09-25-github-migration.md.

WSG-003: audit formátu/importu a výstupního balíčku připraven, viz
docs/BUILD-AUDIT.md. Potvrzení původním WotC SDK je BLOCKED.

WSG-004A: DONE jako zdrojový audit, viz docs/MISSION-PATH.md. Doložena cesta
`X2MissionSourceTemplate -> XComGameState_MissionSite -> SelectSquad ->
ConfirmMission -> LaunchTacticalBattle -> BattleData -> ProcessMissionResults`.
`bRequiresSkyrangerTravel=false` zachová běžnou misi, ale přeskočí let
Skyrangeru; standardní návrat přenáší vojáky, zranění a vybavení.
Nejde o sestavenou nebo ve hře ověřenou expedici.

WSG-008A: DONE jako zdrojový audit, viz docs/CAMPAIGN-DEPENDENCIES.md.
Doloženy obecné události spouštějící tutorial, Avatar pending efekty při návratu,
restart generování Doom a samostatný odpočet porážky. První M1 zachová
infrastrukturu HQ a původní kampaň; vlastní mise oddělí source/callbacky.
Budoucí T14 má přesný postup, zůstává NOT_RUN; WSG-008B je BLOCKED.

Nejbližší práce bez instalace: WSG-009A, ověřený importní postup brány. Po zpřístupnění SDK mají přednost WSG-001, potvrzení
WSG-003 a loader WSG-002.
Vstup od uživatele: verze hry, platforma/větev, operační systém a dostupnost SDK.
