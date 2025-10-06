
class Product {
  final String name;
  final double price;
  final String image;
  final String description;
  final String preparation;

  Product(this.name, this.price, this.image,
      {this.description = '', this.preparation = ''});
}

class CartItem {
  final Product product;
  int quantity;
  String notes;

  CartItem({required this.product, this.quantity = 1, this.notes = ''});

  double get lineTotal => product.price * quantity;
}
