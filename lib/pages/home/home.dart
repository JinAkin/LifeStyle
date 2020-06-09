import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetpack/data/const.dart';
import 'package:jetpack/pages/home/menu_about.dart';
import 'package:jetpack/pages/home/menu_collaborators.dart';
import 'package:jetpack/pages/home/menu_leave_msg.dart';
import 'package:jetpack/styles/fonts.dart';
import 'package:jetpack/styles/sizes.dart';
import 'package:jetpack/widgets/widget_responsive.dart';
import 'package:jetpack/util/screen_utils.dart';

import '../../main.dart';
import 'drawer.dart';
import 'menu_home_new.dart';
import 'menu_setting.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _switchValue = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Material(
        child: Padding(
      padding: padding(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: _buildTitle(),
          actions: WidgetResponsive.isSmallScreen(context)
              ? _buildSmallScreenAction(context)
              : _buildLargeScreenActions(context),
          leading: WidgetResponsive.isSmallScreen(context)
              ? IconButton(
                  icon: Icon(
                    Icons.menu,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                )
              : null,
        ),
        drawer: _buildDrawer(context),
        body: StreamBuilder<Object>(
            initialData: 0,
            stream: homeBloc.stream,
            builder: (context, snapshot) {
              return _getDrawerItemWidget(snapshot.data);
            }),
      ),
    ));
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        textLogoTitle("Jetpack"),
        textLogoSubTitle(".net.cn"),
      ],
    );
  }

  _buildLargeScreenActions(BuildContext context) {
    return <Widget>[
      Switch(
        onChanged: (bool value) {
          setState(() {
            _switchValue = !_switchValue;
          });
          if (value) {
            bloc.changeTheTheme(AppTheme.DARK_THEME);
          } else {
            bloc.changeTheTheme(AppTheme.LIGHT_THEME);
          }
        },
        value: _switchValue,
      ),
      MaterialButton(
        child: textMenuAction('主页'),
        onPressed: () {
          homeBloc.changeSelectedDrawerIndex(0);
          if (WidgetResponsive.isSmallScreen(context)) Navigator.pop(context);
        },
      ),
      MaterialButton(
        child: textMenuAction('关于'),
        onPressed: () {
          homeBloc.changeSelectedDrawerIndex(1);
          if (WidgetResponsive.isSmallScreen(context)) Navigator.pop(context);
        },
      ),
      MaterialButton(
        child: textMenuAction('留言'),
        onPressed: () {
          homeBloc.changeSelectedDrawerIndex(4);
          if (WidgetResponsive.isSmallScreen(context)) Navigator.pop(context);
        },
      ),
      MaterialButton(
        child: textMenuAction('合作者'),
        onPressed: () {
          homeBloc.changeSelectedDrawerIndex(3);
          if (WidgetResponsive.isSmallScreen(context)) Navigator.pop(context);
//          Navigator.of(context).pushNamed("/LaoMeng");
        },
      ),

    ];
  }

  _buildDrawer(BuildContext context) {
    return WidgetResponsive.isSmallScreen(context)
        ? Drawer(
            child: WidgetDrawer(),
          )
        : null;
  }

  Widget _getDrawerItemWidget(int selectedDrawerIndex) {
    switch (selectedDrawerIndex) {
      case 0:
        return WidgetMenuNewHome();
      case 1:
        return WidgetMenuAbout();
      case 2:
        return WidgetMenuSetting();
      case 3:
        return MenuCollaborators();
      case 4:
        return MenuLeaveMsg();
    }
    return Container();
  }

  _buildSmallScreenAction(BuildContext context) {
    return <Widget>[
      Switch(
        onChanged: (bool value) {
          setState(() {
            _switchValue = !_switchValue;
          });
          if (value) {
            bloc.changeTheTheme(AppTheme.DARK_THEME);
          } else {
            bloc.changeTheTheme(AppTheme.LIGHT_THEME);
          }
        },
        value: _switchValue,
      ),
//      IconButton(
//        icon: ,
//        onPressed: () {},
//      ),
      IconButton(
        icon: Icon(Icons.group_add),
        onPressed: () {
          Navigator.of(context).pushNamed("/pageChatGroup");
        },
      )
    ];
  }

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }
}

class HomeBloc {
  final _selectedDrawerIndexController = StreamController<int>();

  get changeSelectedDrawerIndex => _selectedDrawerIndexController.sink.add;

  get stream => _selectedDrawerIndexController.stream;

  dispose() {
    _selectedDrawerIndexController.close();
  }
}

final homeBloc = HomeBloc();
