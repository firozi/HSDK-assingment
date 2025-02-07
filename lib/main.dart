import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsdk_assingment/Cubit/manage_cubit.dart';
import 'package:hsdk_assingment/Screens/home_page.dart';

import 'Screens/SingIn_Screen.dart';
//GOT TIGHT SCHEDULE BECAUSE OF COLLEGE EXAMS
//TEST CASES AND FIREBASE NOTIFICATIONS ARE LEFT ,WILL BE DONE SOON IN FEW DAYS HOPE YOU UNDERSTAND ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageCubit>(
      create: (context) => ManageCubit(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          home: SignInPage()
      ),
    );
  }
}

