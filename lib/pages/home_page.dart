import 'package:e_commerce_app/models/item_model.dart';
import 'package:e_commerce_app/pages/details_page.dart';
import 'package:e_commerce_app/pages/profile_page.dart';
import 'package:e_commerce_app/provider/cart_model.dart';
import 'package:e_commerce_app/widgets/custom_appbar.dart';
import 'package:e_commerce_app/widgets/custom_user_image.dart';
import 'package:e_commerce_app/widgets/custom_username.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'check_out_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bgPlant.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      accountName: const GetUserName(),
                      accountEmail: Text("${user?.email}"),
                      currentAccountPicture: Transform.translate(
                        offset: const Offset(0, 20),
                        child: user?.photoURL == null
                            ? const GetUserImage()
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage("${user?.photoURL}"),
                              ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.home,
                    ),
                    title: const Text("Home"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckOutPage(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.add_shopping_cart,
                    ),
                    title: const Text("My products"),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.help_center,
                    ),
                    title: const Text("About"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.person,
                    ),
                    title: const Text("Profile"),
                  ),
                  ListTile(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    leading: const Icon(
                      Icons.exit_to_app,
                    ),
                    title: const Text("Logout"),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: const Text("Developed by Karim Motaz © 2024"),
              ),
            ],
          ),
        ),
        appBar: const CustomAppbar(title: "Home Page"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 33,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsPage(product: items[index]),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      leading: Text("\$${items[index].price}"),
                      title: const SizedBox(
                        width: 200,
                      ),
                      trailing: Consumer<CartModel>(
                        builder: (context, object, child) {
                          return IconButton(
                            onPressed: () {
                              object.addProduct(items[index]);
                            },
                            icon: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.grey[700],
                            ),
                          );
                        },
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -9,
                            top: 5,
                            right: 0,
                            left: 0,
                            child: Image(
                              image: AssetImage(items[index].url),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
