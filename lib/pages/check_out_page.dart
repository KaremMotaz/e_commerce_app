import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/provider/cart_model.dart';
import 'package:e_commerce_app/widgets/custom_appbar.dart';
import 'package:e_commerce_app/widgets/custom_card.dart';
import 'package:e_commerce_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    final object = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: const CustomAppbar(title: "Check out"),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: object.selectedProducts.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    index: index,
                  );
                },
              ),
            ),
            CustomElevatedButton(
              btnColor: btnPink,
              customWidget: Text(
                "Pay \$${object.price}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(
              height: 0,
            )
          ],
        ),
      ),
    );
  }
}
