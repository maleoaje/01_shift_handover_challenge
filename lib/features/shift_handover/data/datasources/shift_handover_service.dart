import 'dart:math';

import '../../../../core/exceptions.dart';
import '../../domain/entities/shift_handover_models.dart';

class ShiftHandoverService {
  Future<ShiftReport> getShiftReport(String caregiverId) async {
    // Validate input
    if (caregiverId.isEmpty) {
      throw const ValidationException('Caregiver ID cannot be empty');
    }

    try {
      await Future.delayed(const Duration(seconds: 1));

      // Simulate potential network or service failure
      if (Random().nextBool()) {
        return ShiftReport(
          id: 'shift-123',
          caregiverId: caregiverId,
          startTime: DateTime.now().subtract(const Duration(hours: 8)),
          notes: List.generate(5, (index) {
            final type =
                NoteType.values[Random().nextInt(NoteType.values.length)];
            return HandoverNote(
              id: 'note-$index',
              text: 'This is a sample note of type ${type.name}.',
              type: type,
              timestamp: DateTime.now().subtract(Duration(hours: index)),
              authorId: 'caregiver-A',
            );
          }),
        );
      } else {
        throw const NetworkException('Failed to fetch shift report');
      }
    } catch (e) {
      // Rethrow with more context
      throw ShiftReportException('Error retrieving shift report', e.toString());
    }
  }

  Future<bool> submitShiftReport(ShiftReport report) async {
    // Validate input
    if (report.caregiverId.isEmpty) {
      throw const ValidationException('Caregiver ID is required');
    }

    if (report.notes.isEmpty) {
      throw const ValidationException('Cannot submit an empty shift report');
    }

    try {
      await Future.delayed(const Duration(seconds: 2));

      // Simulate network conditions
      if (Random().nextBool()) {
        print(
            'Report submitted successfully for caregiver ${report.caregiverId}');
        return true;
      } else {
        throw const NetworkException(
            'Failed to submit report due to network issues');
      }
    } catch (e) {
      // Log the error and rethrow
      print('Submission error: ${e.toString()}');
      throw ShiftReportException('Error submitting shift report', e.toString());
    }
  }
}
