const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

exports.orderTrigger = functions.firestore.document('requests/{requestId}').onCreate
(
    async (snapshot,context)=>
    {
        var payload = {notification: {title: 'Hello', body: 'message body'},
         data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}

         const respond = await admin.messaging().sendToTopic('Admin',payload);    
    }
);

exports.specialorderTrigger = functions.firestore.document('appointments/{appointmentsId}').onCreate
(
    
    
    async (snapshot,context)=>
    {
        var tokens=[];
        tokens.push(snapshot.data().token);
        var payload = {notification: {title: 'SphinxKcc', body: 'you have a new message'},
         data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}

         const respond = await admin.messaging().sendToDevice(tokens,payload);  
    }


);