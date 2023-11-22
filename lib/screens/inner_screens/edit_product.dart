import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app_panel/controller/MenuController.dart';
import 'package:store_app_panel/screens/loading_manager.dart';
import 'package:store_app_panel/widgets/bottom_widget.dart';
import 'package:store_app_panel/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

import '../../responsive.dart';
import '../../services/global_methods.dart';
import '../../services/utlis.dart';
import '../../widgets/header.dart';
import '../../widgets/side_menu.dart';

class EditProductFrom extends StatefulWidget {
  static const routeName = "/EditProductFrom";

  const EditProductFrom({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.productCat,
    required this.imageUrl,
    required this.isPiece,
    required this.isOnSale,
    required this.salePrice,
  }) : super(key: key);
  final String id, title, price, productCat, imageUrl;
  final bool isPiece, isOnSale;
  final double salePrice;

  @override
  State<EditProductFrom> createState() => _EditProductFromState();
}

class _EditProductFromState extends State<EditProductFrom> {
  final _formkey = GlobalKey<FormState>();
  late final TextEditingController _titleController, _priceController;

  //category
  late String _catValue;

  //sale
  String? _salePercent;
  late String percToShow;
  late double _salePrice;
  late bool _isOnSale;

  //image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;

  //kg or piece
  late int val;
  late bool _isPiece;

  //while loading
  bool _isLoading = false;

