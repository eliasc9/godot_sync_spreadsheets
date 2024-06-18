# Godot Sync Spreadsheets

This is a plugin for Godot 4+ that allows to synchronize CSV files with Google Spreadsheets from godot. 

It's useful for having translations or collaborative databases on Spreadsheets and synchronize them with your game when you create without downloading on every change, just click a button from editor.

## How install this plugin?

Paste the sync_spreadshets on addons folder on your godot project (create an addons folder if you don't have one).

Go to "Project" -> "Project Settings" -> "Plugins" -> "Sync Spreadsheets" -> Put "Enabled" to On


## How use this plugin

0- You need a CSV file on the game files to start. Just create a blank one, or download the first time from Google Spreadsheets.

1- Share the spreadsheet (view only is enough) and get the Sheet ID from the link:
Link example: https://docs.google.com/spreadsheets/d/{Sheet ID}/edit?gid={gid}

2-  In the 'Sync CSV Spreadsheets' bottom panel, click 'Edit CSV Spreadsheets'.

3- Configure the CSV files in the inspector. Paste the Sheet ID and set the Sheet Name or Gid (only one is needed).

4- In the 'Sync CSV Spreadsheets' bottom panel, click 'Sync Now'. To save the config, click 'Save on disk' (config is saved in user://).

5- Done! Every time you click 'Sync Now', it will automatically pull the latest CSV from Google Spreadsheets.

## Bugs? Ideas?

Open an issue on github!