import 'package:equatable/equatable.dart';

/// A person taking part in a raffle.
class Participant extends Equatable {
  const Participant({
    required this.name,
    required this.surname,
    required this.email,
  });

  final String name;
  final String surname;
  final String email;

  String get fullName => '$name $surname';

  Participant copyWith({String? name, String? surname, String? email}) {
    return Participant(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => <Object?>[name, surname, email];
}
