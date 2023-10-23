## Vegetationsaufnahmen vom Online-Feldbuch von Info Flora exportieren transformieren und nutzten


<a name="inhalt"></a>
### Inhalt
- [1. Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora](#export)
- [2. Vegetationsdaten vom Info Flora Online-Feldbuch mit R transformieren](#Rtransformieren)
- [3. Vegetationsdaten vom Info Flora Online-Feldbuch mit VEGEDAZ transformieren](#VEGEDAZtransformieren)


<a name="export"></a>
### 1. Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora

1. Login im [Info Flora Online-Feldbuch](https://auth.infoflora.ch/de/login)

2. Klick auf «Beobachtungen»
   
3. Im Drop-Down Menü von Maske: «Vegetationsaufnahmen wählen»

![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/c1c31b31-7b5a-4050-95c8-7f5cc708dba9)

4. Mit gedrückter Ctrl oder Shift Taste Vegetationsaufnahmen, die exportiert werden sollen, markieren.

5. Auf «Export der Aufnahmen» klicken -> Neues Fenster erscheint

   ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66779fcc-d582-425f-a94e-e7caab2e9ce3)
   
6. «Export der Vegetationsaufnahmen» anklicken, um die Kopfdaten zu speichern. «Export der Beobachtungen» anklicken, um die Artdaten zu speichern.

7. Beide Dateien öffnen und als «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern.
   

<a name="#Rtransformieren"></a>
### 2. Vegetationsdaten vom Info Flora Online-Feldbuch mit R transformieren

#### Artdaten vom Info Flora Online-Feldbuch zu Kreuztabelle transformieren 
[R-Skript](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/blob/main/Artendaten_Info_Flora_FB_de_v.05.R)
das die Artdaten in eine Kreuztabelle transfomiert. Als PlotID wird vom Feldbuch generierte "releve_id" verwendet.


#### Vegetationsdaten vom Info Flora Online-Feldbuch transformieren
[R Skript](Vegetationsdaten_Info_Flora_FB_de_v.01.R) das die Kopf-/Umweldaten mit Einträgen aus den Beobachtungen ergänzt und die Artdaten in eine Kreuztabelle transfomiert. Als PlotID wird der in der FlorApp erfasste "Name der Vegetationsaufnahme" verwendet


<a name="#VEGEDAZtransformieren"></a>
### 3. Vegetationsdaten vom Info Flora Online-Feldbuch mit VEGEDAZ transformieren

1. VEGEDAZ öffnen. *Datei - Import -->* oder ![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66b117bd-1a9f-4db8-890f-fc6cf144c40a)

2. Im neuen Fenster *Beobachtungen einzeln* auswählen.
   Artdaten (obs_releve_export.csv) aus Zwischenanblage importieren (Trennzeichen *TAB (Tabulator-Zeichen)*
   oder 
   Artdaten als Dateiimportieren (Trennzeichen *SEM (Semikolon)* - *Ok* - Datei auswählen

![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/fcb0e8fa-284a-415a-8447-e9c08c13655c)

