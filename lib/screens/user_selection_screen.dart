import 'package:agoraexample/model/user_model.dart';
import 'package:agoraexample/screens/user_call_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatelessWidget {
  final List<Users> userList = [
    Users(name: 'rasik', email: 'rasik@gmail.com', password: '123456789'),
    Users(name: 'rahul', email: 'rahul@gmail.com', password: '123456789')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          Users user = userList[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(user.name[0]),
            ),
            title: Text(user.name),
            trailing: IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
             final userDetails=   await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: user.email, password: user.password);
                    
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserCallScreen()));
              },
            ),
          );
        },
      ),
    );
  }
}
