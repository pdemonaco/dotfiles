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
    $vim_path="C:\Program Files (x86)\vim\vim80\

    # Temporary
    $env:Path += ";$env:Path += ";${vim_path}"

    # Permanent
    [Environment]::SetEnvironmentVariable(
        "Path",
        [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";${vim_path}",
        [EnvironmentVariableTarget]::User)
    ```
1. Ensure `vi.exe` exists in the vim binary directory.

# Initial Setup

```bash
chezmoi init --apply https://github.com/pdemonaco/dotfiles.git
```

```Powershell
.\bin\chezmoi.exe init --apply https://github.com/pdemonaco/dotfiles.git
```
