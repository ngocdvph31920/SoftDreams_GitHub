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
    title: 'Clean',
    price: 13.3,
  ),
  Product(
    image: 'assets/images/anh3.png',
    title: 'Cawai',
    price: 11.2,
  ),
  Product(
    image: 'assets/images/frame9.png',
    title: 'Sprint',
    price: 9.1,
  ),
  Product(
    image: 'assets/images/frame10.png',
    title: 'Recursion',
    price: 12.9,
  ),
];
