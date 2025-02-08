import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hsdk_assingment/model/MedicineModel.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:meta/meta.dart';

part 'manage_state.dart';

class ManageCubit extends Cubit<ManageState> {
  late List<MedicineModel> medicine=[];
  StreamSubscription? internetSubscription;
  ManageCubit() : super(ManageInitial());


  Future<void> singIn(String email,String password)async{
    emit(ManageLoadingEmail());
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      emit(ManageSuccess());
    }on FirebaseAuthException catch(e){
      emit(ManageError());
    }
  }

  Future<void> singUp(String email,String password,String name)async{
    emit(ManageLoadingEmail());
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      emit(ManageSuccess());
    }on FirebaseAuthException catch(e){
      emit(ManageError());
    }
  }

  Future<void>singInWithGoogle()async{
    emit(ManageLoadingGoogle());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(ManageError()); // User canceled login
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(ManageSuccess());
    } catch (e) {
      emit(ManageError());
    }

  }

  void CheckInternetConnection(){
    internetSubscription?.cancel();
    internetSubscription=InternetConnection().onStatusChange.listen((internetStatus){
      if(internetStatus==InternetStatus.connected){
        emit(InternetConnected());
      }
      else{
        emit(NoInternet());
      }
    });
  }

  void AddMedicine(){
    print("in cubit");
    emit(MedicineInput());
    print("emitted state");
  }

  Future<void>addMedicineToDataBase(String medicineName,String medicineQuentity,String time)async {
    try{
      emit(ManageLoading());
      print("storing in firestore");
     final Medicines= FirebaseFirestore.instance.collection("Medicines");
     print("storing in loacal list");
       await Medicines.add({
         "name":medicineName,
         "quentity":medicineQuentity,
         "timeTotake":time,
         "id":FieldValue.serverTimestamp()
       });
       print("done storing");
      medicine.add(MedicineModel(medicineName: medicineName, medicineQuentity: medicineQuentity, medicineTime: time));
       emit(MedicineAdded(AllMedicine:medicine));
       print("state emmited");
    }catch(e){
  emit(ManageError());
    }

}
}
//FIREBASE NOTIFICATIONS ARE LEFT ,WILL BE DONE SOON IN FEW DAYS HOPE YOU UNDERSTAND ...
