import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app_panel/responsive.dart';
import 'package:store_app_panel/screens/dashboard_screen.dart';
import 'package:store_app_panel/widgets/side_menu.dart';

import '../controller/MenuController.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<CustomMenuController>().getScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(Responsive.isDesktop(context))
            const Expanded(child:SideMenu()),
          const Expanded(flex: 5,child: DashboardScreen(),),

        ],
      )),
    );
  }
}
