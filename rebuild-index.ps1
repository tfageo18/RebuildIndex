# Chemin vers le fichier d'indexation
$CheminEDB = "C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb"
# Chemin vers le fichier de log
$cheminLog = "C:\Scripts\RebuildIndex\Logs\index.txt"
# Recupere la date du jour pour la mettre dans le fichier de log
$date = Get-Date
# Variable de Debug 
# 0 = pas de debug
# 1 = debug complet
$debug = 0

Add-Content -Path $cheminLog -Value "-----------"
Add-Content -Path $cheminLog -Value "$date"

# Commande d'arrete du service Windows Search
Stop-Service -Name Wsearch -Force
If ($debug -gt 0) { Write-Host "Arret du service Windows Search" }
Else { Add-Content -Path $cheminLog -Value "Arret du service Windows Search" }
 
# Pause de 15 secondes le temps de l'arret du service
Start-Sleep -Seconds 15

# On récupére le status du service
# Running = Service Wsearch dans l'etat Démarrer
# Stopeed = Service Wsearch dans l'état Arret
$statusService = Get-Service -Name Wsearch | select Status
If ($debug -gt 0) { Write-Host $statusService.Status }
Else { Add-Content -Path $cheminLog -Value $statusService.Status }

# Si le service Wsearch est bien démarré alors on peut continuer
If ($statusService.Status -ne "Running") { 
    If ($debug -gt 0) { Write-Host "Arret du service Windows Search effectue avec succes" }
    Else { Add-Content -Path $cheminLog -Value "Arret du service Windows Search effectue avec succes" }

    # On supprime le fichier EDB
    del $CheminEDB
    If ($debug -gt 0) { Write-Host "Suppression du fichier Windows.edb" }
    Else { Add-Content -Path $cheminLog -Value "Suppression du fichier Windows.edb" }

    # Commande de démarrage du service Windows Search
    Start-Service -Name WSearch
    
    # Pause de 15 secondes le temps du démarrage du service
    Start-Sleep -Seconds 15
    If ($debug -gt 0) { Write-Host "Demarrage du service Windows Search" }
    Else { Add-Content -Path $cheminLog -Value "Demarrage du service Windows Search" }
    
    # On récupére le status du service
    # Running = Service Wsearch dans l'etat Démarrer
    # Stopeed = Service Wsearch dans l'état Arret
    $statusService = Get-Service -Name Wsearch | select Status
    If ($debug -gt 0) { Write-Host $statusService.Status }
    Else { Add-Content -Path $cheminLog -Value $statusService.Status }

    If ($statusService.Status -eq "Running") {
        # Le service est bien démarré
        If ($debug -gt 0) { Write-Host "Demarrage du service Windows Search effectue avec succes" }
        Else { Add-Content -Path $cheminLog -Value "Demarrage du service Windows Search effectue avec succes" }
    }
    Else {
        # Le service n'est pas démarré
        If ($debug -gt 0) { Write-Host "Demarrage du service Windows Search en echec" }
        Else { Add-Content -Path $cheminLog -Value "Demarrage du service Windows Search en echec" }
    }
} 
Else {
    # Le service ne s'est pas arreté
    If ($debug -gt 0) { Write-Host "Impossible d'arreter le service Windows Search" }
    Else { Add-Content -Path $cheminLog -Value "Impossible d'arreter le service Windows Search" }
}