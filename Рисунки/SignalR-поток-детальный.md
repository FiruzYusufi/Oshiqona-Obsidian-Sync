---
tags: [excalidraw, signalr, realtime, oshiqona, diagram, detailed]
created: 2026-04-20
updated: 2026-04-20
excalidraw-plugin: parsed
excalidraw-autoexport: png
---

# 💬 Детальный SignalR поток Oshiqona

> Полная диаграмма реал-тайм коммуникации через SignalR

## 🔄 Диаграмма SignalR потока

```excalidraw
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [
    {
      "type": "rectangle",
      "version": 1,
      "versionNonce": 1,
      "isDeleted": false,
      "id": "signalr-flow-container",
      "fillStyle": "solid",
      "strokeWidth": 3,
      "strokeStyle": "solid",
      "roughness": 1,
      "opacity": 100,
      "angle": 0,
      "x": 50,
      "y": 50,
      "strokeColor": "#d32f2f",
      "backgroundColor": "#ffebee",
      "width": 900,
      "height": 800,
      "seed": 1,
      "groupIds": [],
      "strokeSharpness": "sharp",
      "boundElements": [],
      "updated": 1,
      "link": null,
      "locked": false
    }
  ],
  "appState": {
    "gridSize": null,
    "viewBackgroundColor": "#ffffff"
  },
  "files": {}
}
```

## 💬 Процесс реал-тайм коммуникации

### 1️⃣ Установка SignalR соединения

