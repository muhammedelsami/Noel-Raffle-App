import 'package:equatable/equatable.dart';

/// A gift offered in a gift raffle, with how many of it are available.
class Gift extends Equatable {
  const Gift({required this.name, required this.count});

  final String name;
  final int count;

  Gift copyWith({String? name, int? count}) {
    return Gift(
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => <Object?>[name, count];
}
