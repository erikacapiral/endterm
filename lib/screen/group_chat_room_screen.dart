import 'package:flutter/material.dart';

class GroupChatRoom extends StatelessWidget {
  GroupChatRoom({super.key});

  final TextEditingController _message = TextEditingController();
  
  String currentUserName = 'User1';
  
  List<Map<String, dynamic>> dummyChatList = [
    {
      'message' : 'Hello',
      'userName' : 'User1',
      'type' : 'text'
    }
  ];

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Group Name'
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(
              Icons.more_vert
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.27,
              width: size.width,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return messageTile(size, dummyChatList[index]);
                }
              ),
            ),
            Container(
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
                      onPressed: () {

                      }, 
                      icon: const Icon(
                        Icons.send
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(
        horizontal: size.width / 60,
        vertical: size.height / 30
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height / 50,
          horizontal: size.width / 40
        ),
        child: Text(
          chatMap['message']
        ),
      ),
    );
  }
}