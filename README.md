# Casus Cbs
Repo voor casus cbs : Bevat R code voor het ontsluiten, bewerken, visualiseren en opslaan van data.
De code die wordt gevonden in deze repro is gemaakt in opdracht van het cbs met onderstaande omschrijving als uitgangspunt.

!Belangrijk : De process_cbs_data.R bevat een variabele genaamd dir. Deze moet aan de lokale situatie aangepast worden om de code goed te laten runnen.

## Casus : R
Probeer op basis van StatLine informatie cijfers te maken over de kwartaalmutatie van de consumentenprijs van twee interessante producten.
Zet een klein overzichtelijk en opzichzelfstaand proces op in R, waarbinnen input, throughput en output duidelijk worden onderscheiden.
1. Haal de data op vanuit R zonder gebruik van externe databestanden (i.e. .csv of .excel). Voor meer informatie zie deze website.
2. Bereken de kwartaalmutatie van deze cijfers door gebruik te maken van maandcijfers 2. Maak van deze berekening een functie met de verslagperiode als input-parameter.
3. Maak een aantal grafieken en sla de resultaten op in een lokale database (maak bijvoorbeeld gebruik van een SQLite database).
4. Zet de code op een openbare git omgeving (i.e. github)

## Inhoud repo
De repo bevat 3 R files die de kern vormen van de code:
1. process_cbs_data.R : is het main script wat verantwoordelijk is voor het ontsluiten, bewerken, visualiseren en opslaan van de data.
2. dependencies.R : dit script bevat alle packages die nodig zijn om het process_cbs_data script uit te kunnen voeren.
3. functions.R : dit script bevat zelf geschreven functies die worden gebruikt in het process_cbs_data script.

## Externe afhankelijkheden
1. De input data bestaat uit cbs data. Specifieker de tabel Consumentenprijzen per maand.
2. Er wordt een SQLite database gebruikt.

## Outputs
Na het uitvoeren van het script worden er 2 pfs gegenereerd met grafieken en de tabel met kwartaalmutaties wordt naar een SQLite database geschreven.
