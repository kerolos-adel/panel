import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app_panel/widgets/text_widget.dart';

import '../screens/inner_screens/edit_product.dart';
import '../services/global_methods.dart';
import '../services/utlis.dart';

class ProductWidet extends StatefulWidget {
  const ProductWidet({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<ProductWidet> createState() => _ProductWidetState();
}

class _ProductWidetState extends State<ProductWidet> {
  String title = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  @override
  void initState() {
    getProductData();
    super.initState();
  }

  Future<void> getProductData() async {
    try {
      final DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.id)
          .get();
      if (productDoc == null) {
        return;
      } else {
        setState(() {
          title = productDoc.get('title');
          productCat = productDoc.get('productCategoryName');
          imageUrl = productDoc.get('imageUrl');
          price = productDoc.get('price');
          salePrice = productDoc.get('salePrice');
          isOnSale = productDoc.get('isOnSale');
          isPiece = productDoc.get('isPiece');
        });
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      GlobalMethods.errorDialog(context: context, subtitle: "$error");
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;
    final color = Utlis(context).color;
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProductFrom(
                        id: widget.id,
                        title: title,
                        price: price,
                        salePrice: salePrice,
                        productCat: productCat,
                        imageUrl: imageUrl == null
                            ? "assets/images/imageloading.png"
                            : imageUrl!,
                        isOnSale: isOnSale,
                        isPiece: isPiece,
                      )));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            imageUrl == null
                                ? "assets/images/imageloading.png"
                                : imageUrl!,
                            fit: BoxFit.fill,
                            height: size.width * .12,
                          ),
                        )),
                    const Spacer(),
                    PopupMenuButton(
                      elevation: 0,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {},
                          value: 1,
                          child: const Text('Edit'),
                        ),
                        PopupMenuItem(
                          onTap: () {},
                          value: 1,
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: isOnSale
                          ? "\$${salePrice.toStringAsFixed(2)}"
                          : "\$$price",
                      color: color,
                      textSize: 18,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Visibility(
                        visible: isOnSale,
                        child: Text(
                          "\$$price",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: color),
                        )),
                    const Spacer(),
                    TextWidget(
                      text: isPiece ? 'Piece' : '1Kg',
                      color: color,
                      textSize: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 20,
                  isTitle: true,
                )
              ],
            ),
          ),
        ));
  }
}
