#Import Active Directory Module
Import-module activedirectory

#Autopopulate Domain
$dnsDomain = $env:userdnsdomain

$split = $dnsDomain.split(".")
$domain = $null
foreach ($part in $split) {
    if ($null -ne $domain) {
        $domain += ","
    }
    $domain += "DC=$part"
}

#Declare any Variables
$dirpath = $pwd.path
$counter = 0

#import CSV File
$ImportFile = Import-csv "$dirpath\ADUsers.csv"
$TotalImports = $importFile.Count

#Create Users
$ImportFile | ForEach-Object {
    $counter++
    $progress = [int]($counter / $totalImports * 100)
    Write-Progress -Activity "Provisioning User Accounts" -status "Provisioning account $counter of $TotalImports" -perc $progress
    if ($_.Manager -eq "") {
        New-ADUser -SamAccountName $_."SamAccountName" -Name $_."Name" -Surname $_."Surname" -GivenName $_."GivenName" -AccountPassword (ConvertTo-SecureString $_."Password" -AsPlainText -Force) -Enabled $true -title $_."title" -officePhone $_."officePhone" -department $_."department" -emailaddress $_."Email" -Description $_."title"
    }
    else {
        New-ADUser -SamAccountName $_."SamAccountName" -Name $_."Name" -Surname $_."Surname" -GivenName $_."GivenName" -AccountPassword (ConvertTo-SecureString $_."Password" -AsPlainText -Force) -Enabled $true -title $_."title" -officePhone $_."officePhone" -department $_."department" -emailaddress $_."Email" -Description $_."title" -Manager $_."Manager"
    }
    if (Get-ChildItem "$dirpath\userimages\$($_.name).jpg") {
        $photo = [System.IO.File]::ReadAllBytes("$dirpath\userimages\$($_.name).jpg")
        Set-ADUSER $_.samAccountName -Replace @{thumbnailPhoto = $photo }
    }
    else {
        $photo = [System.IO.File]::ReadAllBytes("$dirpath\userimages\user.jpg")
        Set-ADUSER $_.samAccountName -Replace @{thumbnailPhoto = $photo }
    }
}
