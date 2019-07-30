import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text("首页")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text("分类")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text("购物车")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text("个人中心")
    ),
  ];

  final List tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()

  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    // TODO: implement initState
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        //底部内容列表
        items: bottomTabs,
        //点击事件
        onTap: (index){
          //刷新UI效果
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[index];
          });
        },
      ),
      body: currentPage,
    );
  }
}