```
┌─────────────────────────────────────────────────────────────┐
│                SIGNALR CONNECTION SETUP                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🎯 ChatsComponent                                          │
│   │                                                         │
│   ├── 1. ngOnInit() вызывается                             │
│   │                                                         │
│   ├── 2. Проверка аутентификации                           │
│   │    └── currentUserService.getCurrentUser()             │
│   │                                                         │
│   └── 3. chatHubService.connect()                          │
│        │                                                   │
│        ▼                                                   │
│  🔧 ChatHubService (@core)                                 │
│   │                                                         │
│   ├── 4. Создание HubConnectionBuilder                     │
│   │    ├── URL: '/hubs/chat'                               │
│   │    ├── withAutomaticReconnect()                        │
│   │    └── configureLogging(LogLevel.Information)          │
│   │                                                         │
│   ├── 5. Добавление JWT токена в заголовки                 │
│   │    └── accessTokenFactory: () => tokenService.getToken()│
│   │                                                         │
│   ├── 6. Настройка обработчиков событий                    │
│   │    ├── onReceiveMessage()                              │
│   │    ├── onUserJoined()                                  │
│   │    ├── onUserLeft()                                    │
│   │    ├── onTypingStarted()                               │
│   │    └── onTypingStopped()                               │
│   │                                                         │
│   └── 7. connection.start()                                │
│        │                                                   │
│        ▼                                                   │
│  🌐 SignalR Hub Server                                      │
│   │                                                         │
│   ├── 8. Проверка JWT токена                               │
│   │                                                         │
│   ├── 9. Аутентификация пользователя                       │
│   │                                                         │
│   ├── 10. Добавление в группу пользователей                │
│   │     └── Groups.AddToGroupAsync(userId)                 │
│   │                                                         │
│   └── 11. Подтверждение соединения                         │
│         └── ConnectionId присваивается                     │
│              │                                             │
│              ▼                                             │
│  🔧 ChatHubService (Connection Success)                    │
│   │                                                         │
│   ├── 12. isConnected = true                               │
│   │                                                         │
│   ├── 13. Эмит события connectionEstablished               │
│   │                                                         │
│   └── 14. Загрузка активных чатов                          │
│        │                                                   │
│        ▼                                                   │
│  🎯 ChatsComponent (Connection Ready)                      │
│   │                                                         │
│   ├── 15. Подписка на события SignalR                      │
│   │                                                         │
│   ├── 16. Загрузка списка чатов                            │
│   │                                                         │
│   └── 17. Отображение UI чатов                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2️⃣ Отправка сообщения в реал-тайм

```
┌─────────────────────────────────────────────────────────────┐
│                  SEND MESSAGE PROCESS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  👤 User                                                    │
│   │                                                         │
│   ├── 1. Открывает чат                                     │
│   │                                                         │
│   ├── 2. Вводит сообщение в текстовое поле                 │
│   │                                                         │
│   └── 3. Нажимает Enter или кнопку "Отправить"             │
│        │                                                   │
│        ▼                                                   │
│  🎯 ChatDetailComponent                                     │
│   │                                                         │
│   ├── 4. onSendMessage(messageText)                        │
│   │                                                         │
│   ├── 5. Валидация сообщения                               │
│   │    ├── Проверка на пустоту                             │
│   │    ├── Проверка длины (макс 1000 символов)             │
│   │    └── Санитизация HTML                                │
│   │                                                         │
│   ├── 6. Создание объекта сообщения                        │
│   │    └── { chatId, content, timestamp }                  │
│   │                                                         │
│   └── 7. messageService.sendMessage(message)               │
│        │                                                   │
│        ▼                                                   │
│  🔧 MessageService (@core)                                 │
│   │                                                         │
│   ├── 8. Добавление метаданных                             │
│   │    ├── senderId = currentUser.id                       │
│   │    ├── messageId = generateUUID()                      │
│   │    └── status = 'sending'                              │
│   │                                                         │
│   ├── 9. Оптимистичное обновление UI                       │
│   │    └── Добавление сообщения в локальный массив         │
│   │                                                         │
│   ├── 10. chatHubService.sendMessage(message)              │
│   │                                                         │
│   └── 11. Параллельно: HTTP POST /api/messages             │
│        │    └── Сохранение в базе данных                   │
│        │                                                   │
│        ▼                                                   │
│  🔧 ChatHubService                                         │
│   │                                                         │
│   ├── 12. connection.invoke('SendMessage', message)        │
│   │                                                         │
│   └── 13. Обработка ответа                                 │
│        ├── Success: messageId возвращается                 │
│        └── Error: обработка ошибки                         │
│              │                                             │
│              ▼                                             │
│  🌐 SignalR ChatHub Server                                  │
│   │                                                         │
│   ├── 14. Получение сообщения от клиента                   │
│   │                                                         │
│   ├── 15. Валидация прав доступа                           │
│   │     ├── Проверка участия в чате                        │
│   │     └── Проверка блокировки пользователя               │
│   │                                                         │
│   ├── 16. Обогащение сообщения                             │
│   │     ├── Добавление timestamp сервера                   │
│   │     ├── Добавление информации о отправителе            │
│   │     └── Генерация уникального ID                       │
│   │                                                         │
│   ├── 17. Сохранение в базе данных                         │
│   │     └── INSERT INTO Messages (...)                     │
│   │                                                         │
│   └── 18. Рассылка всем участникам чата                    │
│         └── Clients.Group(chatId).SendAsync('ReceiveMessage')│
│              │                                             │
│              ▼                                             │
│  🔧 ChatHubService (All Participants)                     │
│   │                                                         │
│   ├── 19. onReceiveMessage() обработчик                    │
│   │                                                         │
│   ├── 20. Обновление локального состояния                  │
│   │     ├── Добавление в массив сообщений                  │
│   │     └── Обновление последнего сообщения чата           │
│   │                                                         │
│   └── 21. Эмит события messageReceived                     │
│        │                                                   │
│        ▼                                                   │
│  🎯 ChatDetailComponent (All Participants)                │
│   │                                                         │
│   ├── 22. Подписчики получают новое сообщение              │
│   │                                                         │
│   ├── 23. Обновление UI в реал-тайм                        │
│   │     ├── Добавление сообщения в список                  │
│   │     ├── Автоскролл к последнему сообщению              │
│   │     └── Воспроизведение звука уведомления              │
│   │                                                         │
│   └── 24. Отметка сообщения как прочитанного               │
│         └── markAsRead(messageId)                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3️⃣ Индикаторы набора текста (Typing Indicators)

