param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ProjectPath
)

$ErrorActionPreference = "Stop"

# Install speckit skills
Write-Host "Installing speckit skills..."
Push-Location $ProjectPath
try {
    specify init . --ai claude
} finally {
    Pop-Location
}

# Layer speckit.auto on top
$Target = Join-Path $ProjectPath ".claude" "commands"
New-Item -ItemType Directory -Path $Target -Force | Out-Null
Copy-Item (Join-Path $PSScriptRoot "commands" "speckit.auto.md") -Destination $Target
Write-Host "Installed speckit.auto.md to $Target/"
