import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorite ;
  ProductsGrid(this.showOnlyFavorite);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showOnlyFavorite? productsData.favoriteItems:productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        //create: (c) => products[i],
        child: ProductItem(
            //products[i].id,
            // products[i].title,
            //products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio:2/ 4,
        crossAxisSpacing: 10,
      ),
    );
  }
}
