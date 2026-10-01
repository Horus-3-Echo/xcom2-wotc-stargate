# Stav — XCOM 2: War of the Chosen

Aktualizováno: 2026-10-01, Europe/Prague.
Fáze: M0 loader 0.1.0 sestaven a ověřen ve hře; další krok M1.
Ruční zaváděcí běhy: 1. Dokončené plánované běhy: 4. Běhy bez pokroku: 0.
Ruční migrace na GitHub se do plánovaných běhů nepočítá.

- Připraveno: samostatný projekt, loader s logováním, konfigurace a testovací scénář.
- Statická kontrola T00: poslední PASS v reports/2026-09-26-001.md,
  pouze struktura zdrojů. Runtime zdroje/build konfigurace se nezměnily;
  T00 ani dřívějších 11 syntetických testů nebylo v tomto běhu opakováno.
- Kontrola nového importního podkladu: názvy voleb a SHA primárních zdrojů,
  XML ukázka, JSON protokol a lokální odkazy PASS; není to import/build.
- Kompilace T01: PASS, uživatelský rebuild původním WotC SDK 2026-09-30,
  Default XCOM 2, 0 chyb / 8 varování; kontrola dodaného balíčku PASS.
- Hra T02–T04: PASS, uživatelské logy 2026-10-01 a potvrzení bez problémů.
  Načtení loaderu, nová kampaň/Gatecrasher/návrat a dva strategické loady.
- Prostředí: Windows 11 Pro, Steam stabilní větev, WotC se všemi DLC (uživatel).
  Log: Version 8917, FxsChangelist 469133, Compiled Feb 22 2022.
  Steam build ID a přesná samostatná revize SDK nebyly dodány.
- Důkazy a limity: reports/2026-10-01-001.md. Jde o ruční ověření,
  počet dokončených plánovaných běhů zůstává 4; T00 nebyl znovu spouštěn.
- Herní výprava T10–T14: neimplementována.
- GitHub: `Horus-3-Echo/xcom2-wotc-stargate`, větev `main`, je pracovní autorita.
  Záznam migrace: reports/2026-09-25-github-migration.md.

WSG-003: audit formátu/importu a výstupního balíčku připraven, viz
docs/BUILD-AUDIT.md. Potvrzení sestavení loaderu původním WotC SDK je PASS; WSG-003 DONE.

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

WSG-009A: DONE jako importní kontrakt, docs/GATE-IMPORT.md. Doloženy
FBX StaticMesh volby, actor/component a UPK v projektu. Přesná podporovaná
verze FBX zůstává neověřená do zkušebního importu cílovým editorem.
WSG-009B BLOCKED na importu a M1; SDK je u uživatele dostupné, T20 NOT_RUN. Model ani UPK dosud nevznikly.

Další priorita: WSG-004B READY — implementovat nejmenší vlastní misi podle
docs/MISSION-PATH.md a přijatých rozhodnutí. WSG-001/002/003 DONE v rozsahu
identifikace cílového prostředí a otestovaného loaderu; přesný Steam build ID/SDK
revize zůstávají mezerou reprodukovatelnosti, nikoli blokací zdrojové implementace.
SDK a hra jsou dostupné na počítači uživatele, nikoli automaticky plánovanému
cloudovému běhu. Nové runtime změny vyžadují nový uživatelský build a test;
nepřebírat PASS loaderu na budoucí misi, grafiku nebo odměny.
T10–T14 a T20 zůstávají NOT_RUN. Tento zápis není plánovaný vývojový běh.
