import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ChatRoom extends StatelessWidget {
  ChatRoom({super.key, required this.chatRoomId, required this.userMap});

  final Map<String, dynamic> userMap;
  final String chatRoomId;

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;

  Future getImage() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {

    String fileName = const Uuid().v1();
    int status = 1;
    
    await _firestore.collection('chatroom').doc(chatRoomId).collection('chats').doc(fileName).set({
      'sendby' : _auth.currentUser!.displayName,
      'message' : '',
      'type' : 'img',
      'time' : FieldValue.serverTimestamp()
    });

    var ref = FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore.collection('chatroom').doc(chatRoomId).collection('chats').doc(fileName).delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore.collection('chatroom').doc(chatRoomId).collection('chats').doc(fileName).update({
        'image' : imageUrl
      });
      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby' : _auth.currentUser!.displayName,
        'message' : _message.text,
        'type' : 'text',
        'time' : FieldValue.serverTimestamp()
      };

      _message.clear();
      await _firestore
      .collection('chatroom')
      .doc(chatRoomId)
      .collection('chats')
      .add(messages);
    }
    else {
      print('Enter some texts');
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc().snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(
                      userMap['name']
                    ),
                    Text(
                      userMap['status'],
                      style: const TextStyle(
                        fontSize: 14
                      ),
                    )
                  ]
                ),
              );
            }
            else {
              return Container(

              );
            }
          }
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                .collection('chatroom')
                .doc(chatRoomId)
                .collection('chats')
                .orderBy('time', descending: false)
                .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic>? map = 
                          snapshot.data!.docs[index].data() as Map<String, dynamic>?;
                        return messages(
                          size, map!, context
                        );
                      }
                    );
                  } 
                  else {
                    return Container(

                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height / 10,
        width: size.width,
        alignment: Alignment.center,
        child: SizedBox(
          height: size.height / 12,
          width: size.width / 1.1,
          child: Row(
            children: [
              SizedBox(
                height: size.height / 12,
                width: size.width / 1.5,
                child: TextField(
                  controller: _message,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        getImage();
                      }, 
                      icon: const Icon(
                        Icons.photo
                      )
                    ),
                    hintText: 'Send Message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                ),
              ),
              IconButton(
                onPressed: onSendMessage, 
                icon: const Icon(
                  Icons.send
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == 'text' ? Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName 
      ? Alignment.centerRight 
      : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 8
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue
        ),
        child: Text(
          map['message'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    ) : Container(
      height: size.height / 2.5,
      width: size.width,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5
      ),
      alignment: map['sendby'] == _auth.currentUser!.displayName ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShowImage(imageUrl: map['message'])));
        },
        child: Container(
          height: size.height / 2.5,
          width: size.width / 2,
          decoration: BoxDecoration(
            border: Border.all()
          ),
          alignment: map['message'] != '' ? null : Alignment.center,
          child: map['message'] != '' ? Image.network(
            map['message'],
            fit: BoxFit.cover,
          ) : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {

  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(
          imageUrl
        ),
      ),
    );
  }
}