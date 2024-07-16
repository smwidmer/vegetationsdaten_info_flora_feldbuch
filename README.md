# Vegetationsaufnahmen vom Info Flora Online-Feldbuch exportieren und in R oder VEGEDAZ importieren


<a name="inhalt"></a>
### Inhalt
- [1. Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora](#export)
- [2. Vegetationsdaten vom Info Flora Online-Feldbuch mit R transformieren](#Rtransformieren)
- [3. Vegetationsdaten vom Info Flora Online-Feldbuch mit VEGEDAZ transformieren](#VEGEDAZtransformieren)
<br />

<a name="export"></a>
## 1. Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch

1. Login im [Info Flora Online-Feldbuch](https://auth.infoflora.ch/de/login)

2. Auf «Beobachtungen» klicken.
   
3. Im Drop-Down Menü von Maske: «Vegetationsaufnahmen» wählen.
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/c1c31b31-7b5a-4050-95c8-7f5cc708dba9)
   
   <br />

5. Mit gedrückter Ctrl- oder Shift-Taste Vegetationsaufnahmen, die exportiert werden sollen, markieren.

6. Auf «Export der Aufnahmen» klicken -> Neues Fenster erscheint
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66779fcc-d582-425f-a94e-e7caab2e9ce3)
   
   <br />
   
8. «Export der Vegetationsaufnahmen» anklicken, um die Kopfdaten zu speichern. «Export der Beobachtungen» anklicken, um die Artdaten zu speichern.   <br />
   (Hinweis: Die Artdaten können auch über die Maske Standart heruntergeladen werden. Vorteil: Die Beschränkung auf 50 Aufnahmen entfällt. Nachteil: Die Selektion der zu den gewünschten Aufnahmen gehörenden Artdaten mit der Filter-Funktion ist etwas umständlich bzw beschränkt möglich.)
   

10. Beide exportierten Dateien mit Excel öffnen und als «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern und wieder schliessen. Nun sind die Daten parat zur weiteren Bearbeitung mit R oder VEGEDAZ
<br />


<a name="Rtransformieren"></a>
## 2. Vegetationsdaten vom Online-Feldbuch in R importieren

#### Artdaten vom Info Flora Online-Feldbuch zu Kreuztabelle transformieren 
[R-Skript](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/blob/main/Artdaten_Info_Flora_FB_de.R)
das die Artdaten in eine Kreuztabelle transfomiert. Als PlotID wird vom Feldbuch generierte "releve_id" verwendet.


#### Vegetationsdaten vom Info Flora Online-Feldbuch transformieren
[R Skript](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/blob/main/Vegetationsdaten_Info_Flora_FB_de.R) das die Kopf-/Umweldaten mit Einträgen aus den Beobachtungen ergänzt und die Artdaten in eine Kreuztabelle transfomiert. Als PlotID wird der in der FlorApp erfasste "Name der Vegetationsaufnahme" verwendet
<br />
<br />


<a name="VEGEDAZtransformieren"></a>
## 3. Vegetationsdaten vom  Online-Feldbuch in VEGEDAZ importieren
   <br />
   
***Artdaten importieren***

1. VEGEDAZ öffnen. *Datei - Import -->* oder ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66b117bd-1a9f-4db8-890f-fc6cf144c40a)

2. Im neuen Fenster (siehe unten) *Beobachtungen einzeln* auswählen.
   Artdaten (obs_releve_export.csv) aus Zwischenanblage importieren (Trennzeichen *TAB (Tabulator-Zeichen)*
   <br /> oder    <br />
   Artdaten als Datei importieren (Trennzeichen *SEM (Semikolon)* - *Ok* - Datei auswählen
   <br />

   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/1355496e-59ba-4288-abed-1beab9b47d5b)


   <br />

3. Im neuen Fenster (siehe unten):
   - ***erwünschte Kopfdaten:*** "**releve_id"**, weitere nach Bedarf z.B "x", "y", "xy_precision",  "municipality.name", "altitude_min","altitude_max", "v_co_canton", "v_observers"


   - ***Artnamen:*** "taxon.taxon_name" (Artname Checklist 2017 & addenda) oder "taxon_orig" (Taxaname mit cf. vor Gattung oder cf. vor Art oder Taxaname  welcher als Freitext erfasst wurde. Wenn der Taxaname von der Dropdown-Liste und als "Sichere Bestimmung" gewählt wurde = Artname Checklist 2017 & addenda ohne Autor)
   - ***Deckungen:*** "supplements.cover.abs" (Wenn Deckungen in Prozent geschätzt wurden ansonsten "cover" oder "abundance_code")
  
   Wenn Schicht erfasst wurde:
   - ***erwünschte Art-Zusätze***: supplements.releve.stratum
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/60d328c3-4450-46d8-a740-c5f284080f8b)

   ![grafik](https://github.com/user-attachments/assets/1e57a6b7-560e-4a6c-bf99-9433426ee4bb)

   <br />

5. File speichern (Ctrl + S)
   
***Kopf-/Umweldaten importieren***
   <br />
   
5. Kopfdaten (releve_export.csv) öffnen mit Ctrl + A alles markieren (alternativ nur relevante Spalten markieren) mit Ctrl + C alles kopieren
   
7. VEGEDAZ: *Datei - Import -->* oder ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66b117bd-1a9f-4db8-890f-fc6cf144c40a)

8. Im neuen Fenster (siehe unten) *Transponiert* auswählen.
   Aus Zwischenanblage importieren (Trennzeichen *TAB (Tabulator-Zeichen)*
   <br /> oder    <br />
   Daten von Datei importieren (Trennzeichen *SEM (Semikolon)* - *Ok* - Datei auswählen
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/bc3e30cd-7533-40d5-9900-d06abe56e810)


***Kopf-/Umweldaten mit Artdaten verknüpfen***

9. *Datei - Dateien verknüpfen -->* File mit zuvor gespeicherte "Artdaten" auswählen   <br />
Verknüpfen über Schlüsselfelder "id" und "relve_id" wählen
Optionen: "Arten aus Datei auch einfügen" anwählen

    ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/a9696c62-a8cf-4c2e-9738-9945b047b242)

   
   <br />
11. Wenn Schichten Importiert wurden Menü *Bearbeiten* - *Ersetzten* um die Schicht Codes vom Feldbuch durch die Schicht-Codes von VEGEDAZ zu ersetzten
   <br />
   
   Codes Feldbuch:
   ♃ = Krautschicht; v = Strauchschicht;  Y = Baumschicht; ψ = Moosschicht
      <br />
      
   Codes VEGEDAZ:
   /K = Krautschicht; /S = Strauchschicht; /B = Baumschicht; / M = Moosschicht
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/5a9002dd-2d8c-4431-a902-19e9116c5f27)


