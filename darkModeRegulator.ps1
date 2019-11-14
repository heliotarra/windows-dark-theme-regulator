<#
Title:darkModeRegulator.ps1
author:Jack Murray
date:11/14/2019
version:1.2

Comments:
    11/13/2019 - mkI   - Modified some code I found online for updating Dark mode
                       - Fixed a lot of errors, script was not functioning when I found it.
                       - added automatic user selection
                       - added prompts

               - mkI.2 - changed logout mechanics for better k1000 reporting 

ToDo: 
               - maybe add better UI for prompting dark mode instead of just using yes/no/cancel
            
#>

Add-Type -AssemblyName PresentationFramework

Function Set-DarkTheme { 
<#sets the windows theme to dark#> 
[CmdletBinding()] 
          Param ( [Parameter(Mandatory=$False, ValueFromPipelineByPropertyName=$true, Position=0)] 
                   $DwordName = 'AppsUseLightTheme', 
                   $Value = '0', 
                   $VerbosePreference = 'Continue' 
          ) 
 
    # creates HKLM key 
    # New-ItemProperty "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name $DwordName -Value $Value -PropertyType "DWord" 
   
    #Create access to User Registry
    $user = get-userSID
    New-PSDrive HKU Registry HKEY_USERS
 
    # sets user key 
    try{New-ItemProperty "HKU:\$($user)\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name $DwordName -Value $Value -PropertyType 'DWord' -ErrorAction Stop}
    catch{set-ItemProperty "HKU:\$($user)\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name $DwordName -Value $Value} 
    $r = [System.Windows.MessageBox]::Show('To complete the changes you must sign out and sign back in. Sign out now?','Sign Out Prompt','YesNo')
    if ($r -eq "yes"){
        write-host "User selected to logout"
        Start-Process cmd -ArgumentList "/c timeout 5 && shutdown /l"
    }
    else{
        write-host "User opted to not logout"
    }
    
 
} 
 
Function Set-LightTheme { 
<#sets the windows theme to light#> 
[CmdletBinding()] 
          Param ( [Parameter(Mandatory=$False, ValueFromPipelineByPropertyName=$true, Position=0)] 
                   $DwordName = 'AppsUseLightTheme', 
                   $Value = '1', 
                   $VerbosePreference = 'Continue' 
          ) 
 
    # creates HKLM key 
    # New-ItemProperty "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name $DwordName -Value $Value -PropertyType "DWord" 

    #Create access to User Registry
    $user = get-userSID
    New-PSDrive HKU Registry HKEY_USERS

    # sets user key 
    try{New-ItemProperty "HKU:\$($user)\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name $DwordName -Value $Value -PropertyType 'DWord' -ErrorAction Stop}
    catch{set-ItemProperty "HKU:\$($user)\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name $DwordName -Value $Value} 
    $r = [System.Windows.MessageBox]::Show('To complete the changes you must sign out and sign back in. Sign out now?','Sign Out Prompt','YesNo')
     if ($r -eq "yes"){
        write-host "User selected to logout"
        Start-Process cmd -ArgumentList "/c timeout 5 && shutdown /l"
    }
    else{
        write-host "User opted to not logout"
    }
 
}

function get-userSID{
    <#gets users SID for indentifying users local registry#> 
    $userName = Get-WMIObject -class Win32_ComputerSystem | select username
    $test = Out-String -InputObject $userName -Width 100

    $user1 = $test.split("\")
    $userName = $user1[1].Trim()

    $User = New-Object System.Security.Principal.NTAccount($userName)
    $sid = $User.Translate([System.Security.Principal.SecurityIdentifier]).value

    return $sid
    }

    $r = [System.Windows.MessageBox]::Show('Change Windows theme? Yes=Dark, No=Light, Cancel=No Change','Windows Theme Selector','YesNoCancel','Info')

    if ($r -eq "yes"){
        write-host "User selected Dark Theme"
        Set-DarkTheme
    }
    elseif ($r -eq "no"){
        write-host "User selected Light Theme"
        Set-LightTheme
    }
    elseif ($r -eq "cancel"){
        write-host "User selected Cancel"
}