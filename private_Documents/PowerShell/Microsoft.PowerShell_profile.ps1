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
$env:Path += ";${home}\bin\"
$vim_path="C:\Program Files (x86)\Vim\vim81"
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";${vim_path}",
    [EnvironmentVariableTarget]::User)

# Aliases
New-Alias which Get-Command
New-Alias -Name vi -Value "${vim_path}\vim.exe"
New-Alias -Name vim -Value "${vim_path}\vim.exe"
Set-PSReadlineOption -EditMode vi -BellStyle None

# Chezmoi Settings
$vim="${vim_path}\vim.exe"
[Environment]::SetEnvironmentVariable(
    "EDITOR",
    "${vim}",
    [EnvironmentVariableTarget]::User)
