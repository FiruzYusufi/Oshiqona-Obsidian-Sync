# 🔧 Полная настройка Git репозитория для командной работы

> **Пошаговая инструкция по настройке Git для Obsidian Vault**  
> **Автор**: Kiro AI  
> **Дата**: 2026-04-20

---

## 🎯 Цель настройки

Создать отдельный Git репозиторий для Obsidian документации с автоматической синхронизацией и командной работой.

---

## 📋 Пошаговая инструкция

### 1️⃣ Инициализация Git в Obsidian Vault

```bash
# Переходим в папку Obsidian Vault
cd "C:\Users\Robita\Documents\Obsidian Vault\Проекты\Oshiqona"

# Инициализируем Git репозиторий
git init

# Настраиваем пользователя (если не настроено глобально)
git config user.name "firuz"
git config user.email "tjkbinance1@gmail.com"

# Добавляем все файлы
git add .

# Создаем первый коммит
git commit -m "feat: initial Obsidian vault setup with complete documentation

- Added 16-folder structure for organized documentation
- Migrated 65+ MD files from project documentation  
- Setup 4 Kiro Hooks for automatic synchronization
- Configured Obsidian plugins (Git, Templater, Dataview, Kanban, Excalidraw)
- Created performance metrics and monitoring system

Co-authored-by: Kiro AI <kiro@ai.com>"
```

### 2️⃣ Создание GitHub репозитория

#### Вариант A: Через GitHub CLI (рекомендуется)
```bash
# Установите GitHub CLI если не установлен
# https://cli.github.com/

# Авторизуйтесь в GitHub
gh auth login

# Создайте репозиторий
gh repo create oshiqona-obsidian-docs --public --description "Obsidian Vault for Oshiqona project documentation with automatic Kiro AI synchronization"

# Подключите локальный репозиторий
git remote add origin https://github.com/abubakrmirgiyasov/oshiqona-obsidian-docs.git
git branch -M main
git push -u origin main
```

#### Вариант B: Через веб-интерфейс GitHub
1. Перейдите на https://github.com/new
2. **Repository name**: `oshiqona-obsidian-docs`
3. **Description**: `Obsidian Vault for Oshiqona project documentation with automatic Kiro AI synchronization`
4. **Visibility**: Public (или Private для приватного проекта)
5. **НЕ добавляйте** README, .gitignore, license (у нас уже есть файлы)
6. Нажмите **Create repository**

```bash
# Подключите созданный репозиторий
git remote add origin https://github.com/abubakrmirgiyasov/oshiqona-obsidian-docs.git
git branch -M main
git push -u origin main
```

### 3️⃣ Настройка .gitignore для Obsidian

```bash
# Создаем .gitignore файл
cat > .gitignore << 'EOF'
# Obsidian временные файлы
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/hotkeys.json
.obsidian/appearance.json
.obsidian/core-plugins.json
.obsidian/community-plugins.json

# Системные файлы
*.tmp
*.temp
.DS_Store
Thumbs.db
desktop.ini

# Резервные копии
*.bak
*~

# Логи
*.log

# Сохраняем важные конфигурации
!.obsidian/plugins/
!.obsidian/themes/
!14-Configuration/
EOF

# Коммитим .gitignore
git add .gitignore
git commit -m "chore: add .gitignore for Obsidian vault"
git push
```

---

## ⚙️ Настройка Obsidian Git плагина

### 1️⃣ Активация плагина
1. Откройте Obsidian
2. Settings → Community plugins
3. Найдите **Obsidian Git** и включите его
4. Перезапустите Obsidian

### 2️⃣ Конфигурация плагина
Settings → Obsidian Git:

```json
{
  "commitMessage": "docs: {{date}} auto-sync by {{hostname}}",
  "commitDateFormat": "YYYY-MM-DD HH:mm:ss",
  "autoSaveInterval": 5,
  "autoPushInterval": 10, 
  "autoPullInterval": 15,
  "pullBeforePush": true,
  "disablePush": false,
  "disablePull": false,
  "listChangedFilesInMessageBody": true,
  "showStatusBar": true,
  "updateSubmodules": false,
  "syncMethod": "merge",
  "customMessageOnAutoBackup": false,
  "autoBackupAfterFileChange": true,
  "treeStructure": false,
  "refreshSourceControl": true,
  "basePath": "",
  "differentIntervalCommitAndPush": true,
  "changedFilesInStatusBar": false,
  "showedMobileNotice": true,
  "refreshSourceControlTimer": 7000,
  "showBranchStatusBar": true,
  "setLastSaveToLastCommit": false,
  "submoduleRecurseCheckout": false,
  "gitDir": "",
  "showFileMenu": true,
  "lineAuthor": {
    "show": false,
    "followMovement": "inactive",
    "authorDisplay": "initials",
    "showCommitHash": false,
    "dateTimeFormatOptions": "date",
    "dateTimeFormatCustomString": "YYYY-MM-DD HH:mm",
    "dateTimeTimezone": "viewer-local",
    "coloringMaxAge": "1y",
    "colorNew": {
      "r": 255,
      "g": 150,
      "b": 150
    },
    "colorOld": {
      "r": 120,
      "g": 160,
      "b": 255
    },
    "textColorCss": "var(--text-muted)",
    "ignoreWhitespace": false,
    "gutterSpacingFallbackLength": 5,
    "lastShownAuthorDisplay": "initials",
    "lastShownDateTimeFormatOptions": "date"
  }
}
```

