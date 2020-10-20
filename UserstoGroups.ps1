#Import Active Directory Module
Import-module activedirectory

#Declare any Variables
$dirpath = $pwd.path
$counter = 0

#import CSV File
$list = Import-csv "$dirpath\ADGrouptoUserMapping.csv"
$TotalImports = $list.Count

# Add Users to Groups
$list | ForEach-Object {
    $counter++
    $progress = [int]($counter / $totalImports * 100)
    Write-Progress -Activity "Add users to groups" -status "Action $counter of $TotalImports" -perc $progress

    foreach ($line in $list) {
        add-adgroupmember -identity $line.Group -members $line.SamAccountName
    }
}