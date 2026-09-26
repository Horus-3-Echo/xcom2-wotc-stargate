# WSG-009A — import jednoduché brány do WotC

Ověřeno ve zdrojích 2026-09-26. Vstupní main:
`0c567739ce69d60894175e5742bd3a82a206f0e1`.
WSG-009A dodává importní kontrakt a vykonatelný ověřovací postup.
Žádný FBX ani UPK zatím nebyl importován, sestaven nebo zobrazen ve hře.
WSG-009B zůstává BLOCKED na SDK a funkčním M1.

## Rozsah a doložené rozhraní

První vlastní model bude statický dekorativní kruh bez animace a bez
samostatné herní logiky. Vstup/extrakci nadále představuje oblast z WSG-005;
viditelný model tuto mechaniku nevytváří. To odpovídá docs/BRIEF.md v1:
grafika přijde až po ověření výpravy.

| Doložený typ / člen | Význam pro import |
| --- | --- |
| `FbxImportUI.MeshTypeToImport`, `FBXIT_StaticMesh` | Editor má samostatnou větev pro statický FBX mesh. [S1] |
| `bOverrideFullName` | Použití zadaného jména je doloženo pro scénu s jediným meshem. [S1] |
| `bCombineMeshes` | Sloučí více meshů do jednoho; pro první import je zbytečné mít více render meshů. [S1] |
| `bImportMeshLODs`, `bExplicitNormals`, `bOverrideTangents` | Volby LOD, explicitních normál a tečen; výsledek je nutné zaznamenat, nespoléhat na uložené uživatelské nastavení. [S1] |
| `bImportMaterials`, `bImportTextures` | Při importu materiálů se importují i textury, bez ohledu na samostatnou volbu textur. [S1] |
| `bOneConvexHullPerUCX` | Vytváří jeden konvexní obal na UCX_ kolizní mesh; není příslibem zachování otvoru konkávního kruhu. [S1] |
| `ActorFactoryStaticMesh` | Obsahuje StaticMesh a DrawScale3D; nabídka Add StaticMesh vytváří Engine.StaticMeshActor. [S2] |
| `StaticMeshActor.StaticMeshComponent` | Komponenta je současně CollisionComponent. Poznámka třídy upozorňuje, že PostBeginPlay a SetInitialState se u těchto actorů nevolají. [S3] |
| `StaticMeshComponent.SetStaticMesh(StaticMesh NewMesh, optional bool bForce)` | Nativní setter existuje; jeho existence neřeší uložení, extrakci ani taktickou navigaci. Výchozí BlockActors/BlockZeroExtent/BlockNonZeroExtent/BlockRigidBody jsou true. [S4] |

Jde o kód veřejného zrcadla WotC SDK, ne o test zde nedostupného editoru.
Nativní implementace FBX parseru není v načteném FbxImportUI.uc:
**podporovaná verze FBX ani konkrétní nastavení exportéru zde nejsou prokázány**.
Nevyvozovat je z návodů UE4/UE5 nebo z jiného XCOM.
Vlastnosti tabulky jsou interní názvy; popisky v konkrétním editoru mohou mít
mezery či jiné zobrazení.

## Postup v cílovém editoru

1. Nejprve dolož WotC prostředí a loader podle BUILD.md. Použij UnrealEd
   dodaný s odpovídajícím WotC SDK. Zapiš jeho build, verzi modelovacího
   programu/exportéru a nastavení exportu; nepřebírej instalační cesty jiné
   osoby. Model, materiál i jeho zdroj mají být vlastní, bez kopie SDK obsahu.
2. Před kruhem proveď zkoušku: zvoleným exportérem vyexportuj jednoduchý
   triangulovaný kvádr jako jeden statický FBX mesh bez kostry/animace.
   V importu UnrealEd zvol Static Mesh. Při odmítnutí ulož přesný importní
   log a screenshot voleb; verzi FBX měň až podle diagnostiky či dokumentace
   dodané s tímto SDK. Bez úspěšné zkoušky nepovažuj exportní profil za ověřený.
3. Vlastní kruh exportuj stejným ověřeným profilem jako jediný render mesh.
   Pivot uprostřed spodní hrany a rozměry vůči vojákovi jsou naše pracovní
   volba, nikoli engine konstanty. Připrav UV a normály; bez ověřeného měřítka
   neuváděj pevný převod metrů na herní dlaždice.
