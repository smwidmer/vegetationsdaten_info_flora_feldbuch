#__________________________________________________________________________
# Vegetationsdaten vom Info Flora Online-Feldbuch transformieren
# Stefan Widmer, Forschungsgruppe Vegetationsoekologie
# Vegetationsdaten_Info_Flora_FB_de_v.01.R
# Version 0.1 | 20.10.2023
#__________________________________________________________________________

# Package "tidyverse " installieren (falls noch nicht installiert) und atachen
if(!require(tidyverse )){install.packages("tidyverse")}
library("tidyverse")

# 1. Daten von Info Flora Online-Feldbuch herunterladen -------------------

# "Vegetationsaufnahmen" und "Beobachtungen" exportieren und neu als
# «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern. 
# Anleitung: https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch


# 2. Daten importieren ----------------------------------------------------
#  Working directory definieren
setwd("C:/Users/name/Documents/VegA") # Example

## Artdaten importieren ####
# Name "obs_releve_export.csv" anpassen. "sep = ";" ändern wenn nötig
spxplot_feldbuch <- 
  read.table("obs_releve_export.csv", header = TRUE, sep = ";", stringsAsFactors = TRUE) 

## Kopf-/Umweldaten importieren ####
# Name "releve_export.csv" anpassen. "sep = ";" ändern wenn nötig
env_feldbuch <- 
  read.table("releve_export.csv", header = TRUE, sep = ";", stringsAsFactors = TRUE) 
str(env_feldbuch)
summary(env_feldbuch)


# 3. Kopf-/Umweldaten bearbeiten ------------------------------------------
# Zusammenstellen der  Kopf-/Umweldaten mit relvanten Variablen aus env und spxplot
# -> Spalten gemäss eigenem Bedarf anpassen

env <- merge(x = unique( spxplot_feldbuch[,c(
  "releve_id",
  "x",
  "y",
  "xy_precision",
  "altitude_min",
  "altitude_max",
  "municipality.name",
  "v_co_canton",
  "v_observers")] ), 
  y = env_feldbuch[,c(
    "id",
    "name",
    "surface",
    "orientation",
    "slope", 
    "total_cover",
    "moss_cover", 
    "litter_cover",
    "soil_cover")],
  by.x = "releve_id", by.y = "id", all.x = TRUE)

# Neue Spalte mit Mittelwert Meter über Meer (altitude)
env$altitude <- apply(env[c("altitude_min", "altitude_max")], 1, mean, na.rm = TRUE)

# Eigene PlotID ("name") als rowname setzten
env <- column_to_rownames(env, var = "name")

# Alphabetisch nach PlotID ordnen
env <- env[ order( row.names(env) ), ]


# 4. Artdaten formatieren (Kreuztabelle Sp. x Plot erstellen) --------------

## Artdaten bearbeiten ####
# Auswahl relevanter Spalten von "spxplot_feldbuch" und hinzfügen von eigener 
# PlotID von "env" (supplements.cover_ab = Geschätzte Deckung in %)
spxplot <- merge(
  x = env_feldbuch[,c("id", "name")], 
  y = spxplot_feldbuch[,c("releve_id","taxon_orig", "supplements.cover_abs", "supplements.releve_stratum")],  
  by.x = "id", by.y = "releve_id")

str(spxplot)

## Entscheidung Schichten ####
# ""  = Schicht nicht definiert / ♃ = Krautschicht / v = Strauchschicht / 
# Y = Baumschicht / ψ = Moosschicht /
# Sind mehre Schichten erfasst worden?:
levels(spxplot$supplements.releve_stratum)

# Wenn Output NULL (keine Schichten erfasst)
# ODER 
# Nur eine Schicht erfasst wurde
# ODER
# Nur eine Schicht definiert wurde und die undefinierte Schicht identisch zur definierten Schicht ist
# weiter mit -> Abschnitt 5.1 Kreuztabelle für Vegetationsdaten mit einer Schicht

