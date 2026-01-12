importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

// Updated Firebase configuration for Pegasus project
firebase.initializeApp({
  apiKey: "AIzaSyARG58Taa7uiGOJ3P8_PLZHVrZ023bvTiI",
  authDomain: "pegasus-ecommerce-fed19.firebaseapp.com",
  projectId: "pegasus-ecommerce-fed19",
  storageBucket: "pegasus-ecommerce-fed19.firebasestorage.app",
  messagingSenderId: "602599280130",
  appId: "1:602599280130:web:af71d70c78f9164f13e11b",
  measurementId: "G-T08XDGYQLG"
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
