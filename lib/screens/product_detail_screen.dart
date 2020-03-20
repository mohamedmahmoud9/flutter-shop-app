import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = 'product-detail';

  //final String title;
//ProductDetailScreen(this.title);
  @override
  Widget build(BuildContext context) {
    // final scafold =  Scaffold.of(context);
    final productId = ModalRoute.of(context).settings.arguments; //the id

    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final cart = Provider.of<Cart>(context);
    //  final product = Provider.of<Product>(context, listen: false);
    // final counter= Provider.of<Counter>(context);
    // var quantity = 1;
    final _quantityController = TextEditingController();
    final auth = Provider.of<Auth>(context, listen: false);

    //...
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      // floatingActionButton:
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              //  title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // Padding(
                      //padding:EdgeInsets.only(left: 30),
                      Text(
                        loadedProduct.title,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Anton'),
                      ),
                      FavoriteWidget(loadedProduct: loadedProduct, auth: auth),

                      // ),
                      //  Chip(label: Text('Item in stock',style: TextStyle(fontSize:10),),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // SizedBox(
                      //   width: 30,
                      // ),
                      Chip(
                        label: Text(
                          '\$${loadedProduct.price}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      //  SizedBox(
                      //   width: 30,
                      // ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('ADD TO CART',
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Lato')),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => QuantityDialog(
                              quantityController: _quantityController,
                              cart: cart,
                              productId: productId,
                              loadedProduct: loadedProduct));
                      //  cart.addItem(loadedProduct.id, loadedProduct.price, loadedProduct.title);
                      //       scafold.hideCurrentSnackBar();
                      // scafold.showSnackBar(SnackBar(
                      //     content: Text('Added item to cart!'),
                      //     duration: Duration(seconds: 2),
                      //     action: SnackBarAction(
                      //       label: 'UNDO',
                      //       onPressed: () {
                      //         cart.removeSingleItem(loadedProduct.id);
                      //       },
                      //     ),
                      //   ));
                    },
                  )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({
    Key key,
    @required this.loadedProduct,
    @required this.auth,
  }) : super(key: key);

  final Product loadedProduct;
  final Auth auth;

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 50,
      icon: Icon(
        widget.loadedProduct.isFavorite
            ? Icons.favorite
            : Icons.favorite_border,
      ),
      onPressed: () {
        setState(() {
          widget.loadedProduct
              .toggleFavoriteStatus(widget.auth.token, widget.auth.userId);
        });
      },
      color: Theme.of(context).accentColor,
    );
  }
}

class QuantityDialog extends StatefulWidget {
  const QuantityDialog({
    Key key,
    @required TextEditingController quantityController,
    @required this.cart,
    @required this.productId,
    @required this.loadedProduct,
  })  : _quantityController = quantityController,
        super(key: key);

  final TextEditingController _quantityController;
  final Cart cart;
  final Object productId;
  final Product loadedProduct;

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  var count = 1;
  void _plus() {
    setState(() {
      count++;
    });
  }

  void _minus() {
    setState(() {
      if (count == 1) {
        return;
      } else {
        count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Quantity',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      contentPadding: EdgeInsets.all(8),
      children: <Widget>[
        Text('How many items do you need ?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              color: Colors.grey,
              onPressed: () => _minus(),
              child: Text('-',
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
            Text(count.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).primaryColor)),
            FlatButton(
              color: Colors.grey,
              onPressed: () => _plus(),
              child: Text(
                '+',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel')),
            FlatButton(
                autofocus: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.cart.addItem(
                      widget.productId,
                      widget.loadedProduct.price,
                      widget.loadedProduct.title,
                      count);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ))
          ],
        )
      ],
    );
  }
}
