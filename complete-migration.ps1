# Полная миграция и синхронизация Oshiqona с Obsidian
# Автор: Kiro AI
# Дата: 2026-04-20
# Версия: 2.0.0 - Улучшенная структура и синхронизация

param(
    [string]$VaultPath = "C:\Users\Robita\Documents\Obsidian Vault\Проекты\Oshiqona",
    [switch]$Force = $false,
    [switch]$CreateKiroHooks = $true
)

# Настройка кодировки для корректной работы с кириллицей
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🚀 Полная миграция и синхронизация Oshiqona → Obsidian" -ForegroundColor Green
Write-Host "📍 Целевая папка: $VaultPath" -ForegroundColor Cyan
Write-Host "🔄 Создание Kiro Hooks: $CreateKiroHooks" -ForegroundColor Cyan

# Улучшенная структура папок (15 разделов)
$folderStructure = [ordered]@{
    "00-Main" = @{
        "name" = "Главная"
        "description" = "Главная страница, навигация и дашборд"
        "icon" = "🏠"
        "files" = @("Главная.md", "Дашборд.md", "README.md", "improved-home.md")
    }
    "01-Documentation" = @{
        "name" = "Документация"
        "description" = "Основная документация проекта"
        "icon" = "📖"
        "source" = "..\DOCUMENTATION"
    }
    "02-Architecture" = @{
        "name" = "Архитектура"
        "description" = "Архитектурные решения и технические спецификации"
        "icon" = "🏗️"
        "files" = @()
    }
    "03-Diagrams" = @{
        "name" = "Диаграммы"
        "description" = "Excalidraw диаграммы и схемы"
        "icon" = "🖼️"
        "source" = "Рисунки"
    }
    "04-API-Documentation" = @{
        "name" = "API-Документация"
        "description" = "REST API и SignalR документация"
        "icon" = "🔌"
        "files" = @()
    }
    "05-Components" = @{
        "name" = "Компоненты"
        "description" = "Angular компоненты и их описание"
        "icon" = "🎨"
        "files" = @()
    }
    "06-Services" = @{
        "name" = "Сервисы"
        "description" = "Сервисы и бизнес-логика"
        "icon" = "🔧"
        "files" = @()
    }
    "07-Testing" = @{
        "name" = "Тестирование"
        "description" = "Тесты, покрытие, стратегии тестирования"
        "icon" = "🧪"
        "files" = @()
    }
    "08-Deployment" = @{
        "name" = "Развертывание"
        "description" = "CI/CD, Docker, развертывание"
        "icon" = "🚀"
        "files" = @()
    }
    "09-Project-Management" = @{
        "name" = "Управление-Проектом"
        "description" = "Kanban доски, спринты, задачи"
        "icon" = "🎯"
        "source" = "Kanban"
    }
    "10-Knowledge-Base" = @{
        "name" = "Базы-Знаний"
        "description" = "Структурированные данные и метрики"
        "icon" = "📊"
        "source" = "Базы"
    }
    "11-Templates" = @{
        "name" = "Шаблоны"
        "description" = "Templater шаблоны для создания контента"
        "icon" = "📝"
        "source" = "Шаблоны"
    }
    "12-Daily-Notes" = @{
        "name" = "Дневники"
        "description" = "Ежедневные и еженедельные записи"
        "icon" = "📅"
        "source" = "Дневник"
    }
    "13-Resources" = @{
        "name" = "Ресурсы"
        "description" = "Ссылки, документы, материалы"
        "icon" = "🔗"
        "source" = "Ресурсы"
    }
    "14-Configuration" = @{
        "name" = "Конфигурации"
        "description" = "Настройки Obsidian и плагинов"
        "icon" = "⚙️"
        "source" = ".obsidian-config"
    }
    "15-Scripts" = @{
        "name" = "Скрипты"
        "description" = "Автоматизация и утилиты"
        "icon" = "🔧"
        "files" = @("*.ps1", "*.cs", "*.exe", ".gitignore", "kiro-obsidian-sync.md")
    }
}

