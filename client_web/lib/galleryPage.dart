import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_web/design/colorSet.dart';
import 'package:client_web/design/shadowSet.dart';
import 'package:client_web/model/result/resultGetAllDto.dart';
import 'package:client_web/service/resultApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'controller/Category.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  CategoryService _categoryService = new CategoryService();

  ResultApi _resultApi = new ResultApi();

  int itemLength;
  List<Result> resultData;
  Size displaySize;

  bool flag;

  int goal = 500;
  int now = 0;
  double progress;
  @override
  void initState() {
    flag = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Image.asset(
                  'images/final.gif',
                  width: 350,
                  height: 250,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _resultApi.getAll(),
                  builder: (BuildContext context,
                      AsyncSnapshot<ResultGetAllDto> snapshot) {
                    if (snapshot.hasData == false) {
                      return SizedBox();
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      List<Result> data = snapshot.data.result;
                      return Swiper(
                        viewportFraction: 0.5,
                        autoplay: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          int reverseIndex = data.length - 1 - index;
                          // 끝번일 경우
                          if (reverseIndex == data.length - 1 && flag == true) {
                            if (flag) {
                              Future.delayed(Duration.zero, () async {
                                _resultApi.getAll().then((value) {
                                  if (value.result.length != data.length) {
                                    Get.offAllNamed('/');
                                  }
                                });
                                flag = false;
                              });
                            }
                          } else if (reverseIndex == 0) {
                            Future.delayed(Duration.zero, () async {
                              flag = true;
                            });
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 250),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    ),
                                  ),
                                  imageUrl: data[reverseIndex].path,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorSet.mainColor.withOpacity(0.5),
                                  boxShadow: ShadowSet.shadow(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    data[reverseIndex].id.toString() + "번째 기부자",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _categoryService.indexToCategory(
                                    data[reverseIndex].category),
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                data[reverseIndex].name,
                                style: TextStyle(
                                  fontSize: 67,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.place),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "서울특별시 종로구",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              FutureBuilder(
                future: _resultApi.getAll(),
                builder: (BuildContext context,
                    AsyncSnapshot<ResultGetAllDto> snapshot) {
                  if (snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    now = snapshot.data.result.length;
                    progress = (now / 5) * 0.01;
                    print(progress);
                    return Column(
                      children: [
                        goalLayOut(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget goalLayOut() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorSet.mainColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: ShadowSet.shadow(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "목표까지 남은 거리",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "목표까지 남은 거리, ${goal - now}km. 현재까지 ${now}명이 선을 이어주셨습니다.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 2,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: Get.size.width * 0.7,
                  height: 20,
                  child: LiquidLinearProgressIndicator(
                    value: progress,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.black,
                    ),
                    borderColor: Colors.black,
                    backgroundColor: Colors.white,
                    borderWidth: 0.0,
                    borderRadius: 3.0,
                    direction: Axis.horizontal,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${goal}km',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
