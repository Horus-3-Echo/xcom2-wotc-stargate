# Sestavení a první test WotC

Loader 0.1.0 byl sestaven původním SDK a ověřen ve hře; viz
[ruční přejímka T01–T04](reports/2026-10-01-001.md). Cíl je pouze XCOM 2: War of the Chosen.
Audit WSG-003 a neměnné odkazy: [docs/BUILD-AUDIT.md](docs/BUILD-AUDIT.md).

## Původní WotC ModBuddy — aktuální cesta

1. Zapiš verzi/build WotC, distribuci, OS, verzi a větev WotC SDK do místní
   kopie environment.example.json. Lokální cesty ani SDK necommituj.
2. Použij ModBuddy z WotC SDK a otevři StargateWOTC.XCOM_sln.
   Nastav vlastní skutečné cesty WotC SDK/hry; ne základní XCOM 2.
   Projekt importuje původní `$(MSBuildLocalExtensionPath)/XCOM2.targets`.
   Název platformy `XCOM 2` v řešení je doložen i ve WotC projektu:
   sám o sobě neurčuje edici hry. Rozhoduje také použitý SDK/toolchain.
3. Ověřená konfigurace je `Default XCOM 2`; použij Rebuild Solution.
   Pro důkaz nastav Tools → Options → Projects and Solutions → Build and Run →
   MSBuild project build output verbosity na Detailed. Ulož celý text build výstupu, verze prostředí,
   revizi zdrojů a výsledek kompilátoru. Pokud projekt nelze načíst/sestavit,
   vytvoř vedle něj prázdný projekt ve stejném WotC ModBuddy a porovnej
   jeho .x2proj, .XCOM_sln a import targets. Kandidáta neopravuj odhadem.
   Přesný původní WotC XCOM2.targets zde není dostupný.
4. Ze skutečného build logu zjisti výstupní adresář módu.
   Spusť `python tools/check_package.py "<výstupní adresář StargateWOTC>"`.
   Požaduj descriptor StargateWOTC.XComMod s [mod], Title=StargateWOTC,
   publishedFileId=0 a RequiresXPACK=true, tři registrační INI,
   `Config/XComMissionSources.ini` s přesným mapováním
   `MissionSource_StargatePrototype + Reward_None -> SupplyLineRaid` a
   neprázdný `Script/StargateWOTC.u`. Kontrola nic nepřepisuje ani neopravuje.
   Je to kontrola uspořádání, nikoli důkaz platného bytecode či úspěšného buildu.
   T01 PASS vyžaduje zvlášť úspěšný čerstvý build log; starý .u soubor nestačí.
   Descriptor ručně nepřidávej do zdrojů jako náhražku opravy build cesty.
5. Teprve po T01 PASS povol mód ve WotC a spusť novou testovací kampaň.
   Očekávaný herní log: `[WSG] templates-ready version=0.1.0`
   a `[WSG] new-campaign`, bez chyb načtení loaderu. Samotné `new-campaign`
   není důkaz nové hratelné kampaně: naměřeno i během inicializace menu.
   T03 dolož také přechodem do úvodní mise a návratem na Avenger.
6. Ulož strategickou pozici, načti ji přímo do strategie, zopakuj načtení.
   Při každém návratu do strategie očekávej `[WSG] strategy-save-loaded`.
   Není to test jednorázového OnLoadedSavedGame ani důkaz uložené expedice.
   Dodej celý herní log, seznam povolených módů, build log a výstup kontroly
   balíčku; screenshot chyby při neúspěchu. Citlivé lokální údaje před sdílením rediguj.

## Dostupné kontroly bez SDK

- `python tools/check_source.py` — T00, jen struktura XML/INI/řešení.
- `python -m unittest discover -s tools -p "test_*.py" -v` — syntetické
  testy kontroly balíčku. Fiktivní .u v testu není sestavený herní soubor.
- `python tools/check_package.py StargateWOTC` musí skončit chybou:
  zdrojový adresář nemá descriptor ani kompilovaný skript.

X2ModBuildCommon není integrován. Jeho doložená revize a odlišné nastavení jsou
v auditu; nepřebírat jeho targets bez odpovídajícího build.ps1 a nástrojů.
Highlander není runtime požadavek loaderu. Žádné veřejné publikování,
automatické nahrávání ani vlastní letecký boj se neprovádí.

## T05 — opravená prototypová mise 0.2.2

Verze 0.2.1 se sestavila a vytvořila misi, ale kliknutí neotevřelo UI; viz
reports/2026-10-01-005.md. Kandidát 0.2.2 přidává vlastní podtřídu MissionSite,
přímý dispatch do zděděného `SelectSquad`, migraci uložené základní mise a
umístění do kontaktovaného regionu. Níže je nový test, nikoli potvrzení opravy.

Tento postup použij až po čerstvém úspěšném Rebuild Solution přesné revize 0.2.2:

1. Ulož celý Detailed build log a spusť
   `python tools/check_package.py "<výstupní adresář StargateWOTC>"`.
   Očekávání: 0 chyb kompilátoru, PASS kontroly balíčku včetně mission-source
   mapování a nový `Script/StargateWOTC.u`. Balíček 0.2.1 nestačí.
2. Povol sestavený lokální mód ve WotC. Přednostně načti save
   `WSG-021-neklikatelna`, pokud skutečně existuje; jinak použij zachovaný
   post-Gatecrasher save před vytvořením mise. Otevři glóbus a nech proběhnout
   geoscape tick. Pro starý save očekávej právě jeden řádek
   `[WSG] prototype-mission-migrated old=1807 new=<n> region=<n> type=<typ>`;
   pro čistý save právě jeden `prototype-mission-created`. Na glóbu musí být
   jediná značka `STARGATE PROTOTYPE` v již kontaktovaném regionu.
3. Klikni na značku. Očekávej `[WSG] prototype-mission-selected id=<n>` a
   otevření squad selectu. Ponech čtyřčlennou sestavu rané kampaně a pošli
   screenshot glóbu před kliknutím i otevřeného squad selectu.
4. Ulož strategii před startem, dvakrát ji přímo načti a pokaždé zkontroluj
   glóbus. Očekávání: stále jedna klikatelná značka; žádný další
   `prototype-mission-created` ani `prototype-mission-migrated`.
5. Potvrď start. Očekávej právě jeden řádek
   `[WSG] prototype-mission-launch id=<n> squad=4 travel=direct type=<typ>`
   těsně před taktickým loadem a pozorováním potvrď, že neproběhla
   animace/let Skyrangeru. Log dokládá stav source a squad v `OnPreMission`,
   nikoli sám o sobě obrazovou sekvenci. Dokonči nebo prohraj vestavěný cíl
   Supply Raid a vrať se na Avenger.
6. Očekávání návratu: standardní post-mission obrazovky a právě jeden řádek
   `[WSG] prototype-mission-result=success|failure id=<n>`. Po návratu save
   znovu načti; mise se nesmí znovu objevit. Dodej celý `Launch.log`, celý
   build log, výstup kontroly balíčku a uvedené screenshoty. Při pádu přidej
   screenshot chyby a uveď poslední úspěšný krok.

T05 dokládá pouze obal vlastní mise a standardní návrat. Nedokládá artefakt,
vstupní/extrakční bránu, vlastní planetu ani jednorázovou trvalou odměnu.
