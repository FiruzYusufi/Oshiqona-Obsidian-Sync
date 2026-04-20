# Полная миграция проекта Oshiqona в Obsidian Vault
# Автор: Kiro AI
# Дата: 2026-04-20

param(
    [string]$VaultPath = "C:\Users\Robita\Documents\Obsidian Vault\Проекты\Oshiqona",
    [switch]$Force = $false
)

Write-Host "🚀 Начинаем полную миграцию в Obsidian Vault..." -ForegroundColor Green
Write-Host "📍 Целевая папка: $VaultPath" -ForegroundColor Cyan

# Создаём улучшенную структуру папок
$folders = @{
    "00-Главная" = "Главная страница и навигация"
    "01-Документация" = "Основная документация проекта"
    "02-Архитектура" = "Архитектурные решения и схемы"
    "03-Диаграммы" = "Excalidraw диаграммы и схемы"
    "04-API-Документация" = "REST API и SignalR документация"
    "05-Компоненты" = "Angular компоненты и их описание"
    "06-Сервисы" = "Сервисы и бизнес-логика"
    "07-Тестирование" = "Тесты, покрытие, стратегии"
    "08-Развертывание" = "CI/CD, Docker, развертывание"
    "09-Управление-Проектом" = "Kanban, спринты, задачи"
    "10-Базы-Знаний" = "Структурированные данные"
    "11-Шаблоны" = "Templater шаблоны"
    "12-Дневники" = "Ежедневные и еженедельные записи"
    "13-Ресурсы" = "Ссылки, документы, материалы"
    "14-Конфигурации" = "Настройки Obsidian и плагинов"
    "15-Скрипты" = "Автоматизация и утилиты"
}

# Создаём структуру папок
Write-Host "`n📁 Создание структуры папок..." -ForegroundColor Yellow
foreach ($folder in $folders.Keys) {
    $folderPath = Join-Path $VaultPath $folder
    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
        Write-Host "  ✅ $folder - $($folders[$folder])" -ForegroundColor Green
    } else {
        Write-Host "  📁 $folder - уже существует" -ForegroundColor Gray
    }
}

# Функция для безопасного копирования файлов с кодировкой UTF-8
function Copy-FileWithEncoding {
    param(
        [string]$SourcePath,
        [string]$DestinationPath,
        [switch]$Force
    )
    
    try {
        if (Test-Path $SourcePath) {
            # Создаём папку назначения если не существует
            $destDir = Split-Path $DestinationPath -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            # Читаем и записываем с правильной кодировкой
            $content = [System.IO.File]::ReadAllText($SourcePath, [System.Text.Encoding]::UTF8)
            [System.IO.File]::WriteAllText($DestinationPath, $content, [System.Text.Encoding]::UTF8)
            
            return $true
        }
    } catch {
        Write-Host "    ❌ Ошибка копирования: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    
    return $false
}

# Миграция файлов по категориям
Write-Host "`n📄 Миграция файлов..." -ForegroundColor Yellow

# 1. Главная страница и навигация
Write-Host "  📋 Главная страница..." -ForegroundColor Cyan
$mainFiles = @{
    "Главная.md" = "00-Главная/Главная.md"
    "Дашборд.md" = "00-Главная/Дашборд.md"
    "README.md" = "00-Главная/README.md"
}

foreach ($file in $mainFiles.Keys) {
    $source = $file
    $dest = Join-Path $VaultPath $mainFiles[$file]
    if (Copy-FileWithEncoding -SourcePath $source -DestinationPath $dest -Force:$Force) {
        Write-Host "    ✅ $file → $($mainFiles[$file])" -ForegroundColor Green
    }
}

# 2. Документация
Write-Host "  📖 Документация..." -ForegroundColor Cyan
$docSource = "..\DOCUMENTATION"
if (Test-Path $docSource) {
    Get-ChildItem $docSource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "01-Документация\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 3. Диаграммы
Write-Host "  🖼️ Диаграммы..." -ForegroundColor Cyan
$diagramSource = "Рисунки"
if (Test-Path $diagramSource) {
    Get-ChildItem $diagramSource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "03-Диаграммы\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 4. Управление проектом (Kanban)
Write-Host "  🎯 Управление проектом..." -ForegroundColor Cyan
$kanbanSource = "Kanban"
if (Test-Path $kanbanSource) {
    Get-ChildItem $kanbanSource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "09-Управление-Проектом\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 5. Базы знаний
Write-Host "  📊 Базы знаний..." -ForegroundColor Cyan
$basesSource = "Базы"
if (Test-Path $basesSource) {
    Get-ChildItem $basesSource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "10-Базы-Знаний\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 6. Шаблоны
Write-Host "  📝 Шаблоны..." -ForegroundColor Cyan
$templatesSource = "Шаблоны"
if (Test-Path $templatesSource) {
    Get-ChildItem $templatesSource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "11-Шаблоны\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 7. Дневники
Write-Host "  📅 Дневники..." -ForegroundColor Cyan
$diarySource = "Дневник"
if (Test-Path $diarySource) {
    Get-ChildItem $diarySource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "12-Дневники\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 8. Ресурсы
Write-Host "  🔗 Ресурсы..." -ForegroundColor Cyan
$resourcesSource = "Ресурсы"
if (Test-Path $resourcesSource) {
    Get-ChildItem $resourcesSource -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $VaultPath "13-Ресурсы\$($_.Name)"
        if (Copy-FileWithEncoding -SourcePath $_.FullName -DestinationPath $dest -Force:$Force) {
            Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
        }
    }
}

# 9. Конфигурации
Write-Host "  ⚙️ Конфигурации..." -ForegroundColor Cyan
$configSource = ".obsidian-config"
if (Test-Path $configSource) {
    # Копируем всю структуру конфигураций
    $configDest = Join-Path $VaultPath "14-Конфигурации\.obsidian-config"
    if (-not (Test-Path $configDest)) {
        New-Item -ItemType Directory -Path $configDest -Force | Out-Null
    }
    
    Copy-Item -Path "$configSource\*" -Destination $configDest -Recurse -Force
    Write-Host "    ✅ Конфигурации плагинов скопированы" -ForegroundColor Green
}

# 10. Скрипты
Write-Host "  🔧 Скрипты..." -ForegroundColor Cyan
$scriptFiles = @("migrate-to-obsidian.ps1", "sync-to-obsidian.ps1", ".gitignore")
foreach ($script in $scriptFiles) {
    if (Test-Path $script) {
        $dest = Join-Path $VaultPath "15-Скрипты\$script"
        Copy-Item -Path $script -Destination $dest -Force
        Write-Host "    ✅ $script" -ForegroundColor Green
    }
}

# Подсчёт результатов
Write-Host "`n📊 Результаты миграции:" -ForegroundColor Yellow
$totalFiles = (Get-ChildItem $VaultPath -Recurse -Filter "*.md").Count
$totalFolders = (Get-ChildItem $VaultPath -Directory -Recurse).Count + (Get-ChildItem $VaultPath -Directory).Count

Write-Host "  📄 Всего MD файлов: $totalFiles" -ForegroundColor Green
Write-Host "  📁 Всего папок: $totalFolders" -ForegroundColor Green
Write-Host "  📍 Расположение: $VaultPath" -ForegroundColor Cyan

Write-Host "`n🎉 Миграция завершена успешно!" -ForegroundColor Green
Write-Host "💡 Откройте Obsidian и перейдите к папке проекта для начала работы." -ForegroundColor Yellow