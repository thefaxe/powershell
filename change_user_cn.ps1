#change_user_displayname.ps1
#
# Synopsis
# 
# Get all Users from an active directory organisation unit and
# change display name, distinguished name and companyname
#
#
################################################################
#Variables - edit as required
################################################################

$container = "OU=ouname,DC=domain,DC=local"
$company = "Your Comany Name here"
$emaildomain = "yourcompany.org"

################################################################
 
#Read users into variable.
$users = get-aduser -filter * -SearchBase $container
  
#Process users.
Foreach ($user in $users) {
    $newDN = $user.surname + ", " + $user.GivenName
    $email=$user.GivenName+"."+$user.surname+"@"+$emaildomain
    $email=$email.ToLower()
    #Change display name, and company name
    set-aduser $user -Displayname $newDN -company $company -ErrorAction SilentlyContinue
    Set-ADUser -Identity $user -EmailAddress $email
    #Change distinguished name
        Try {
            Rename-ADObject -identity $user -Newname $newDN
        }
        Catch {
            Write-Host "$user may already exist."
        }
    }