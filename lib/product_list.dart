import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:modulo_venta/cart_model.dart';
import 'package:modulo_venta/cart_provider.dart';
import 'package:modulo_venta/cart_screen.dart';
import 'package:modulo_venta/db_helper.dart';
import 'package:modulo_venta/products.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de productos'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString(),
                        style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.add_shopping_cart_rounded),
              ),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      body: Products(),
    );
  }
}
