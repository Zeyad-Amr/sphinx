const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);
const db = admin.firestore();

exports.newRequest = functions.firestore.document('requests/{requestId}').onCreate
(
    async (snapshot,context)=>
    {

        var tokens=[];

        const dataa = db.collection('users').doc(snapshot.data().DoctorPhone);
        const doc = await dataa.get();

        tokens.push(doc.data().token);
       


      
        var payload = {notification: {title:'New Consultation request' , body:snapshot.data().name +' requests for an appointment' },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);


exports.newAppointment = functions.firestore.document('appointments/{appointmentsId}').onCreate
(
    async (snapshot,context)=>
    {

        
        var tokens=[];

        const dataa = db.collection('users').doc(snapshot.data().patientPhone);
        const doc = await dataa.get();
          
        tokens.push(doc.data().token);
       


      
        var payload = {notification: {title:'Your Consultation date has been set' , body:snapshot.data().DoctorName +' set your consultation date at '+ snapshot.data().AppointmentDate },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);

exports.newChatMessage = functions.firestore.document('chatRooms/{chatRoomId}/chats/{message}').onCreate
(
    async (snapshot,context)=>
    {

        
        var tokens=[];

        const dataa = db.collection('users').doc(snapshot.data().sendTo);
        const doc = await dataa.get();
          
        tokens.push(doc.data().token);
       


      
        var payload = {notification: {title:snapshot.data().sendByName , body:snapshot.data().message },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);

/* 
exports.req = functions.firestore.document('requests/{requestId}').onCreate
(
    async (snapshot,context)=>
    {
       
     
      
        var payload = {notification: {title:'Consult' , body:snapshot.data().name +' requesting' },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice('eDaoIkJsQVCG2MlwLRqy0m:APA91bF3C49UH9ETX0R1ST_17I1k-vIaXWwq7La148P6TD4VmvwBDAduNxBobL-npB5FWm19LlD9dA5j4lEGZ8JHIiJLPtRBFkKJF3f2-sekW6IfTPTYh0Stldz3_Q-L5liWzNIxT8Ck',payload); 
    }
); */


/*  var token =[];
       token.push("eDaoIkJsQVCG2MlwLRqy0m:APA91bF3C49UH9ETX0R1ST_17I1k-vIaXWwq7La148P6TD4VmvwBDAduNxBobL-npB5FWm19LlD9dA5j4lEGZ8JHIiJLPtRBFkKJF3f2-sekW6IfTPTYh0Stldz3_Q-L5liWzNIxT8Ck");  */
        
/* exports.orderTriggerrr = functions.firestore.document('requests/{requestId}').onCreate
(
    async (snapshot,context)=>
    {
        
       
        var payload = {notification: {title: 'hiiiiiiiiiiii', body: 'Your consultation date has been set'},
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

); */
/* 
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

); */