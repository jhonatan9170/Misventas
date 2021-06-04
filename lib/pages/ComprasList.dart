

import 'package:flutter/material.dart';

import 'Compras.dart';

class ComprasList extends StatelessWidget {
  const ComprasList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Compras()),
          );
        },
      ),
    );
  }
}
