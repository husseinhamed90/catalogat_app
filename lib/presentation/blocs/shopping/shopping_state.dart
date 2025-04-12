part of 'shopping_cubit.dart';

class ShoppingState extends Equatable {

  final int quantity;
  const ShoppingState({
    this.quantity = 1,
  });

  @override
  List<Object> get props => [
    quantity,
  ];

  ShoppingState copyWith({
    int? quantity,
  }) {
    return ShoppingState(
      quantity: quantity ?? this.quantity,
    );
  }
}
