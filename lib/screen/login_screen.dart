import 'package:flutter/material.dart';
import 'package:todo_assignment/method/methods.dart';
import 'package:todo_assignment/screen/home_screen.dart';
import 'package:todo_assignment/screen/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading? Center(
        child: SizedBox(
          height: size.height / 20,
          width: size.height / 20,
          child: const CircularProgressIndicator(),
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
            SizedBox(
              width: size.width / 1.3,
              child: const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              width: size.width / 1.3,
              child: const Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(
              height: size.height / 10,
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
              height: size.height / 10,
            ),
            customButton(size),
            SizedBox(
              height: size.height / 40,
            ),
            GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateAccountScreen()));
              },
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
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
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print('Login Successful');
              setState(() {
                isLoading = false;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
            else {
              print('Login Failed');
              setState(() {
                isLoading = false;
              });
            }
          });
        }
        else {
          print('Please fill form correctly');
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
        child: const Text(
          'Login',
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
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(
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