part of 'manage_cubit.dart';

@immutable
sealed class ManageState {}

final class ManageInitial extends ManageState {}
final class ManageLoadingEmail extends ManageState{}
final class ManageLoading extends ManageState{}
final class ManageLoadingGoogle extends ManageState{}
final class ManageSuccess extends ManageState{}
final class ManageError extends ManageState{}
final class InternetConnected extends ManageState{}
final class NoInternet extends ManageState{}
final class MedicineInput extends ManageState{}
final class MedicineAdded extends ManageState{
  MedicineAdded({required this.AllMedicine});

 List<MedicineModel> AllMedicine;


}
