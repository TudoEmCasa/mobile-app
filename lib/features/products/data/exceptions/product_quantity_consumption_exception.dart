class ProductQuantityConsumptionException implements Exception {
  final String message;

  const ProductQuantityConsumptionException(this.message);

  @override
  String toString() => message;
}
