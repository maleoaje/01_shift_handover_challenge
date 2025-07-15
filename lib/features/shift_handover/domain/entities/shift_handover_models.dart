import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_handover_models.freezed.dart';
// Remove JSON serialization part

enum NoteType {
  observation,
  incident,
  medication,
  task,
  supplyRequest,
}

@freezed
class HandoverNote with _$HandoverNote {
  const factory HandoverNote({
    required String id,
    required String text,
    required NoteType type,
    required DateTime timestamp,
    required String authorId,
    @Default([]) List<String> taggedResidentIds,
    @Default(false) bool isAcknowledged,
  }) = _HandoverNote;

  const HandoverNote._();

  Color getColor() {
    switch (type) {
      case NoteType.incident:
        return Colors.red.shade100;
      case NoteType.supplyRequest:
        return Colors.yellow.shade100;
      case NoteType.observation:
      default:
        return Colors.blue.shade100;
    }
  }

  // Create a new instance with acknowledged status
  HandoverNote acknowledge() {
    return copyWith(isAcknowledged: true);
  }
}

@freezed
class ShiftReport with _$ShiftReport {
  const factory ShiftReport({
    required String id,
    required String caregiverId,
    required DateTime startTime,
    DateTime? endTime,
    @Default([]) List<HandoverNote> notes,
    @Default('') String summary,
    @Default(false) bool isSubmitted,
  }) = _ShiftReport;

  const ShiftReport._();

  // Create a new instance with an added note
  ShiftReport addNote(HandoverNote note) {
    return copyWith(notes: [...notes, note]);
  }

  // Create a new instance with submitted status
  ShiftReport submit(String reportSummary) {
    return copyWith(
      summary: reportSummary,
      endTime: DateTime.now(),
      isSubmitted: true,
    );
  }
}
