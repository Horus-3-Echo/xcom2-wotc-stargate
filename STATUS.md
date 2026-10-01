# Stav — XCOM 2: War of the Chosen

Aktualizováno: 2026-10-02, Europe/Prague.
Fáze: M1 zdrojový kandidát 0.2.2 opravuje T05 UI; čeká na build a retest.
Ruční zaváděcí běhy: 1. Dokončené plánované běhy: 8. Běhy bez pokroku: 0.
Ruční migrace na GitHub se do plánovaných běhů nepočítá.

- Připraveno: loader, vlastní `MissionSource_StargatePrototype`, ukládaný
  jednorázový guard, factory jedné neexpirující `MissionSite`, mapování
  `Reward_None -> SupplyLineRaid`, vlastní klikací MissionSite, migrace 0.2.1,
  preference kontaktovaného regionu, předstartovní diagnostika a přesný T05.
- Statická kontrola T00 a T00-MISSION: PASS v reports/2026-10-01-002.md.
  Ověřuje jen strukturu, zahrnutí tříd, mapování a požadované zdrojové vazby.
  Třináct syntetických testů kontroly balíčku PASS; od
  reports/2026-10-01-003.md kontrola odmítne i chybějící nebo nesprávné
  `XComMissionSources.ini`.
- Kontrola nového importního podkladu: názvy voleb a SHA primárních zdrojů,
  XML ukázka, JSON protokol a lokální odkazy PASS; není to import/build.
- Kompilace T01 loaderu 0.1.0: PASS, uživatelský rebuild původním WotC SDK 2026-09-30,
  Default XCOM 2, 0 chyb / 8 varování; kontrola dodaného balíčku PASS.
- Kompilace 0.2.1: PASS u uživatele; mod compiler 0 chyb / 8 varování.
  Dodaný balíček prošel kontrolou a hra načetla verzi 0.2.1; viz report 005.
- Kompilace 0.2.2: NOT_RUN; zdrojová oprava potřebuje čerstvý uživatelský build.
- Hra T02–T04 loaderu 0.1.0: PASS, uživatelské logy 2026-10-01 a potvrzení bez problémů.
  Načtení loaderu, nová kampaň/Gatecrasher/návrat a dva strategické loady.
- Prostředí: Windows 11 Pro, Steam stabilní větev, WotC se všemi DLC (uživatel).
  Log: Version 8917, FxsChangelist 469133, Compiled Feb 22 2022.
  Steam build ID a přesná samostatná revize SDK nebyly dodány.
- Důkazy a limity: reports/2026-10-01-001.md. Jde o ruční ověření,
  při tehdejší ruční přejímce se počet plánovaných běhů nezvýšil (zůstal 4).
- T05 mise 0.2.1: FAIL na otevření mise. Vytvoření PASS: id=1807,
  type=SupplyRaidATT. Uživatel vidí značku, kliknutí neotevře nabídku.
  Start/návrat a ochrana proti duplikaci po dvou loadech zatím NOT_RUN.
  Kandidát 0.2.2 je staticky zkontrolován; jeho nový T05 je NOT_RUN.
  Artefaktová výprava T10–T14 není implementována.
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

WSG-004B: BLOCKED po přípravě zdrojové opravy 0.2.2. `UpdateDLC`
čeká na plný geoscape a mimo let/popup jednou vytvoří misi. Ukládaný
`XComGameState_StargateProgram` brání duplikaci i po dokončení a loadu;
vlastní source vypíná Skyranger travel a nepřebírá příběhové callbacky
Supply Raid. `OnPreMission` nově loguje ID, neprázdné členy `XComHQ.Squad`,
režim transportu a typ mise. Statická kontrola a zpřísněná přejímka balíčku
PASS; build 0.2.1 i runtime vytvoření potvrzeny, T05 selhal v UI.
Oprava: `XComGameState_MissionSite_Stargate.MissionSelected` volá zděděné
`SelectSquad` přímo. Factory rozpozná starou základní misi, v jednom change
state ji odstraní, vytvoří novou podtřídu s novým `Reward_None`, aktualizuje
uloženou referenci a preferuje region s navázaným kontaktem. Build 0.2.2
a nový T05 jsou NOT_RUN; WSG-004B proto není DONE ani NEEDS_GAME_TEST.

WSG-008A: DONE jako zdrojový audit, viz docs/CAMPAIGN-DEPENDENCIES.md.
Doloženy obecné události spouštějící tutorial, Avatar pending efekty při návratu,
restart generování Doom a samostatný odpočet porážky. První M1 zachová
infrastrukturu HQ a původní kampaň; vlastní mise oddělí source/callbacky.
Budoucí T14 má přesný postup, zůstává NOT_RUN; WSG-008B je BLOCKED.

WSG-009A: DONE jako importní kontrakt, docs/GATE-IMPORT.md. Doloženy
FBX StaticMesh volby, actor/component a UPK v projektu. Přesná podporovaná
verze FBX zůstává neověřená do zkušebního importu cílovým editorem.
WSG-009B BLOCKED na importu a M1; SDK je u uživatele dostupné, T20 NOT_RUN. Model ani UPK dosud nevznikly.

Další priorita: čerstvý build kandidáta 0.2.2 a nový T05 podle BUILD.md.
Neopakovat 0.2.1; uživatel již doložil její build i přesnou UI chybu.
Retest má přednostně načíst uloženou neklikatelnou misi, ověřit jediný migrační
marker, kontaktovaný region, kliknutí do squad selectu, dva loady bez duplikace,
přímý start, návrat a stav po návratu.
SDK/hra zůstávají na počítači uživatele. WSG-001/002/003 DONE beze změny,
T10–T14/T20 NOT_RUN. Ruční zápis testu počet nezvýšil; tento uložený běh je osmý.
