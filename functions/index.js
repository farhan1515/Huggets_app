const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {v4: uuidv4} = require("uuid");

admin.initializeApp();
const firestore = admin.firestore();

// Using the standard pubsub approach that works across all Firebase versions
exports.checkAbsences = functions.pubsub
  .topic("daily-attendance-check")
  .onPublish(async () => {
    const today = new Date();
    const customersSnapshot = await firestore.collection("customers").get();

    for (const customerDoc of customersSnapshot.docs) {
      const customer = customerDoc.data();
      const attendanceSnapshot = await firestore
        .collection("attendance")
        .where("customerId", "==", customer.id)
        .orderBy("timestamp", "desc")
        .limit(1)
        .get();

      if (attendanceSnapshot.empty) {
        const notification = {
          id: uuidv4(),
          customerId: customer.id,
          customerName: customer.name,
          message: `⚠️ ${customer.name} has not visited the gym for ` + 
            "the last 3 days.",
          createdAt: today.toISOString(),
        };
        await firestore.collection("notifications")
          .doc(notification.id)
          .set(notification);
        continue;
      }

      const lastAttendance = 
        new Date(attendanceSnapshot.docs[0].data().timestamp);
      const daysSinceLast = Math.floor(
        (today - lastAttendance) / (1000 * 60 * 60 * 24)
      );

      if (daysSinceLast >= 3) {
        const notification = {
          id: uuidv4(),
          customerId: customer.id,
          customerName: customer.name,
          message: `⚠️ ${customer.name} has not visited the gym for ` + 
            "the last 3 days.",
          createdAt: today.toISOString(),
        };
        await firestore.collection("notifications")
          .doc(notification.id)
          .set(notification);
      }
    }

    return null;

  });

    

   