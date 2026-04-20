# Simple migration script for Obsidian
$vaultPath = "C:\Users\Robita\Documents\Obsidian Vault\Проекты\Oshiqona"

Write-Host "Starting migration to Obsidian Vault..." -ForegroundColor Green

# Create folder structure
$folders = @(
    "00-Main",
    "01-Documentation", 
    "02-Architecture",
    "03-Diagrams",
    "04-API-Docs",
    "05-Components",
    "06-Services", 
    "07-Testing",
    "08-Deployment",
    "09-Project-Management",
    "10-Knowledge-Base",
    "11-Templates",
    "12-Journals",
    "13-Resources",
    "14-Configurations",
    "15-Scripts"
)

foreach ($folder in $folders) {
    $folderPath = Join-Path $vaultPath $folder
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
        Write-Host "Created: $folder" -ForegroundColor Green
    }
}

# Copy main files
if (Test-Path "Главная.md") {
    Copy-Item "Главная.md" "$vaultPath\00-Main\Home.md" -Force
    Write-Host "Copied: Home.md" -ForegroundColor Green
}

if (Test-Path "Дашборд.md") {
    Copy-Item "Дашборд.md" "$vaultPath\00-Main\Dashboard.md" -Force
    Write-Host "Copied: Dashboard.md" -ForegroundColor Green
}

if (Test-Path "README.md") {
    Copy-Item "README.md" "$vaultPath\00-Main\README.md" -Force
    Write-Host "Copied: README.md" -ForegroundColor Green
}

# Copy documentation
if (Test-Path "..\DOCUMENTATION") {
    Get-ChildItem "..\DOCUMENTATION" -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName "$vaultPath\01-Documentation\$($_.Name)" -Force
        Write-Host "Copied: $($_.Name)" -ForegroundColor Green
    }
}

# Copy diagrams
if (Test-Path "Рисунки") {
    Get-ChildItem "Рисунки" -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName "$vaultPath\03-Diagrams\$($_.Name)" -Force
        Write-Host "Copied diagram: $($_.Name)" -ForegroundColor Green
    }
}

# Copy other folders
$sourceFolders = @{
    "Kanban" = "09-Project-Management"
    "Базы" = "10-Knowledge-Base"
    "Шаблоны" = "11-Templates"
    "Дневник" = "12-Journals"
    "Ресурсы" = "13-Resources"
}

foreach ($source in $sourceFolders.Keys) {
    if (Test-Path $source) {
        $dest = $sourceFolders[$source]
        Get-ChildItem $source -Filter "*.md" | ForEach-Object {
            Copy-Item $_.FullName "$vaultPath\$dest\$($_.Name)" -Force
            Write-Host "Copied: $source\$($_.Name)" -ForegroundColor Green
        }
    }
}

# Copy configurations
if (Test-Path ".obsidian-config") {
    Copy-Item ".obsidian-config" "$vaultPath\14-Configurations\.obsidian-config" -Recurse -Force
    Write-Host "Copied: Configurations" -ForegroundColor Green
}

# Copy scripts
Copy-Item "*.ps1" "$vaultPath\15-Scripts\" -Force
Copy-Item ".gitignore" "$vaultPath\15-Scripts\" -Force

$totalFiles = (Get-ChildItem $vaultPath -Recurse -Filter "*.md").Count
Write-Host "`nMigration completed! Total MD files: $totalFiles" -ForegroundColor Yellow