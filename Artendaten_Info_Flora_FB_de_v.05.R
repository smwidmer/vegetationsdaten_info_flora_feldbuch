#__________________________________________________________________________
# Artdaten vom Info Flora Online-Feldbuch zu Kreuztabelle transformieren
# Stefan Widmer, Forschungsgruppe Vegetationsoekologie
# Artendaten_Info_Flora_FB_de_v.05.R
# Version 0.5 | 20.10.2023
#__________________________________________________________________________

# 1. Artdaten von Info Flora Online-Feldbuch herunterladen ................
# 2. Artdaten importieren .................................................
# 3.1 Kreuztabelle für Vegetationsdaten mit einer Schicht .................
# 3.2 Kreuztabelle mit allen Schichten der Vegetationsdaten ...............
# 3.3 Kreuztabelle für definierte Schicht(en) .............................


# Package "tidyverse " installieren (falls noch nicht installiert) und atachen
if(!require(tidyverse )){install.packages("tidyverse ")}
library("tidyverse")

# 1. Artdaten von Info Flora Online-Feldbuch herunterladen ----------------

# "Beobachtungen" exportieren und neu als:
# «CSV UTF-8 (durch Trennzeichen-getrennt) (*.csv)» speichern. 
# Anleitung: https://github.com/smwidmer/vegetationsdaten_info_flora_feldbuch


# 2. Artdaten importieren -------------------------------------------------
#  Working directory definieren
setwd("C:/Users/name/Documents/VegA") # Example

## Artdaten importieren ####
# Name "obs_releve_export.csv" anpassen. "sep = ";" ändern wenn nötig
spxplot_feldbuch <- 
  read.table("obs_releve_export.csv", header = TRUE, sep = ";", stringsAsFactors = T) 

# Spalte "taxon.taxon_name" = Taxaname Checklist 2017 & addenda
# Spalte "taxon_orig" = Taxaname mit cf. (Unsichere Art oder Unsichere Gattung gewählt) oder 
# Taxaname welcher als Freitext erfasst wurde. Ansonsten Checklist 2017 & addenda ohne Autor.

# 3. Entscheid Schicht ----------------------------------------------------
# Sind mehre Schichten erfasst worden?:
levels(spxplot_feldbuch$supplements.releve_stratum)
# NULL = keine Schicht wurde erfasst /""  = Schicht nicht definiert / ♃ = Krautschicht 
# / v = Strauchschicht /  Y = Baumschicht / ψ = Moosschicht /

# Wenn Output NULL (keine Schichten erfasst)
# ODER 
# Nur eine Schicht erfasst wurde
# ODER
# Nur eine Schicht definiert wurde und die undefinierte Schicht identisch zur definierten Schicht ist
# weiter mit -> Abschnitt 3.1 Kreuztabelle für Vegetationsdaten mit einer Schicht

# Wenn mehre Schichten erfasst wurden:
# -> 3.2 Kreuztabelle mit allen Schichten der Vegetationsdaten 
# -> 3.3 Kreuztabelle für definierte Schicht(en)


# 3.1 Kreuztabelle für Vegetationsdaten mit einer Schicht -----------------

# Kreuztabelle erstellen
# supplements.cover_ab = Geschätzte Deckung in %
spxplot <-  pivot_wider(spxplot_feldbuch[,c("releve_id","taxon.taxon_name", "supplements.cover_abs")], 
                        names_from = releve_id, values_from = supplements.cover_abs)

# Wenn Fehlermeldung: "supplements.cover_abs` are not uniquely identified" 
# Wenn nicht die selbe Art in mehreren Schichten in einem Plot vorhanden ist (siehe oben),
# wurde eine oder mehre Arten im gleichen Plot in der gleichen Schicht erfasst 
# -> im Online-Feldbuch korrigieren und bei 1. neu starten

# Taxa name als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon.taxon_name")

# Leere Zellen mit 0 ersetzten
spxplot[is.na(spxplot)] <- 0

# Bei Bedarf Artdaten exportieren
write.table(spxplot, file = "spxplot.csv", sep = ";", col.names = NA, fileEncoding = "UTF-8")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)

# Aufsteigend nach relve_id ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]


# 3.2 Kreuztabelle mit allen Schichten der Vegetationsdaten ---------------
# ""  = Schicht nicht definiert / ♃ = Krautschicht / v = Strauchschicht / 
# Y = Baumschicht / ψ = Moosschicht /

# Bei Bedarf nicht definierte Schicht einer Schicht zuweisen (hier bsp. Krautschicht)
nicht_definerte_Schicht = "♃"
spxplot_feldbuch$supplements.releve_stratum[spxplot_feldbuch$supplements.releve_stratum==""] <- nicht_definerte_Schicht

# Neue Spalte mit Taxon und Schicht
spxplot_feldbuch$taxon_schicht <- 
  paste(spxplot_feldbuch$taxon.taxon_name, spxplot_feldbuch$supplements.releve_stratum, sep = " /")

# Kreuztabelle erstellen
spxplot <-  pivot_wider(spxplot_feldbuch[,c("releve_id","taxon_schicht", "supplements.cover_abs")], 
                        names_from = releve_id, values_from = supplements.cover_abs)

# Leere Zellen mit 0 ersetzten
spxplot[is.na(spxplot)] <- 0

# Taxaname als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon_schicht")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)

# Aufsteigend nach relve_id ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]


# 3.3 Kreuztabelle für definierte Schicht(en) -----------------------------

# Bei Bedarf nicht definierte Schicht einer Schicht zuweisen (hier bsp. Krautschicht)
nicht_definerte_Schicht = "♃"
spxplot_feldbuch$supplements.releve_stratum[spxplot_feldbuch$supplements.releve_stratum==""] <- nicht_definerte_Schicht

# Schicht auswählen
# ""  = Schicht nicht definiert / ♃ = Krautschicht / v = Strauchschicht / 
# Y = Baumschicht / ψ = Moosschicht /

# Eine Schicht auswählen (bsp. Krautschicht)
select_Schicht <- "♃"
spxplot <- spxplot_feldbuch[spxplot_feldbuch$supplements.releve_stratum == select_Schicht,]

# Zwei Schichten auswählen (bsp. Krautschicht und Moosschicht)
# nur sinvoll wenn Taxa im gleichen Plot nicht in zwei Schichten vorkommt
select_Schicht_1 <- "♃"
select_Schicht_2 <- "ψ"

spxplot <- spxplot_feldbuch[spxplot_feldbuch$supplements.releve_stratum == select_Schicht_1| 
                     spxplot_feldbuch$supplements.releve_stratum == select_Schicht_2,]

# Kreuztabelle erstellen
spxplot <-  pivot_wider(spxplot[,c("releve_id","taxon.taxon_name", "supplements.cover_abs")], 
                        names_from = releve_id, values_from = supplements.cover_abs)

# Taxa name als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon.taxon_name")

# Leere Zellen mit 0 ersetzten
spxplot[is.na(spxplot)] <- 0

# Bei Bedarf Artdaten exportieren
write.table(spxplot, file = "spxplot.csv", sep = ";", col.names = NA, fileEncoding = "UTF-8")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)

# Aufsteigend nach relve_id ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]
