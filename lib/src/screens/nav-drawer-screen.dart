//  THIS PAGE IS A NAVIGATION OVERLAY WIDGET THAT DISPLAYS OVER OTHER SCREENS 

import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/item-screen.dart';
import 'package:howell_capstone/src/screens/qr-screen.dart';
import 'package:howell_capstone/src/screens/scan-screen.dart';
import 'package:howell_capstone/src/screens/view-screen.dart';
import 'package:howell_capstone/src/screens/store-screen.dart';




class NavigationDrawerWidget extends StatelessWidget {
final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Material( //  making this a material widget instead of container provides us witha visual change
        color: Color(0xff403F4C),
        child: ListView(
          padding: padding,

          children: <Widget>[

            //  each of these is an item in the nav drawer
            const SizedBox(height:50),
            buildMenuItem(
              text:'STORE', 
              icon: Icons.store,
              onClicked: () => selectedItem(context, 0),
            ),

            const SizedBox(height:15),
            buildMenuItem(
              text:'ITEMS', 
              icon: Icons.article, 
              onClicked: () => selectedItem(context, 4),
            ),

            const SizedBox(height:15),
            buildMenuItem(
              text:'QR CODE', 
              icon: Icons.qr_code_2,
              onClicked: () => selectedItem(context, 1),
            ),


            const SizedBox(height:15),
            buildMenuItem(
              text:'SCAN', 
              icon: Icons.screenshot,
              onClicked: () => selectedItem(context, 2),
            ),


            const SizedBox(height:15),
            buildMenuItem(
              text:'VIEW', 
              icon: Icons.info,
              onClicked: () => selectedItem(context, 3),
            ),

            

            //  this is our divider
            const SizedBox(height:24),
            Divider(color: Colors.white70),
            const SizedBox(height:24),
          ]

        )
      )
    );
  }

 //  build a widget method for custom listTile items
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color:color)),
      hoverColor: hoverColor,  //  adds some extra pizzazz if you're viewing it on the web
      onTap: onClicked,
    );
  }


  /* 
  create a selectedItem method. It pushes the context using the Navigator to whatever page
  is associated with the integer value in the method parameter. I assign the different pages to different
  ints, then just reference those ints up in my nav drawer on the onClicked.
  This cleans up the code and makes it easier to read.   */
  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0: 
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoreScreen(),
        )
      );
      break;

      case 1: 
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QRScreen(),
        )
      );
      break;

      case 2: 
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScanScreen(),
        )
      );
      break;

      case 3: 
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ViewScreen(),
        )
      );
      break;

      case 4: 
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemScreen(),
        )
      );
      break;
    }
  }
}

