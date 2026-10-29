# Tassen-Dienstag

Kleine Abstimmungsseite: An welchem Dienstag töpfern wir zusammen eine Tasse
im Handaufbau? Birmensdorferstrasse 377, Zürich (Heuried), 18 bis ca. 20 Uhr.

Statische Seite auf GitHub Pages, Daten in Supabase. Alle sehen live
denselben Stand.

## Dateien

- `index.html`: die ganze Seite (Stil, Raster, Logik)
- `config.js`: Supabase-URL und öffentlicher Schlüssel
- `supabase/schema.sql`: Tabelle, Zugriffsregeln, die sechs Namen

## Supabase einrichten

1. Auf [supabase.com](https://supabase.com) ein kostenloses Projekt anlegen.
2. Im SQL Editor den Inhalt von `supabase/schema.sql` ausführen.
3. Unter Project Settings → API die Project URL und den publishable (oder
   anon) key in `config.js` eintragen. Nie den secret/service_role key.

## Was die Seite darf

Mit dem öffentlichen Schlüssel kann man lesen, Namen hinzufügen und Dienstage
ankreuzen. Löschen und Namen ändern geht nur im Supabase-Dashboard.

## Lokal anschauen

```bash
python3 -m http.server 8080
```
