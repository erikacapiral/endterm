import 'package:flutter/material.dart';
import 'package:todo_assignment/method/methods.dart';
import 'package:todo_assignment/screen/home_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading? Center(
        child: Container(
          height: size.height / 20,
          width: size.height / 20,
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height/20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: size.width / 1.2,
              child: IconButton(
                onPressed: () {}, 
                icon: const Icon(
                  Icons.arrow_back_ios
                )
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            Container(
              width: size.width / 1.1,
              child: const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: size.width / 1.1,
              child: const Text(
                'Create account to continue!',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0
              ),
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                child: field(
                  size, 'Full name', Icons.account_box, _name
                )
              ),
            ),
            Container(
              width: size.width,
              alignment: Alignment.center,
              child: field(
                size, 'Email address', Icons.account_box, _email
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0
              ),
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                child: field(
                  size, 'Password', Icons.lock, _password
                )
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            customButton(size),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onDoubleTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onDoubleTap: () {
        if (_name.text.isNotEmpty && _email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text)
          .then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              print('Account Created Successful');
            }
            else {
              print('Account Creation Failed');
            }
          });
        }
        else {
          print('Please enter Fields');
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue
        ),
        child: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget field(Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
      ),
    );
  }
}