```
┌─────────────────────────────────────────────────────────────┐
│                 TYPING INDICATORS PROCESS                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  👤 User A                                                  │
│   │                                                         │
│   ├── 1. Начинает печатать в поле ввода                    │
│   │                                                         │
│   └── 2. keydown/input события                             │
│        │                                                   │
│        ▼                                                   │
│  🎯 ChatDetailComponent                                     │
│   │                                                         │
│   ├── 3. onInputChange() обработчик                        │
│   │                                                         │
│   ├── 4. Debounce логика (300ms)                           │
│   │    ├── Если первый символ → startTyping()              │
│   │    └── Если пауза > 2сек → stopTyping()                │
│   │                                                         │
│   └── 5. chatHubService.startTyping(chatId)                │
│        │                                                   │
│        ▼                                                   │
│  🔧 ChatHubService                                         │
│   │                                                         │
│   ├── 6. connection.invoke('StartTyping', chatId)          │
│   │                                                         │
│   └── 7. Установка таймера автостопа (5 секунд)            │
│        │                                                   │
│        ▼                                                   │
│  🌐 SignalR ChatHub Server                                  │
│   │                                                         │
│   ├── 8. Получение события StartTyping                     │
│   │                                                         │
│   ├── 9. Добавление пользователя в список печатающих       │
│   │    └── typingUsers[chatId].add(userId)                 │
│   │                                                         │
│   └── 10. Уведомление других участников                    │
│         └── Clients.GroupExcept(chatId, connectionId)      │
│             .SendAsync('UserStartedTyping', userId)        │
│              │                                             │
│              ▼                                             │
│  🔧 ChatHubService (Other Participants)                   │
│   │                                                         │
│   ├── 11. onUserStartedTyping() обработчик                 │
│   │                                                         │
│   └── 12. Эмит события userTypingChanged                   │
│        │                                                   │
│        ▼                                                   │
│  🎯 ChatDetailComponent (Other Participants)              │
│   │                                                         │
│   ├── 13. Обновление списка печатающих                     │
│   │     └── typingUsers.add(userId)                        │
│   │                                                         │
│   └── 14. Отображение индикатора                           │
│         └── "Пользователь печатает..."                     │
│                                                             │
│  ⏰ Автоматическая остановка                                │
│   │                                                         │
│   ├── 15. Таймер срабатывает через 5 секунд                │
│   │                                                         │
│   ├── 16. chatHubService.stopTyping(chatId)                │
│   │                                                         │
│   └── 17. Удаление индикатора у всех участников            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4️⃣ Уведомления в реал-тайм

```
┌─────────────────────────────────────────────────────────────┐
│               REAL-TIME NOTIFICATIONS PROCESS              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🔔 NotificationHubService (@core)                         │
│   │                                                         │
│   ├── 1. Подключение к NotificationHub                     │
│   │    └── URL: '/hubs/notifications'                      │
│   │                                                         │
│   ├── 2. Настройка обработчиков                            │
│   │    ├── onReceiveNotification()                         │
│   │    ├── onMatchFound()                                  │
│   │    ├── onNewMessage()                                  │
│   │    └── onUserOnline()                                  │
│   │                                                         │
│   └── 3. Присоединение к персональной группе               │
│        └── Groups.AddToGroupAsync(userId)                  │
│              │                                             │
│              ▼                                             │
│  🎯 Триггеры уведомлений                                   │
│   │                                                         │
│   ├── 📧 Новое сообщение                                   │
│   │   ├── Пользователь получает сообщение                  │
│   │   ├── Если приложение неактивно                        │
│   │   └── → Отправка push уведомления                      │
│   │                                                         │
│   ├── 💕 Новый матч                                        │
│   │   ├── Взаимный лайк обнаружен                          │
│   │   ├── Создание нового чата                             │
│   │   └── → Уведомление обеим сторонам                     │
│   │                                                         │
│   ├── 👤 Пользователь онлайн                               │
│   │   ├── Друг/матч заходит в приложение                   │
│   │   └── → Обновление статуса в UI                        │
│   │                                                         │
│   └── 🎯 Новая рекомендация                                │
│       ├── Система находит подходящего пользователя         │
│       └── → Уведомление о новых карточках                  │
│              │                                             │
│              ▼                                             │
│  🌐 NotificationHub Server                                  │
│   │                                                         │
│   ├── 4. SendNotificationToUser(userId, notification)      │
│   │                                                         │
│   ├── 5. Определение типа уведомления                      │
│   │    ├── InApp — показ в приложении                      │
│   │    ├── Push — браузерное уведомление                   │
│   │    └── Email — отправка на почту                       │
│   │                                                         │
│   └── 6. Clients.Group(userId).SendAsync()                 │
│        └── 'ReceiveNotification', notification             │
│              │                                             │
│              ▼                                             │
│  🔧 NotificationHubService (Client)                       │
│   │                                                         │
│   ├── 7. onReceiveNotification() обработчик                │
│   │                                                         │
│   ├── 8. Определение способа отображения                   │
│   │    ├── Если приложение активно → InApp                 │
│   │    └── Если приложение неактивно → Browser Push        │
│   │                                                         │
│   └── 9. Эмит события notificationReceived                 │
│        │                                                   │
│        ▼                                                   │
│  🎯 Layout/Header Component                                │
│   │                                                         │
│   ├── 10. Обновление счётчика уведомлений                  │
│   │     └── notificationCount++                            │
│   │                                                         │
│   ├── 11. Показ toast уведомления                          │
│   │     ├── Иконка по типу уведомления                     │
│   │     ├── Текст сообщения                                │
│   │     └── Кнопка действия (если есть)                    │
│   │                                                         │
│   └── 12. Воспроизведение звука                            │
│         └── notificationSound.play()                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 SignalR Hubs и методы

