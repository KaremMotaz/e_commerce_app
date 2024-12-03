import 'package:e_commerce_app/provider/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key,required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    final object = Provider.of<CartModel>(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(object.selectedProducts[index].url),
          backgroundColor: Colors.grey[300],
        ),
        title: Text(
          "Product ${index+1}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("\$ ${object.selectedProducts[index].price} - Flower Shop"),
        trailing: IconButton(
            onPressed: () {
              object.removeProduct(object.selectedProducts[index]);
            },
            icon: const Icon(Icons.remove)),
      ),
    );
  }
}
