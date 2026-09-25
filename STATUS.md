# Stav — XCOM 2: War of the Chosen

Aktualizováno: 2026-09-25, Europe/Prague.
Fáze: M0, příprava načtení módu. Zdrojový startér: 0.1.0.
Ruční zaváděcí běhy: 1. Dokončené plánované běhy: 0. Běhy bez pokroku: 0.
Ruční migrace na GitHub se do plánovaných běhů nepočítá.

- Připraveno: samostatný projekt, loader s logováním, konfigurace a testovací scénář.
- Statická kontrola T00: PASS, python tools/check_source.py, exit code 0; viz reports/2026-09-25-bootstrap.md.
- Kompilace T01: NOT_RUN, hra/SDK a kompilátor nejsou v pracovním prostředí.
- Hra T02–T04: NOT_RUN. Testovaná verze hry: nezjištěna.
- Herní výprava T10–T14: neimplementována.
- GitHub: `Horus-3-Echo/xcom2-wotc-stargate`, větev `main`, je pracovní autorita.
  Importována poslední verze zdrojového ZIPu v0.
  Záznam migrace: reports/2026-09-25-github-migration.md.

Nejbližší práce bez instalace: WSG-004A, dohledání a zapsání konkrétní
cesty ke spuštění vlastní mise v primárních zdrojích.
Vstup od uživatele: verze hry, platforma/větev, operační systém a dostupnost SDK.
