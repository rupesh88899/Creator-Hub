# Creator Hub — Complete Project Documentation

A feature-complete Flutter social platform built with GetX + Firebase + Cloudinary using MVVM architecture. Designed for Android mobile (not web/desktop).

## Table of Contents

1. [Overview](#overview)
2. [Tech Stack](#tech-stack)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Features](#features)
6. [Auth Flow](#auth-flow)
7. [Data Models](#data-models)
8. [Firestore Schema](#firestore-schema)
9. [Services](#services)
10. [Widgets](#widgets)
11. [Routing](#routing)
12. [State Management](#state-management)
13. [UI / Theming](#ui--theming)
14. [Setup Guide](#setup-guide)
15. [Build & Run](#build--run)
16. [Implementation Order](#implementation-order)
17. [Review Checklist](#review-checklist)
18. [Dependencies](#dependencies)
19. [Security Notes](#security-notes)
20. [License](#license)

---

## Overview

Creator Hub is a social platform where users can sign up / log in with email and password, browse a feed of posts and like them, create posts with images uploaded via Cloudinary, chat one-on-one with other users in real time, browse and list products with Indian rupee (₹) pricing, and view and manage their profile. The app uses **Firebase** for authentication and database, **Cloudinary** for image hosting, and **GetX** for state management and routing. All sensitive credentials are stored in a `.env` file that is not committed to version control.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** 3.41+ (Dart 3.11+) | Cross-platform mobile framework |
| **GetX** | State management, routing, dependency injection |
| **Firebase Auth** | Email/password authentication |
| **Cloud Firestore** | Database for posts, messages, products, users |
| **Cloudinary** | Image upload & hosting (HTTP multipart, no SDK) |
| **flutter_secure_storage** | Session persistence |
| **connectivity_plus** | Network monitoring |
| **animated_notch_bottom_bar** | Notch-style bottom navigation |
| **MVVM Architecture** | Separation of concerns |

### Key Design Decisions

- **No firebase_storage** — All images uploaded directly to Cloudinary via HTTP multipart request
- **Custom widgets over external packages** — Text fields, loading states, empty states, error displays, post cards, and network widget are all hand-built
- **Custom floating notch bar** — Uses `animated_notch_bottom_bar` package for the notch-style bottom navigation
- **Named routes** — GetX named routes with bindings ensure controllers are properly initialized and disposed
- **Responsive layout** — All nav sizes derived from `MediaQuery` for screen adaptability

---

## Architecture

The project follows **MVVM (Model-View-ViewModel)** with GetX controllers acting as the ViewModel layer.

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────┐
│    View      │────▶│  Controller      │────▶│  Repository  │
│ (Widget)     │     │ (GetX / ViewModel)│     │              │
│              │◀────│                  │◀────│              │
└──────────────┘     └──────────────────┘     └──────┬───────┘
                                                      │
                                                      ▼
                                              ┌──────────────┐
                                              │    Service   │
                                              │  (Firestore/ │
                                              │   Firebase)  │
                                              └──────────────┘
```

### Data Flow
1. **View** (StatelessWidget) uses `Obx()` to reactively observe controller state
2. **Controller** (GetxController) manages business logic and reactive state
3. **Repository** abstracts data access (Firestore streams, Cloudinary uploads)
4. **Service** handles raw Firebase / Firestore / HTTP operations

---

## Project Structure

```
lib/
├── main.dart                          # Entry — init Firebase, GetX
├── app.dart                           # GetMaterialApp with theme & routing
├── firebase_options.dart              # Generated Firebase config
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   └── string_constants.dart      # UI strings
│   ├── theme/
│   │   └── app_theme.dart             # Green palette, global theme data
│   ├── utils/
│   │   ├── validators.dart            # Email/password validators
│   │   └── helpers.dart               # Time formatting, etc.
│   └── services/
│       ├── auth_service.dart          # Firebase Auth wrapper
│       ├── firestore_service.dart     # Firestore CRUD helpers
│       ├── cloudinary_service.dart    # Cloudinary image upload
│       └── connectivity_service.dart  # Network state monitoring
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
    ├── post_card.dart
    ├── no_network_widget.dart
    └── floating_bottom_nav.dart
```

---

## Features

### Auth Module
- Login with email + password via Firebase Auth
- Signup with email, password, name, optional photo (Cloudinary)
- Session persistence via flutter_secure_storage
- Full-screen branded splash screen with auto-navigation
- Email regex validation

### Feed Module
- Post list from Firestore stream sorted by timestamp descending
- Like/unlike toggle with Firestore array operations
- Create post with text content + optional image (Cloudinary upload)

### Chat Module
- User list with card UI (all registered users excluding self)
- Real-time 1-to-1 chat via Firestore subcollection
- Auto-created chat rooms per participant pair
- Message status (sending → sent → delivered → read)
- Optimistic message sending with sending indicator
- Auto-scroll to bottom on new message

### Products Module
- Product list from Firestore stream with styled cards
- Add product with name, description, price (₹), image via Cloudinary
- Buy Now mock dialog
- Indian rupee symbol formatting

### Profile Module
- User info display (name, email, photo)
- Logout with confirmation dialog, session clear, navigation to login

---

## Auth Flow

```
App Start
    │
    ▼
SplashScreen
    │
    ├── Has saved session? ──▶ MainScreen (skip login)
    │
    └── No session ──▶ LoginView
                          │
                          ├── Login success ──▶ MainScreen (save session)
                          │
                          └── Tap "Sign Up" ──▶ SignupView
                                                  │
                                                  └── Signup success ──▶ MainScreen (save session)
```

Session is persisted using `flutter_secure_storage`. On app restart, the saved credentials are checked and the user is auto-logged in.

---

## Data Models

### UserModel
`uid`, `email`, `name`, `photoUrl`, `createdAt`

### PostModel
`id`, `userId`, `content`, `imageUrl`, `likes` (List<String>), `createdAt`

### MessageModel
`id`, `senderId`, `receiverId`, `text`, `timestamp`, `status` (sending/sent/delivered/read)

### ProductModel
`id`, `name`, `description`, `price`, `imageUrl`, `userId`, `createdAt`

---

## Firestore Schema

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

## Services

- **AuthService** — login, signup, signOut, auth state stream, session persistence via flutter_secure_storage
- **FirestoreService** — CRUD for users, posts, chats, messages, products collections
- **CloudinaryService** — HTTP POST multipart image upload to unsigned preset, returns image URL
- **ConnectivityService** — Network state RxBool via connectivity_plus, used in MainScreen for no-network overlay

---

## Widgets

| Widget | Usage |
|---|---|
| `CustomTextField` | Themed text input with label, validation error, obscure toggle |
| `LoadingWidget` | Centered `CircularProgressIndicator` |
| `EmptyStateWidget` | Icon + message for empty lists |
| `ErrorWidget` | Error message with retry button |
| `PostCard` | Feed post with avatar, name, content, image, like button + count |
| `NoNetworkWidget` | Full-screen offline illustration + message |
| `FloatingBottomNav` | Notch-style animated bottom navigation with 4 tabs |

---

## Routing

Named routes defined in `AppRoutes`:

| Route | Page | Binding |
|---|---|---|
| `/` | SplashScreen | — |
| `/login` | LoginView | AuthBinding |
| `/signup` | SignupView | AuthBinding |
| `/main` | MainScreen | — |
| `/create-post` | CreatePostView | FeedBinding |
| `/chat-room` | ChatRoomView | — |
| `/add-product` | AddProductView | ProductBinding |

All navigation uses `Get.toNamed()` to ensure bindings run and controllers are properly initialized.

---

## State Management

The app uses **GetX** with three reactive tools:

| Tool | Usage |
|---|---|
| `Rx<T>` / `.obs` | Reactive variables (isLoading, users list, messages list) |
| `Obx()` | Stateless reactive rebuild on variable change |
| `Get.put()` / `Get.find()` | Dependency injection for controllers and services |

Controllers extend `GetxController` and use `onInit()` for initialization, `onClose()` for cleanup. Services are registered once at app level via `Get.put()` in `main.dart`.

---

## UI / Theming

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| `primaryColor` | `#43A047` | Active tab, buttons, links |
| `secondaryColor` | `#81C784` | Secondary accents |
| `backgroundColor` | `#F1F8E9` | Scaffold background |
| `surfaceColor` | `#FFFFFF` | Cards, app bar |
| `textPrimary` | `#1B5E20` | Headings, body text |
| `textSecondary` | `#558B2F` | Subtitles, secondary text |
| `errorColor` | `#E57373` | Error messages |
| `dividerColor` | `#C8E6C9` | Dividers, borders |

### AppBar
- White background, no elevation
- Rounded bottom corners (28px radius)
- Centered title in dark green

### Bottom Nav
- Floating pill-shaped bar above system navigation
- Green circular notch at active tab position
- Smooth 300ms notch slide animation

### Input Fields
- Light green fill (`#F1F8E9`)
- 8px border radius
- Green focus border

### Cards
- 12px border radius
- Subtle elevation
- 16px horizontal margin

---

## Setup Guide

### Prerequisites
- Flutter 3.41+ (Dart 3.11+)
- Android device or emulator
- Firebase project with Authentication + Firestore enabled
- Cloudinary account (free tier)

### Step 1: Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project (or use existing)
3. Register an Android app with the package name from `android/app/build.gradle`
4. Download `google-services.json` and place it in `android/app/`
5. Enable **Email/Password** sign-in in Authentication → Sign-in method
6. Create Firestore database in **test mode**
7. (Optional) Set Firestore rules for authenticated access only

### Step 2: Cloudinary
1. Create a [Cloudinary](https://cloudinary.com) account
2. Note your **Cloud Name** from the dashboard
3. Go to Settings → Upload → Upload presets
4. Create an **unsigned** upload preset
5. Note the preset name (e.g., `ml_default`)

### Step 3: Environment File
Create a file named `.env` in the project root (do not commit this file):

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_UPLOAD_PRESET=your_preset_name
```

### Step 4: Install & Run

```bash
# Clean any previous builds
flutter clean

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

### Step 5: Build APK

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

---

## Build & Run

### Common Commands

```bash
flutter clean                    # Clean build cache
flutter pub get                  # Install/resolve dependencies
flutter run                      # Run on connected device
flutter build apk --release      # Build release APK
flutter analyze                  # Static analysis (must pass with 0 issues)
```

### Android-Specific

- **Min SDK**: 23 (Android 6.0)
- **Target SDK**: 34 (Android 14)
- **Permissions**: INTERNET, ACCESS_NETWORK_STATE (in AndroidManifest.xml)

### Debugging

- `flutter logs` — View device logs
- `flutter analyze` — Run static analysis
- `flutter run --verbose` — Detailed build output

---

## Implementation Order

| Step | Module | What |
|---|---|---|
| 1 | Setup | pubspec.yaml, firebase_options, theme, constants |
| 2 | Core Services | auth, firestore, cloudinary, connectivity |
| 3 | Models | user, post, message, product |
| 4 | Repositories | auth, post, chat, product |
| 5 | Auth Module | Login, Signup, session persistence |
| 6 | Feed Module | Feed list, create post, like/unlike |
| 7 | Chat Module | User list, real-time chat room |
| 8 | Products Module | Add product, product list, Buy Now mock |
| 9 | Profile Module | User info, logout |
| 10 | Widgets | Reusable UI components |
| 11 | Routes | GetX routing with bindings |
| 12 | Polish | Loading, error, empty states, edge cases |

---

## Review Checklist

- [ ] `flutter analyze` passes with no errors
- [ ] No hardcoded dummy data (Firestore/API only)
- [ ] All async operations show loading state
- [ ] All errors show meaningful error messages
- [ ] Empty states shown when no data exists
- [ ] Business logic is in controllers/repositories, not in UI files
- [ ] Reusable widgets extracted where appropriate
- [ ] Auth session persists across app restarts

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core:        # Firebase initialization
  firebase_auth:        # Authentication
  cloud_firestore:      # Database
  get:                  # State management + routing
  image_picker:         # Camera/gallery for uploads
  http:                 # Cloudinary multipart upload
  intl:                 # Date/time formatting
  cached_network_image: # Image caching
  flutter_secure_storage: # Session persistence
  flutter_dotenv:       # Environment variable loading
  connectivity_plus:    # Network monitoring
  animated_notch_bottom_bar:  # Notch bottom navigation
  cupertino_icons:      # Icon set
```

---

## Security Notes

- No API keys or secrets hardcoded in source code
- All Cloudinary credentials are stored in `.env` (gitignored)
- `google-services.json` not tracked in git (in `.gitignore`)
- Firebase config auto-generated in `firebase_options.dart`

---

## License

MIT License
