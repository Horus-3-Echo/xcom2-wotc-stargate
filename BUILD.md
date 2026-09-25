# Sestavení a první test WotC

Zdrojový kandidát 0.1.0 nebyl kompilován. Cíl je pouze XCOM 2: War of the Chosen.
Audit WSG-003 a neměnné odkazy: [docs/BUILD-AUDIT.md](docs/BUILD-AUDIT.md).

## Původní WotC ModBuddy — aktuální cesta

1. Zapiš verzi/build WotC, distribuci, OS, verzi a větev WotC SDK do místní
   kopie environment.example.json. Lokální cesty ani SDK necommituj.
2. Použij ModBuddy z WotC SDK a otevři StargateWOTC.XCOM_sln.
   Nastav vlastní skutečné cesty WotC SDK/hry; ne základní XCOM 2.
   Projekt importuje původní `$(MSBuildLocalExtensionPath)/XCOM2.targets`.
   Název platformy `XCOM 2` v řešení je doložen i ve WotC projektu:
   sám o sobě neurčuje edici hry. Rozhoduje také použitý SDK/toolchain.
3. Vyber Debug a Build Solution. Ulož celý text build výstupu, verze prostředí,
   revizi zdrojů a výsledek kompilátoru. Pokud projekt nelze načíst/sestavit,
   vytvoř vedle něj prázdný projekt ve stejném WotC ModBuddy a porovnej
   jeho .x2proj, .XCOM_sln a import targets. Kandidáta neopravuj odhadem.
   Přesný původní WotC XCOM2.targets zde není dostupný.
4. Ze skutečného build logu zjisti výstupní adresář módu.
   Spusť `python tools/check_package.py "<výstupní adresář StargateWOTC>"`.
   Požaduj descriptor StargateWOTC.XComMod s [mod], Title=StargateWOTC,
   publishedFileId=0 a RequiresXPACK=true, tři registrační INI a neprázdný
   Script/StargateWOTC.u. Kontrola nic nepřepisuje ani neopravuje.
   Je to kontrola uspořádání, nikoli důkaz platného bytecode či úspěšného buildu.
   T01 PASS vyžaduje zvlášť úspěšný čerstvý build log; starý .u soubor nestačí.
   Descriptor ručně nepřidávej do zdrojů jako náhražku opravy build cesty.
5. Teprve po T01 PASS povol mód ve WotC a spusť novou testovací kampaň.
   Očekávaný herní log: `[WSG] templates-ready version=0.1.0`
   a `[WSG] new-campaign`, bez chyb načtení loaderu.
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
