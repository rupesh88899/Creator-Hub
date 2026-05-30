# Creator Hub Mobile App — Master Plan

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform mobile framework |
| **GetX** | State management, routing, dependency injection |
| **Firebase Auth** | Email/password authentication |
| **Cloud Firestore** | Database for posts, messages, products, users |
| **Cloudinary** | Image upload & hosting |
| **MVVM Architecture** | Separation of concerns |

---

## Folder Structure

```
lib/
├── main.dart                          # Entry — init Firebase, GetX
├── app.dart                           # GetMaterialApp with theme & routing
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   └── string_constants.dart      # UI strings
│   ├── theme/
│   │   └── app_theme.dart             # Theme configuration
│   ├── utils/
│   │   ├── validators.dart            # Email/password validators
│   │   └── helpers.dart               # Time formatting, etc.
│   └── services/
│       ├── auth_service.dart          # Firebase Auth wrapper
│       ├── firestore_service.dart     # Firestore CRUD helpers
│       └── cloudinary_service.dart    # Cloudinary image upload
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── post_model.dart
│   │   ├── message_model.dart
│   │   └── product_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── post_repository.dart
│       ├── chat_repository.dart
│       └── product_repository.dart
├── modules/
│   ├── auth/
│   │   ├── controllers/auth_controller.dart
│   │   ├── views/login_view.dart
│   │   ├── views/signup_view.dart
│   │   └── bindings/auth_binding.dart
│   ├── feed/
│   │   ├── controllers/feed_controller.dart
│   │   ├── views/feed_view.dart
│   │   ├── views/create_post_view.dart
│   │   └── bindings/feed_binding.dart
│   ├── chat/
│   │   ├── controllers/chat_list_controller.dart
│   │   ├── controllers/chat_room_controller.dart
│   │   ├── views/chat_list_view.dart
│   │   ├── views/chat_room_view.dart
│   │   └── bindings/chat_binding.dart
│   ├── products/
│   │   ├── controllers/product_controller.dart
│   │   ├── views/product_list_view.dart
│   │   ├── views/add_product_view.dart
│   │   └── bindings/product_binding.dart
│   └── profile/
│       ├── controllers/profile_controller.dart
│       ├── views/profile_view.dart
│       └── bindings/profile_binding.dart
├── routes/
│   ├── app_routes.dart                # Route name constants
│   └── app_pages.dart                 # Route list with bindings
└── widgets/
    ├── custom_text_field.dart
    ├── loading_widget.dart
    ├── empty_state_widget.dart
    ├── error_widget.dart
    └── post_card.dart
```

---

## Firebase Firestore Schema

### `users/` collection

| Field | Type | Notes |
|---|---|---|
| `uid` | string | Firebase Auth UID |
| `email` | string | |
| `name` | string | |
| `photoUrl` | string | From Cloudinary |
| `createdAt` | timestamp | |

### `posts/` collection

| Field | Type | Notes |
|---|---|---|
| `userId` | string | |
| `userName` | string | Denormalized |
| `userPhoto` | string | Denormalized |
| `text` | string | |
| `imageUrl` | string (nullable) | Cloudinary URL |
| `likes` | array\<string\> | User IDs who liked |
| `likeCount` | number | |
| `createdAt` | timestamp | |

### `chats/{chatId}/messages/{messageId}` (subcollection)

Chat document:

| Field | Type |
|---|---|
| `participants` | array\<string\> |
| `lastMessage` | string |
| `lastMessageTime` | timestamp |

Message document:

| Field | Type |
|---|---|
| `senderId` | string |
| `receiverId` | string |
| `text` | string |
| `timestamp` | timestamp |
| `status` | string (sent / delivered / read) |

### `products/` collection

| Field | Type | Notes |
|---|---|---|
| `userId` | string | |
| `title` | string | |
| `price` | number | |
| `imageUrl` | string | Cloudinary URL |
| `description` | string | |
| `createdAt` | timestamp | |

---

## Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.13.0
  firebase_auth: ^5.5.0
  cloud_firestore: ^5.6.0
  get: ^4.7.2
  image_picker: ^1.1.2
  http: ^1.3.0
  intl: ^0.20.2
  cached_network_image: ^3.4.1
  flutter_secure_storage: ^9.2.4
```

---

## Navigation / Routing Flow

```
SplashScreen (check auth session)
  ├── Not logged in → LoginScreen ↔ SignUpScreen
  └── Logged in → MainShell (BottomNavigationBar)
       ├── Tab 1: FeedView (+ FAB → CreatePostView)
       ├── Tab 2: ChatListView (user list) → ChatRoomView
       ├── Tab 3: ProductListView → AddProductView
       └── Tab 4: ProfileView (user info, logout)
```

Route names:

| Route | Name |
|---|---|
| `/login` | `AppRoutes.login` |
| `/signup` | `AppRoutes.signup` |
| `/feed` | `AppRoutes.feed` |
| `/create-post` | `AppRoutes.createPost` |
| `/chat-list` | `AppRoutes.chatList` |
| `/chat-room` | `AppRoutes.chatRoom` |
| `/products` | `AppRoutes.products` |
| `/add-product` | `AppRoutes.addProduct` |
| `/profile` | `AppRoutes.profile` |

---

## Cloudinary Setup Guide (to do)

1. Go to [cloudinary.com](https://cloudinary.com) and sign up (free tier)
2. From the Dashboard, copy: **Cloud Name**, **API Key**, **API Secret**
3. Create an **unsigned upload preset**: Settings → Upload → Upload presets → Add upload preset, set Signing Mode to `Unsigned`, enable Auto-generate filename, save and copy the preset name
4. Add these to `lib/core/constants/app_constants.dart`

---

## Implementation Order

| Step | Module | What |
|---|---|---|
| 1 | Setup | `pubspec.yaml`, `firebase_options.dart`, theme, constants |
| 2 | Core Services | `auth_service`, `firestore_service`, `cloudinary_service` |
| 3 | Models | `user_model`, `post_model`, `message_model`, `product_model` |
| 4 | Repositories | Auth, Post, Chat, Product repositories |
| 5 | Auth Module | Login, Signup views + controller, session persistence |
| 6 | Feed Module | Feed list, create post, like/unlike |
| 7 | Chat Module | User list, real-time chat room |
| 8 | Products Module | Add product, product list, Buy Now mock |
| 9 | Profile Module | User info, logout |
| 10 | Widgets | Reusable UI components (text field, loading, empty state, error, post card) |
| 11 | Routes | GetX routing setup |
| 12 | Polish | Loading states, error handling, empty states, edge cases |

---

## Review Checklist (to verify after each step)

- [ ] `flutter analyze` passes with no errors
- [ ] No hardcoded dummy data (Firestore/API only)
- [ ] All async operations show loading state
- [ ] All errors show meaningful error messages
- [ ] Empty states shown when no data exists
- [ ] Business logic is in controllers/repositories, not in UI files
- [ ] Reusable widgets extracted where appropriate
- [ ] Auth session persists across app restarts
