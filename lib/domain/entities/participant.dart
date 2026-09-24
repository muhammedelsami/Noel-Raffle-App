import 'package:equatable/equatable.dart';

/// A person taking part in a raffle. [name] identifies them in the results, so
/// it is unique within a raffle; [email] is optional and only used to send the
/// result from the organizer's own mail app.
class Participant extends Equatable {
  const Participant({required this.name, this.email});

  final String name;
  final String? email;

  bool get hasEmail => email != null && email!.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[name, email];
}