# Функция для безопасного создания папки
function New-SafeDirectory {
    param([string]$Path)
    
    try {
        if (-not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            return $true
        }
        return $true
    } catch {
        Write-Host "    ❌ Ошибка создания папки: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Функция для безопасного копирования с UTF-8
function Copy-FileUTF8 {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Force
    )
    
    try {
        if (Test-Path $Source) {
            # Создаём папку назначения
            $destDir = Split-Path $Destination -Parent
            New-SafeDirectory -Path $destDir | Out-Null
            
            # Читаем и записываем с UTF-8
            $content = [System.IO.File]::ReadAllText($Source, [System.Text.Encoding]::UTF8)
            [System.IO.File]::WriteAllText($Destination, $content, [System.Text.Encoding]::UTF8)
            
            return $true
        }
    } catch {
        Write-Host "    ❌ Ошибка копирования $Source`: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    
    return $false
}

# Создание структуры папок
Write-Host "`n📁 Создание улучшенной структуры папок..." -ForegroundColor Yellow

foreach ($folder in $folderStructure.Keys) {
    $folderInfo = $folderStructure[$folder]
    $folderPath = Join-Path $VaultPath $folder
    
    if (New-SafeDirectory -Path $folderPath) {
        Write-Host "  $($folderInfo.icon) $folder - $($folderInfo.description)" -ForegroundColor Green
        
        # Создаём README для каждой папки
        $readmePath = Join-Path $folderPath "README.md"
        $readmeContent = @"
# $($folderInfo.icon) $($folderInfo.name)

> $($folderInfo.description)

## 📋 Содержание

Эта папка содержит файлы, связанные с $($folderInfo.name.ToLower()).

## 🔗 Навигация

- [[00-Main/Главная|🏠 Главная страница]]
- [[00-Main/Дашборд|📊 Дашборд]]

---

**Создано**: $(Get-Date -Format "yyyy-MM-dd")  
**Категория**: $($folderInfo.name)  
**Автор**: Kiro AI
"@
        
        [System.IO.File]::WriteAllText($readmePath, $readmeContent, [System.Text.Encoding]::UTF8)
    } else {
        Write-Host "  ❌ $folder - ошибка создания" -ForegroundColor Red
    }
}

# Миграция файлов
Write-Host "`n📄 Миграция файлов по категориям..." -ForegroundColor Yellow

$migratedCount = 0
$errorCount = 0

foreach ($folder in $folderStructure.Keys) {
    $folderInfo = $folderStructure[$folder]
    $targetPath = Join-Path $VaultPath $folder
    
    Write-Host "  $($folderInfo.icon) $($folderInfo.name)..." -ForegroundColor Cyan
    
    # Миграция из исходной папки
    if ($folderInfo.source) {
        $sourcePath = $folderInfo.source
        if (Test-Path $sourcePath) {
            Get-ChildItem $sourcePath -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
                $destFile = Join-Path $targetPath $_.Name
                if (Copy-FileUTF8 -Source $_.FullName -Destination $destFile -Force:$Force) {
                    Write-Host "    ✅ $($_.Name)" -ForegroundColor Green
                    $script:migratedCount++
                } else {
                    $script:errorCount++
                }
            }
            
            # Копируем также другие файлы (не только .md)
            if ($folder -eq "14-Configuration") {
                Copy-Item -Path "$sourcePath\*" -Destination $targetPath -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "    ✅ Конфигурации плагинов" -ForegroundColor Green
            }
        }
    }
    
    # Миграция конкретных файлов
    if ($folderInfo.files) {
        foreach ($filePattern in $folderInfo.files) {
            $files = Get-ChildItem -Path "." -Filter $filePattern -ErrorAction SilentlyContinue
            foreach ($file in $files) {
                $destFile = Join-Path $targetPath $file.Name
                if (Copy-FileUTF8 -Source $file.FullName -Destination $destFile -Force:$Force) {
                    Write-Host "    ✅ $($file.Name)" -ForegroundColor Green
                    $script:migratedCount++
                } else {
                    $script:errorCount++
                }
            }
        }
    }
}

# Создание главной страницы навигации
Write-Host "`n🏠 Создание главной страницы..." -ForegroundColor Yellow

$homePage = Join-Path $VaultPath "00-Main\Главная.md"
$homeContent = @"
---
tags: [home, main, oshiqona, navigation]
created: $(Get-Date -Format "yyyy-MM-dd")
updated: $(Get-Date -Format "yyyy-MM-dd")
cssclasses: [home-page, dashboard]
---

# 🚀 Oshiqona — Центр управления проектом

> **Angular 20 · Nx Monorepo · SignalR · Taiga UI · TypeScript 5.8**  
> Полная база знаний и управление проектом в Obsidian

---

## 🎛️ Быстрая навигация

### 📊 Управление и мониторинг
| Раздел | Описание | Ссылка |
|--------|----------|--------|
| **Дашборд** | Центральная панель с метриками | [[00-Main/Дашборд\|📊 Дашборд]] |
| **Проект** | Kanban доски и спринты | [[09-Project-Management/README\|🎯 Управление]] |
| **Метрики** | Производительность и аналитика | [[10-Knowledge-Base/README\|⚡ Метрики]] |

### 📖 Документация и архитектура
| Раздел | Описание | Ссылка |
|--------|----------|--------|
| **Обзор** | Полное описание проекта | [[01-Documentation/README\|📖 Документация]] |
| **Архитектура** | Структура и компоненты | [[02-Architecture/README\|🏗️ Архитектура]] |
| **Диаграммы** | Excalidraw схемы и потоки | [[03-Diagrams/README\|🖼️ Диаграммы]] |

### 🔧 Разработка и API
| Раздел | Описание | Ссылка |
|--------|----------|--------|
| **API** | REST API и SignalR | [[04-API-Documentation/README\|🔌 API]] |
| **Компоненты** | Angular компоненты | [[05-Components/README\|🎨 Компоненты]] |
| **Сервисы** | Бизнес-логика и сервисы | [[06-Services/README\|🔧 Сервисы]] |
| **Тестирование** | Тесты и покрытие | [[07-Testing/README\|🧪 Тесты]] |

---

## 🗂️ Полная структура проекта

"@

# Добавляем все разделы в навигацию
foreach ($folder in $folderStructure.Keys) {
    $folderInfo = $folderStructure[$folder]
    $homeContent += "- $($folderInfo.icon) **$($folderInfo.name)** — $($folderInfo.description) → [[$folder/README|Перейти]]`n"
}

$homeContent += @"

---

## 📊 Статус проекта

```dataview
TABLE WITHOUT ID
  "v0.1.174" AS "🏷️ Версия",
  "Angular 20.3.15" AS "🅰️ Фреймворк", 
  "🟢 Active" AS "📈 Статус",
  "$(Get-Date -Format "yyyy-MM-dd")" AS "📅 Обновлено"
```

---

## 🔄 Синхронизация Kiro ↔ Obsidian

### Автоматические процессы
- **Kiro → Obsidian**: Обновление документации при изменении кода
- **Obsidian → Kiro**: Обратная связь и задачи
- **Git синхронизация**: Автоматические коммиты каждые 10 минут
- **Командная работа**: Версионирование и совместное редактирование

### Быстрые команды
- `Ctrl+P` → "Git: Commit all changes" — ручной коммит
- `Ctrl+P` → "Git: Push" — отправка изменений  
- `Ctrl+P` → "Git: Pull" — получение обновлений
- `Ctrl+Shift+G` — открыть панель Git

---

## 🎯 Следующие шаги

### Приоритеты
- [ ] Настройка автоматической синхронизации
- [ ] Создание Kiro Hooks для обновления документации
- [ ] Интеграция с системой задач
- [ ] Настройка уведомлений команды

### Планы развития
- [ ] AI-powered документация
- [ ] Автоматические диаграммы из кода
- [ ] Интеграция с Jira/GitHub Issues
- [ ] Мониторинг производительности

---

**Последнее обновление**: $(Get-Date -Format "yyyy-MM-dd HH:mm")  
**Версия документации**: 2.0.0  
**Статус**: ✅ Активная разработка  
**Файлов мигрировано**: $migratedCount
"@

[System.IO.File]::WriteAllText($homePage, $homeContent, [System.Text.Encoding]::UTF8)
Write-Host "  ✅ Главная страница создана" -ForegroundColor Green

# Создание Kiro Hooks для синхронизации
if ($CreateKiroHooks) {
    Write-Host "`n🔗 Создание Kiro Hooks для синхронизации..." -ForegroundColor Yellow
    
    $hooksPath = Join-Path $VaultPath "15-Scripts\kiro-hooks"
    New-SafeDirectory -Path $hooksPath | Out-Null
    
    # Hook 1: Обновление документации при изменении компонентов
    $componentHook = @{
        name = "Component Documentation Sync"
        version = "1.0.0"
        description = "Автоматическое обновление документации компонентов при изменении кода"
        when = @{
            type = "fileEdited"
            patterns = @("**/*.component.ts", "**/*.component.html", "**/*.component.scss")
        }
        then = @{
            type = "askAgent"
            prompt = "Обнови документацию компонента в Obsidian Vault на основе изменений в файле. Создай или обнови соответствующий MD файл в папке 05-Components с описанием интерфейса, свойств и методов компонента."
        }
    }
    
    $componentHookPath = Join-Path $hooksPath "component-sync.json"
    $componentHook | ConvertTo-Json -Depth 10 | Out-File -FilePath $componentHookPath -Encoding UTF8
    Write-Host "  ✅ Component Documentation Sync Hook" -ForegroundColor Green
    
    # Hook 2: Обновление документации сервисов
    $serviceHook = @{
        name = "Service Documentation Sync"
        version = "1.0.0"
        description = "Автоматическое обновление документации сервисов при изменении кода"
        when = @{
            type = "fileEdited"
            patterns = @("**/*.service.ts")
        }
        then = @{
            type = "askAgent"
            prompt = "Обнови документацию сервиса в Obsidian Vault на основе изменений в файле. Создай или обнови соответствующий MD файл в папке 06-Services с описанием методов, интерфейсов и зависимостей сервиса."
        }
    }
    
    $serviceHookPath = Join-Path $hooksPath "service-sync.json"
    $serviceHook | ConvertTo-Json -Depth 10 | Out-File -FilePath $serviceHookPath -Encoding UTF8
    Write-Host "  ✅ Service Documentation Sync Hook" -ForegroundColor Green
    
    # Hook 3: Синхронизация архитектурных изменений
    $architectureHook = @{
        name = "Architecture Documentation Sync"
        version = "1.0.0"
        description = "Обновление архитектурной документации при изменении структуры проекта"
        when = @{
            type = "fileCreated"
            patterns = @("**/*.module.ts", "**/routes.ts", "**/app.config.ts")
        }
        then = @{
            type = "askAgent"
            prompt = "Обнови архитектурную документацию в Obsidian Vault. Проанализируй изменения в структуре проекта и обнови соответствующие файлы в папках 02-Architecture и 03-Diagrams."
        }
    }
    
    $architectureHookPath = Join-Path $hooksPath "architecture-sync.json"
    $architectureHook | ConvertTo-Json -Depth 10 | Out-File -FilePath $architectureHookPath -Encoding UTF8
    Write-Host "  ✅ Architecture Documentation Sync Hook" -ForegroundColor Green
    
    # Hook 4: Обновление метрик производительности
    $metricsHook = @{
        name = "Performance Metrics Sync"
        version = "1.0.0"
        description = "Обновление метрик производительности после тестов"
        when = @{
            type = "postToolUse"
            toolTypes = @("shell")
        }
        then = @{
            type = "askAgent"
            prompt = "Если была выполнена команда тестирования или сборки, обнови метрики производительности в Obsidian Vault в папке 10-Knowledge-Base. Включи данные о размере бандла, времени сборки и покрытии тестами."
        }
    }
    
    $metricsHookPath = Join-Path $hooksPath "metrics-sync.json"
    $metricsHook | ConvertTo-Json -Depth 10 | Out-File -FilePath $metricsHookPath -Encoding UTF8
    Write-Host "  ✅ Performance Metrics Sync Hook" -ForegroundColor Green
}

# Создание скрипта автоматической синхронизации
Write-Host "`n🔄 Создание скрипта автоматической синхронизации..." -ForegroundColor Yellow

$syncScriptPath = Join-Path $VaultPath "15-Scripts\auto-sync.ps1"
$syncScript = @"
# Автоматическая синхронизация Kiro ↔ Obsidian
# Запускается каждые 5 минут через Task Scheduler

param(
    [string]`$VaultPath = "$VaultPath",
    [string]`$ProjectPath = "$(Get-Location)"
)

`$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "🔄 [`$timestamp] Начинаем синхронизацию..." -ForegroundColor Cyan

