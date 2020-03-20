import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  //final String id;
  // final String title;
  // final String description;
  // final double price;
  // final String imageUrl;

  // ProductItem(
  // this.id,
  // this.title,
  // this.description,
  //  this.price,
  // this.imageUrl,
  // );
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            )),
        footer: Container(
          height: 170,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      product.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Anton', fontSize: 20),
                    ),
                  ),
                  Consumer<Product>(
                    builder: (ctx, product, child) => IconButton(
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        product.toggleFavoriteStatus(auth.token, auth.userId);
                      },
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],

                // trailing: IconButton(
                //   icon: Icon(Icons.shopping_cart),
                //   onPressed: () {
                //     cart.addItem(product.id, product.price, product.title);
                //     Scaffold.of(context).hideCurrentSnackBar();
                //     Scaffold.of(context).showSnackBar(SnackBar(
                //       content: Text('Added item to cart!'),
                //       duration: Duration(seconds: 2),
                //       action: SnackBarAction(
                //         label: 'UNDO',
                //         onPressed: () {
                //           cart.removeSingleItem(product.id);
                //         },
                //       ),
                //     ));
                //   },
                //   color: Colors.grey,
                // ),
              ),
              Center(
                  child: Container(
                    height: 20,
                      child: FittedBox(
                          child: Text(
                '${product.description.substring(0, 25)}...',
                style: TextStyle(color: Colors.grey, fontFamily: 'Lato'),
              )))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Chip(
                    backgroundColor: Colors.white24,
                    label: Text(
                      'Price: ${product.price}\$',
                      style: TextStyle(fontSize: 10, fontFamily: 'Anton'),
                    ),
                    //  backgroundColor: Colors.lightGreenAccent,
                  ),
                  Chip(
                    label: Text('In Stock',
                        style: TextStyle(fontSize: 10, fontFamily: 'Anton')),
                  )
                ],
              ),
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text('ADD TO CART',
                    style: TextStyle(color: Colors.white, fontFamily: 'Lato')),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
