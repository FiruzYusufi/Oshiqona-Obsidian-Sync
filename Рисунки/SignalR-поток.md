---
tags: [рисунок, signalr, websocket, excalidraw, диаграмма]
created: 2026-04-19
---

# SignalR — Поток реал-тайм коммуникации

## Подключение к хабу

```
Client (Angular)                    Server (.NET)
    │                                    │
    ├── new HubConnectionBuilder()       │
    │   .withUrl('/chat-hub',            │
    │     accessTokenFactory: token)     │
    │   .withAutomaticReconnect()        │
    │   .build()                         │
    │                                    │
    ├── hubConnection.start() ──────────►│
    │                                    ├── Проверить JWT токен
    │                                    ├── Добавить в группу
    │◄────────────── Connected ──────────┤
    │                                    │
```

## Отправка сообщения

```
Пользователь A                ChatHubService              Server              Пользователь B
    │                              │                         │                      │
    ├── sendMessage(text) ────────►│                         │                      │
    │                              ├── invoke('SendMessage') ►│                      │
    │                              │                         ├── Сохранить в БД     │
    │                              │                         ├── on('MessageReceived')►│
    │                              │◄── MessageReceived ─────┤                      │
    │◄── messages$.next(msg) ──────┤                         │                      │
    │                              │                         │                      │
```

## Уведомление о печатании

```
Пользователь A                ChatHubService              Server              Пользователь B
    │                              │                         │                      │
    ├── onInput() ────────────────►│                         │                      │
    │                              ├── invoke('SendTyping') ─►│                      │
    │                              │                         ├── on('UserTyping') ──►│
    │                              │                         │                      ├── isTyping = true
    │                              │                         │                      ├── setTimeout 3s
    │                              │                         │                      └── isTyping = false
```

## Автоматическое переподключение

```
Соединение разорвано
    │
    ▼
[onreconnecting()]
    │
    ├── Попытка 1: сразу
    ├── Попытка 2: сразу
    ├── Попытка 3: сразу
    ├── Попытка 4: через 5 сек
    ├── Попытка 5: через 5 сек
    └── Попытка 6: через 10 сек
            │
            ├── Успех → [onreconnected()] → Продолжить работу
            └── Ошибка → [onclose()] → Показать ошибку
```

## Связанные документы

- [[08-Реал-тайм]]
- [[05-Сервисы]]
