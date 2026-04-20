# ============================================================
# sync-to-obsidian.ps1
# Синхронизация документации Oshiqona с Obsidian Vault
# Запуск: .\sync-to-obsidian.ps1
# ============================================================

param(
    [string]$VaultPath = "C:\Users\Robita\Documents\Obsidian Vault",
    [string]$ProjectPath = $PSScriptRoot,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$target = "$VaultPath\Проекты\Oshiqona"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Oshiqona → Obsidian Sync" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Source : $ProjectPath" -ForegroundColor Gray
Write-Host "Target : $target" -ForegroundColor Gray
Write-Host ""

# ── 1. Создать папки ──────────────────────────────────────
$folders = @(
    "Документация",
    "Kanban",
    "Базы",
    "Шаблоны",
    "Дневник",
    "Рисунки",
    "Заметки",
    "Ресурсы",
    "Релизы",
    "Тесты",
    "Конфигурация"
)

Write-Host "Создание папок..." -ForegroundColor Yellow
foreach ($f in $folders) {
    $path = "$target\$f"
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "  + $f" -ForegroundColor Green
    }
}

# ── 2. Копировать файлы ───────────────────────────────────
function Copy-UTF8 {
    param([string]$Src, [string]$Dst)
    $content = [System.IO.File]::ReadAllText($Src, [System.Text.Encoding]::UTF8)
    [System.IO.File]::WriteAllText($Dst, $content, [System.Text.Encoding]::UTF8)
}

# Документация
Write-Host ""
Write-Host "Копирование документации..." -ForegroundColor Yellow
$docSrc = "$ProjectPath\Документация"
$docDst = "$target\Документация"
if (Test-Path $docSrc) {
    Get-ChildItem "$docSrc\*.md" | ForEach-Object {
        Copy-UTF8 $_.FullName "$docDst\$($_.Name)"
        Write-Host "  + $($_.Name)" -ForegroundColor Green
    }
}

# Все остальные папки
$syncFolders = @("Kanban","Базы","Шаблоны","Дневник","Рисунки","Заметки","Ресурсы","Релизы")
foreach ($f in $syncFolders) {
    $srcDir = "$ProjectPath\$f"
    $dstDir = "$target\$f"
    if (Test-Path $srcDir) {
        Write-Host ""
        Write-Host "Копирование $f..." -ForegroundColor Yellow
        Get-ChildItem "$srcDir\*.md" | ForEach-Object {
            Copy-UTF8 $_.FullName "$dstDir\$($_.Name)"
            Write-Host "  + $($_.Name)" -ForegroundColor Green
        }
    }
}

# Главная страница
if (Test-Path "$ProjectPath\Главная.md") {
    Copy-UTF8 "$ProjectPath\Главная.md" "$target\Главная.md"
    Write-Host ""
    Write-Host "  + Главная.md" -ForegroundColor Green
}

# ── 3. Конфигурация плагинов ──────────────────────────────
Write-Host ""
Write-Host "Применение конфигурации плагинов..." -ForegroundColor Yellow

$pluginConfigs = @{
    "templater-obsidian" = "templater.json"
    "dataview"           = "dataview.json"
    "obsidian-kanban"    = "kanban.json"
    "obsidian-git"       = "obsidian-git.json"
    "obsidian-tasks-plugin" = "tasks.json"
}

$obsidianPluginsPath = "$VaultPath\.obsidian\plugins"
$configSrc = "$ProjectPath\.obsidian-config"

foreach ($plugin in $pluginConfigs.Keys) {
    $configFile = $pluginConfigs[$plugin]
    $srcFile = "$configSrc\$configFile"
    $dstDir  = "$obsidianPluginsPath\$plugin"
    $dstFile = "$dstDir\data.json"

    if ((Test-Path $srcFile) -and (Test-Path $dstDir)) {
        Copy-UTF8 $srcFile $dstFile
        Write-Host "  + $plugin config" -ForegroundColor Green
    }
}

# Graph config
$graphSrc = "$configSrc\graph.json"
$graphDst = "$VaultPath\.obsidian\graph.json"
if (Test-Path $graphSrc) {
    Copy-UTF8 $graphSrc $graphDst
    Write-Host "  + graph.json" -ForegroundColor Green
}

# ── 4. Итог ───────────────────────────────────────────────
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
$count = (Get-ChildItem $target -Recurse -Filter "*.md").Count
Write-Host "  Готово! Скопировано файлов: $count" -ForegroundColor Green
Write-Host "  Vault: $target" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Откройте Obsidian и перезагрузите Vault (Ctrl+R)" -ForegroundColor Yellow
Write-Host ""
