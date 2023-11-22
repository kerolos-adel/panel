import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app_panel/widgets/header.dart';
import 'package:store_app_panel/widgets/order_list.dart';

import '../../controller/MenuController.dart';
import '../../responsive.dart';
import '../../services/utlis.dart';
import '../../widgets/grid_products.dart';
import '../../widgets/side_menu.dart';
import '../dashboard_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utlis(context).screenSize;

    return Scaffold(
      key: context
          .read<CustomMenuController>()
          .getOrderGridScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context)) const Expanded(
                  child: SideMenu()),
              Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(children: [
                      Header(
                          header: "All Orders",
                          fun: () {
                            context.read<CustomMenuController>()
                                .controlOrders();
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: OrderList(
                            isInDashboard: false,
                          )
                      )
                    ]),
                  )),
            ],
          )),
    );
  }
}