4. Pro první kontrolu geometrie nastav:
   MeshTypeToImport=FBXIT_StaticMesh, bOverrideFullName=true,
   bCombineMeshes=false, bImportMeshLODs=false, bRemoveDegenerates=true,
   bImportMaterials=false, bImportTextures=false,
   bExplicitNormals=true, bOverrideTangents=false.
   Jsou to **navržené volby pro tento vzorek**, ne ověřené výchozí hodnoty.
   Importuj normály z připraveného modelu; při stínových vadách porovnej
   přepočtené normály jako samostatně zaznamenaný pokus.
5. Ulož mesh do nového vlastního balíčku a přiřaď jednoduchý vlastní materiál.
   Návrhové názvy jsou `WSG_GatePrototype` (balíček) a
   `SM_WSG_GatePrototype` (objekt). Nejsou to existující SDK assety.
   Z editoru opiš skutečné úplné jméno objektu a ulož ho do protokolu;
   runtime referenci nevymýšlej ze samotného názvu souboru.
6. V editoru umísti model pomocí doloženého Add StaticMesh do oddělené
   testovací scény. Ověř orientaci, velikost, materiál a otvor z obou stran.
   Zavři a znovu otevři editor/balíček: objekt i materiál musí zůstat.
   Tím se prověří uložení assetu, nikoli save/load herní expedice.
7. První kruh je dekorace: zkontroluj a nastav kolize umístěné komponenty tak,
   aby model neblokoval vstup/extrakci. Výchozí blokování není vypnuté [S4].
   Pokud později rám dostane fyzickou kolizi, rozděl ji na více konvexních
   dílů kolem otvoru. Jediný konvexní obal celého kruhu otvor vyplní
   (geometrický důsledek, nikoli test WotC). Samotný průhledný střed modelu
   nedokazuje průchozí herní dlaždice, krytí ani line of sight.

## Balíček v projektu a build

Navržené projektové umístění vlastního výsledku je
`StargateWOTC/Content/WSG_GatePrototype.upk`.
Referenční WotC projekt [S5] opravdu zařazuje UPK jako Content položku:

```xml
<Content Include="Content\WSG_GatePrototype.upk">
  <SubType>Content</SubType>
</Content>
```

Ukázka pouze mění jméno balíčku podle našeho návrhu. Do současného .x2proj ji
**nepřidávat, dokud soubor neexistuje**. Při skutečném importu použít přidání
existujícího souboru v ModBuddy a zkontrolovat výsledné XML.
Referenční projekt používá X2ModBuildCommon; původní targets našeho projektu
je třeba ověřit podle BUILD.md, tato reference jeho kompatibilitu nedokazuje.

Sestav původní WotC cestou podle BUILD.md a v úplném build logu ověř také
zpracování grafického obsahu/shaderů. Ve skutečném výstupním adresáři ověř
přítomnost vlastního balíčku a vyřešení všech materiálových referencí.
`tools/check_package.py` kontroluje loaderový balíček, **nekontroluje
importovaný mesh, jeho závislosti ani správnost shaderů**.

[S6] dokládá, že X2ModBuildCommon prohledává Content pro UPK, samostatně
spouští prekompilaci shaderů a odděluje ContentForCook. Není to návod
zapnout jeho experimentální cooking nebo kopírovat jeho commandlet do
původního toolchainu. Tento úkol nemění build systém, nepřidává runtime
závislosti a nepředepisuje neověřené cook parametry.
Firaxis Quick Start [S7] potvrzuje obecné rozlišení content packages,
UnrealEd a buildu; týká se základního XCOM 2, nikoli důkazu WotC importu.

Přítomnost UPK v Content **neumisťuje bránu do mise**. Zapojení konkrétní
mapy/parcely nebo runtime vytvoření objektu vyžaduje samostatné ověření
ve WSG-009B. Zde není vymyšlen název mapy ani API pro spawn.
Bez této vazby nelze následující herní část provést.

## T20 — přejímka importu ve WSG-009B

