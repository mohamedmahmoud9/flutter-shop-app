import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProducItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String productId;
  UserProducItem(this.title, this.imgUrl, this.productId);
  @override
  Widget build(BuildContext context) {
    final scafold =  Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: productId);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                            'Do you want to remove this product',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () async{
                                Navigator.of(ctx).pop();
                                try {
                                  await Provider.of<Products>(context, listen: false)
                                      .removeProduct(productId);
                                      scafold.showSnackBar(SnackBar(
                                    content: Text('Deleting done!'),
                                  ));
                                } catch (error) {
                                 scafold.showSnackBar(SnackBar(
                                    content: Text('Deleting failed!'),
                                  ));
                                }
                              },
                            )
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
