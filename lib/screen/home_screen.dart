import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_assignment/method/methods.dart';
import 'package:todo_assignment/screen/chat_screen.dart';
import 'package:todo_assignment/screen/group_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'status' : status
    });
  }

 
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus('Online');
    }
    else {
      setStatus('Offline');
    }
  } 

 String chatRoomId(String user1, String user2) {

  if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return '$user1$user2';
  }
  else {
    return '$user2$user1';
  }

 } 

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore.collection('users')
      .where('name', isEqualTo: _search.text)
      .get()
      .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen'
        ),
        actions: [
          IconButton(
            onPressed: () {
              logOut(context);
            }, 
            icon: Icon(
              Icons.logout
            )
        )
        ],
      ),
      body: isLoading? Center(
        child: Container(
          height: size.height / 20,
          width: size.height / 20,
          child: CircularProgressIndicator(),
        ),
      ) : Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            onPressed: onSearch, 
            child: Text(
              'Search'
            )
          ),
          SizedBox(
            height: size.height / 30,
          ),
          userMap != null ? ListTile(
            onTap: () {
              String roomId = chatRoomId(
                _auth.currentUser!.displayName ?? ' ',
                userMap!['name'], 
              );

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoom(chatRoomId: roomId, userMap: userMap!)));
            },
            leading: Icon(
              Icons.account_box,
              color: Colors.black,
            ),
            title: Text(
              userMap!['name'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500
              ),
            ),
            subtitle: Text(
              userMap!['email']
            ),
            trailing: Icon(
              Icons.chat_rounded,
              color: Colors.black,
            ),
          ) 
          : Container(

          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.group
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupChat()));
        }
      ),
    );
  }
}