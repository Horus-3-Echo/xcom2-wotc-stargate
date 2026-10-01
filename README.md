# Stargate — XCOM 2: War of the Chosen

Loader 0.1.0 byl 2026-09-30 sestaven a 2026-10-01 ověřen ve WotC (T01–T04 PASS).
Důkazy a omezení: reports/2026-10-01-001.md. Zdrojový kandidát 0.2.1 přidává
jednorázově nabídnutou prototypovou misi s přímým přechodem bez Skyrangeru,
uložený guard a předstartovní diagnostiku T05, ale dosud nebyl sestaven ani
spuštěn. Nejde ještě o Stargate výpravu s
artefaktem, bránou nebo trvalou odměnou.

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
