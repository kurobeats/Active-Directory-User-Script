Import-Module ActiveDirectory 
$comps = get-aduser -Filter { title -eq "IT Manager" -or title -eq "Service Account" } | Select-object -expandproperty SamAccountName
$users = @()

$Users = foreach ($comp in $comps) {
    Get-ADUser $comp
}
Add-ADGroupMember "Domain Admins" -Members $users