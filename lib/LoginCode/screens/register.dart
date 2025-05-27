import 'package:flutter/material.dart';
import 'package:regendataapp/LoginCode/screens/login.dart';

class RegisterScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              SizedBox(height: 16, width: 12),
              TextField(
                decoration: InputDecoration(labelText: "Password"),
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.black),
                  ),
                  onPressed: (){

                  },
                  child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white
                      ),
                  )

              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                )
              ),
            ],
          ),
      ),
    );
    throw UnimplementedError();
  }
}