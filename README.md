# Prep

## Linux / Unix

1. Install chezmoi somehow

## Windows

1. Create a local bin directory

  ```PowerShell
  mkdir -p "${home}\bin"
  ```
1. Download the latest release of chezmoi and put the binary in the directory listed above.
1. Ensure gvim is installed and is included in the path. You can get this in your powershell path via

    ```PowerShell
    $vim_path="C:\Program Files (x86)\vim\vim81\

    # Temporary
    $env:Path += ";${vim_path}"

    # Permanent
    [Environment]::SetEnvironmentVariable(
        "Path",
        [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";${vim_path}",
        [EnvironmentVariableTarget]::User)
    ```
1. Permanently set the `EDITOR` user environment variable to `vim.exe`. 

    ```PowerShell
    $vim="${vim_path}\vim.exe"
    [Environment]::SetEnvironmentVariable(
        "EDITOR",
        "${vim}",
        [EnvironmentVariableTarget]::User)
    ```
1. Create a chezmoi config file

    ```Powershell
    mkdir -p "${home}\.config\chezmoi\"
    vim "${home}\.config\chezmoi\"
    ```
1. Add an entry similar to the following

    ```YAML
    ---
    merge.command: 'C:\Program Files (x86)\Vim\vim81\diff.exe'
    ```
1. Close and reopen powershell (it doesn't update the environment variables)



# Initial Setup

```bash
chezmoi init --apply https://github.com/pdemonaco/dotfiles.git
```

```Powershell
.\bin\chezmoi.exe init --apply https://github.com/pdemonaco/dotfiles.git
```