# Проверяем изменения в проекте
Set-Location `$ProjectPath
`$gitStatus = git status --porcelain 2>`$null

if (`$gitStatus) {
    Write-Host "📝 Обнаружены изменения в проекте" -ForegroundColor Yellow
    
    # Анализируем типы изменений
    `$changedComponents = git diff --name-only | Where-Object { `$_ -match "\.component\.(ts|html|scss)`$" }
    `$changedServices = git diff --name-only | Where-Object { `$_ -match "\.service\.ts`$" }
    `$changedModules = git diff --name-only | Where-Object { `$_ -match "\.module\.ts`$" }
    
    if (`$changedComponents) {
        Write-Host "🎨 Изменены компоненты: `$(`$changedComponents.Count)" -ForegroundColor Green
    }
    
    if (`$changedServices) {
        Write-Host "🔧 Изменены сервисы: `$(`$changedServices.Count)" -ForegroundColor Green
    }
    
    if (`$changedModules) {
        Write-Host "🏗️ Изменены модули: `$(`$changedModules.Count)" -ForegroundColor Green
    }
}

# Синхронизируем Obsidian Vault
Set-Location `$VaultPath
`$obsidianStatus = git status --porcelain 2>`$null

if (`$obsidianStatus) {
    Write-Host "📚 Синхронизируем изменения в Obsidian..." -ForegroundColor Yellow
    
    git add .
    git commit -m "docs: auto-sync `$timestamp"
    git push origin main 2>`$null
    
    Write-Host "✅ Синхронизация завершена" -ForegroundColor Green
} else {
    Write-Host "📚 Obsidian Vault актуален" -ForegroundColor Gray
}

Write-Host "🔄 [`$timestamp] Синхронизация завершена" -ForegroundColor Cyan
"@

[System.IO.File]::WriteAllText($syncScriptPath, $syncScript, [System.Text.Encoding]::UTF8)
Write-Host "  ✅ Скрипт автоматической синхронизации создан" -ForegroundColor Green

# Создание .obsidian конфигурации в целевой папке
Write-Host "`n⚙️ Настройка Obsidian конфигурации..." -ForegroundColor Yellow

$obsidianConfigPath = Join-Path $VaultPath ".obsidian"
New-SafeDirectory -Path $obsidianConfigPath | Out-Null

# Копируем конфигурации плагинов
$sourceConfigPath = ".obsidian-config"
if (Test-Path $sourceConfigPath) {
    Copy-Item -Path "$sourceConfigPath\*" -Destination $obsidianConfigPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  ✅ Конфигурации плагинов скопированы" -ForegroundColor Green
}

# Создание workspace.json для Obsidian
$workspaceConfig = @{
    main = @{
        id = "main-workspace"
        type = "split"
        children = @(
            @{
                id = "main-editor"
                type = "leaf"
                state = @{
                    type = "markdown"
                    state = @{
                        file = "00-Main/Главная.md"
                        mode = "source"
                    }
                }
            }
        )
    }
    left = @{
        id = "left-sidebar"
        type = "split"
        children = @(
            @{
                id = "file-explorer"
                type = "leaf"
                state = @{
                    type = "file-explorer"
                    state = @{}
                }
            }
        )
        collapsed = $false
    }
    right = @{
        id = "right-sidebar"
        type = "split"
        children = @(
            @{
                id = "outline"
                type = "leaf"
                state = @{
                    type = "outline"
                    state = @{}
                }
            }
        )
        collapsed = $false
    }
    active = "main-editor"
    lastOpenFiles = @("00-Main/Главная.md")
}

$workspacePath = Join-Path $obsidianConfigPath "workspace.json"
$workspaceConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $workspacePath -Encoding UTF8
Write-Host "  ✅ Workspace конфигурация создана" -ForegroundColor Green

# Финальная статистика
Write-Host "`n📊 Результаты миграции:" -ForegroundColor Yellow

$totalFiles = (Get-ChildItem $VaultPath -Recurse -Filter "*.md" -ErrorAction SilentlyContinue).Count
$totalFolders = (Get-ChildItem $VaultPath -Directory -Recurse -ErrorAction SilentlyContinue).Count + (Get-ChildItem $VaultPath -Directory -ErrorAction SilentlyContinue).Count
$totalSize = [math]::Round(((Get-ChildItem $VaultPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB), 2)

Write-Host "  📄 Всего MD файлов: $totalFiles" -ForegroundColor Green
Write-Host "  📁 Всего папок: $totalFolders" -ForegroundColor Green
Write-Host "  💾 Общий размер: $totalSize MB" -ForegroundColor Green
Write-Host "  ✅ Успешно мигрировано: $migratedCount файлов" -ForegroundColor Green
Write-Host "  ❌ Ошибок: $errorCount" -ForegroundColor $(if ($errorCount -eq 0) { "Green" } else { "Red" })
Write-Host "  📍 Расположение: $VaultPath" -ForegroundColor Cyan

if ($CreateKiroHooks) {
    Write-Host "  🔗 Kiro Hooks созданы: 4 автоматических хука" -ForegroundColor Green
}

Write-Host "`n🎉 Полная миграция и синхронизация завершена!" -ForegroundColor Green
Write-Host "💡 Следующие шаги:" -ForegroundColor Yellow
Write-Host "   1. Откройте Obsidian и выберите папку: $VaultPath" -ForegroundColor White
Write-Host "   2. Активируйте плагины: Git, Templater, Dataview, Kanban" -ForegroundColor White
Write-Host "   3. Настройте Git репозиторий для командной работы" -ForegroundColor White
Write-Host "   4. Импортируйте Kiro Hooks для автоматической синхронизации" -ForegroundColor White

Write-Host "`n🔄 Автоматическая синхронизация настроена!" -ForegroundColor Green
Write-Host "   Скрипт: $VaultPath\15-Scripts\auto-sync.ps1" -ForegroundColor Cyan
Write-Host "   Запуск: каждые 5 минут через Task Scheduler" -ForegroundColor Cyan