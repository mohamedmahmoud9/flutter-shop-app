import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'package:connectivity/connectivity.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
    //  var connectivityResult =  (Connectivity().checkConnectivity());

  // var _isInit = true;
  // var _isloading = false;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isloading = true;
  //     });

  //     Provider.of<Products>(context).fetchAndSetProduct().then((_) {
  //       setState(() {
  //         _isloading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MY SHOP'),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            ),
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOptions.All,
                      ),
                      PopupMenuItem(
                          child: Text('Show Favorites'),
                          value: FilterOptions.Favorites),
                    ]),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(future: Provider.of<Products>(context,listen: false).fetchAndSetProduct(),
          builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          
          else {
            return ProductsGrid(_showOnlyFavorites);
          }
        }));
  }
}
