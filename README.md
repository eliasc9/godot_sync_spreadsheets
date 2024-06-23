# Godot Sync Spreadsheets

Forked from [eliasc9/godot_sync_spreadsheets](https://github.com/eliasc9/godot_sync_spreadsheets)!

This is a plugin for Godot 4+ that allows to synchronize CSV files with Google Spreadsheets from godot.

It's useful for having translations or collaborative databases on Spreadsheets and synchronize them with your game when you create without downloading on every change, just click a button from editor.

## How install this plugin?

Paste the sync_spreadshets on addons folder on your godot project (create an addons folder if you don't have one).

Go to "Project" -> "Project Settings" -> "Plugins" -> "Sync Spreadsheets" -> Put "Enabled" to On

## How use this plugin

You don't need a CSV file on the game files to start.

1- Share the spreadsheet (view only is enough) and get the Spreadsheet ID from the link:
Link example: https://docs.google.com/spreadsheets/d/{Spreadsheet ID}/edit?gid={gid}

2-  In the 'Sync CSV' bottom panel, click 'Add New'.

3- Configure the CSV files in the inspector. Paste the Spreadsheet ID and set the Sheet Name or Gid (only one is needed).

4- In the 'Sync CSV' bottom panel, click 'Sync Now'. To save the config, click 'Save Config' (config is saved in user://).

5- Done! Every time you click 'Sync Now', it will automatically pull the latest CSV from Google Spreadsheets.

## This fork

Many thanks to @eliasc9!

I mostly tweaked things on the user interface, the underlying synchronization logic remains pretty much intact. The configuration files are different so the ones from the original repo won't work here.
I also changed the naming and coding style to my preference (Sorry but I just couldn't resist the temptation!)