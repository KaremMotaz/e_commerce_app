class ItemModel {
  final String url;
  final double price;
  ItemModel({required this.url, required this.price});
}

final List<ItemModel> items = [
    ItemModel(url: "assets/images/1.png", price: 12.48),
    ItemModel(url: "assets/images/2.png", price: 13.47),
    ItemModel(url: "assets/images/3.png", price: 22.39),
    ItemModel(url: "assets/images/4.png", price: 10.49),
    ItemModel(url: "assets/images/5.png", price: 40.28),
    ItemModel(url: "assets/images/6.png", price: 4.26),
    ItemModel(url: "assets/images/7.png", price: 2.28),
    ItemModel(url: "assets/images/8.png", price: 90.45),
  ];
  