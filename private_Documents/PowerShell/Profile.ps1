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
$vim_path="C:\Program Files (x86)\Vim\vim81"
$bin_path="${home}\bin"

# Add any missing paths from our existing path value
$new_paths = $bin_path, $vim_path
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
New-Alias -Name vi -Value "${vim_path}\vim.exe"
New-Alias -Name vim -Value "${vim_path}\vim.exe"
Set-PSReadlineOption -EditMode vi -BellStyle None

# Set Default Editor (Needed for Chezmoi)
$vim="${vim_path}\vim.exe"
if ([Environment]::GetEnvironmentVariable("EDITOR", [EnvironmentVariableTarget]::User) -ne $vim) {
    [Environment]::SetEnvironmentVariable(
        "EDITOR",
        "${vim}",
        [EnvironmentVariableTarget]::User)
}
