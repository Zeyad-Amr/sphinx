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
        if(doc.data().token !== ""){
            tokens.push(doc.data().token);
        }

        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(docc=>{
            if(docc.data().info =='admin'){
               if(docc.data().token !== ""){
                tokens.push(docc.data().token);
               }
            }
        });

      
        var payload = {notification: {title:'New Onilne Consultation Request' , body:snapshot.data().name +' has requested for an appointment' },
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
        if(doc.data().token !== ""){
            tokens.push(doc.data().token);
        }

        var payload = {notification: {title:'Your Online Consultation Date has been set' , body:snapshot.data().DoctorNameEn +' has set your consultation date at '+ snapshot.data().AppointmentDate },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload);
    }
);


exports.newAppointmentadmin = functions.firestore.document('appointments/{appointmentsId}').onCreate
(
    async (snapshot,context)=>
    {

        var tokens=[];
   
        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(docc=>{
            if(docc.data().info =='admin'){
               if(docc.data().token !== ""){
                tokens.push(docc.data().token);
               }
            }
        });

     
        var payload = {notification: {title:'An Online Consultation Date has been set' , body:snapshot.data().DoctorNameEn +' has set an online consultation date for ' + snapshot.data().patientName+' at '+ snapshot.data().AppointmentDate },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respondd = await admin.messaging().sendToDevice(tokens,payload);
    }
);





exports.EndAppointment = functions.firestore.document('appointments/{appointmentsId}').onUpdate
(
    async (change,context)=>
    {
        const newValue = change.after.data();

        var tokens=[];
      

        const dataa = db.collection('users').doc(newValue.patientPhone);
        const doc = await dataa.get();
        if(doc.data().token !== ""){
            tokens.push(doc.data().token);
        }
      
        var payload = {notification: {title:'Your Online Consultation ended' , body:newValue.DoctorNameEn +' has ended the consultation for you' },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 

    }
);



exports.EndAppointmentadmin = functions.firestore.document('appointments/{appointmentsId}').onUpdate
(
    async (change,context)=>
    {
        const newValue = change.after.data();

        var tokens=[];
      

        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(docc=>{
            if(docc.data().info =='admin'){
               if(docc.data().token !== ""){
                tokens.push(docc.data().token);
               }
            }
        });
 
      
        var payload = {notification: {title:'An Online Consultation Date has been set' , body:snapshot.data().DoctorNameEn +' has ended the consultation for '+ snapshot.data().patientName },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'message'}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 

    }
);





exports.newService = functions.firestore.document('BookedServices/{BookedServicesId}').onCreate
(
    async (snapshot,context)=>
    {
        var tokens=[];

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


exports.newfawryreq = functions.firestore.document('fawryRequests/{fawryRequestsId}').onCreate
(
    async (snapshot,context)=>
    {
        var tokens=[];

        const adminData =  db.collection('users');
        const adminTokens = await adminData.get();
        adminTokens.forEach(doc=>{
            if(doc.data().info =='admin'){
               if(doc.data().token !== ""){
                tokens.push(doc.data().token);
               }
            }
            
        });
        
        var payload = {notification: {title:'New Fawry Payment' , body:snapshot.data().name +' has received fawry code' },
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
          
        if(doc.data().token !== ""){
            tokens.push(doc.data().token);
        }
       
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
          
        if(doc.data().token !== ""){
            tokens.push(doc.data().token);
        }
       


      
        var payload = {notification: {title:snapshot.data().callByName , body:'is calling you now' },
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'videoCall' ,
        callId:snapshot.data().callId ,
        callToName:snapshot.data().callToName,
        callByName:snapshot.data().callByName,
        callBy:snapshot.data().callBy,
        callTo:snapshot.data().callTo,
        imageUrl:snapshot.data().imageUrl}}
        const respond = await admin.messaging().sendToDevice(tokens,payload); 
    }
);
