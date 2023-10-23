# Vegetationsaufnahmen vom Online-Feldbuch von Info Flora exportieren und transformieren


<a name="inhalt"></a>
### Inhalt
- [1. Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora](#export)
- [2. Vegetationsdaten vom Info Flora Online-Feldbuch mit R transformieren](#Rtransformieren)
- [3. Vegetationsdaten vom Info Flora Online-Feldbuch mit VEGEDAZ transformieren](#VEGEDAZtransformieren)
<br />

<a name="export"></a>
## 1. Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora

1. Login im [Info Flora Online-Feldbuch](https://auth.infoflora.ch/de/login)

2. Klick auf «Beobachtungen»
   
3. Im Drop-Down Menü von Maske: «Vegetationsaufnahmen wählen»
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/c1c31b31-7b5a-4050-95c8-7f5cc708dba9)
   
   <br />

5. Mit gedrückter Ctrl oder Shift Taste Vegetationsaufnahmen, die exportiert werden sollen, markieren.

6. Auf «Export der Aufnahmen» klicken -> Neues Fenster erscheint
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66779fcc-d582-425f-a94e-e7caab2e9ce3)
   
   <br />
   
8. «Export der Vegetationsaufnahmen» anklicken, um die Kopfdaten zu speichern. «Export der Beobachtungen» anklicken, um die Artdaten zu speichern.

9. Beide Dateien öffnen und als «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern.
<br />


<a name="Rtransformieren"></a>
## 2. Vegetationsdaten vom Info Flora Online-Feldbuch mit R transformieren

#### Artdaten vom Info Flora Online-Feldbuch zu Kreuztabelle transformieren 
[R-Skript](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/blob/main/Artendaten_Info_Flora_FB_de_v.05.R)
das die Artdaten in eine Kreuztabelle transfomiert. Als PlotID wird vom Feldbuch generierte "releve_id" verwendet.


#### Vegetationsdaten vom Info Flora Online-Feldbuch transformieren
[R Skript](Vegetationsdaten_Info_Flora_FB_de_v.01.R) das die Kopf-/Umweldaten mit Einträgen aus den Beobachtungen ergänzt und die Artdaten in eine Kreuztabelle transfomiert. Als PlotID wird der in der FlorApp erfasste "Name der Vegetationsaufnahme" verwendet
<br />


<a name="VEGEDAZtransformieren"></a>
## 3. Vegetationsdaten vom Info Flora Online-Feldbuch mit VEGEDAZ transformieren
   <br />
   
***Artdaten importieren***

1. VEGEDAZ öffnen. *Datei - Import -->* oder ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66b117bd-1a9f-4db8-890f-fc6cf144c40a)

2. Im neuen Fenster (siehe unten) *Beobachtungen einzeln* auswählen.
   Artdaten (obs_releve_export.csv) aus Zwischenanblage importieren (Trennzeichen *TAB (Tabulator-Zeichen)*
   oder 
   Artdaten als Datei importieren (Trennzeichen *SEM (Semikolon)* - *Ok* - Datei auswählen
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/92003b62-3674-41db-bdee-ffd691558d0b)
   
   <br />

4. Im neuen Fenster (siehe unten):
   - ***erwünschte Kopfdaten:*** "releve_id"
   - ***Artnamen: "taxon_orig"*** oder "taxon.taxon_name"
   - ***Deckungen:*** "supplements.cover.abs" (Wenn Deckungen in Prozent geschtätzt wurden
  
   - Wenn Schicht erfasst wurde
   - ***erwünschte Art-Zusätze***: - supplements.releve.stratum
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/60d328c3-4450-46d8-a740-c5f284080f8b)

   <br />

***Kopf-/Umweldaten importieren***
   <br />
   
5. Crouser in Zelle "releve_id" setzten, danach mit Ctrl + Enter eine neue Zeile einfügen
6. Kopfdaten (releve_export.csv) öffnen mit Ctrl + A alles markieren (alternativ nur elevante einträge kopieren) mit Ctrl + C alles kopieren
7. VEGEDAZ: *Bearbeiten - Einfügen (Optionen) -->*
8. Im neuen Fenster Option *"(+Alt) Transponieren, überschreiben" wählen - "ok"*
   <br />
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/1f87eec7-499c-49a2-b3c3-b5d11c50e983)
   <br />

9. Wenn Schichten Importiert wurden Menü *Bearbeiten* - *Ersetzten* um die Schicht Codes vom Feldbuch durch die Schicht-Codes von VEGEDAZ zu ersetzten
   <br />
   
   Codes Feldbuch:
   ♃ = Krautschicht; v = Strauchschicht;  Y = Baumschicht; ψ = Moosschicht
      <br />
      
   Codes VEGEDAZ:
   /K = Krautschicht; /S = Strauchschicht; /B = Baumschicht; / M = Moosschicht
   <br />
   
   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/5a9002dd-2d8c-4431-a902-19e9116c5f27)


   


