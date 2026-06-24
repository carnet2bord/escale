; Génère un exécutable Windows portable unique pour Escale.
; Au double-clic : extraction silencieuse de l'app dans un dossier temporaire,
; lancement de Escale.exe, puis nettoyage automatique à la fermeture.
; Les fichiers de l'app doivent être placés dans le dossier "payload\" à côté
; de ce script, et makensis doit être lancé depuis la racine du dépôt.

Unicode true
Name "Escale"
OutFile "Escale-portable.exe"
SilentInstall silent
RequestExecutionLevel user
Icon "windows\runner\resources\app_icon.ico"

Section
  InitPluginsDir
  SetOutPath "$PLUGINSDIR\Escale"
  File /r "payload\*"
  ExecWait '"$PLUGINSDIR\Escale\Escale.exe"'
SectionEnd
