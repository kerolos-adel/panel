import 'package:flutter/material.dart';
import 'package:store_app_panel/responsive.dart';
import 'package:store_app_panel/services/utlis.dart';

import '../const/conss.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.fun, required this.header,  this.showTextField=true}) : super(key: key);
final Function fun;
final String header;
final bool showTextField;
  @override
  Widget build(BuildContext context) {
    final theme =Utlis(context).getTheme;
    final color=theme==true?Colors.white:Colors.black;


    return Row(children: [
      if(!Responsive.isDesktop(context))
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            fun();
          },
        ),
    if(Responsive.isDesktop(context))
      Padding(padding: const EdgeInsets.all(8),
      child: Text(header,style: Theme.of(context).textTheme.headline6,),
      ),
      if(Responsive.isDesktop(context))
        Spacer(flex: Responsive.isDesktop(context)?2:1,),
     !showTextField?Container(): Expanded(child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          fillColor: Theme.of(context).cardColor,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(defaultPadding*.75),
              margin: const EdgeInsets.symmetric  (horizontal:defaultPadding/2),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Icon(Icons.search),
            ),
          )
        ),
      ))
    ],);
  }
}
