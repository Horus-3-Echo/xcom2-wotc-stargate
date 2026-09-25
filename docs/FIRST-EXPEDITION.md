# M1 — ověřovací scénář první výpravy

Scénář SG-PROTOTYPE-01 používá existující mapu a dočasné vstupní/extrakční značky.
Připravená specifikace není implementace herní logiky.

1. Ze strategické vrstvy vyber přesně čtyři dostupné vojáky. Ulož jejich stabilní ID,
   vybavení, zásoby a zdraví v testovacím protokolu.
2. Spusť výpravu bez sestřelu UFO; herní adaptér musí určit konkrétní cestu nasazení.
3. Získej jeden artefakt. Úspěch vyžaduje návrat artefaktu a nejméně jednoho přeživšího.
4. Návrat bez artefaktu je ústup bez odměny. Ztráta celého týmu je neúspěch.
   Ztráta nosiče artefaktu sama nesmí udělit odměnu; vyzvednutí musí mít herní důkaz.
5. Přenes pouze skutečně navrácené vojáky, jejich zranění, vybavení a spotřebu.
6. Odměnu přiznej jednou pro stabilní ID výpravy, odemkni testovací výzkum/adresu.
   Opakované zpracování téhož výsledku nesmí vytvářet další kopie předmětu či odměny.
7. Ulož a načti stav před odletem, v misi před i po získání artefaktu a po návratu.
8. Ověř, že původní kampaň v úvodní fázi nespouští neřešitelný časový tlak.

Každý pokus zaznamená verzi hry a módu, scénář, postup, výsledek a log/save.
Implementace musí respektovat ukládání daného enginu. Nesdílet mezi hrami runtime kód.
