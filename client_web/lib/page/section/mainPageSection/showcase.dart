import 'package:client_web/design/colorSet.dart';
import 'package:client_web/page/model/result.dart';
import 'package:client_web/service/resultIndexGet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ShowCase extends StatefulWidget {
  @override
  _ShowCaseState createState() => _ShowCaseState();
}

class _ShowCaseState extends State<ShowCase> {
  Size displaySize;

  List<Result> itemList;
  int itemListLength;

  @override
  void initState() {
    itemListLength = 0;
    super.initState();
  }

  // void loadResultIndex() {
  //   GetResultIndex().resultIndex.then((value) {
  //     setState(() {
  //       itemList = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Container(
      width: displaySize.width,
      height: displaySize.height * 0.4,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: ColorSet.mainColor,
            child: Text(
              "사진사진사진사진사진사진사진사진사진사진",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
        autoplay: true,
        itemCount: 3,
        control: new SwiperControl(
          iconNext: null,
          iconPrevious: null,
        ),
      ),
    );
  }
}
