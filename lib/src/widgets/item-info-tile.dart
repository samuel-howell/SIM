import 'package:flutter/material.dart';

class ItemInfoTile extends StatefulWidget {
  const ItemInfoTile({ Key? key }) : super(key: key);

  @override
  _ItemInfoTileState createState() => _ItemInfoTileState();
}

class _ItemInfoTileState extends State<ItemInfoTile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(//  without scaffold the text is big and red with yellow underline
      body: Column(
        children: [
          Text('hello'),
          Text('this is not the end')
        ],
      ),
    );
  }
}