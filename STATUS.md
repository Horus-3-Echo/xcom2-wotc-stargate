# Stav — XCOM 2: War of the Chosen

Aktualizováno: 2026-09-26, Europe/Prague.
Fáze: M0, příprava načtení módu. Zdrojový startér: 0.1.0.
Ruční zaváděcí běhy: 1. Dokončené plánované běhy: 4. Běhy bez pokroku: 0.
Ruční migrace na GitHub se do plánovaných běhů nepočítá.

- Připraveno: samostatný projekt, loader s logováním, konfigurace a testovací scénář.
- Statická kontrola T00: poslední PASS v reports/2026-09-26-001.md,
  pouze struktura zdrojů. Runtime zdroje/build konfigurace se nezměnily;
  T00 ani dřívějších 11 syntetických testů nebylo v tomto běhu opakováno.
- Kontrola nového importního podkladu: názvy voleb a SHA primárních zdrojů,
  XML ukázka, JSON protokol a lokální odkazy PASS; není to import/build.
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

WSG-009A: DONE jako importní kontrakt, docs/GATE-IMPORT.md. Doloženy
FBX StaticMesh volby, actor/component a UPK v projektu. Přesná podporovaná
verze FBX zůstává neověřená do zkušebního importu cílovým editorem.
WSG-009B BLOCKED; T20 NOT_RUN. Model ani UPK dosud nevznikly.

Nezávislé READY úkoly jsou vyčerpány. Další priorita WSG-001: dodat verzi
WotC, distribuci/větev, OS a verzi/dostupnost odpovídajícího SDK.
Poté provést BUILD.md a dodat celý build log pro WSG-003/002. Bez cílového
prostředí nelze ověřit kompilaci, import ani běh hry. Stačí údaje a protokoly,
nikoli nahrávání herních DLL/SDK. Tento běh přinesl nový nález; bez pokroku 0.
Rozvrh ani aktivní stav úlohy se tímto záznamem nemění.
