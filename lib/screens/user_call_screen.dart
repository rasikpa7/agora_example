import 'package:agoraexample/model/user_model.dart';
import 'package:agoraexample/widgets/video_call_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class UserCallScreen extends StatefulWidget {

  @override
  State<UserCallScreen> createState() => _UserCallScreenState();
}

class _UserCallScreenState extends State<UserCallScreen> {
    final List<Users> userList = [
   Users(name: 'rasik', email: 'rasik@gmail.com', password: '123456789'),
   Users(name: 'rahul',email: 'rahul@gmail.com', password: '123456789')
  ];

  late final firebaseToken;
  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   storeUserTokenWithEmail();

  }

  Future<void> storeUserTokenWithEmail() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the current user
  User? user = auth.currentUser;

  if (user != null) {
    // Get the FCM token
    String fcmToken = await messaging.getToken() ?? "";

    // Create a reference to the Firestore collection
    CollectionReference users = firestore.collection('users');

    // Store user email and FCM token in Firestore
    await users.doc(user.uid).set({
      'email': user.email,
      'fcmToken': fcmToken,
    });

    print('User data stored successfully.');
  } else {
    print('User not logged in.');
  }
}


  Future<void> sendPushNotification(String toUserFCMToken, String message) async {
 

  }

  

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Hi ${FirebaseAuth.instance.currentUser?.email}'),actions: [IconButton(onPressed: ()async{

          }, icon: Icon(Icons.logout))],
        ),
        body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            Users user = userList[index];
            if(FirebaseAuth.instance.currentUser?.email==user.email){
              return SizedBox();
            }else{
            return ListTile(
              leading: CircleAvatar(
                child: Text(user.name[0]),
              ),
              title: Text(user.name),
              trailing: IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => BaseVideoCallPage(),));
                },
              ),
            );
            }
          },
        ),
    );
  }
}