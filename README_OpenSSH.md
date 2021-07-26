1. Remove the OS feature

    ```PowerShell
    dism.exe /online /remove-capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0
    ```
1. Download the latest version of OpenSSH for windows from [here](https://github.com/PowerShell/Win32-OpenSSH/releases).
1. Extract the zip to the root of the C drive (for convenience)

    ```PowerShell
    $archive = "${home}\downloads\OpenSSH-Win64.zip"
    Expand-Archive -Path $archive -DestinationPath 'c:\'
    ```
1. Set the permissions appropriately

    ```PowerShell
    $ssh_path = "C:\OpenSSH-Win64"
    $acl = Get-Acl $ssh_path
    
    # Configure the owner
    $owner = New-Object `
      -TypeName System.Security.Principal.NTAccount `
      -ArgumentList @("Builtin","Administrators")
    $acl.SetOwner($owner)

    # Give Builtin Administrators and SYSTEM full control
    $rules = @{
      "BUILTIN\Administrators" = @{
        "Rights"      = @("FullControl")
        "Inheritance" = @("ContainerInherit","ObjectInherit")
        "Propagation" = @("None")
        "Type"        = "Allow"
      };
      "NT AUTHORITY\SYSTEM" = @{
        "Rights"      = @("FullControl")
        "Inheritance" = @("ContainerInherit","ObjectInherit")
        "Propagation" = @("None")
        "Type"        = "Allow"
      }
      "BUILTIN\Users" = @{
        "Rights"      = @("ReadAndExecute", "Synchronize")
        "Inheritance" = @("ContainerInherit","ObjectInherit")
        "Propagation" = @("None")
        "Type"        = "Allow"
      }
      "NT AUTHORITY\Authenticated Users" = @{
        "Rights"      = @("ReadAndExecute", "Synchronize")
        "Inheritance" = @("ContainerInherit","ObjectInherit")
        "Propagation" = @("None")
        "Type"        = "Allow"
      }
    }
    foreach($r in $rules.GetEnumerator()) {
      $name = $r.Key
      $data = $r.Value
      $args = @(
        $name,
        $data.Rights,
        $data.Inheritance
        $data.Propagation
        $data.Type
      )
      $rule = New-Object `
        -TypeName System.Security.AccessControl.FileSystemAccessRule `
        -ArgumentList $args
      $acl.SetAccessRule($rule)
    }

    # Disable inheritance without preserving rules
    $acl.SetAccessRuleProtection($True, $False)

    Set-Acl -Path $ssh_path -AclObject $acl
    ```
1. Add the new location to the system path.

    ```PowerShell
    $new_path = $ssh_path
    $target = [EnvironmentVariableTarget]::Machine
    $current_path = [Environment]::GetEnvironmentVariable(
      "Path",
      $target)
    $new_pattern = [regex]::Escape($new_path)
    if ($current_path -notmatch $new_pattern) {
        Write-Host "Adding '${new_path}' to User Path"
        [Environment]::SetEnvironmentVariable(
           "Path",
            "${current_path};${new_path}",
            $target)
    }
    ```
1. Finally, install the services

    ```PowerShell
    powershell.exe -ExecutionPolicy Bypass -File $ssh_path\install-sshd.ps1
    ```

