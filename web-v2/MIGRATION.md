# Web-v2 Migration Guide

## Quick Start

The `web-v2` folder contains all Android changes applied to the web version of the Pegasus app. This is a complete, standalone deployment folder ready for production use.

## Key Updates

### 1. Firebase Project Changed
- **From**: 6amMart project (ammart-8885e)
- **To**: Pegasus project (pegasus-ecommerce-fed19)

### 2. Authentication Updated
- **Google OAuth Client ID**: Updated to match Android/iOS
- **Firebase Auth**: Now enabled alongside messaging

### 3. Design System Unified
- **Color Scheme**: Changed from primary color to body text colors
- **Theme Persistence**: Updated localStorage key
- **Dark Mode**: Improved support with new color scheme

## File Structure

```
web-v2/
├── index.html                    # Main entry point
├── style.css                      # Updated styling
├── firebase-messaging-sw.js       # Push notification service worker
├── manifest.json                  # PWA manifest
├── .htaccess                      # Apache routing config
├── CONFIG.md                      # Configuration details
├── CHANGES.md                     # Detailed change log
└── MIGRATION.md                   # This file
```

## Pre-Deployment Checklist

### 1. Firebase Configuration
- [ ] Verify Firebase project ID: `pegasus-ecommerce-fed19`
- [ ] Verify API Key: `AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU`
- [ ] Verify Messaging Sender ID: `602599280130`
- [ ] Confirm Firebase project access

### 2. Google OAuth Setup
- [ ] Verify OAuth Client ID: `602599280130-sgb79qd6islsfikbunrjmfnm9b9tn10m.apps.googleusercontent.com`
- [ ] Add domain to authorized JavaScript origins
- [ ] Add redirect URIs if needed

### 3. Google Maps
- [ ] Verify API Key is active: `AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU`
- [ ] Enable Maps JavaScript API
- [ ] Check quota limits

### 4. Hosting Setup
- [ ] Configure server to serve index.html for 404s (SPA routing)
- [ ] Ensure .htaccess is active (if using Apache)
- [ ] Enable HTTPS
- [ ] Configure CORS if needed

### 5. Testing Environment
- [ ] Set up staging domain
- [ ] Configure Firebase security rules for testing
- [ ] Test on multiple browsers
- [ ] Test on mobile devices

## Deployment Steps

### Step 1: Backup Current Web Version
```bash
cp -r web web.backup.$(date +%Y%m%d)
```

### Step 2: Replace Web Files
```bash
# Option A: Copy files from web-v2
cp web-v2/* web/

# Option B: Switch folder names
mv web web.old
mv web-v2 web
```

### Step 3: Verify Configuration
```bash
# Check Firebase configuration
grep "pegasus-ecommerce-fed19" web/index.html
grep "602599280130" web/firebase-messaging-sw.js

# Check Google OAuth
grep "602599280130-sgb" web/index.html

# Check theme colors
grep "333333" web/style.css
```

### Step 4: Test Locally
```bash
# Run a local web server
python3 -m http.server 8000

# Visit http://localhost:8000
# Check browser console for errors
# Test Firebase initialization
# Test Google Sign-in
```

### Step 5: Deploy to Production
```bash
# Push to your deployment branch
git add web/
git commit -m "Update web to Pegasus v2 configuration"
git push origin [branch-name]

# Deploy through your CI/CD pipeline
# (deployment process varies by hosting provider)
```

## Verification After Deployment

### 1. Browser Console Checks
```javascript
// Check Firebase initialization
console.log(firebase.app().name);  // Should show '[DEFAULT]'

// Check configuration
console.log(firebase.app().options.projectId);  
// Should show 'pegasus-ecommerce-fed19'
```

### 2. Network Tab Checks
- [ ] index.html loads successfully
- [ ] Firebase SDK loads from gstatic.com
- [ ] Service worker registers (firebase-messaging-sw.js)
- [ ] No mixed content warnings (all HTTPS)

### 3. Functional Tests
- [ ] Page loads without console errors
- [ ] Theme switcher works (light/dark mode)
- [ ] LocalStorage saves theme preference
- [ ] Google Sign-in appears and works
- [ ] Push notifications can be requested
- [ ] Maps API calls work

### 4. Mobile Tests
- [ ] Add to home screen (PWA works)
- [ ] Manifest loads correctly
- [ ] Service worker caches assets
- [ ] App icon displays properly

## Rollback Procedure

If issues occur, rollback is simple:

```bash
# Option A: Restore from backup
rm -rf web
mv web.backup.YYYYMMDD web

# Option B: Restore from git
git checkout HEAD~1 -- web/

# Option C: Use previous web.old folder
rm -rf web
mv web.old web
```

## Performance Considerations

### Bundle Size
- Firebase SDK: ~50KB
- Style CSS: ~10KB
- Service Worker: ~2KB
- Total additional: ~62KB

### Loading Optimization
- Service worker caches static assets
- Firebase SDK is deferred
- Style CSS is critical (no async)
- Index.html is minimal

### Recommendations
1. Enable GZIP compression on server
2. Use CDN for static assets
3. Enable browser caching with far-future headers
4. Monitor Firebase quota usage

## Troubleshooting

### Firebase Not Initializing
```javascript
// In browser console
firebase.app().options
// Should show all configuration fields

// Check for CORS issues
// Check Network tab for firebase SDK loading
```

### Google Sign-in Not Working
```javascript
// Check if library loaded
window.gapi ? 'loaded' : 'not loaded'

// Verify client ID
document.querySelector('meta[name="google-signin-client_id"]').content
```

### Service Worker Registration Issues
```javascript
// Check service worker
navigator.serviceWorker.getRegistrations().then(r => console.log(r))

// Check browser console for errors
// Ensure HTTPS is enabled (required for service workers)
```

### Push Notifications Not Working
1. Verify Firebase Messaging API is enabled
2. Check browser notification permissions
3. Verify service worker is registered
4. Check Firebase Security Rules

## Browser Support

- **Modern Browsers**: Chrome, Firefox, Safari, Edge (fully supported)
- **IE11**: Not supported (no service worker, limited Firebase support)
- **Mobile**: iOS Safari 11.3+, Chrome, Firefox

## Support and Monitoring

### Monitoring Tools
- Firebase Console (analytics, messaging)
- Google Search Console
- Browser DevTools
- Custom error logging (optional)

### Common Issues Log
| Issue | Solution |
|-------|----------|
| 403 Unauthorized | Check API keys and OAuth credentials |
| Service Worker not registering | Enable HTTPS, check .htaccess |
| Theme not persisting | Clear localStorage, check localStorage access |
| Push notifications silent | Check notification permissions, Firebase rules |
| Maps not loading | Verify API key, check quota |

## Next Steps

1. **Test in staging environment** (1-2 days)
2. **Monitor staging analytics** (3-5 days)
3. **Deploy to production**
4. **Monitor error rates** for 24 hours
5. **Notify users** of any changes

## Contact & Support

For issues or questions:
1. Check CONFIG.md and CHANGES.md
2. Review browser console errors
3. Check Firebase console logs
4. Contact development team with error screenshots

## Version Info

- **Web-v2 Version**: Based on Pegasus Android changes (commit a45bb41)
- **Firebase Project**: pegasus-ecommerce-fed19
- **Firebase SDK**: 8.10.1
- **Created**: 2026-01-12
- **Last Updated**: 2026-01-12