  @override
  void initState() {
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);

    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;
    _isPiece = widget.isPiece;
    val = _isPiece ? 2 : 1;
    _imageUrl = widget.imageUrl;
    percToShow =
        '${(100 - (_salePrice * 100) / double.parse(widget.price)).round().toStringAsFixed(1)}%';
    super.initState();
  }

  int _groupValue = 1;

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void updateProduct() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();

      try {
        String? imageUri;
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('productsImages')
              .child(widget.id + 'jpg');

          if (kIsWeb) {
            await ref.putData(webImage);
          } else {
            await ref.putFile(_pickedImage!);
          }
          imageUri = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': _titleController.text,
          'price': _priceController.text,
          'salePrice': _salePrice,
          'imageUrl':
              _pickedImage == null ? widget.imageUrl : imageUri.toString(),
          'productCategoryName': _catValue,
          'isOnSale': _isOnSale,
          'isPiece': _isPiece,
        });
        Fluttertoast.showToast(
          msg: 'Product has been updated',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
        print("successfuly");
      } on FirebaseException catch (e) {
        // ignore: use_build_context_synchronously
        GlobalMethods.errorDialog(context: context, subtitle: "${e.message}");
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        GlobalMethods.errorDialog(
            context: context, subtitle: "an error occurred$e");
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;
    Color color = Utlis(context).color;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final theme = Utlis(context).getTheme;

    var inputDecoration = InputDecoration(
        filled: true,
        fillColor: scaffoldColor,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: color,
          width: 1.0,
        )));

    return Scaffold(
        //key: context.read<CustomMenuController>().getAddProductScaffoldKey,
        //drawer: const SideMenu(),
        body: LoadingManager(
      isLoading: _isLoading,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Center(
          child: Column(children: [
            // Header(
            //     showTextField: false,
            //     header: "Add product",
            //     fun: () {
            //       context
            //           .read<CustomMenuController>()
            //           .controlAddProductMenu();
            //     }),
            Container(
              width: size.width > 650 ? 650 : size.width,
              color: Colors.tealAccent,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextWidget(
                        text: "product title",
                        color: color,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _titleController,
                        key: const ValueKey("Title"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a title";
                          } else {
                            return null;
                          }
                        },
                        decoration: inputDecoration,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: "Price in \$*",
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: _priceController,
                                        key: const ValueKey("Price\$"),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "price is missed";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: inputDecoration,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: 'Product category*',
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _categoryDropDawn(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: "Measure unit",
                                      color: color,
                                      isTitle: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        TextWidget(text: 'KG', color: color),
                                        Radio(
                                          activeColor: Colors.green,
                                          value: 1,
                                          groupValue: _groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              _groupValue = 1;
                                              _isPiece = false;
                                            });
                                          },
                                        ),
                                        TextWidget(text: 'Piece', color: color),
                                        Radio(
                                          value: 2,
                                          groupValue: _groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              _groupValue = 2;
                                              _isPiece = true;
                                            });
                                          },
                                          activeColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isOnSale,
                                          onChanged: (value) {
                                            setState(() {
                                              _isOnSale = value!;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        TextWidget(
                                            color: color,
                                            text: "Sale",
                                            isTitle: true),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(seconds: 1),
                                      child: !_isOnSale
                                          ? Container()
                                          : Row(
                                              children: [
                                                TextWidget(
                                                    text:
                                                        "\$${_salePrice.toStringAsFixed(2)}",
                                                    color: color),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                saleProcentaDropDownWidget(color)
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height:
                                        size.width > 650 ? 350 : size.width * .45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _pickedImage == null
                                          ? Image.network(_imageUrl)
                                          : (kIsWeb)
                                              ? Image.memory(
                                                  webImage,
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.file(
                                                  _pickedImage!,
                                                  fit: BoxFit.fill,
                                                ),
                                    )),
                              )),
                          Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: TextButton(
                                          onPressed: () {
                                            _pickImage();
                                          },
                                          child: TextWidget(
                                              text: "Upload image",
                                              color: Colors.blue)),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ButtonWidget(
                                onPressed: () async {
                                  GlobalMethods.warningDialog(
                                      context: context,
                                      title: "Delete?",
                                      subtitle: "press okay to confirm",
                                      fct: () async {
                                        FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(widget.id)
                                            .delete();
                                        await Fluttertoast.showToast(
                                          msg: 'Product has been deleted',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                        );
                                        // ignore: use_build_context_synchronously
                                        while (Navigator.canPop(context)) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        }
                                      });
                                },
                                text: "Delete",
                                icon: IconlyBold.danger,
                                backgroundColor: Colors.red.shade300),
                            ButtonWidget(
                                onPressed: () {
                                  updateProduct();
                                },
                                text: "Update",
                                icon: IconlyBold.upload,
                                backgroundColor: Colors.blue)
                          ],
                        ),
                      )
                    ],
                  )),
            )
          ]),
        ),
      ),
    ));
  }

  DropdownButtonHideUnderline saleProcentaDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      style: TextStyle(color: color),
      items: const [
        DropdownMenuItem<String>(
          value: '10',
          child: Text("10%"),
        ),
        DropdownMenuItem<String>(
          value: '15',
          child: Text("15%"),
        ),
        DropdownMenuItem<String>(
          value: '25',
          child: Text("25%"),
        ),
        DropdownMenuItem<String>(
          value: '50',
          child: Text("50%"),
        ),
        DropdownMenuItem<String>(
          value: '75',
          child: Text("75%"),
        ),
      ],
      onChanged: (value) {
        if (value == '0') {
          return;
        } else {
          setState(() {
            _salePercent = value;
            _salePrice = double.parse(widget.price) -
                (double.parse(value!) * (double.parse(widget.price) / 100));
          });
        }
      },
      hint: Text(_salePercent ?? percToShow),
      value: _salePercent,
    ));
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print("no image");
      }
    } else {
      print('somthing wrong');
    }
  }

  Widget dottedBoarder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [6.7],
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      _pickImage();
                    },
                    child:
                        TextWidget(text: "Choose an image", color: Colors.blue))
              ],
            ),
          )),
    );
  }

  Widget _categoryDropDawn() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      value: _catValue,
      onChanged: (value) {
        setState(() {
          _catValue = value!;
        });
      },
      hint: const Text('Select a category'),
      items: const [
        DropdownMenuItem(
          value: 'Vegetables',
          child: Text(
            "Vegetables",
          ),
        ),
        DropdownMenuItem(
          value: 'Fruits',
          child: Text(
            "Fruits",
          ),
        ),
        DropdownMenuItem(
          value: 'Grains',
          child: Text(
            "Grains",
          ),
        ),
        DropdownMenuItem(
          value: 'Nuts',
          child: Text(
            "Nuts",
          ),
        ),
        DropdownMenuItem(
          value: 'Herbs',
          child: Text(
            "Herbs",
          ),
        ),
        DropdownMenuItem(
          value: 'Spices',
          child: Text(
            "Spices",
          ),
        ),
      ],
    ));
  }
}
