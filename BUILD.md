# Sestavení a první test WotC

Zdrojový kandidát nebyl kompilován. Je určen pro XCOM 2: War of the Chosen,
nikoli pro základní XCOM 2 nebo Enemy Unknown.

1. Zapiš build hry, distribuci, OS a verzi odpovídajícího WotC SDK.
2. Ve WotC ModBuddy otevři StargateWOTC.XCOM_sln. Ověř cesty SDK a WotC hry
   v konfiguraci svého prostředí. Projekt importuje SDK XCOM2.targets.
3. Zkus Debug build a uchovej celý log. Pokud SDK odmítne formát projektu,
   porovnej ho s prázdným projektem vytvořeným stejnou verzí ModBuddy;
   zdroj a registrace jsou připravené, formát projektu ještě čeká na ověření.
4. Zkontroluj skutečný výstup: balíček skriptů StargateWOTC, konfigurace,
   registrace DLC a vygenerovaný descriptor .XComMod určený pro WotC
   (RequiresXPACK=true). Do dalšího testu pokračuj jen s úspěšným buildem.
5. Povol mód, spusť novou testovací kampaň. V herním logu očekávej
   `[WSG] templates-ready version=0.1.0` a `[WSG] new-campaign`.
6. Ulož strategickou pozici a načti ji přímo do strategie. Očekávej
   `[WSG] strategy-save-loaded`. Dolož log a případné chyby loaderu.

T00 bez hry: `python tools/check_source.py`. Nekompiluje UnrealScript.
Aktuální loader používá základní DLC lifecycle; Highlander není deklarovaný
runtime požadavek tohoto pokusu. Pokud další funkce využije jeho rozšíření,
závislost se musí výslovně přidat a otestovat.

Pro pozdější opakovatelné sestavení lze připojit X2ModBuildCommon podle jeho
README a uzamknout konkrétní revizi. Zatím není stažen ani integrován.
Automatické publikování a vlastní letecký boj nejsou součást tohoto startéru.
