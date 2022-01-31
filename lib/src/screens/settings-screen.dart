import 'package:flutter/material.dart';
import 'package:howell_capstone/theme/theme_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with AutomaticKeepAliveClientMixin {
  bool isSwitched = false;
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(),
          
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
    
              children:[
                
              Card(
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('DARK THEME', style: TextStyle(fontSize: 17, )), 
                    
                      Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = !isSwitched; //TODO: the toggle resets to off every time i open the page. automaticClientMixin didn't seem to fix it
                        themeNotifier.isDark = isSwitched;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Theme.of(context).colorScheme.primaryVariant,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                    ]
                  ),
                ),
              )
              ]
            ),
          )
          
          );
      }
    );
  }
}
