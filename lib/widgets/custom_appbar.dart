import 'package:e_commerce_app/pages/check_out_page.dart';
import 'package:e_commerce_app/provider/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, required this.title})
      : preferredSize = const Size.fromHeight(kToolbarHeight);
  @override
  final Size preferredSize;
  final String title;
  @override
  Widget build(BuildContext context) {
    final object = Provider.of<CartModel>(context);
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Stack(
          children: [
            Container(
                width: 20,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(211, 164, 255, 193),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${object.productsCount}",
                  textAlign: TextAlign.center,
                )),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckOutPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_shopping_cart,
                size: 24,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            '\$ ${object.price}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}
