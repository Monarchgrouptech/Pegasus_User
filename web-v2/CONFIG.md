# Web-v2 Configuration Document

## Overview
This `web-v2` folder contains the updated web version of the Pegasus User app with all Android configuration changes applied.

## Changes Applied

### 1. Firebase Configuration Update
**Source:** Android `google-services.json` and iOS `GoogleService-Info.plist`

The Firebase configuration has been updated from the old 6amMart project to the Pegasus project:

**Old Configuration (6amMart):**
```
Project ID: ammart-8885e
API Key: AIzaSyDFN-73p8zKVZbA0i5DtO215XzAb-xuGSE
Messaging Sender ID: 1000163153346
```

**New Configuration (Pegasus):**
```
Project ID: pegasus-ecommerce-fed19
API Key: AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU
Messaging Sender ID: 602599280130
Auth Domain: pegasus-ecommerce-fed19.firebaseapp.com
Storage Bucket: pegasus-ecommerce-fed19.firebasestorage.app
```

### 2. Google OAuth Configuration
**Updated Client ID** from Android build configuration:
- Old: `491987943015-agln6biv84krpnngdphj87jkko7r9lb8.apps.googleusercontent.com`
- New: `602599280130-sgb79qd6islsfikbunrjmfnm9b9tn10m.apps.googleusercontent.com`

### 3. Firebase Dependencies Update
Aligned with Android Firebase dependencies using BOM (Bill of Materials) v34.6.0:
- Added Firebase Analytics
- Added Firebase Auth
- Updated Firebase Messaging

### 4. Theme Color Changes
Updated theme colors from primary color scheme to text theme body colors:
- Primary Text: `#333333` (light mode) / `#E0E0E0` (dark mode)
- Secondary Text: `#666666` (light mode) / `#B0B0B0` (dark mode)

### 5. Storage Key Updates
Changed localStorage key from `flutter.6ammart_theme` to `flutter.pegasus_theme` for proper theme persistence.

## Files Modified

1. **index.html**
   - Updated Firebase configuration
   - Updated Google Sign-in Client ID
   - Updated localStorage key references
   - Added Firebase Auth and Analytics scripts

2. **style.css**
   - Added text theme color variables
   - Updated color scheme for cards and components
   - Improved dark mode support

3. **firebase-messaging-sw.js**
   - Updated Firebase configuration for Pegasus project
   - Enhanced notification handling

4. **manifest.json**
   - Updated theme_color to match new color scheme
   - Updated background_color for consistency

5. **.htaccess**
   - Maintained server routing configuration for SPA

## Deployment Instructions

1. Replace the current `web/` folder content with `web-v2/` content
2. Ensure Firebase credentials are correct
3. Test Firebase initialization in browser console
4. Verify Google Sign-in works with new Client ID
5. Test push notifications with Firebase Messaging

## Testing Checklist

- [ ] Firebase initializes without errors
- [ ] Google Sign-in works correctly
- [ ] Push notifications are received
- [ ] Theme switching works (light/dark mode)
- [ ] localStorage persists theme preference
- [ ] Web app loads without console errors

## References

- Android: `android/app/google-services.json`
- iOS: `ios/GoogleService-Info.plist`
- Android Build: `android/app/build.gradle.kts`
- App Constants: `lib/util/app_constants.dart`

## Notes

- The Pegasus project uses centralized theme system with `textTheme.bodyLarge!.color` instead of `primaryColor`
- All Firebase SDKs are imported but using older v8.10.1 for compatibility
- Consider upgrading to Firebase SDK v9+ for better modular approach in future updates
