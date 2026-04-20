---
tags: [home, main, oshiqona, navigation, dashboard]
created: 2026-04-20
updated: 2026-04-20
cssclasses: [home-page, dashboard, kiro-sync]
---

# 🚀 Oshiqona — Центр управления проектом

> **Angular 20 · Nx Monorepo · SignalR · Taiga UI · TypeScript 5.8**  
> Полная база знаний с автоматической синхронизацией Kiro ↔ Obsidian

---

## 🎛️ Быстрая навигация

### 📊 Управление и мониторинг
| Раздел | Описание | Статус | Ссылка |
|--------|----------|--------|--------|
| **Дашборд** | Центральная панель с метриками | 🟢 | [[00-Main/Дашборд\|📊 Дашборд]] |
| **Проект** | Kanban доски и спринты | 🟢 | [[09-Project-Management/README\|🎯 Управление]] |
| **Метрики** | Производительность и аналитика | 🟡 | [[10-Knowledge-Base/README\|⚡ Метрики]] |
| **Синхронизация** | Kiro ↔ Obsidian автосинк | ✅ | [[15-Scripts/kiro-obsidian-sync\|🔄 Синхронизация]] |

### 📖 Документация и архитектура
| Раздел | Описание | Файлов | Ссылка |
|--------|----------|--------|--------|
| **Обзор** | Полное описание проекта | 16 | [[01-Documentation/README\|📖 Документация]] |
| **Архитектура** | Структура и компоненты | 5 | [[02-Architecture/README\|🏗️ Архитектура]] |
| **Диаграммы** | Excalidraw схемы и потоки | 7 | [[03-Diagrams/README\|🖼️ Диаграммы]] |
| **API** | REST API и SignalR | 8 | [[04-API-Documentation/README\|🔌 API]] |

### 🔧 Разработка и компоненты
| Раздел | Описание | Автосинк | Ссылка |
|--------|----------|----------|--------|
| **Компоненты** | Angular компоненты | ✅ Hook | [[05-Components/README\|🎨 Компоненты]] |
| **Сервисы** | Бизнес-логика и сервисы | ✅ Hook | [[06-Services/README\|🔧 Сервисы]] |
| **Тестирование** | Тесты и покрытие | ✅ Hook | [[07-Testing/README\|🧪 Тесты]] |
| **Развертывание** | CI/CD и Docker | 🟡 | [[08-Deployment/README\|🚀 Deploy]] |

---

## 🔄 Статус автоматической синхронизации

### Kiro Hooks (активны)
```dataview
TABLE WITHOUT ID
  "✅ Component Documentation Sync" AS "Hook",
  "fileEdited: *.component.*" AS "Триггер",
  "05-Components/" AS "Цель"
UNION
  "✅ Service Documentation Sync" AS "Hook",
  "fileEdited: *.service.ts" AS "Триггер", 
  "06-Services/" AS "Цель"
UNION
  "✅ Architecture Documentation Sync" AS "Hook",
  "fileCreated: *.module.ts" AS "Триггер",
  "02-Architecture/" AS "Цель"
UNION
  "✅ Performance Metrics Sync" AS "Hook",
  "postToolUse: shell" AS "Триггер",
  "10-Knowledge-Base/" AS "Цель"
```

### Git синхронизация
- **Автокоммиты**: каждые 10 минут
- **Автопуш**: при изменениях
- **Автопулл**: каждые 15 минут
- **Статус**: 🟢 Активна

---

## 🗂️ Полная структура проекта (15 разделов)

### 🏠 Основные разделы
- **00-Main** — Главная страница, навигация и дашборд → [[00-Main/README|Перейти]]
- **01-Documentation** — Основная документация проекта → [[01-Documentation/README|Перейти]]
- **02-Architecture** — Архитектурные решения и технические спецификации → [[02-Architecture/README|Перейти]]
- **03-Diagrams** — Excalidraw диаграммы и схемы → [[03-Diagrams/README|Перейти]]

### 🔧 Разработка
- **04-API-Documentation** — REST API и SignalR документация → [[04-API-Documentation/README|Перейти]]
- **05-Components** — Angular компоненты и их описание → [[05-Components/README|Перейти]]
- **06-Services** — Сервисы и бизнес-логика → [[06-Services/README|Перейти]]
- **07-Testing** — Тесты, покрытие, стратегии тестирования → [[07-Testing/README|Перейти]]
- **08-Deployment** — CI/CD, Docker, развертывание → [[08-Deployment/README|Перейти]]

### 📊 Управление и данные
- **09-Project-Management** — Kanban доски, спринты, задачи → [[09-Project-Management/README|Перейти]]
- **10-Knowledge-Base** — Структурированные данные и метрики → [[10-Knowledge-Base/README|Перейти]]
- **11-Templates** — Templater шаблоны для создания контента → [[11-Templates/README|Перейти]]
- **12-Daily-Notes** — Ежедневные и еженедельные записи → [[12-Daily-Notes/README|Перейти]]

