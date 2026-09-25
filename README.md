# Stargate — XCOM 2: War of the Chosen

Zdrojový startér 0.1.0, připravený 2026-09-25. Není to sestavený ani hratelný mód.
Obsahuje první kód pro záznam načtení módu a životního cyklu hry, soubory
projektu, backlog a testovací postup. Herní výprava ještě není implementovaná.

Začni v BUILD.md. Dostupná kontrola bez hry: `python tools/check_source.py`.
Průběžný stav je v STATUS.md, jediný pracovní backlog v BACKLOG.md.
Cílem je čtyřčlenný tým → planeta → artefakt → návrat → trvalá odměna.

Projekt je oddělený od druhé varianty módu. Sdílí pouze zadání v1.
Pracovní autoritou je [Horus-3-Echo/xcom2-wotc-stargate](https://github.com/Horus-3-Echo/xcom2-wotc-stargate), větev `main`.
Zdrojový ZIP byl 2026-09-25 převeden do repozitáře.
Původní ZIP zůstává archivem migrace; další vývoj se ukládá pouze do GitHubu.
Repozitář obsahuje zdroje, žádné herní knihovny, SDK ani sestavené binární soubory.

Nejdříve doplň verzi hry, distribuční platformu, větev a dostupnost SDK do
environment.example.json (pracovní kopie environment.local.json).
Cesty ke hře se nesmí odvozovat z ukázky jiné instalace.
