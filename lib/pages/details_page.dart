import 'package:e_commerce_app/constants/custom_colors.dart';
import 'package:e_commerce_app/models/item_model.dart';
import 'package:e_commerce_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.product});
  final ItemModel product;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isMore = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppbar(
          title: "Details Screen",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey[300],
                height: 310,
                width: double.infinity,
                child: Image.asset(widget.product.url),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "\$ ${widget.product.price}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "New",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.edit_location,
                              color: appbarGreen,
                            ),
                            Text(
                              "Flower Shop",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Details :",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "A flower, also known as a bloom or blossom, is the reproductive structure found in flowering plants (plants of the division Angiospermae). Flowers consist of a combination of vegetative organs – sepals that enclose and protect the developing flower. These petals attract pollinators, and reproductive organs that produce gametophytes, which in flowering plants produce gametes. The male gametophytes, which produce sperm, are enclosed within pollen grains produced in the anthers. The female gametophytes are contained within the ovules produced in the ovary.",
                        textAlign: TextAlign.start,
                        maxLines: isMore ? null : 3,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isMore = !isMore;
                        });
                      },
                      child: Text(
                        isMore ? "Show less" : "Show more",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
