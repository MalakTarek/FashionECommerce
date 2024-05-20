const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendProductNotification = functions.firestore
  .document("products/{productId}")
  .onCreate(async (snap) => {
    const product = snap.data();

    // Fetch all users with role "shopper"
    const shoppersSnapshot = await admin.firestore().collection("users")
      .where("role", "==", "shopper")
      .get();

    const tokens = shoppersSnapshot.docs
      .map((doc) => doc.data().fcmToken)
      .filter((token) => !!token);

    if (tokens.length > 0) {
      const payload = {
        notification: {
          title: "New Product Alert!",
          body: `A new product "${product.name}" has been added by ${product.vendorName}. Check it out now!`,
        },
      };

      // Send notifications to all tokens
      const response = await admin.messaging().sendToDevice(tokens, payload);

      console.log("Notifications sent:", response);
    }
  });
