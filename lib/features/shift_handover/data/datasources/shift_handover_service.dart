import 'dart:async';

import '../../../../core/exceptions.dart';
import '../../domain/entities/shift_handover_models.dart';

class ShiftHandoverService {
  Future<ShiftReport> getShiftReport(String caregiverId) async {
    // Validate input
    if (caregiverId.isEmpty) {
      throw const ValidationException('Caregiver ID cannot be empty');
    }

    // Return an empty shift report
    return ShiftReport(
      id: 'shift-${DateTime.now().millisecondsSinceEpoch}',
      caregiverId: caregiverId,
      startTime: DateTime.now(),
      notes: [], // Empty list of notes
    );
  }

  Future<bool> submitShiftReport(ShiftReport report) async {
    // Validate input
    if (report.caregiverId.isEmpty) {
      throw const ValidationException('Caregiver ID is required');
    }

    if (report.notes.isEmpty) {
      throw const ValidationException('Cannot submit an empty shift report');
    }

    // Simulate a successful submission
    return true;
  }
}
