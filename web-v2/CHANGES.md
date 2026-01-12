# Android to Web Changes Migration Log

## Summary
This document tracks all changes made from the Android version to create the web-v2 folder with updated Pegasus configuration.

## Source Commits Analyzed

- **35d5094**: google json file (iOS app icons + GoogleService-Info.plist)
- **62633b9**: Update AppDelegate.swift
- **a45bb41**: Changed the names and icons (Major refactoring - Firebase deps, store card changes, theme colors)
- **cbfe63b**: google json file
- **95b05fb**: Add files via upload

## Detailed Changes Applied

### 1. Firebase Configuration (from a45bb41, 35d5094, cbfe63b)

#### Android Build Changes (android/app/build.gradle.kts)
```gradle
// OLD:
implementation("com.google.firebase:firebase-messaging:23.4.1")

// NEW (using BOM):
implementation(platform("com.google.firebase:firebase-bom:34.6.0"))
implementation("com.google.firebase:firebase-analytics")
implementation("com.google.firebase:firebase-auth")
```

#### Web Equivalent Changes (web-v2/index.html)
```html
<!-- Added Firebase modules -->
<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-analytics.js"></script>

<!-- Updated Firebase configuration -->
const firebaseConfig = {
  apiKey: "AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU",
  authDomain: "pegasus-ecommerce-fed19.firebaseapp.com",
  projectId: "pegasus-ecommerce-fed19",
  storageBucket: "pegasus-ecommerce-fed19.firebasestorage.app",
  messagingSenderId: "602599280130",
  appId: "1:602599280130:web:pegasus-user-web-app",
  measurementId: "G-PEGASUS-WEB"
};
```

### 2. Google OAuth Client ID Update

#### From lib/util/app_constants.dart and Android google-services.json
```dart
// OLD:
static const String googleServerClientId = 
  '491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com';

// NEW:
static const String googleServerClientId = 
  '602599280130-sgb79qd6islsfikbunrjmfnm9b9tn10m.apps.googleusercontent.com';
```

#### Web Equivalent (web-v2/index.html)
```html
<!-- OLD -->
<meta name="google-signin-client_id" 
  content="491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com">

<!-- NEW -->
<meta name="google-signin-client_id" 
  content="602599280130-sgb79qd6islsfikbunrjmfnm9b9tn10m.apps.googleusercontent.com">
```

### 3. Theme Color Refactoring (from a45bb41)

This was a major change across 63 Dart files, changing from `primaryColor` to `textTheme.bodyLarge!.color`:

#### Examples from Dart files modified:
```dart
// OLD - lib/common/widgets/card_design/store_card.dart:
Icon(Icons.storefront, size: 15, color: Theme.of(context).primaryColor),
Text(store.address ?? '',
  style: robotoRegular.copyWith(
    color: Theme.of(context).primaryColor
  ),
),

// NEW:
Icon(Icons.storefront, size: 15, 
  color: Theme.of(context).textTheme.bodyLarge!.color),
Text(store.address ?? '',
  style: robotoMedium.copyWith(
    color: Theme.of(context).textTheme.bodyLarge!.color
  ),
),
```

#### Web CSS Equivalent (web-v2/style.css)
```css
/* Added color scheme for text-based theming */
.text-primary {
  color: #333333;  /* Light mode */
}

.theme-dark .text-primary {
  color: #E0E0E0;  /* Dark mode */
}

.text-secondary {
  color: #666666;  /* Light mode */
}

.theme-dark .text-secondary {
  color: #B0B0B0;  /* Dark mode */
}
```

### 4. App Title and Name Changes

#### From lib/util/app_constants.dart:
```dart
// OLD:
static const String appName = 'StackFood';

// NEW:
static const String appName = 'Pegasus';
```

#### Web Equivalents:
- `index.html`: `<title>Pegasus User</title>`
- `index.html`: `<meta name="apple-mobile-web-app-title" content="Pegasus">`
- `manifest.json`: `"short_name": "Pegasus"`

