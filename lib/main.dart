import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './screens/products_overview_screen.dart';
import './providers/auth.dart';
import './screens/edit_product_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_history_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './providers/cart.dart';
import './screens/splash_screen.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (_, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (_, auth, previousOrders) => Orders(auth.token, auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.red,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersHistoryScreen.routeName: (ctx) => OrdersHistoryScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
