#!/bin/bash

chemin="$1"

# Pause nécéssaire pour que le système ait le temps
# d'enlever le fichier de la semaine dernière du dock
sleep 5

# Ajoute chemin au Dock
defaults write com.apple.dock persistent-others -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$chemin</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
#sleep 3

killall Dock
