# Pravidla vývoje

- Pracuj pouze v tomto projektu. Druhý mód má vlastní zdroje, stav a testy.
- Na začátku čti README.md, BUILD.md, STATUS.md, BACKLOG.md, DECISIONS.md,
  docs/BRIEF.md a nové protokoly v reports/. Pokračuj v rozpracovaném úkolu.
- Udělej jeden omezený, proveditelný krok nejvyšší priority. Vytvoř skutečnou
  změnu, ověřený technický nález nebo konkrétní testovací podklad.
- API a souborové formáty ověřuj v primárních zdrojích a cílové verzi hry.
  Nezaměňuj existující hook za důkaz funkční celé herní smyčky.
- Rozlišuj připravený zdroj, statickou kontrolu, kompilaci a test ve hře.
  Herní úkol může být DONE pouze s příslušným herním důkazem.
- Stavy: READY, IN_PROGRESS, NEEDS_GAME_TEST, DONE, BLOCKED. Úkol čekající
  na kompilaci bez SDK je BLOCKED, nikoli NEEDS_GAME_TEST.
- Pokud chybí hra, pokračuj v nezávislé práci s jasným přínosem: dohledání hooku,
  implementace ověřeného rozhraní, příprava konkrétního testu nebo importního postupu.
  Nerozmnožuj obecné plány. Stejnou blokaci nezkoumej znovu bez nové stopy.
- Po třech bězích bez pokroku popiš přesně chybějící vstup a navrhni pozastavení.
  Neměň sám rozvrh, platformu ani společné zadání.
- Jedinou pracovní autoritou je GitHub `Horus-3-Echo/xcom2-wotc-stargate`, větev `main`.
  Na začátku načti aktuální vzdálený commit a pracuj z něj. Starý místní adresář
  ani původní zdrojový ZIP nejsou aktuální zdroj pravdy; ZIP je archiv migrace.
- Aktualizuj STATUS.md a BACKLOG.md, významná rozhodnutí v DECISIONS.md,
  a reports/YYYY-MM-DD-NNN.md. Denní počet běhů zvýš až při úspěšném uložení;
  zaváděcí ruční běh se do deseti plánovaných běhů nepočítá.
- Při konfliktu verzí načti nový stav a sluč vlastní změny. Nepřepisuj cizí pokrok.
- Ulož změny jedním commitem na `main`; před zápisem ověř aktuální vzdálený stav.
  Při souběžné změně nejprve sluč vlastní práci, nikdy nepoužívej force push.
  Pokrok hlásit až po potvrzeném zápisu a s odkazem na commit.
  Nevytvářej druhou současně zapisovanou autoritu. Veřejné vydání teď není úkol.
- Nespouštěj další agenty bez výslovného zadání uživatele.