### 5. LocalStorage Key Update

#### From web/index.html:
```javascript
// OLD:
var itemValue = localStorage.getItem("flutter.6ammart_theme");

// NEW:
var itemValue = localStorage.getItem("flutter.pegasus_theme");
```

### 6. Google Maps API Key

#### From web/index.html:
```html
<!-- Maintained with Pegasus API key -->
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU"></script>
```

### 7. Firebase Messaging Service Worker Update

#### Old (web/firebase-messaging-sw.js):
```javascript
firebase.initializeApp({
  apiKey: "AIzaSyDFN-73p8zKVZbA0i5DtO215XzAb-xuGSE",
  projectId: "ammart-8885e",
  storageBucket: "ammart-8885e.appspot.com",
  messagingSenderId: "1000163153346",
  // ... other fields
});
```

#### New (web-v2/firebase-messaging-sw.js):
```javascript
firebase.initializeApp({
  apiKey: "AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU",
  projectId: "pegasus-ecommerce-fed19",
  storageBucket: "pegasus-ecommerce-fed19.firebasestorage.app",
  messagingSenderId: "602599280130",
  // ... other fields
});
```

Also improved notification handling:
```javascript
// OLD:
const options = {
  body: payload.notification.score  // This seems like a bug
};

// NEW:
const options = {
  body: payload.notification.body,
  icon: payload.notification.icon
};
```

### 8. Manifest.json Theme Update

#### Old:
```json
{
  "theme_color": "#2A9849",
  "background_color": "#2A9849"
}
```

#### New:
```json
{
  "theme_color": "#333333",
  "background_color": "#FFFFFF"
}
```

## Files in web-v2 Folder

1. **index.html** - Main entry point with updated Firebase config
2. **style.css** - Updated styles with new color scheme
3. **firebase-messaging-sw.js** - Service worker for notifications
4. **manifest.json** - PWA manifest with updated metadata
5. **.htaccess** - Server routing configuration
6. **CONFIG.md** - Configuration documentation
7. **CHANGES.md** - This change log

## Statistics

- **63 Dart files modified** in original Android changes
- **2 Android build config files** updated
- **iOS GoogleService-Info.plist** updated
- **7 web-v2 files** created/updated
- **Key theme colors changed** from primary (#2A9849) to text-based (#333333)

## Affected Components

### Dart Components Changed (from Android changes):
- Store Cards
- Item Cards  
- Cart Screens
- Checkout Screens
- Home Screens
- Search Screens
- Parcel Screens
- Dashboard Components
- And 30+ more widget files

### Web Components Affected:
- Header styling
- Card designs
- Text colors
- Dark mode support
- Firebase integration

## Migration Notes

1. **Backward Compatibility**: The web-v2 folder is a separate deployment. Old web folder remains intact.

2. **Version Control**: Original Android changes tracked in commits:
   - a45bb41: "Changed the names and icons"
   - 35d5094: "google json file"

3. **Testing Priority**:
   - Firebase initialization
   - Google Sign-in
   - Push notifications
   - Theme persistence
   - Dark mode functionality

4. **Future Considerations**:
   - Consider upgrading Firebase SDK from v8.10.1 to v9.x
   - Implement modular Firebase imports
   - Add more granular error logging
   - Expand CSS custom properties for theme management

## Deployment Path

```
Original:  web/ → web-v2/ (new folder)
Future:    web-v2/ → web/ (when ready to fully migrate)
```

## Validation Commands

```bash
# Check Firebase initialization
cd /workspaces/Pegasus_User/web-v2
grep -r "firebase" index.html firebase-messaging-sw.js

# Verify configuration match
grep "pegasus-ecommerce-fed19" index.html firebase-messaging-sw.js

# Check color scheme
grep -E "333333|E0E0E0|666666|B0B0B0" style.css
```