### ChatHub методы
```typescript
interface ChatHub {
  // Управление соединением
  OnConnectedAsync(): Promise<void>
  OnDisconnectedAsync(exception?: Error): Promise<void>
  
  // Управление чатами
  JoinChat(chatId: string): Promise<void>
  LeaveChat(chatId: string): Promise<void>
  
  // Сообщения
  SendMessage(chatId: string, message: string): Promise<void>
  MarkAsRead(chatId: string, messageId: string): Promise<void>
  
  // Индикаторы набора
  StartTyping(chatId: string): Promise<void>
  StopTyping(chatId: string): Promise<void>
  
  // Статус пользователя
  UpdateOnlineStatus(isOnline: boolean): Promise<void>
}
```

### NotificationHub методы
```typescript
interface NotificationHub {
  // Управление соединением
  OnConnectedAsync(): Promise<void>
  OnDisconnectedAsync(exception?: Error): Promise<void>
  
  // Уведомления
  SendNotification(userId: string, notification: Notification): Promise<void>
  MarkNotificationAsRead(notificationId: string): Promise<void>
  GetUnreadCount(): Promise<number>
  
  // Групповые уведомления
  BroadcastToAll(message: string): Promise<void>
  SendToGroup(groupName: string, message: string): Promise<void>
}
```

### Client-side обработчики событий
```typescript
// ChatHubService
connection.on('ReceiveMessage', (message: Message) => {
  this.messageReceived.next(message);
});

connection.on('UserJoinedChat', (userId: string, chatId: string) => {
  this.userJoinedChat.next({ userId, chatId });
});

connection.on('UserLeftChat', (userId: string, chatId: string) => {
  this.userLeftChat.next({ userId, chatId });
});

connection.on('UserStartedTyping', (userId: string, chatId: string) => {
  this.userStartedTyping.next({ userId, chatId });
});

connection.on('UserStoppedTyping', (userId: string, chatId: string) => {
  this.userStoppedTyping.next({ userId, chatId });
});

// NotificationHubService
connection.on('ReceiveNotification', (notification: Notification) => {
  this.notificationReceived.next(notification);
});

connection.on('MatchFound', (match: Match) => {
  this.matchFound.next(match);
});

connection.on('UserOnlineStatusChanged', (userId: string, isOnline: boolean) => {
  this.userOnlineStatusChanged.next({ userId, isOnline });
});
```

## ⚡ Производительность и оптимизация

### Управление соединениями
- **Автоматическое переподключение** при потере связи
- **Heartbeat** для проверки состояния соединения
- **Graceful shutdown** при закрытии приложения
- **Connection pooling** на сервере

### Оптимизация трафика
- **Debouncing** для typing indicators (300ms)
- **Batching** уведомлений при высокой нагрузке
- **Compression** сообщений (gzip)
- **Message deduplication** по messageId

### Обработка ошибок
- **Retry logic** для неудачных отправок
- **Fallback to HTTP** при проблемах с WebSocket
- **Error logging** и мониторинг
- **User-friendly error messages**

---

**Создано**: 2026-04-20  
**Обновлено**: 2026-04-20  
**Версия диаграммы**: 2.0.0  
**Тип**: Детальный SignalR поток реал-тайм коммуникации