### 3️⃣ Горячие клавиши
Settings → Hotkeys → Obsidian Git:
- **Commit all changes**: `Ctrl+Shift+K`
- **Push**: `Ctrl+Shift+P`
- **Pull**: `Ctrl+Shift+L`
- **Stage current file**: `Ctrl+Shift+S`

---

## 🔄 Настройка автоматической синхронизации

### 1️⃣ Git Hooks для уведомлений Kiro

```bash
# Создаем папку для hooks
mkdir -p .git/hooks

# Создаем post-commit hook
cat > .git/hooks/post-commit << 'EOF'
#!/bin/sh
# Post-commit hook для уведомления Kiro AI

COMMIT_HASH=$(git rev-parse HEAD)
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD)
COMMIT_MESSAGE=$(git log -1 --pretty=%B)
TIMESTAMP=$(date -Iseconds)

# Уведомляем Kiro AI о изменениях (если Kiro запущен)
curl -X POST http://localhost:3000/kiro/git-update \
  -H "Content-Type: application/json" \
  -d "{
    \"repository\": \"oshiqona-obsidian-docs\",
    \"commit\": \"$COMMIT_HASH\",
    \"message\": \"$COMMIT_MESSAGE\",
    \"files\": \"$CHANGED_FILES\",
    \"timestamp\": \"$TIMESTAMP\"
  }" \
  --connect-timeout 2 \
  --max-time 5 \
  --silent || true

echo "Git hook: Notified Kiro AI about commit $COMMIT_HASH"
EOF

# Делаем hook исполняемым
chmod +x .git/hooks/post-commit
```

### 2️⃣ Скрипт для ручной синхронизации

```bash
# Создаем скрипт sync.ps1 в корне Obsidian Vault
cat > sync.ps1 << 'EOF'
# Ручная синхронизация Obsidian Vault
param(
    [string]$Message = "docs: manual sync $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

Write-Host "🔄 Начинаем синхронизацию Obsidian Vault..." -ForegroundColor Cyan

# Проверяем статус
$status = git status --porcelain
if ($status) {
    Write-Host "📝 Обнаружены изменения:" -ForegroundColor Yellow
    git status --short
    
    # Добавляем все изменения
    git add .
    
    # Коммитим
    git commit -m $Message
    
    # Пушим
    git push
    
    Write-Host "✅ Синхронизация завершена успешно!" -ForegroundColor Green
} else {
    Write-Host "📚 Нет изменений для синхронизации" -ForegroundColor Gray
}

# Проверяем обновления с сервера
Write-Host "🔄 Проверяем обновления с сервера..." -ForegroundColor Cyan
git pull

Write-Host "🎉 Синхронизация завершена!" -ForegroundColor Green
EOF
```

---

## 👥 Настройка для командной работы

### 1️⃣ Добавление участников команды

```bash
# На GitHub репозитории:
# Settings → Manage access → Invite a collaborator
# Добавьте участников команды с правами:
# - Write: для основных разработчиков
# - Read: для просмотра документации
```

### 2️⃣ Ветвление стратегия

```bash
# Создаем ветки для разных типов работы
git checkout -b develop
git push -u origin develop

git checkout -b docs/architecture
git push -u origin docs/architecture

git checkout -b docs/api-updates  
git push -u origin docs/api-updates

# Возвращаемся на main
git checkout main
```

### 3️⃣ Правила для команды

#### Commit message конвенция:
```
<type>: <краткое описание>

<детальное описание>

<footer>
```

**Типы коммитов:**
- `docs:` — обновление документации
- `feat:` — новые разделы документации
- `fix:` — исправление ошибок в документации
- `refactor:` — реорганизация структуры
- `style:` — форматирование, исправление стилей
- `chore:` — обновление конфигураций

#### Примеры:
```bash
git commit -m "docs: update API documentation for SignalR integration

- Added detailed SignalR connection flow diagram
- Updated authentication requirements
- Fixed broken links in API reference

Closes #123"

git commit -m "feat: add performance monitoring dashboard

- Created new section 10-Knowledge-Base/Performance
- Added real-time metrics tracking
- Integrated with Kiro AI hooks for automatic updates

Co-authored-by: TeamMember <email@example.com>"
```

---

## 📊 Мониторинг и метрики

### 1️⃣ GitHub Actions для автоматизации

