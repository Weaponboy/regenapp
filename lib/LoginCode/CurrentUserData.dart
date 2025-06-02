import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:regendataapp/screens/home.dart';
import 'package:regendataapp/LoginCode/screens/register.dart';

class currentUserData {
  static final currentUserData _instance = currentUserData._internal();
  String email = '';
  String username = '';
  bool? admin;

  factory currentUserData() {
    return _instance;
  }

  currentUserData._internal();
}