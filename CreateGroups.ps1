#Import Active Directory Module
Import-module activedirectory

#Declare any Variables
$dirpath = $pwd.path
$counter = 0

#import CSV File
$groups = Import-csv "$dirpath\ADGroups.csv"
$TotalImports = $groups.Count

#Create Users
$groups | ForEach-Object {
    $counter++
    $progress = [int]($counter / $totalImports * 100)
    Write-Progress -Activity "Provisioning AD Groups" -status "Provisioning group $counter of $TotalImports" -perc $progress

    foreach ($group in $groups) {
        New-ADGroup -Name $group.name -Description "New Groups Created in Bulk" -GroupCategory Security -GroupScope Universal -Managedby Administrator
    }
}