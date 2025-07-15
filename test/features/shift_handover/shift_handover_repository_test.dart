import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shift_handover_challenge/core/exceptions.dart';
import 'package:shift_handover_challenge/features/shift_handover/data/datasources/shift_handover_service.dart';
import 'package:shift_handover_challenge/features/shift_handover/domain/entities/shift_handover_models.dart';
import 'package:shift_handover_challenge/features/shift_handover/domain/repositories/shift_handover_repository.dart';

// Mock ShiftHandoverService
class MockShiftHandoverService extends Mock implements ShiftHandoverService {}

void main() {
  late ShiftHandoverRepositoryImpl repository;
  late MockShiftHandoverService mockService;

  setUp(() {
    mockService = MockShiftHandoverService();
    repository = ShiftHandoverRepositoryImpl(mockService);
  });

  group('ShiftHandoverRepository', () {
    const testCaregiverId = 'test-caregiver-123';
    final testReport = ShiftReport(
      id: 'report-1',
      caregiverId: testCaregiverId,
      startTime: DateTime.now(),
    );

    test('getShiftReport throws ValidationException for empty caregiver ID',
        () {
      expect(
        () => repository.getShiftReport(''),
        throwsA(isA<ValidationException>()),
      );
    });

    test('addNote validates note before adding', () {
      final invalidNote = HandoverNote(
        id: '',
        text: '',
        type: NoteType.observation,
        timestamp: DateTime.now(),
        authorId: '',
      );

      expect(
        () => repository.addNote(testReport, invalidNote),
        throwsA(isA<ValidationException>()),
      );
    });

    test('removeNote throws ValidationException for empty note ID', () {
      expect(
        () => repository.removeNote(testReport, ''),
        throwsA(isA<ValidationException>()),
      );
    });

    test('removeNote throws ValidationException if note not found', () {
      expect(
        () => repository.removeNote(testReport, 'non-existent-id'),
        throwsA(isA<ValidationException>()),
      );
    });

    test('submitReport validates report before submission', () {
      final invalidReport = testReport.copyWith(
        caregiverId: '',
        notes: [],
      );

      expect(
        () => repository.submitShiftReport(invalidReport),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
