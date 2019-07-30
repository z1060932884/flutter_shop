import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
//"https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=长腿小姐姐"

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = "正在获取数据……";

  @override
  void initState() {
    // TODO: implement initState

    getHomePageContent().then((val) {
      setState(() {
        homePageContent = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
          appBar: AppBar(
            title: new Text("百姓生活+"),
          ),
          body: FutureBuilder(
            future: getHomePageContent(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                var data = json.decode(snapshot.data.toString());
                List<Map> swiper = (data['data']['slides'] as List).cast();
                List<Map> navigatorList =(data['data']['category'] as List).cast(); //类别列表
                String advertesPicture = data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
                String leaderImage = data['data']['shopInfo']['leaderImage']; //店长图片
                String leaderPhone = data['data']['shopInfo']['leaderPhone'];//店长电话
                return Column(
                  children: <Widget>[
                    SwiperDiy(swiperDateList: swiper),//轮播组件
                    TopNavigator(navigatorList:navigatorList),  //导航组件
                    AdBanner(advertesPicture:advertesPicture),   //广告组件
                    LeaderPhone(leaderImage:leaderImage,leaderPhone: leaderPhone)  //广告组件 
                  ],
                );
              }else{
                  return Center(
                    child: Text("加载中……"),
                  );
              }
            },
          ),
      ),
    );
  }
}

/**
 * 首页轮播组件
 */
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({Key key,this.swiperDateList}):super(key:key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDateList[index]['image']}",fit: BoxFit.fill,);
        },
        itemCount: 3,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}


 class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context,item){

    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(navigatorList.length>10){
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding:EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }


}


//广告图片
class AdBanner extends StatelessWidget {
  final String advertesPicture;
  AdBanner({Key key, this.advertesPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

//店长电话
class LeaderPhone extends StatelessWidget{

  final String leaderImage;//店长图片
  final String leaderPhone;//店长电话

  LeaderPhone({Key key,this.leaderImage,this.leaderPhone}) : super (key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){
         launchUrl();
        },
        child: Image(image: NetworkImage(leaderImage)),
      ),

    );
  }


  void launchUrl() async{
    String url = 'tel:'+leaderPhone;
    //地址是否支持打开
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url不能进行访问';
    }
  }

}



