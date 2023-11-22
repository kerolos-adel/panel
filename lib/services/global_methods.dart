import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class GlobalMethods {
  static Future<void> warningDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Function fct,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                FancyShimmerImage(
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEwWnlPlPS8jebu6k-a2TnK7fHZS7IHSFi9hLV6g2amWszAZBdGqAdwaoctgGeqRZ-RYg&usqp=CAU',
                  boxFit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title)
              ],
            ),
            content: Text(subtitle),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {

                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  fct();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required BuildContext context,
    required String subtitle,

  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                FancyShimmerImage(
                  imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEwWnlPlPS8jebu6k-a2TnK7fHZS7IHSFi9hLV6g2amWszAZBdGqAdwaoctgGeqRZ-RYg&usqp=CAU',
                  boxFit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("error occured")
              ],
            ),
            content: Text(subtitle),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }
}