Nyní NOT_RUN. Nejprve T01–T04 a funkční M1; grafika nesmí předběhnout mechaniku.
Protokol lze vyplnit podle [GATE-IMPORT-RESULT.example.json](GATE-IMPORT-RESULT.example.json).
Jde o ruční evidenci, ne automatický validátor úspěchu.

1. **Editor:** proveď kvádr, kruh a znovuotevření výše. Očekávej správný typ
   StaticMesh, nepoškozený otvor, materiál a uložené úplné jméno assetu.
   Důkaz: importní log, exportní profil a screenshot geometrie i kolizí.
2. **Build:** vlož vlastní UPK do projektu, dolož jeho přítomnost v čerstvém
   výstupu a celý úspěšný build včetně shaderů. Očekávej vyřešené reference.
   Zapiš SHA-256 vlastního FBX a UPK, commit a sestavení prostředí.
3. **Hra:** po doloženém umístění do testovací mise spusť skutečnou WotC
   hru s modem. Očekávej viditelnou bránu se správným materiálem bez pomoci
   otevřeného SDK editoru. Dodat celý herní log; screenshot brány a přesný
   text případného missing-package/material hlášení.
4. **Průchod:** se všemi čtyřmi vojáky projdi otvorem, zkontroluj ukazatel
   dosažitelných polí a návrat přes extrakční oblast. Očekávej stejnou
   průchodnost a extrakci jako u dočasné grafiky M1. Dodat screenshoty
   pohybového náhledu, rozmístění týmu a extrakce.
5. **Taktické uložení:** ulož u brány, načti dvakrát a dokonči návrat.
   Očekávej jednu bránu, zachovaný materiál/kolize a žádnou změnu
   jednorázovosti odměny. Dodat save identifikátory, screenshot po loadu,
   herní log a výsledek navazujícího T13.

PASS editoru neznamená PASS buildu; PASS buildu neznamená PASS hry nebo
expedice. Při chybě zastav danou větev a zaznamenej skutečný výsledek.
Nikdo nyní nemá testovat neexistující sestavení.

## Připnuté primární zdroje

- S1: [FbxImportUI.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/UnrealEd/Classes/FbxImportUI.uc),
  blob `0acdc7bbca3eb77b75e71b5e14ab2ae26e12a9f8`.
- S2: [ActorFactoryStaticMesh.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/Engine/Classes/ActorFactoryStaticMesh.uc),
  blob `03fee8fc56dab806f80aca652a55da1aeab180a9`.
- S3: [StaticMeshActor.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/Engine/Classes/StaticMeshActor.uc),
  blob `462c8597aa4b27fc48a7085c6b6004667c2421d2`.
- S4: [StaticMeshComponent.uc](https://github.com/daakru/xcom2-wotc-modding/blob/75bf2d520d2d2ae600b579ca0e5ae306e3abc7f1/Firaxis/XCOM/SrcOrig/Engine/Classes/StaticMeshComponent.uc),
  blob `4e823c31a4e6c454851274f79956a0104b6984a5`.
- S5: [WotC projekt s Content UPK](https://github.com/X2CommunityCore/X2CommunityPromotionScreen/blob/34439925a59004bec17ea9a3c34a3164f6a459a5/X2WOTCCommunityPromotionScreen/X2WOTCCommunityPromotionScreen.x2proj),
  blob `20deed7fbddc9675924763efb2542cb8952eb328`.
- S6: [build_common.ps1, zejména _PrecompileShaders](https://github.com/X2CommunityCore/X2ModBuildCommon/blob/14e97e10260295b6900c7b2da0ab6e7b7da29e5d/build_common.ps1),
  blob `0486b01c94f943ca80e9e27da902deb72b9ef383`.
- S7: [Firaxis/2K SDK Quick Start](https://downloads.2kgames.com/xcom2/uploads/pdfs/XCOM2_SDK_QuickStart.pdf),
  strany 4–5, základní XCOM 2; pouze obecný kontext.

Staré UDK stránky nebyly při tomto ověření dostupné; nejsou podkladem pro
tvrzení o verzi FBX. Nové UE4/UE5 návody se nepoužily jako důkaz pro WotC.
Do repozitáře se nepřidávají cizí zdroje, SDK balíčky ani dočasné výstupy.
