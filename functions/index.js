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

        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(doc=>{
            if(doc.data().info =='admin'){
               
               if(doc.data().token !== ""){
                tokens.push(doc.data().token);
               }
            }
            
        });

      
        var payload = {notification: {title:'New Consultation request' , body:snapshot.data().name +' has requested for an appointment' },
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
       
        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(doc=>{
            if(doc.data().info =='admin'){
               
               if(doc.data().token !== ""){
                tokens.push(doc.data().token);
               }
            }
            
        });

      
        var payload = {notification: {title:'Your Consultation date has been set' , body:snapshot.data().DoctorNameEn +' has set your consultation date at '+ snapshot.data().AppointmentDate },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);



exports.EndAppointment = functions.firestore.document('appointments/{appointmentsId}').onUpdate
(
    async (snapshot,context)=>
    {

        
        var tokens=[];

        const dataa = db.collection('users').doc(snapshot.data().patientPhone);
        const doc = await dataa.get();
          
        tokens.push(doc.data().token);
       
        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(doc=>{
            if(doc.data().info =='admin'){
               
               if(doc.data().token !== ""){
                tokens.push(doc.data().token);
               }
            }
            
        });

      
        var payload = {notification: {title:'Your Consultation date has been set' , body:snapshot.data().DoctorNameEn +' has ended the consultation for '+ snapshot.data().patientName },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);



exports.newService = functions.firestore.document('BookedServices/{BookedServicesId}').onCreate
(
    async (snapshot,context)=>
    {

        var tokens=[];

/*         tokens.push('ec5BS51kRXGlUf0WOuMMNw:APA91bHnOT3lJOmfEvl_GMdqFA8n9hC9Rxqln9q9mNr12mHapuxQ9WSpERFMXX7fC9xZqvVC_8C5wc9SzJ4hDSPhXrRoAoE4Ay7BVuO20kEPqBTfOCffphUqI4Jgh7oNqgRueyGveom5');
 */
        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(doc=>{
            if(doc.data().info =='admin'){
               
               if(doc.data().token !== ""){
                tokens.push(doc.data().token);
               }
            }
            
        });
        

        
        

      
        var payload = {notification: {title:'New Service Reservation' , body:snapshot.data().name +' has reserved '+snapshot.data().serviceNameEn },
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
       
        if(snapshot.data().type =='text'){
            var messagefield = snapshot.data().message;
        }else if(snapshot.data().type =='img'){
            var messagefield = 'has sent an image to you';
        }

      
        var payload = {notification: {title:snapshot.data().sendByName , body:messagefield },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);



exports.videoCall = functions.firestore.document('videoCalls/{call}').onCreate
(
    async (snapshot,context)=>
    {

        
        var tokens=[];

        const dataa = db.collection('users').doc(snapshot.data().callTo);
        const doc = await dataa.get();
          
        tokens.push(doc.data().token);
       


      
        var payload = {notification: {title:snapshot.data().callByName , body:'is calling you now' },
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