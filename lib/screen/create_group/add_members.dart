import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_assignment/screen/create_group/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {

  final TextEditingController _search = TextEditingController();
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((map) {
      setState(() {
        membersList.add({
        'name' : map['name'],
        'email' : map['email'],
        'uid' : map['uid'],
        'isAdmin' : true
      });
      });
    });
  }

  void onSearch() async {
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

  void onResultTap() {

    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          'name' : userMap!['name'],
          'email' : userMap!['email'],
          'uid' : userMap!['uid'],
          'isAdmin' : false
        });

        userMap = null;
      });
    }
  }

  void onRemoveMember(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Members'
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: membersList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      onRemoveMember(index);
                    },
                    leading: Icon(
                      Icons.account_circle
                    ),
                    title: Text(
                      membersList[index]['name']
                    ),
                    subtitle: Text(
                      membersList[index]['email']
                    ),
                    trailing: Icon(
                      Icons.close
                    ),
                  );
                }
              )
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
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
            isLoading? Container(
              height: size.height / 12,
              width: size.height / 12,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ) : ElevatedButton(
              onPressed: onSearch,
              child: const Text(
                'Search'
              )
            ),
            userMap != null? ListTile(
              onTap: onResultTap,
              leading: Icon(
                Icons.account_box
              ),
              title: Text(
                userMap!['name']
              ),
              subtitle: Text(
                userMap!['email']
              ),
              trailing: Icon(
                Icons.add
              ),
            ) : SizedBox(

            )
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2 ?FloatingActionButton(
        child: Icon(
          Icons.forward
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateGroup(membersList: membersList,)));
        }
      ) : SizedBox(

      )
    );
  }
}