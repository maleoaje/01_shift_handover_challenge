import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shift_handover_challenge/features/shift_handover/domain/entities/shift_handover_models.dart';
import 'package:shift_handover_challenge/features/shift_handover/presentation/bloc/shift_handover_bloc.dart';

class NoteCard extends StatelessWidget {
  final HandoverNote note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  static const Map<NoteType, IconData> _iconMap = {
    NoteType.observation: Icons.visibility_outlined,
    NoteType.incident: Icons.warning_amber_rounded,
    NoteType.medication: Icons.medical_services_outlined,
    NoteType.task: Icons.check_circle_outline,
    NoteType.supplyRequest: Icons.shopping_cart_checkout_outlined,
  };

  static final Map<NoteType, Color> _colorMap = {
    NoteType.observation: Colors.blue.shade700,
    NoteType.incident: Colors.red.shade700,
    NoteType.medication: Colors.purple.shade700,
    NoteType.task: Colors.green.shade700,
    NoteType.supplyRequest: Colors.orange.shade700,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colorMap[note.type] ?? Colors.grey;
    final icon = _iconMap[note.type] ?? Icons.help_outline;

    return Dismissible(
      key: Key(note.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Show a confirmation dialog
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete this note?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Dispatch remove note event
        context.read<ShiftHandoverBloc>().add(RemoveNote(note.id));
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                child: Icon(icon, color: color, size: 28),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            note.type.name.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Text(
                          DateFormat.jm().format(note.timestamp),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