```yaml
# .github/workflows/docs-quality.yml
name: Documentation Quality Check

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  quality-check:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Check for broken links
      uses: gaurav-nelson/github-action-markdown-link-check@v1
      with:
        use-quiet-mode: 'yes'
        use-verbose-mode: 'yes'
        config-file: '.github/markdown-link-check-config.json'
    
    - name: Validate Obsidian vault structure
      run: |
        # Проверяем наличие обязательных папок
        required_folders=("00-Main" "01-Documentation" "03-Diagrams" "10-Knowledge-Base")
        for folder in "${required_folders[@]}"; do
          if [ ! -d "$folder" ]; then
            echo "❌ Missing required folder: $folder"
            exit 1
          fi
        done
        echo "✅ All required folders present"
    
    - name: Count documentation files
      run: |
        md_count=$(find . -name "*.md" | wc -l)
        echo "📄 Total MD files: $md_count"
        if [ $md_count -lt 50 ]; then
          echo "⚠️ Warning: Less than 50 MD files found"
        fi
    
    - name: Generate metrics report
      run: |
        echo "## 📊 Documentation Metrics" >> $GITHUB_STEP_SUMMARY
        echo "- **Total MD files**: $(find . -name '*.md' | wc -l)" >> $GITHUB_STEP_SUMMARY
        echo "- **Total folders**: $(find . -type d | wc -l)" >> $GITHUB_STEP_SUMMARY
        echo "- **Repository size**: $(du -sh . | cut -f1)" >> $GITHUB_STEP_SUMMARY
        echo "- **Last updated**: $(date)" >> $GITHUB_STEP_SUMMARY
```

### 2️⃣ Настройка защищенных веток

```bash
# На GitHub:
# Settings → Branches → Add rule
# Branch name pattern: main
# ✅ Require pull request reviews before merging
# ✅ Require status checks to pass before merging
# ✅ Require branches to be up to date before merging
# ✅ Include administrators
```

---

## 🚀 Запуск и тестирование

### 1️⃣ Первый тест синхронизации

```bash
# Создаем тестовый файл
echo "# Тест синхронизации

Этот файл создан для тестирования Git синхронизации.

**Время создания**: $(date)
**Автор**: $(git config user.name)

## Проверка функций
- [x] Git инициализация
- [x] Подключение к GitHub
- [x] Автоматические коммиты
- [ ] Командная работа

" > 00-Main/test-sync.md

# Коммитим и пушим
git add 00-Main/test-sync.md
git commit -m "test: add sync test file for validation"
git push

# Проверяем на GitHub что файл появился
```

### 2️⃣ Тест Obsidian Git плагина

1. Откройте Obsidian
2. Создайте новый файл в любой папке
3. Подождите 5 минут (auto-save interval)
4. Проверьте статус бар Obsidian — должен показать Git статус
5. Проверьте GitHub — новый коммит должен появиться автоматически

### 3️⃣ Тест командной работы

```bash
# Пригласите коллегу в репозиторий
# Попросите его склонировать репозиторий:

git clone https://github.com/abubakrmirgiyasov/oshiqona-obsidian-docs.git
cd oshiqona-obsidian-docs

# Создать тестовое изменение:
echo "Тест от коллеги" >> 00-Main/test-sync.md
git add .
git commit -m "test: team collaboration test"
git push

# Проверьте что изменения синхронизируются у всех участников
```

---

## 📋 Чек-лист готовности

### ✅ Git репозиторий
- [ ] Git инициализирован в Obsidian Vault
- [ ] Создан GitHub репозиторий `oshiqona-obsidian-docs`
- [ ] Настроен .gitignore для Obsidian
- [ ] Выполнен первый push
- [ ] Настроены Git hooks

### ✅ Obsidian настройка
- [ ] Obsidian Git плагин активирован
- [ ] Конфигурация плагина настроена
- [ ] Горячие клавиши назначены
- [ ] Автоматическая синхронизация работает

### ✅ Командная работа
- [ ] Участники команды добавлены в репозиторий
- [ ] Ветвление стратегия определена
- [ ] Правила коммитов документированы
- [ ] GitHub Actions настроены

### ✅ Тестирование
- [ ] Ручная синхронизация работает
- [ ] Автоматическая синхронизация работает
- [ ] Командная работа протестирована
- [ ] Kiro Hooks интегрированы

---

## 🎉 Заключение

### ✅ Что настроено:
1. **Отдельный Git репозиторий** для Obsidian документации
2. **Автоматическая синхронизация** каждые 10 минут
3. **Командная работа** через GitHub с правилами и защитой
4. **Интеграция с Kiro AI** через Git hooks
5. **Мониторинг качества** через GitHub Actions

### 🚀 Результат:
**Профессиональная система управления документацией с полной Git интеграцией и командной работой готова к использованию!**

### 📞 Поддержка:
- **Ручная синхронизация**: `.\sync.ps1`
- **Статус Git**: Статус бар в Obsidian
- **Горячие клавиши**: `Ctrl+Shift+K/P/L`
- **GitHub репозиторий**: https://github.com/abubakrmirgiyasov/oshiqona-obsidian-docs

---

**Создано**: 2026-04-20  
**Автор**: Kiro AI  
**Версия**: 1.0.0  
**Статус**: ✅ Готово к использованию