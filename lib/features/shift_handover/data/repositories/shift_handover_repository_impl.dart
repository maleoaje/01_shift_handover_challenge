import '../../../../core/error/exceptions.dart';
import '../../domain/entities/shift_handover_models.dart';
import '../../domain/repositories/shift_handover_repository.dart';
import '../datasources/shift_handover_service.dart';

class ShiftHandoverRepositoryImpl implements ShiftHandoverRepository {
  final ShiftHandoverService _service;

  ShiftHandoverRepositoryImpl(this._service);

  @override
  Future<ShiftReport> getShiftReport(String caregiverId) async {
    // Additional validation can be added here
    if (caregiverId.trim().isEmpty) {
      throw ValidationException('Caregiver ID cannot be empty');
    }

    return await _service.getShiftReport(caregiverId);
  }

  @override
  Future<bool> submitShiftReport(ShiftReport report) async {
    // Enhanced validation
    _validateReport(report);
    return await _service.submitShiftReport(report);
  }

  @override
  ShiftReport addNote(ShiftReport report, HandoverNote note) {
    // Validate note before adding
    _validateNote(note);
    return report.addNote(note);
  }

  @override
  ShiftReport removeNote(ShiftReport report, String noteId) {
    // Validate note removal
    if (noteId.trim().isEmpty) {
      throw ValidationException('Note ID cannot be empty');
    }

    // Find and remove the note
    final updatedNotes =
        report.notes.where((note) => note.id != noteId).toList();

    // Check if note was actually removed
    if (updatedNotes.length == report.notes.length) {
      throw ValidationException('Note with ID $noteId not found');
    }

    return report.copyWith(notes: updatedNotes);
  }

  // Enhanced validation methods
  void _validateReport(ShiftReport report) {
    if (report.caregiverId.trim().isEmpty) {
      throw ValidationException('Caregiver ID is required');
    }

    if (report.notes.isEmpty) {
      throw ValidationException('Shift report must contain at least one note');
    }

    // Additional report-level validations can be added here
    if (report.summary.trim().isEmpty && report.isSubmitted) {
      throw ValidationException('Submitted report must have a summary');
    }
  }

  void _validateNote(HandoverNote note) {
    if (note.id.trim().isEmpty) {
      throw ValidationException('Note ID cannot be empty');
    }

    if (note.text.trim().isEmpty) {
      throw ValidationException('Note text cannot be empty');
    }

    if (note.authorId.trim().isEmpty) {
      throw ValidationException('Author ID is required for the note');
    }

    // Additional note-level validations
    if (note.text.length > 500) {
      throw ValidationException('Note text cannot exceed 500 characters');
    }
  }
}