# Wenn mehre Schichten erfasst wurden:
# -> 5.2 Kreuztabelle mit allen Schichten der Vegetationsdaten 
# -> 5.3 Kreuztabelle für definierte Schicht(en)


# 5.1 Kreuztabelle für Vegetationsdaten mit einer Schicht -----------------

# Kreuztabelle erstellen
spxplot <-  pivot_wider(spxplot[,c("name","taxon_orig", "supplements.cover_abs")], 
                        names_from = name, values_from = supplements.cover_abs)

# Wenn Fehlermeldung: "supplements.cover_abs` are not uniquely identified" 
# Wenn nicht die selbe Art in mehreren Schichten in einem Plot vorhanden ist (siehe oben),
# wurde eine oder mehre Arten im gleichen Plot in der gleichen Schicht erfasst 
# -> im Online-Feldbuch korrigieren und bei 1. neu starten

# Taxa name als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon_orig")

# Leere Zellen mit 0 ersetzten
spxplot[is.na(spxplot)] <- 0

# Bei Bedarf Artdaten exportieren
write.table(spxplot, file = "spxplot.csv", sep = ";", col.names = NA, fileEncoding = "UTF-8")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)
# Alphabetisch nach PlotID ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]


# 5.2 Kreuztabelle mit allen Schichten der Vegetationsdaten ---------------
# ""  = Schicht nicht definiert / ♃ = Krautschicht / v = Strauchschicht / 
# Y = Baumschicht / ψ = Moosschicht /

# Bei Bedarf nicht definierte Schicht einer Schicht zuweisen (hier bsp. Krautschicht)
nicht_definerte_Schicht = "♃"
spxplot$supplements.releve_stratum[spxplot_feldbuch$supplements.releve_stratum==""] <- nicht_definerte_Schicht

# Neue Spalte mit taxon und Schicht
spxplot$taxon_schicht <- 
  paste(spxplot$taxon_orig, spxplot$supplements.releve_stratum, sep = " /")

# Kreuztabelle erstellen
spxplot <-  pivot_wider(spxplot[,c("releve_id","taxon_schicht", "supplements.cover_abs")], 
                        names_from = releve_id, values_from = supplements.cover_abs)

# Leere Zellen mit 0 ersetzten
spxplot[is.na(spxplot)] <- 0

# Taxaname als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon_schicht")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)

# Aufsteigend nach relve_id ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]


# 5.3 Kreuztabelle für definierte Schicht(en) -----------------------------

# Bei Bedarf nicht definierte Schicht einer Schicht zuweisen (hier bsp. Krautschicht)
nicht_definerte_Schicht = "♃"
spxplot$supplements.releve_stratum[spxplot$supplements.releve_stratum==""] <- nicht_definerte_Schicht

# Schicht auswählen
# ""  = Schicht nicht definiert / ♃ = Krautschicht / v = Strauchschicht / 
# Y = Baumschicht / ψ = Moosschicht /

# Eine Schicht auswählen (bsp. Krautschicht)
select_Schicht <- "♃"
spxplot <- spxplot[spxplot$supplements.releve_stratum == select_Schicht,]

# Zwei Schichten auswählen (bsp. Krautschicht und Moosschicht)
# nur sinvoll wenn Taxa im gleichen Plot nicht in zwei Schichten vorkommt
select_Schicht_1 <- "♃"
select_Schicht_2 <- "ψ"

spxplot <- spxplot[spxplot$supplements.releve_stratum == select_Schicht_1| 
                     spxplot$supplements.releve_stratum == select_Schicht_2,]

# Kreuztabelle erstellen
spxplot <-  pivot_wider(spxplot[,c("releve_id","taxon_orig", "supplements.cover_abs")], 
                        names_from = releve_id, values_from = supplements.cover_abs)

# Taxa name als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon_orig")

# Leere Zellen mit 0 ersetzten
spxplot[is.na(spxplot)] <- 0

# Bei Bedarf Artdaten exportieren
write.table(spxplot, file = "spxplot.csv", sep = ";", col.names = NA, fileEncoding = "UTF-8")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)

# Aufsteigend nach relve_id ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]
