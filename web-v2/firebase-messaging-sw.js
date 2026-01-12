importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

// Updated Firebase configuration for Pegasus project
firebase.initializeApp({
  apiKey: "AIzaSyBtpRQdTwBFMzQQisxNiyiaAcuHs-q28BU",
  authDomain: "pegasus-ecommerce-fed19.firebaseapp.com",
  projectId: "pegasus-ecommerce-fed19",
  storageBucket: "pegasus-ecommerce-fed19.firebasestorage.app",
  messagingSenderId: "602599280130",
  appId: "1:602599280130:web:pegasus-user-web-app",
  measurementId: "G-PEGASUS-WEB"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.body,
                icon: payload.notification.icon
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});

self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
    event.notification.close();
});
