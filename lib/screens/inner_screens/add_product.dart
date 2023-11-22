
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

class UploadProductFrom extends StatefulWidget {
  static const routeName = "/UploadProductFrom";

  const UploadProductFrom({Key? key}) : super(key: key);

  @override
  State<UploadProductFrom> createState() => _UploadProductFromState();
}

class _UploadProductFromState extends State<UploadProductFrom> {
  int _groupValue = 1;
  bool isPiece = false;
  String _catValue = "Vegetables";
  String? imageUri;
  final _formkey = GlobalKey<FormState>();
  late final TextEditingController _titleController, _priceController;
  File? pickedImage;
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  void uploadFrom() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      final uuid = Uuid().v4();
      if (pickedImage == null) {
        GlobalMethods.errorDialog(
            context: context, subtitle: 'please pick up an image');
        return;
      }
      _formkey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        final ref =FirebaseStorage.instance.ref().child('userImages').child('$uuid.jpg');
        if(kIsWeb) {
          await ref.putData(webImage);
        }
        else{
          await ref.putFile(pickedImage!);
        }
        imageUri= await ref.getDownloadURL();
        //  fb.StorageReference storageRef =
       //      fb.storage().ref().child('productsImages').child(uuid + 'jpg');
       //  final fb.UploadTaskSnapshot uploadTaskSnapshot =
       //      await storageRef.put(kIsWeb ? webImage : pickedImage).future;
       // Uri imageUri= await uploadTaskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('products').doc(uuid).set({
          'id': uuid,
          'title': _titleController.text,
          'price': _priceController.text,
          'salePrice': 0.1,
          'imageUrl': imageUri,
          'productCategoryName': _catValue,
          'isOnSale': false,
          'isPiece': isPiece,
          'createAt': Timestamp.now()
        });
        clearForm();
        Fluttertoast.showToast(
          msg: 'Product uploaded succefully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
        print("successfuly");
      } on FirebaseException catch (e) {
        // ignore: use_build_context_synchronously
        GlobalMethods.errorDialog(context: context, subtitle: "${e.message}");
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        GlobalMethods.errorDialog(
            context: context, subtitle: "an error occurred$e");
        setState(() {
          isLoading = false;
        });
      } finally {
        setState(() {
          isLoading = false;
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
      key: context.read<CustomMenuController>().getAddProductScaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            if (Responsive.isDesktop(context))
              const Expanded(child: SideMenu()),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(children: [
                    Header(
                        showTextField: false,
                        header: "Add product",
                        fun: () {
                          context
                              .read<CustomMenuController>()
                              .controlAddProductMenu();
                        }),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                keyboardType:
                                                    TextInputType.number,
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
                                                TextWidget(
                                                    text: 'KG', color: color),
                                                Radio(
                                                  activeColor: Colors.green,
                                                  value: 1,
                                                  groupValue: _groupValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _groupValue = 1;
                                                      isPiece = false;
                                                    });
                                                  },
                                                ),
                                                TextWidget(
                                                    text: 'Piece',
                                                    color: color),
                                                Radio(
                                                  value: 2,
                                                  groupValue: _groupValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _groupValue = 2;
                                                      isPiece = true;
                                                    });
                                                  },
                                                  activeColor: Colors.green,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: size.width > 650
                                                ? 350
                                                : size.width * .45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            child: pickedImage == null
                                                ? dottedBoarder(color: color)
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: kIsWeb
                                                        ? Image.memory(
                                                            webImage,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.file(
                                                            pickedImage!,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  )),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  pickedImage = null;
                                                  webImage = Uint8List(8);
                                                });
                                              },
                                              child: TextWidget(
                                                  text: "Clear",
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonWidget(
                                        onPressed: clearForm,
                                        text: "Clear from",
                                        icon: IconlyBold.danger,
                                        backgroundColor: Colors.red.shade300),
                                    ButtonWidget(
                                        onPressed: () {
                                          uploadFrom();
                                        },
                                        text: "Upload",
                                        icon: IconlyBold.upload,
                                        backgroundColor: Colors.blue)
                                  ],
                                ),
                              )
                            ],
                          )),
                    )
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  void clearForm() {
    isPiece = false;
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    setState(() {
      pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          pickedImage = File('a');
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
                      pickImage();
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
