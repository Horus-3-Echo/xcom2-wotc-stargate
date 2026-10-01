# Jediný backlog WotC

| ID | Stav | Úkol a podmínka dokončení |
| --- | --- | --- |
| WSG-000 | DONE | Založit startér, ověřit formáty a trvale uložit zdroje. |
| WSG-001 | DONE | Cílové prostředí identifikováno: Windows 11 Pro, Steam stable WotC, Version 8917 / FxsChangelist 469133, funkční původní WotC SDK u uživatele. Přesný Steam build ID / revize SDK nezjištěny; viz reports/2026-10-01-001.md. |
| WSG-002 | DONE | Loader 0.1.0 sestaven, načten ve hře; nová kampaň, návrat na Avenger a dva loady doloženy. T01–T04 PASS; reports/2026-10-01-001.md. |
| WSG-003 | DONE | Původní WotC SDK provedlo rebuild Default XCOM 2; 0 chyb, 8 DLC varování. Descriptor, registrace a skript dodaného balíčku ověřeny; reports/2026-10-01-001.md. |
| WSG-004A | DONE | Cesta vlastní mise ze strategie, transport bez Skyrangeru, výsledek a ukládaný stav doloženy v docs/MISSION-PATH.md; jde o zdrojový audit bez buildu/hry. |
| WSG-004B | BLOCKED | Zdrojový kandidát 0.2.0 implementuje vlastní source, jednorázový persisted guard, factory `MissionSite`, mapu `Reward_None -> SupplyLineRaid` a přímé cestování. T00 a 13 regresních testů PASS; kontrola balíčku vyžaduje i přesné mission-source mapování. Chybí nový build původním WotC SDK a herní T05 podle BUILD.md. PASS loaderu 0.1.0 nedokládá funkční misi. |
| WSG-005 | BLOCKED | Čtyřčlenná sestava a vstup/extrakce představující bránu; po 004B. |
| WSG-006 | BLOCKED | Artefakt, ústup, ztráta nosiče a výsledek mise; po 005. |
| WSG-007 | BLOCKED | Jednorázová odměna a uložení/načtení, T10–T13; po 006. |
| WSG-008A | DONE | Zdrojový audit Avenger/Avatar/příběh a přesný budoucí T14 v docs/CAMPAIGN-DEPENDENCIES.md; bez runtime změn, buildu a hry. |
| WSG-008B | BLOCKED | Izolovat vlastní source/callbacky a ověřit soužití s původní kampaní podle docs/CAMPAIGN-DEPENDENCIES.md; po loaderu a implementaci mise, T14 dosud NOT_RUN. |
| WSG-009A | DONE | Importní kontrakt StaticMesh/FBX/UPK a přesný T20 doloženy v docs/GATE-IMPORT.md; zdrojový audit, nikoli provedený import. |
| WSG-009B | BLOCKED | Provést import, doložit exportní profil, build a T20 podle docs/GATE-IMPORT.md; SDK je u uživatele dostupné, chybí provedený import a funkční M1. |
| WSG-010 | BLOCKED | Reprodukovatelný testovací balíček první výpravy a instalace. |
| WSG-011 | BLOCKED | Vyhodnotit proveditelnost pozdější obrany Země; až po výsledku M1. |

Další priorita: odblokovat WSG-004B čerstvým buildem kandidáta 0.2.0 a T05.
SDK/hra běží u uživatele; cloudový běh nesmí tvrdit nový build/herní PASS bez
nových protokolů.
Ruční přejímka 2026-10-01 se nepočítá jako plánovaný vývojový běh.
