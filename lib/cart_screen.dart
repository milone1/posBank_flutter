import 'dart:convert';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modulo_venta/cart_model.dart';
import 'package:modulo_venta/cart_provider.dart';
import 'package:modulo_venta/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_usb_printer/flutter_usb_printer.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  bool connected = false;
  DBHelper? dbHelper = DBHelper();

  @override
  initState() {
    flutterUsbPrinter.connect(1155, 41014);
  }

  _print(nombre, qty, precio) async {
    try {
      var name = Uint8List.fromList(utf8.encode(nombre));
      var canti = Uint8List.fromList(utf8.encode(qty.toString()));
      var price = Uint8List.fromList(utf8.encode(precio.toString()));
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("---------------ACURIO----------------------");
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("                                           ");
      await flutterUsbPrinter.printText("                                           ");
      await flutterUsbPrinter.printText("                                           ");
      await flutterUsbPrinter.printText('NOMBRE:                                    ');
      await flutterUsbPrinter.write(name                                            );
      await flutterUsbPrinter.printText('CANTIDAD:                                 ');
      await flutterUsbPrinter.write(canti                                           );
      await flutterUsbPrinter.printText('PRECIO:                                   ');
      await flutterUsbPrinter.write(price                                          );
      await flutterUsbPrinter.printText("                                           ");
      await flutterUsbPrinter.printText("                                           ");
      await flutterUsbPrinter.printText("                                           ");
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("-------------------------------------------");
      await flutterUsbPrinter.printText("-------------------------------------------");
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de compras'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCounter().toString(),
                      style: TextStyle(color: Colors.white));
                },
              ),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              child: Icon(Icons.add_shopping_cart_rounded),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('images/empty_cart.png'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('El carrito esta vacío 😌',
                                style: Theme.of(context).textTheme.headline5),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                'Explore la tienda y eliga lo que mas le guste',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2)
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image.asset(
                                              width: 150,
                                              height: 100,
                                              snapshot.data![index].image
                                                  .toString()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          .productName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          dbHelper!.delete(
                                                              snapshot
                                                                  .data![index]
                                                                  .id!);
                                                          cart.removerCounter();
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .productPrice
                                                                  .toString()));
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "s/ " +
                                                      snapshot.data![index]
                                                          .productPrice
                                                          .toString() +
                                                      ".00",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      print("");
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(5.0),
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: () {
                                                                  _print(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .productName,
                                                                          snapshot
                                                                          .data![
                                                                              index]
                                                                          .quantity,
                                                                          snapshot
                                                                          .data![
                                                                              index]
                                                                          .productPrice,
                                                                          
                                                                      );
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;
                                                                  quantity--;
                                                                  int?
                                                                      newPrice =
                                                                      price *
                                                                          quantity;

                                                                  if (quantity >
                                                                      0) {
                                                                    dbHelper!
                                                                        .updateQuantity(Cart(
                                                                            id: snapshot.data![index].id!,
                                                                            productId: snapshot.data![index].id!.toString(),
                                                                            productName: snapshot.data![index].productName!,
                                                                            initialPrice: snapshot.data![index].initialPrice!,
                                                                            productPrice: newPrice,
                                                                            quantity: quantity,
                                                                            unitTag: snapshot.data![index].unitTag.toString(),
                                                                            image: snapshot.data![index].image.toString()))
                                                                        .then((value) {
                                                                      newPrice =
                                                                          0;
                                                                      quantity =
                                                                          0;
                                                                      cart.removeTotalPrice(double.parse(snapshot
                                                                          .data![
                                                                              index]
                                                                          .initialPrice!
                                                                          .toString()));
                                                                    }).onError((error, stackTrace) {
                                                                      print(error
                                                                          .toString());
                                                                    });
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .quantity
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white)),
                                                            InkWell(
                                                                onTap: () {
                                                                  int quantity = snapshot
                                                                      .data![
                                                                          index]
                                                                      .quantity!;
                                                                  int price = snapshot
                                                                      .data![
                                                                          index]
                                                                      .initialPrice!;
                                                                  quantity++;
                                                                  int?
                                                                      newPrice =
                                                                      price *
                                                                          quantity;

                                                                  dbHelper!
                                                                      .updateQuantity(Cart(
                                                                          id: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id!,
                                                                          productId: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id!
                                                                              .toString(),
                                                                          productName: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .productName!,
                                                                          initialPrice: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .initialPrice!,
                                                                          productPrice:
                                                                              newPrice,
                                                                          quantity:
                                                                              quantity,
                                                                          unitTag: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .unitTag
                                                                              .toString(),
                                                                          image: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .image
                                                                              .toString()))
                                                                      .then(
                                                                          (value) {
                                                                    newPrice =
                                                                        0;
                                                                    quantity =
                                                                        0;
                                                                    cart.addTotalPrice(double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initialPrice!
                                                                        .toString()));
                                                                  }).onError((error,
                                                                          stackTrace) {});
                                                                },
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }
                  return Text('');
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ReusableWidget(
                      title: 'Total: ',
                      value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 50,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
