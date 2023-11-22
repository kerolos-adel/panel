import 'package:flutter/material.dart';

class CustomMenuController extends ChangeNotifier{
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey=GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _ordersScaffoldKey=GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey=GlobalKey<ScaffoldState>();
   GlobalKey<ScaffoldState> get getScaffoldKey=>_scaffoldKey;
  GlobalKey<ScaffoldState> get getGridScaffoldKey=>_gridScaffoldKey;
  GlobalKey<ScaffoldState> get getOrderGridScaffoldKey=>_ordersScaffoldKey;
  GlobalKey<ScaffoldState> get getAddProductScaffoldKey=>_addProductScaffoldKey;

   void controlDashboardMenu(){
    if(!_scaffoldKey.currentState!.isDrawerOpen){
      _scaffoldKey.currentState!.openDrawer();
    }
  }
  void controlProductMenu(){
    if(!_gridScaffoldKey.currentState!.isDrawerOpen){
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }
  void controlOrders(){
    if(!_ordersScaffoldKey.currentState!.isDrawerOpen){
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductMenu(){
    if(!_addProductScaffoldKey.currentState!.isDrawerOpen){
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }



}