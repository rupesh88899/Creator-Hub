# Creator Hub

A feature-complete Flutter social platform with authentication, feed, chat, products, and profile management.

## Tech Stack

- **Framework:** Flutter 3.41+ (Android only)
- **State Management:** GetX (MVVM architecture)
- **Backend:** Firebase Auth + Cloud Firestore
- **Media:** Cloudinary (image upload via HTTP multipart)
- **UI:** Custom widgets, green palette (#43A047), notch bottom nav

## Features

| Module | Capabilities |
|---|---|
| **Auth** | Login, signup, splash screen, session persistence via flutter_secure_storage |
| **Feed** | Post list with likes, create post with image upload (Cloudinary) |
| **Chat** | Real-time 1-to-1 messaging, user list, timestamps, delivery status |
| **Products** | Product listing, add product with image, Buy Now mock dialog (₹ pricing) |
| **Profile** | User info display, logout with confirmation dialog |

## Architecture

```
lib/
├── core/           # Services (auth, firestore, cloudinary, connectivity), theme, constants, utils
├── data/           # Models (user, post, message, product) + repositories
├── modules/        # Feature modules (auth, feed, chat, products, profile)
│   └── */          # Each module: bindings/, controllers/, views/
├── routes/         # GetX routing (app_pages, app_routes)
└── widgets/        # Reusable widgets (custom_text_field, loading, empty_state, error, post_card, no_network, floating_bottom_nav)
```

## Setup

### Prerequisites
- Flutter 3.41+ (Dart 3.11+)
- Android device/emulator
- Firebase project with Auth + Firestore enabled
- Cloudinary account

### 1. Firebase Setup
1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Enable **Email/Password** sign-in in Authentication
3. Create a Firestore database (test mode)
4. Download `google-services.json` → place in `android/app/`
5. Enable **Firestore** with rules allowing reads/writes

### 2. Environment Variables
Create `.env` in the project root:
```
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_UPLOAD_PRESET=your_unsigned_preset
```

### 3. Cloudinary
1. Create an unsigned upload preset from your Cloudinary dashboard
2. Set the preset name in `.env` as `CLOUDINARY_UPLOAD_PRESET`
3. Default preset name in code: `ml_default`

### 4. Run
```bash
flutter clean
flutter pub get
flutter run
```

## Key Packages

| Package | Purpose |
|---|---|
| `get` | State management & routing |
| `firebase_auth` | Authentication |
| `cloud_firestore` | Database |
| `image_picker` | Camera/gallery access |
| `http` | Cloudinary multipart upload |
| `flutter_secure_storage` | Auth token persistence |
| `connectivity_plus` | Network state monitoring |
| `animated_notch_bottom_bar` | Bottom navigation notch animation |
| `cached_network_image` | Image caching |

## Screenshots

*(Add screenshots here)*

## License

MIT
