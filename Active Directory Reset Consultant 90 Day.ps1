Import-Module ActiveDirectory

#This PowerShell script will set the expiration date of an account to 90 days from today's date.
#Be careful, as this will apply to any account specified.


Write-Host "This PowerShell script will set the expiration date of an account to 90 days from today's date. Be careful, as this will apply to any account specified."
$continue = $true

while($continue -eq $true){


    $current_date = Get-Date -Format "MM-dd-yyyy" #ex. 01-01-2021
    $server = ""
    $samaccountname = Read-Host 'Enter a username to search or type "end" to end the program'

    if( $samaccountname -eq "end")
    {
        break
    }

    #Printout the person's info to verify information
    Get-ADUser -Server $server -Filter{samaccountname -eq $samaccountname}
    Get-ADUser -Server $server -Filter{samaccountname -eq $samaccountname} -Properties * | select-object AccountExpirationDate
    
    #Convert to DateTime and apply formatting
    $90DaysFromNow = (Get-Date).AddDays(90)            
    $90DaysConverted = Get-Date -Date $90DaysFromNow -Format "MM/dd/yyyy"

    $nameReturned = Get-ADUser -Server $server -Filter {samaccountname -eq $samaccountname} -Properties samaccountname | select samaccountname
        if ( ($nameReturned -ne $null) -and ($nameReturned -ne ""))
        {
            Write-Host "Found user" $samaccountname "— Would you like to set their account expiration date to 12:00am on " $90DaysConverted "?"
            $inputString = Read-Host "Type in Y to change the date"
            if ( ($inputString -eq "Y") -or ($inputString -eq "y"))
            {
                #Note that the calculation is end of day. ex. -DateTime "02/10/2022" will list it as 02/09/2022 end of day in AD. 
                        
           
                #Set user's expiration to 90 days from today.
                Set-ADAccountExpiration -Server $server -Identity $samaccountname -DateTime $90DaysConverted
                #Set-ADAccountExpiration -Server $server -Identity tauser17 -DateTime "04/08/2022"

                Write-Host "`nThe account expiration date for" $samaccountname "has been changed to " $90DaysConverted
                Write-Host "Continue if you have an additional account to modify.`n"                
            }
            else
            {
                Write-Host "The account" $samaccountname "has not been modified.`n"
            }

        }        
        
        else
        {
            Write-Host "`nUser " $samaccountname " was not found. Please try again `n"
        }
        

}