### ⚙️ Конфигурация и ресурсы
- **13-Resources** — Ссылки, документы, материалы → [[13-Resources/README|Перейти]]
- **14-Configuration** — Настройки Obsidian и плагинов → [[14-Configuration/README|Перейти]]
- **15-Scripts** — Автоматизация и утилиты → [[15-Scripts/README|Перейти]]

---

## 📊 Статус проекта и метрики

### Основная информация
```dataview
TABLE WITHOUT ID
  "v0.1.174" AS "🏷️ Версия",
  "Angular 20.3.15" AS "🅰️ Фреймворк", 
  "🟢 Active Development" AS "📈 Статус",
  "2026-04-20" AS "📅 Обновлено",
  "45+ файлов" AS "📄 Документация",
  "4 хука" AS "🔄 Автосинк"
```

### Ключевые метрики производительности
| Метрика | Текущее | Цель | Статус | Тренд |
|---------|---------|------|--------|-------|
| **Bundle Size** | 4.2MB | 2.5MB | 🔴 | ↗️ |
| **Load Time** | 2.8s | 2.0s | 🟡 | ↘️ |
| **Test Coverage** | 65% | 80% | 🟡 | ↗️ |
| **Lighthouse Score** | 85/100 | 95/100 | 🟡 | ↗️ |
| **Documentation** | 95% | 100% | 🟢 | ↗️ |

---

## 🎯 Критические задачи и приоритеты

### Сегодня
```tasks
not done
tags include #critical
due before tomorrow
limit 5
```

### На этой неделе
```tasks
not done
tags include #high-priority
due before next week
limit 10
```

---

## 🏗️ Архитектура проекта (интерактивная)

### Основная схема
```mermaid
graph TB
    subgraph "Frontend Applications"
        A[Admin App :4000] 
        B[Client App :4001]
    end
    
    subgraph "Shared Libraries"
        C[@core - Business Logic]
        D[@core/auth - Authentication]
        E[@shared/cdk - Utilities]
        F[@shared/kit - UI Components]
    end
    
    subgraph "Backend Services"
        G[SignalR Hub - Real-time]
        H[REST API - Main Backend]
        I[Database - PostgreSQL]
    end
    
    subgraph "Documentation System"
        J[Kiro AI - Code Analysis]
        K[Obsidian Vault - Documentation]
        L[Git Repository - Versioning]
    end
    
    A --> C
    B --> C
    C --> D
    C --> E
    C --> F
    
    G --> B
    H --> A
    H --> B
    I --> H
    
    J --> K
    K --> L
    J -.-> A
    J -.-> B
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style J fill:#e8f5e8
    style K fill:#fff3e0
```

### Детальные диаграммы
- [[03-Diagrams/Архитектура-проекта-детальная|🏗️ Детальная архитектура]]
- [[03-Diagrams/SignalR-поток-детальный|💬 SignalR поток]]
- [[03-Diagrams/Поток-аутентификации-детальный|🔐 Аутентификация]]
- [[03-Diagrams/Система-рекомендаций|🎯 ML рекомендации]]

---

## 🔄 Последние изменения и активность

### Изменения за сегодня
```dataview
TABLE WITHOUT ID
  file.name AS "📄 Файл",
  file.mtime AS "🕒 Время",
  file.size AS "📏 Размер"
FROM ""
WHERE file.mtime > date(today)
SORT file.mtime DESC
LIMIT 15
```

### Активность по разделам
```dataview
TABLE WITHOUT ID
  split(file.folder, "/")[0] AS "📁 Раздел",
  length(rows) AS "📄 Файлов",
  sum(rows.file.size) AS "📏 Размер"
FROM ""
WHERE file.name != "README"
GROUP BY split(file.folder, "/")[0]
SORT sum(rows.file.size) DESC
```

---

## 🎨 Приложения и функциональность

### 👨‍💼 Admin App (порт 4000)
- **Dashboard** — метрики и мониторинг системы
- **References** — справочники и настройки
- **User Management** — управление пользователями
- **Analytics** — аналитика и отчеты
- **Guard**: `authGuard` + группа `Administrators`

### 👥 Client App (порт 4001) 
- **Matches** — система рекомендаций и совместимости
- **Chats** — реал-тайм сообщения через SignalR
- **Profile** — профили пользователей и настройки
- **Gallery** — управление фотографиями и медиа
- **Near Users** — поиск пользователей поблизости
- **Guard**: `clientAuthGuard`

---

## 🛠️ Технологический стек

