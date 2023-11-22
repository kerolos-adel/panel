import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:store_app_panel/providers/dark_theme_provider.dart';
import 'package:store_app_panel/screens/inner_screens/all_products.dart';
import 'package:store_app_panel/screens/inner_screens/orders_screen.dart';
import 'package:store_app_panel/screens/main_screen.dart';
import 'package:store_app_panel/services/utlis.dart';
import 'package:store_app_panel/widgets/text_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utlis(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = Utlis(context).color;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset('assets/images/groceries.jpg')),
          DrawerListTile(
            title: "Main",
            press: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ));
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
              title: "View all products", press: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllProductsScreen(),));
          }, icon: Icons.store),
          DrawerListTile(
            title: "View all order",
            press: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrdersScreen(),));
            },
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
            title: const Text("Theme"),
            secondary: Icon(themeState.getDarkTheme
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            value: theme,
            onChanged: (value) {
              setState(() {
                themeState.setDarkTheme = value;
              });
            },
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key, required this.title, required this.press, required this.icon})
      : super(key: key);
  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utlis(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 18,
      ),
      title: TextWidget(text: title, color: color),
    );
  }
}
