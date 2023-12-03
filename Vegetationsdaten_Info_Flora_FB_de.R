#__________________________________________________________________________
# Vegetationsdaten vom Info Flora Online-Feldbuch transformieren
# Stefan Widmer, Forschungsgruppe Vegetationsoekologie
# Vegetationsdaten_Info_Flora_FB_de.R
# Version 1.3 | 3.12.2023
#__________________________________________________________________________

# Package "tidyverse " installieren (falls noch nicht installiert) und atachen
if(!require(tidyverse )){install.packages("tidyverse ")}
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
  read.csv("obs_releve_export.csv", sep = ";", stringsAsFactors = TRUE) 

# Spalte "taxon.taxon_name" = Taxaname Checklist 2017 & addenda
# Spalte "taxon_orig" = Taxaname mit cf. (Unsichere Art oder Unsichere Gattung gewählt) oder 
# Taxaname welcher als Freitext erfasst wurde. Ansonsten Checklist 2017 & addenda ohne Autor.


## Kopf-/Umweldaten importieren ####
# Name "releve_export.csv" anpassen. "sep = ";" ändern wenn nötig
env_feldbuch <- 
  read.csv("releve_export.csv", sep = ";", stringsAsFactors = TRUE) 
str(env_feldbuch)
summary(env_feldbuch)


# 3. Kopf-/Umweldaten bearbeiten ------------------------------------------
# Zusammenstellen der  Kopf-/Umweldaten: Alle env mit Einträgen & 
# relevante Spalten aus spxplot_feldbuch (obs_releve)

# 3.1 Auswahl Kopf-/Umweldaten von spxplot_feldbuch 

# Funktion Modus definieren
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Relevante Spalten von spxplot_feldbuch auswählen (bei Bedarf anpassen)
sp_fb_env <- aggregate( 
  cbind(x,
        y, 
        xy_precision,
        altitude_min,
        altitude_max,
        "municipality" = as.character(municipality.name),
        "canton" = as.character(v_co_canton),
        "observers" = as.character(v_observers))
  ~releve_id, spxplot_feldbuch, FUN = "Mode")

# Numerische Werte wieder als numerisch definieren
sp_fb_env <- mutate_at(sp_fb_env, c("x", "y", "xy_precision", "altitude_min",
                                        "altitude_max"), as.numeric)

# 3.2 Zusammenstellen Kopf-/Umweldaten
env <- merge(
  x = sp_fb_env, 
  y =  env_feldbuch[, !apply( is.na(env_feldbuch), 2, all)],
  by.x = "releve_id", by.y = "id")

# Neue Spalte mit Mittelwert Meter über Meer (altitude)
env$altitude <- apply(env[c("altitude_min", "altitude_max")], 1, mean, na.rm = TRUE)

# Eigene PlotID ("name") als rowname setzten
env <- column_to_rownames(env, var = "name")

# Alphabetisch nach PlotID ordnen
env <- env[ order( row.names(env) ), ]


# 4. Artdaten formatieren (Kreuztabelle Sp. x Plot erstellen) --------------

## Artdaten bearbeiten ####

# Benutze Deckungsschätzung
cover_nu <- apply(is.na(spxplot_feldbuch[c("cover","abundance_code", "supplements.cover_abs")]), 2, all )
cover_estimate <- names(cover_nu)[cover_nu == FALSE]

# Auswahl relevanter Spalten von "spxplot_feldbuch" und hinzfügen von eigener 
# PlotID von "env"
spxplot <- merge(
  x = env_feldbuch[,c("id", "name")], 
  y = spxplot_feldbuch[,c("releve_id", "taxon_orig", cover_estimate, "supplements.releve_stratum")],  
  by.x = "id", by.y = "releve_id")

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
spxplot <-  spread(spxplot[,c("name", "taxon_orig", cover_estimate)], 
                   name, cover_estimate, fill = 0)

# Wenn Fehlermeldung: Error in `spread()`:! Each row of output must be identified 
# by a unique combination of keys
# Wenn nicht die selbe Art in mehreren Schichten in einem Plot vorhanden ist (siehe oben),
# wurde eine oder mehre Arten im gleichen Plot in der gleichen Schicht erfasst 
# -> im Online-Feldbuch korrigieren und bei 1. neu starten

# Taxa name als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon_orig")

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
spxplot$supplements.releve_stratum[spxplot$supplements.releve_stratum==""] <- nicht_definerte_Schicht

# Neue Spalte mit taxon und Schicht
spxplot$taxon_schicht <- 
  paste(spxplot$taxon_orig, spxplot$supplements.releve_stratum, sep = " /")

# Kreuztabelle erstellen
spxplot <-  spread(spxplot[,c("name","taxon_schicht", cover_estimate)], 
                    name, cover_estimate, fill = 0)

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
spxplot <-  spread(spxplot[,c("name","taxon_orig", cover_estimate)], 
                   name, cover_estimate, fill = 0)

# Taxa name als rowname festlegen
spxplot <- column_to_rownames(spxplot, var = "taxon_orig")

# Bei Bedarf Artdaten exportieren
write.table(spxplot, file = "spxplot.csv", sep = ";", col.names = NA, fileEncoding = "UTF-8")

# Artdaten transponieren für weitere Auswertungen in R
spxplot <- t(spxplot)

# Aufsteigend nach relve_id ordnen
spxplot <- spxplot[ order( row.names(spxplot) ), ]
