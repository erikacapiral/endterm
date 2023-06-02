import 'package:flutter/material.dart';
import 'package:todo_assignment/screen/group_chat_room_screen.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Groups'
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupChatRoom()));
            },
            leading: const Icon(
              Icons.group
            ),
            title: Text(
              'Group $index'
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create Group',
        child: const Icon(
          Icons.create
        ),
      ),
    );
  }
}