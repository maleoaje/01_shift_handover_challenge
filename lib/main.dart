import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/service_locator.dart';
import 'features/shift_handover/presentation/bloc/shift_handover_bloc.dart';
import 'features/shift_handover/presentation/pages/shift_handover_screen.dart';

void main() {
  // Setup dependency injection
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift Handover Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) =>
            ShiftHandoverBloc()..add(const LoadShiftReport('current-user-id')),
        child: const ShiftHandoverScreen(),
      ),
    );
  }
}
