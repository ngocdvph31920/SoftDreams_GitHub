class Product {
  final String image;
  final String title;
  final double price;
  Product({
    required this.image,
    required this.title,
    required this.price,
  });
}

List<Product> listProductCart = [
  Product(
    image: 'assets/images/anh1.png',
    title: 'Control Flow',
    price: 10.5,
  ),
  Product(
    image: 'assets/images/anh4.png',
    title: 'Variables',
    price: 5.6,
  ),
  Product(
    image: 'assets/images/anh2.png',
    title: 'Functions',
    price: 7.7,
  ),
  Product(
    image: 'assets/images/anh3.png',
    title: 'Operators',
    price: 4.4,
  ),
  Product(
    image: 'assets/images/anh1.png',
    title: 'Control Flow',
    price: 10.5,
  ),
  Product(
    image: 'assets/images/anh4.png',
    title: 'Variables',
    price: 5.6,
  ),
];
