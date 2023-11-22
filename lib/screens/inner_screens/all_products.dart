import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app_panel/widgets/header.dart';

import '../../controller/MenuController.dart';
import '../../responsive.dart';
import '../../services/utlis.dart';
import '../../widgets/grid_products.dart';
import '../../widgets/side_menu.dart';
import '../dashboard_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;

    return Scaffold(
      key: context.read<CustomMenuController>().getGridScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context)) const Expanded(child: SideMenu()),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(children: [
                  Header(
                      header: "All product",
                      fun: () {
                    context.read<CustomMenuController>().controlProductMenu();
                  }),
                  const SizedBox(height: 25,),
                  Responsive(
                    mobile: ProductGridWidget(
                      crossAxisCount: size.width < 650 ? 2 : 4,
                      childAspectRatio:
                          size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                      isInMain: false,
                    ),
                    desktop: ProductGridWidget(
                      childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                      isInMain: false,
                    ),
                  )
                ]),
              )),
        ],
      )),
    );
  }
}
