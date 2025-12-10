import 'package:flutter_bloc/flutter_bloc.dart';

// A Cubit manages state directly via functions, no "Events" class needed.
// The state is just an 'int' representing the active tab index.
class DashboardCubit extends Cubit<int> {
  // Start at index 0 (Home Page)
  DashboardCubit() : super(0);

  // Function to change the tab
  void changeTab(int index) {
    emit(index);
  }
}