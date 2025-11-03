// web/firebase-messaging-sw.js

importScripts("https://www.gstatic.com/firebasejs/9.1.3/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.1.3/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyA-7zpJrb1Ngo7KB0g155u_PWKJC7fw_-o", // ⚠️ Mets ici tes vraies clés
      appId: "1:1057982567529:web:6d5dd88bf367489aaa3ef8",
      messagingSenderId: "1057982567529",
      projectId: "helper-92613",
});

const messaging = firebase.messaging();

// Optionnel : afficher une notification personnalisée
messaging.onBackgroundMessage(function(payload) {
  console.log('📦 Message reçu en arrière-plan: ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
