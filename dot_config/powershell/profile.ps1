# See https://github.com/neilpa/cmd-colors-solarized for detail
# Include the solarized files
$solarized_files = (Join-Path -Path (Split-Path -Parent -Path $PROFILE) -ChildPath $(switch($HOST.UI.RawUI.BackgroundColor.ToString()){'White'{'Set-SolarizedLightColorDefaults.ps1'}'Black'{'Set-SolarizedDarkColorDefaults.ps1'}default{return}}))
foreach ( $solarized_file in $solarized_files ) {
        Unblock-File $solarized_file
        . $solarized_file
}

# Check this guys default's out at some point
# https://github.com/mikemaccana/powershell-profile/

# Path Changes
$bin_path="${home}\bin"
$pdk_path="C:\Program Files\Puppet Labs\DevelopmentKit\bin"
$android_platform_path = "${HOME}\AppData\Local\Android\Sdk\platform-tools"

# Add any missing paths from our existing path value
$new_paths = $bin_path, $pdk_path, $android_platform_path
foreach ( $new_path in $new_paths ) {
    $current_path = [Environment]::GetEnvironmentVariable("Path",
        [EnvironmentVariableTarget]::User)
    $new_pattern = [regex]::Escape($new_path)
    if ($current_path -notmatch $new_pattern) {
        Write-Host "Adding '${new_path}' to User Path"
        [Environment]::SetEnvironmentVariable(
           "Path",
            "${current_path};${new_path}",
            [EnvironmentVariableTarget]::User)
    }
}


# Aliases
New-Alias which Get-Command
'gvim','vim' | foreach-Object {
    $c = $_
    New-Alias -Name $c -Value (Get-Command "${c}").Source
}
New-Alias -Name vi -Value (
    Get-Command -Name vim -CommandType Application `
        | Select-Object -First 1
    ).Source
New-Alias -Name sshno -Value "$((get-command ssh).Source) -o UserKnownHostsFile=$null -o StrictHostKeyChecking=no"
Set-PSReadlineOption -EditMode vi -BellStyle None

# Set Default Editor (Needed for Chezmoi)
$vim="vim.exe"
if ([Environment]::GetEnvironmentVariable("EDITOR", [EnvironmentVariableTarget]::User) -ne $vim) {
    [Environment]::SetEnvironmentVariable(
        "EDITOR",
        "${vim}",
        [EnvironmentVariableTarget]::User)
}

# Change how powershell does tab completion
# http://stackoverflow.com/questions/39221953/can-i-make-powershell-tab-complete-show-me-all-options-rather-than-picking-a-sp
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Should really be name=value like Unix version of export but not a big deal
function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	get-process $name -ErrorAction SilentlyContinue | stop-process
}

function pgrep($name) {
	get-process $name
}

# Like Unix touch, creates new files and updates time on old ones
# PSCX has a touch, but it doesn't make empty files
#Remove-Alias touch
function touch($file) {
	if ( Test-Path $file ) {
		Set-FileTime $file
	} else {
		New-Item $file -type file
	}
}

# From https://stackoverflow.com/questions/894430/creating-hard-and-soft-links-using-powershell
function ln($target, $link) {
	New-Item -ItemType SymbolicLink -Path $link -Value $target
}

set-alias new-link ln

# Attempt to import posh-sshell and posh-git
$modules = "posh-sshell","posh-git"
foreach($module in $modules) {
    try {
        Import-Module $module `
            -ErrorAction Stop
        # Importing Keys
        #Start-SshAgent -Quiet
    } catch {
        Write-Host "${module}: missing, attempting to install!"
        Install-Module $module -Scope CurrentUser `
            -AllowPrerelease -Force
    }
}

function Get-ADPasswordStatus {
    param(
        [Parameter(Mandatory=$true)][String] $Identity,
        [Parameter(Mandatory=$false)][String] $Server
    )

    $params = @{
        Identity = $Identity
    }
    if("" -ne $Server) {
        $params["Server"] = $Server
    }

    $u = Get-ADUser @params `
        -Properties CannotChangePassword, LastBadPasswordAttempt, `
            LastLogonDate, LockedOut, PasswordExpired, `
            PasswordLastSet, PasswordNeverExpires, pwdLastSet, `
            DisplayName
    $policy = Get-ADDefaultDomainPasswordPolicy
    $date = Get-Date
    if($u.PasswordNeverExpires) {
        $expirationDate = $null
        $remainingDays = $null
    } else {
        $expirationDate = if($null -ne $u.passwordLastSet) {
            $u.passwordLastSet.AddDays($policy.MaxPasswordAge.Days)
        } else {
            $null
        }
        $remainingDays = ($expirationDate - $date).Days
    }
    [PSCustomObject]@{
        SamAccountName          = $u.SamAccountName
        DisplayName             = $u.DisplayName
        LastLogonDate           = $u.LastLogonDate
        PasswordLastSet         = $u.PasswordLastSet
        LastBadPasswordAttempt  = $u.LastBadPasswordAttempt
        LockedOut               = $u.LockedOut
        ExpirationDate          = $expirationDate
        RemainingDays           = $remainingDays
        Enabled                 = $u.Enabled
        PasswordExpired         = $u.PasswordExpired
        CannotChangePassword    = $u.CannotChangePassword
        PasswordNeverExpires    = $u.PasswordNeverExpires
    }
}

function Get-AdminCredential {
    param(
        [Parameter(Mandatory=$true)][ValidateSet("CGP","ARDEN","AS")][String] $Domain
    )
    switch($Domain) {
        ('CGP') {
            $account = "adm_${env:USERNAME}"
            $server = "bfmdccgp01.cgp.ad.cent.com"
            break
        }
        ('ARDEN') {
            $account = "${env:USERNAME}-it0"
            $server = "bf0-dc01.ardencompanies.com"
            break
        }
        ('AS') {
            $account = "${env:USERNAME}-it0"
            $server = "as0-dc01.as.ardencompanies.com"
            break
        }
    }

    $cred = Get-Credential "${Domain}\${account}"

    try {
        Import-Module ActiveDirectory -ErrorAction Stop `
            | Out-Null
        Get-ADUser -Identity $account -Server $server `
            -Credential $cred `
            | Out-Null
    } catch {
        Write-Warning "Could not validate credential"
        Write-Warning $_
    }
    
    # Return the credential
    $cred
}

# Set Android Home variable
$android_home = "${HOME}\AppData\Local\Android\Sdk"
if ([Environment]::GetEnvironmentVariable("ANDROID_HOME", [EnvironmentVariableTarget]::User) -ne $android_home) {
    [Environment]::SetEnvironmentVariable(
        "ANDROID_HOME",
        "${android_home}",
        [EnvironmentVariableTarget]::User)
}
