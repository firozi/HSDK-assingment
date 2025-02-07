import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsdk_assingment/Cubit/manage_cubit.dart';

import '../model/MedicineModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController medicineName = TextEditingController();
  TextEditingController medicineQuentity = TextEditingController();
  String ?Time;
  List<MedicineModel> _medicineList = [];

  @override
  void initState() {
    context.read<ManageCubit>().CheckInternetConnection();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageCubit, ManageState>(
      listener: (context, state) {
        if (state is NoInternet) {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: const Text("No Internet Connection"),
                  content: const Text(
                      "You are offline. Please check your internet connection."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
          );
        }
        if (state is MedicineInput) {
          print("in bottem sheet");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Full-screen height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add Medicine",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    // Medicine Name
                    TextField(
                      controller: medicineName,
                      decoration: InputDecoration(
                        labelText: "Medicine Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 60),
                    // Quantity Selector
                    TextField(
                      controller: medicineQuentity,
                      decoration: InputDecoration(
                        labelText: "Quantity",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 80),
                    // Time Picker
                    Text("Select Time:", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          Time = pickedTime.format(context);
                          print("Selected time: ${pickedTime.format(context)}");
                        }
                      },
                      child: Text("Pick Time"),
                    ),
                    SizedBox(height: 180),
                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ManageCubit>().addMedicineToDataBase(
                              medicineName.text, medicineQuentity.text, Time!);
Navigator.of(context).pop();
                          // Close sheet after saving
                        },
                        child: Text("Save Medicine"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state is MedicineAdded) {
            _medicineList = state.AllMedicine;
        }
        if (state is ManageLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Blue progress
                strokeWidth: 3, // Thicker for better visibility
              ),
            ),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              print("add medicine clicked");
              context.read<ManageCubit>().AddMedicine();

              // Add medicine logic here
            },
            backgroundColor: Colors.blue,
            // Primary color
            foregroundColor: Colors.white,
            // Text/Icon color
            icon: Icon(Icons.add, size: 28),
            label: Text(
              "Add Medicine",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          body: _medicineList.isEmpty
              ? Center(child: Text("No Medicines Added"))
              : ListView.builder(
            itemCount: _medicineList.length,
            itemBuilder: (context, index) {
              final medicine = _medicineList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                child: ListTile(
                  title: Text(medicine.medicineName, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Quantity: ${medicine.medicineQuentity} - Time: ${medicine
                          .medicineTime}"),
                  trailing: Icon(Icons.medical_services, color: Colors.blue),
                ),
              );
            },
          ),
        );
      },
    );
  }
}