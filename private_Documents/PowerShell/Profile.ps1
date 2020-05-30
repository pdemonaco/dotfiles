# See https://github.com/neilpa/cmd-colors-solarized for detail
# Include the solarized files
$solarized_files = (Join-Path -Path (Split-Path -Parent -Path $PROFILE) -ChildPath $(switch($HOST.UI.RawUI.BackgroundColor.ToString()){'White'{'Set-SolarizedLightColorDefaults.ps1'}'Black'{'Set-SolarizedDarkColorDefaults.ps1'}default{return}}))
foreach ( $solarized_file in $solarized_files ) {
        Unblock-File $solarized_file
        . $solarized_file
}

# Check this guys default's out at some point
# https://github.com/mikemaccana/powershell-profile/

# Identify vim path
$vim_versions = @(
    "C:\Program Files\vim\vim82",
    "C:\Program Files (x86)\Vim\vim81"
)

foreach ( $vim in $vim_versions ) {
    $vim_exists = Test-Path `
        $vim `
        -PathType Container

    if ($vim_exists -eq $true) {
        $vim_path = $vim
        break
    }
}

# Path Changes
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
New-Alias -Name gvim -Value "${vim_path}\gvim.exe"
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


