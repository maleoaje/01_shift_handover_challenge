import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

import '../../../../core/service_locator.dart';
import '../../../../core/exceptions.dart';
import '../../domain/entities/shift_handover_models.dart';
import '../../domain/repositories/shift_handover_repository.dart';

abstract class ShiftHandoverEvent extends Equatable {
  const ShiftHandoverEvent();
  @override
  List<Object> get props => [];
}

class LoadShiftReport extends ShiftHandoverEvent {
  final String caregiverId;
  const LoadShiftReport(this.caregiverId);
}

class AddNewNote extends ShiftHandoverEvent {
  final String text;
  final NoteType type;
  const AddNewNote(this.text, this.type);
}

class RemoveNote extends ShiftHandoverEvent {
  final String noteId;
  const RemoveNote(this.noteId);
}

class SubmitReport extends ShiftHandoverEvent {
  final String summary;
  const SubmitReport(this.summary);
}

class SortNotesEvent extends ShiftHandoverEvent {
  final bool isNewestFirst;
  const SortNotesEvent({this.isNewestFirst = true});
}

class ShiftHandoverState extends Equatable {
  final ShiftReport? report;
  final bool isLoading;
  final bool isSubmitting;
  final AppException? error;

  const ShiftHandoverState({
    this.report,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  ShiftHandoverState copyWith({
    ShiftReport? report,
    bool? isLoading,
    bool? isSubmitting,
    AppException? error,
    bool clearError = false,
  }) {
    return ShiftHandoverState(
      report: report ?? this.report,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [report, isLoading, isSubmitting, error];
}

class ShiftHandoverBloc extends Bloc<ShiftHandoverEvent, ShiftHandoverState> {
  final ShiftHandoverRepository _repository;

  ShiftHandoverBloc()
      : _repository = getIt<ShiftHandoverRepository>(),
        super(const ShiftHandoverState()) {
    on<LoadShiftReport>(_onLoadShiftReport);
    on<AddNewNote>(_onAddNewNote);
    on<RemoveNote>(_onRemoveNote);
    on<SubmitReport>(_onSubmitReport);
    on<SortNotesEvent>(_onSortNotes);
  }

  void _onRemoveNote(
    RemoveNote event,
    Emitter<ShiftHandoverState> emit,
  ) {
    if (state.report == null) return;

    try {
      final updatedReport = _repository.removeNote(state.report!, event.noteId);
      emit(state.copyWith(report: updatedReport, clearError: true));
    } catch (e) {
      final appException = ExceptionHandler.handle(e);
      emit(state.copyWith(error: appException));
    }
  }

  Future<void> _onLoadShiftReport(
    LoadShiftReport event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final report = await _repository.getShiftReport(event.caregiverId);
      emit(state.copyWith(report: report, isLoading: false));
    } catch (e) {
      final appException = ExceptionHandler.handle(e);
      emit(state.copyWith(error: appException, isLoading: false));
    }
  }

  void _onAddNewNote(
    AddNewNote event,
    Emitter<ShiftHandoverState> emit,
  ) {
    if (state.report == null) return;

    try {
      final newNote = HandoverNote(
        id: 'note-${Random().nextInt(1000)}',
        text: event.text,
        type: event.type,
        timestamp: DateTime.now(),
        authorId: state.report!.caregiverId,
      );

      final updatedReport = _repository.addNote(state.report!, newNote);

      emit(state.copyWith(report: updatedReport, clearError: true));
    } catch (e) {
      final appException = ExceptionHandler.handle(e);
      emit(state.copyWith(error: appException));
    }
  }

  Future<void> _onSubmitReport(
    SubmitReport event,
    Emitter<ShiftHandoverState> emit,
  ) async {
    if (state.report == null) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final updatedReport = state.report!.submit(event.summary);

      final success = await _repository.submitShiftReport(updatedReport);

      if (success) {
        emit(state.copyWith(report: updatedReport, isSubmitting: false));
      } else {
        emit(state.copyWith(
            error: NetworkException('Failed to submit report'),
            isSubmitting: false));
      }
    } catch (e) {
      final appException = ExceptionHandler.handle(e);
      emit(state.copyWith(error: appException, isSubmitting: false));
    }
  }

  void _onSortNotes(
    SortNotesEvent event,
    Emitter<ShiftHandoverState> emit,
  ) {
    if (state.report == null) return;

    try {
      print('Sorting notes: isNewestFirst = ${event.isNewestFirst}');
      print('Before sorting: ${state.report!.notes.map((n) => n.timestamp)}');

      // Create a new list of notes sorted by timestamp
      final sortedNotes = List<HandoverNote>.from(state.report!.notes);

      // Sort notes based on the event parameter
      sortedNotes.sort((a, b) => event.isNewestFirst
          ? b.timestamp.compareTo(a.timestamp)
          : a.timestamp.compareTo(b.timestamp));

      print('After sorting: ${sortedNotes.map((n) => n.timestamp)}');

      // Create a new report with sorted notes
      final sortedReport = state.report!.copyWith(notes: sortedNotes);

      emit(state.copyWith(report: sortedReport, clearError: true));
    } catch (e) {
      print('Error sorting notes: $e');
      final appException = ExceptionHandler.handle(e);
      emit(state.copyWith(error: appException));
    }
  }
}
