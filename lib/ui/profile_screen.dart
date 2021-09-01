import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickeat_app/widgets/platformWidget.dart';

class ProfileScreen extends StatelessWidget {
  static final routeName = '/profile_page';

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }

  

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile',
          style: TextStyle(fontSize: 32),),
          toolbarHeight: 80,
        ),
        body: _buildList(),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle : Text(
            'Your Favorite Places', style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black))),
      
      child: _buildList());
  }
}

Widget _buildList() {
  return Center(
    child: Text('Profile Page'),
  );
}
