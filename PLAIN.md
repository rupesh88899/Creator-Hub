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

## Overview

Creator Hub is a social platform where users can sign up / log in with email and password, browse a feed of posts and like them, create posts with images uploaded via Cloudinary, chat one-on-one with other users in real time, browse and list products with Indian rupee (₹) pricing, and view and manage their profile. The app uses **Firebase** for authentication and database, **Cloudinary** for image hosting, and **GetX** for state management and routing. All sensitive credentials are stored in a `.env` file that is not committed to version control.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.41+ (Dart 3.11+) |
| Platform | Android only |
| State Management | GetX (reactive, MVVM pattern) |
| Backend | Firebase Auth + Cloud Firestore |
| Image Hosting | Cloudinary (HTTP multipart upload, no SDK) |
| Secure Storage | flutter_secure_storage |
| Connectivity | connectivity_plus |
| Navigation | Animated notch bottom bar |

### Key Design Decisions
- **No firebase_storage** — All images uploaded directly to Cloudinary via HTTP multipart request
- **Custom widgets over external packages** — Text fields, loading states, empty states, error displays, post cards, and network widget are all hand-built
- **Custom floating notch bar** — Uses `animated_notch_bottom_bar` package for the notch-style bottom navigation
- **Named routes** — GetX named routes with bindings ensure controllers are properly initialized and disposed
- **Responsive layout** — All nav sizes derived from `MediaQuery` for screen adaptability

## Architecture

The project follows **MVVM (Model-View-ViewModel)** with GetX controllers acting as the ViewModel layer.

### Data Flow
1. **View** (StatelessWidget) uses `Obx()` to reactively observe controller state
2. **Controller** (GetxController) manages business logic and reactive state
3. **Repository** abstracts data access (Firestore streams, Cloudinary uploads)
4. **Service** handles raw Firebase / Firestore / HTTP operations

## Project Structure

```
lib/
├── main.dart                          # App entry: Firebase init, dotenv, connectivity
├── app.dart                           # GetMaterialApp with theme, routes
├── firebase_options.dart              # Generated Firebase config
├── core/
│   ├── services/                      # auth, firestore, cloudinary, connectivity
│   ├── theme/app_theme.dart           # Green palette, global theme data
│   ├── constants/                     # app_constants, string_constants
│   └── utils/helpers.dart             # Date formatting, validation
├── data/
│   ├── models/                        # user, post, message, product
│   └── repositories/                  # auth, feed, chat, product
├── modules/
│   ├── auth/                          # Splash, Login, Signup
│   ├── feed/                          # Feed list, Create post
│   ├── chat/                          # User list, Chat room
│   ├── products/                      # Product list, Add product
│   └── profile/                       # User info, logout
├── routes/                            # app_routes, app_pages
└── widgets/                           # Reusable UI components
```

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

## Auth Flow
```
App Start → SplashScreen → Has session? → Yes → MainScreen
                           No  → LoginView → Login success → MainScreen
                                   Tap Sign Up → SignupView → Signup success → MainScreen
```

## Data Models

### UserModel
`uid`, `email`, `name`, `photoUrl`, `createdAt`

### PostModel
`id`, `userId`, `content`, `imageUrl`, `likes` (List<String>), `createdAt`

### MessageModel
`id`, `senderId`, `receiverId`, `text`, `timestamp`, `status` (sending/sent/delivered/read)

### ProductModel
`id`, `name`, `description`, `price`, `imageUrl`, `userId`, `createdAt`

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
Chat document: `participants` (array\<string\>), `lastMessage` (string), `lastMessageTime` (timestamp)
Message document: `senderId`, `receiverId`, `text`, `timestamp`, `status`

### `products/` collection
`userId`, `title`, `price`, `imageUrl`, `description`, `createdAt`

## Services

- **AuthService** — login, signup, signOut, auth state stream, session persistence
- **FirestoreService** — CRUD for users, posts, chats, messages, products collections
- **CloudinaryService** — HTTP multipart image upload to unsigned preset
- **ConnectivityService** — Network state RxBool via connectivity_plus

## Widgets

| Widget | Usage |
|---|---|
| `CustomTextField` | Themed text input with validation |
| `LoadingWidget` | Centered circular progress |
| `EmptyStateWidget` | Icon + message for empty lists |
| `PostCard` | Feed post with avatar, content, image, likes |
| `NoNetworkWidget` | Full-screen offline indicator |
| `FloatingBottomNav` | Notch-style animated bottom nav |

## Routing

| Route | Page | Binding |
|---|---|---|
| `/` | SplashScreen | — |
| `/login` | LoginView | AuthBinding |
| `/signup` | SignupView | AuthBinding |
| `/main` | MainScreen | — |
| `/create-post` | CreatePostView | FeedBinding |
| `/chat-room` | ChatRoomView | — |
| `/add-product` | AddProductView | ProductBinding |

## State Management

GetX with `Rx<T>` / `.obs` for reactive variables, `Obx()` for reactive rebuilds, `Get.put()` / `Get.find()` for DI. Controllers extend `GetxController`.

## UI / Theming

**Palette:** primary `#43A047`, secondary `#81C784`, background `#F1F8E9`, textPrimary `#1B5E20`, textSecondary `#558B2F`

**AppBar:** White, no elevation, rounded bottom corners (28px)
**Bottom Nav:** Floating pill-shaped bar with green notch animation (300ms)
**Inputs:** Light green fill, 8px radius
**Cards:** 12px radius, subtle elevation

## Setup Guide

### Prerequisites
- Flutter 3.41+ (Dart 3.11+), Android device/emulator
- Firebase project with Auth + Firestore enabled
- Cloudinary account (free tier)

### Steps
1. **Firebase:** Create project, register Android app, download `google-services.json` to `android/app/`, enable Email/Password sign-in, create Firestore database
2. **Cloudinary:** Create account, note cloud name, create unsigned upload preset
3. **Environment:** Create `.env` with `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_UPLOAD_PRESET`
4. **Run:** `flutter clean && flutter pub get && flutter run`

## Build & Run

```bash
flutter clean                    # Clean build cache
flutter pub get                  # Install dependencies
flutter run                      # Run on device
flutter build apk --release      # Build release APK
flutter analyze                  # Static analysis (0 issues)
```

**Android:** Min SDK 23, Target SDK 34, Permissions: INTERNET + ACCESS_NETWORK_STATE

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

## Review Checklist

- [ ] `flutter analyze` passes with no errors
- [ ] No hardcoded dummy data (Firestore/API only)
- [ ] All async operations show loading state
- [ ] All errors show meaningful error messages
- [ ] Empty states shown when no data exists
- [ ] Business logic is in controllers/repositories, not in UI files
- [ ] Reusable widgets extracted where appropriate
- [ ] Auth session persists across app restarts

## Dependencies

`firebase_core`, `firebase_auth`, `cloud_firestore`, `get`, `image_picker`, `http`, `intl`, `cached_network_image`, `flutter_secure_storage`, `flutter_dotenv`, `connectivity_plus`, `animated_notch_bottom_bar`

## Security Notes

- No API keys or secrets hardcoded in source code
- Cloudinary credentials in `.env` (gitignored)
- `google-services.json` not tracked in git (in `.gitignore`)
- Firebase config auto-generated in `firebase_options.dart`

## License

MIT License
