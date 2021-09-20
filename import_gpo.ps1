#GPOs per Powershell importieren
#Importiert GPOs aus einem Ordner
#Benutzer kann Ordner in dem die GPOs sind auswählen
#Orginal https://johnpenford.wordpress.com/category/gpo/, Anpassungen peter@lachenmair.info

#nach c:\temp\import loggen
start-transcript c:\temp\import.log

#module laden
Import-Module ActiveDirectory            
Import-Module GroupPolicy  

#auswahfenster
$window = new-object -com Shell.Application
$ordner = $window.BrowseForFolder(0, "Ordner auswählen", 0, "C:\")
$GPOordnername = $ordner.Self.Path
$import = get-childitem $GPOordnername | Select name

#import
foreach ($ID in $import) {
    $XMLFile = $GPOordnername + "\" + $ID.Name + "\gpreport.xml"
    $XMLData = [XML](get-content $XMLFile)
    $GPO = $XMLData.GPO.Name
    import-gpo -BackupId $ID.Name -TargetName $GPO -path $GPOordnername -CreateIfNeeded
}

#logging deaktivieren
stop-transcript