### Frontend Framework
- **Angular**: 20.3.15 — основной фреймворк
- **TypeScript**: 5.8.3 — язык разработки
- **Nx**: 22.2.3 — monorepo управление
- **Taiga UI**: 4.79.0 — UI библиотека

### Backend & Real-time
- **SignalR**: 9.0.6 — реал-тайм коммуникация
- **JWT**: аутентификация и авторизация
- **REST API**: основное API приложения

### Development & Testing
- **Jest**: 29.7.0 — unit тестирование
- **ESLint**: 9.8.0 — качество кода
- **Tailwind**: 4.1.18 — стилизация
- **Vite**: сборка и разработка

### Documentation & Sync
- **Obsidian**: база знаний и документация
- **Kiro AI**: автоматическая синхронизация
- **Git**: версионирование и командная работа
- **Excalidraw**: диаграммы и схемы

---

## 📋 Быстрые команды и горячие клавиши

### Разработка (Terminal)
```bash
npm run start:oshiqona-client   # Client App (4001)
npm run start:oshiqona-admin    # Admin App (4000)
npm run build:prod              # Production build
npm run test                    # Запуск тестов
npm run lint                    # Проверка кода
npm run e2e                     # E2E тестирование
```

### Obsidian (Горячие клавиши)
- `Ctrl+O` — быстрый переход к файлу
- `Ctrl+Shift+F` — глобальный поиск по всем файлам
- `Ctrl+G` — граф связей между документами
- `Ctrl+P` — палитра команд
- `Ctrl+E` — переключение режима редактирования
- `Ctrl+,` — настройки Obsidian

### Git синхронизация
- `Ctrl+Shift+G` — панель Git в Obsidian
- `Ctrl+P` → "Git: Commit all changes" — ручной коммит
- `Ctrl+P` → "Git: Push" — отправка изменений
- `Ctrl+P` → "Git: Pull" — получение обновлений

---

## 🎯 Планы развития и roadmap

### Краткосрочные цели (1-2 недели)
- [ ] Оптимизация размера бандла (4.2MB → 2.5MB)
- [ ] Улучшение покрытия тестами (65% → 80%)
- [ ] Повышение Lighthouse Score (85 → 95)
- [ ] Исправление критических багов
- [ ] Настройка CI/CD pipeline

### Среднесрочные планы (1-2 месяца)
- [ ] Видео чаты (WebRTC интеграция)
- [ ] Мобильное приложение (React Native)
- [ ] ML улучшения системы рекомендаций
- [ ] Расширенная аналитика и метрики
- [ ] Интеграция с внешними сервисами

### Долгосрочная перспектива (3-6 месяцев)
- [ ] Микросервисная архитектура
- [ ] Kubernetes развертывание
- [ ] AI-powered функции
- [ ] Международная локализация
- [ ] Масштабирование на 100k+ пользователей

---

## 📞 Контакты, ресурсы и поддержка

### Команда проекта
- **Автор**: abubakrmirgiyasov
- **AI Архитектор**: Kiro AI
- **Тип проекта**: Nx Monorepo
- **Лицензия**: Private

### Полезные ссылки
- [[13-Resources/Ссылки|🔗 Все полезные ссылки]]
- [[01-Documentation/README|📚 README проекта]]
- [[11-Templates/Новая-задача|➕ Создать новую задачу]]
- [[11-Templates/Новый-компонент|🎨 Создать компонент]]
- [[11-Templates/Новый-сервис|🔧 Создать сервис]]

### Техническая поддержка
- **Документация**: Этот Obsidian Vault
- **Синхронизация**: [[15-Scripts/kiro-obsidian-sync|Настройка синхронизации]]
- **Hooks**: Kiro IDE → Command Palette → "Open Kiro Hook UI"
- **Git**: [[15-Scripts/auto-sync.ps1|Автоматическая синхронизация]]

---

## 🎉 Статус системы

### ✅ Что работает отлично
- **Автоматическая синхронизация** Kiro ↔ Obsidian
- **Документация** всегда актуальна
- **Диаграммы** интерактивные и понятные
- **Поиск** мгновенный по всей базе знаний
- **Командная работа** через Git

### 🟡 Что можно улучшить
- **Производительность** приложений
- **Покрытие тестами** увеличить до 80%
- **CI/CD** настроить автоматическое развертывание
- **Мониторинг** добавить метрики в реальном времени

### 🔴 Критические задачи
- **Bundle size** оптимизировать до 2.5MB
- **Security audit** провести аудит безопасности
- **Performance** улучшить время загрузки

---

**Последнее обновление**: 2026-04-20 11:30  
**Версия документации**: 2.0.0  
**Статус**: ✅ Полностью функциональная система  
**Автосинхронизация**: 🟢 Активна (4 хука)  
**Git синхронизация**: 🟢 Каждые 10 минут  
**Следующее обновление**: Автоматическое при изменении кода