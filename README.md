## Vegetationsaufnahme-Daten vom Online-Feldbuch von Info Flora nutzten


<a name="inhalt"></a>
### Inhalt
- [Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora](#export)
- [Vegetationsdaten vom Info Flora Online-Feldbuch transformieren](#transformieren)


<a name="export"></a>
## Exportieren von Vegetationsaufnahmen aus dem Online-Feldbuch von Info Flora

1. Login im [Info Flora Online-Feldbuch](https://auth.infoflora.ch/de/login)

3. Klick auf «Beobachtungen»
   
4. Im Drop-Down Menü von Maske: «Vegetationsaufnahmen wählen»

![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/9b4d82aa-1550-49dc-b598-4bf51c4a255e)

5. «Export der Vegetationsaufnahmen» anklicken, um die Kopfdaten zu speichern «Export der Beobachtungen» anklicken, um die Artdaten zu speichern

6. Beide Dateien öffnen und als «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern.

![grafik](https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch/assets/89586146/66779fcc-d582-425f-a94e-e7caab2e9ce3)

7. Beide Dateien öffnen und als «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern.
   

<a name="transformieren"></a>
## Vegetationsdaten vom Info Flora Online-Feldbuch transformieren


#### Artdaten vom Info Flora Online-Feldbuch zu Kreuztabelle transformieren 
R-Skript um die Artdaten in eine Kreuztabelle umwandelt. Als PlotID wird vom Feldbuch generierte "releve_id" verwendet.


#### Vegetationsdaten vom Info Flora Online-Feldbuch transformieren
R Skript das die Kopf-/Umweldaten mit Einträgen aus den Beobachtungen ergänzt und die Artdaten in eine Kreuztabelle umwandelt. Als PlotID wird der in der FlorApp erfasste "Name der Vegetationsaufnahme" verwendet

