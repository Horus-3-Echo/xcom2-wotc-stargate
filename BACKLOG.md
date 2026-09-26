# Jediný backlog WotC

| ID | Stav | Úkol a podmínka dokončení |
| --- | --- | --- |
| WSG-000 | DONE | Založit startér, ověřit formáty a trvale uložit zdroje. |
| WSG-001 | BLOCKED | Zapsat verzi WotC, distribuci/OS a odpovídající SDK; čeká na instalaci uživatele. |
| WSG-002 | BLOCKED | Sestavit a načíst loader, doložit novou i načtenou kampaň; zdroj připraven, chybí SDK/hra. |
| WSG-003 | BLOCKED | Audit primárních zdrojů, build postup a kontrola výstupního balíčku připraveny (docs/BUILD-AUDIT.md); potvrzení kandidáta původním WotC SDK čeká na instalaci a T01. |
| WSG-004A | DONE | Cesta vlastní mise ze strategie, transport bez Skyrangeru, výsledek a ukládaný stav doloženy v docs/MISSION-PATH.md; jde o zdrojový audit bez buildu/hry. |
| WSG-004B | BLOCKED | Implementovat nejmenší vlastní misi podle 004A; čeká na WSG-002 a ověření konfigurace cílovým SDK. |
| WSG-005 | BLOCKED | Čtyřčlenná sestava a vstup/extrakce představující bránu; po 004B. |
| WSG-006 | BLOCKED | Artefakt, ústup, ztráta nosiče a výsledek mise; po 005. |
| WSG-007 | BLOCKED | Jednorázová odměna a uložení/načtení, T10–T13; po 006. |
| WSG-008A | DONE | Zdrojový audit Avenger/Avatar/příběh a přesný budoucí T14 v docs/CAMPAIGN-DEPENDENCIES.md; bez runtime změn, buildu a hry. |
| WSG-008B | BLOCKED | Izolovat vlastní source/callbacky a ověřit soužití s původní kampaní podle docs/CAMPAIGN-DEPENDENCIES.md; po loaderu a implementaci mise, T14 dosud NOT_RUN. |
| WSG-009A | DONE | Importní kontrakt StaticMesh/FBX/UPK a přesný T20 doloženy v docs/GATE-IMPORT.md; zdrojový audit, nikoli provedený import. |
| WSG-009B | BLOCKED | Provést import, doložit exportní profil, build a T20 podle docs/GATE-IMPORT.md; chybí SDK a funkční M1. |
| WSG-010 | BLOCKED | Reprodukovatelný testovací balíček první výpravy a instalace. |
| WSG-011 | BLOCKED | Vyhodnotit proveditelnost pozdější obrany Země; až po výsledku M1. |

Nezávislé READY úkoly jsou nyní vyčerpány. Další priorita: 001, následně
potvrzení buildu 003 a loader 002. Novou READY položku přidat jen při konkrétní
nové stopě nebo dostupném vstupu, ne opakováním již doložených auditů.
Jakmile je dostupný WotC SDK, mají přednost 001, ověření 003 a loader 002.
