# Simple Complete Migration Script
# Avoids PowerShell encoding issues with Cyrillic text

param(
    [string]$VaultPath = "C:\Users\Robita\Documents\Obsidian Vault\Проекты\Oshiqona"
)

Write-Host "Starting complete migration to Obsidian Vault..." -ForegroundColor Green
Write-Host "Target path: $VaultPath" -ForegroundColor Cyan

# Create folder structure
$folders = @(
    "00-Main",
    "01-Documentation", 
    "02-Architecture",
    "03-Diagrams",
    "04-API-Documentation",
    "05-Components",
    "06-Services", 
    "07-Testing",
    "08-Deployment",
    "09-Project-Management",
    "10-Knowledge-Base",
    "11-Templates",
    "12-Daily-Notes", 
    "13-Resources",
    "14-Configuration",
    "15-Scripts"
)

Write-Host "Creating folder structure..." -ForegroundColor Yellow
foreach ($folder in $folders) {
    $folderPath = Join-Path $VaultPath $folder
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
        Write-Host "  Created: $folder" -ForegroundColor Green
    }
}

# Copy files using .NET methods to handle encoding properly
Write-Host "Migrating files..." -ForegroundColor Yellow

# Main files
$mainFiles = @("Главная.md", "Дашборд.md", "README.md", "improved-home.md")
foreach ($file in $mainFiles) {
    if (Test-Path $file) {
        $dest = Join-Path $VaultPath "00-Main\$file"
        $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $file to 00-Main" -ForegroundColor Green
    }
}

# Documentation files
if (Test-Path "..\DOCUMENTATION") {
    Get-ChildItem "..\DOCUMENTATION" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "01-Documentation\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 01-Documentation" -ForegroundColor Green
    }
}

# Diagrams
if (Test-Path "Рисунки") {
    Get-ChildItem "Рисунки" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "03-Diagrams\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 03-Diagrams" -ForegroundColor Green
    }
}

# Project Management (Kanban)
if (Test-Path "Kanban") {
    Get-ChildItem "Kanban" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "09-Project-Management\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 09-Project-Management" -ForegroundColor Green
    }
}

# Knowledge Base
if (Test-Path "Базы") {
    Get-ChildItem "Базы" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "10-Knowledge-Base\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 10-Knowledge-Base" -ForegroundColor Green
    }
}

# Templates
if (Test-Path "Шаблоны") {
    Get-ChildItem "Шаблоны" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "11-Templates\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 11-Templates" -ForegroundColor Green
    }
}

# Daily Notes
if (Test-Path "Дневник") {
    Get-ChildItem "Дневник" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "12-Daily-Notes\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 12-Daily-Notes" -ForegroundColor Green
    }
}

# Resources
if (Test-Path "Ресурсы") {
    Get-ChildItem "Ресурсы" -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "13-Resources\$($_.Name)"
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText($dest, $content, [System.Text.Encoding]::UTF8)
        Write-Host "  Copied: $($_.Name) to 13-Resources" -ForegroundColor Green
    }
}

# Configuration
if (Test-Path ".obsidian-config") {
    Copy-Item -Path ".obsidian-config\*" -Destination (Join-Path $VaultPath "14-Configuration") -Recurse -Force
    Write-Host "  Copied: Obsidian configurations to 14-Configuration" -ForegroundColor Green
}

# Scripts
$scriptFiles = @("*.ps1", "*.cs", "*.exe", ".gitignore", "kiro-obsidian-sync.md")
foreach ($pattern in $scriptFiles) {
    Get-ChildItem -Filter $pattern | ForEach-Object {
        $dest = Join-Path $VaultPath "15-Scripts\$($_.Name)"
        Copy-Item -Path $_.FullName -Destination $dest -Force
        Write-Host "  Copied: $($_.Name) to 15-Scripts" -ForegroundColor Green
    }
}

Write-Host "Migration completed successfully!" -ForegroundColor Green