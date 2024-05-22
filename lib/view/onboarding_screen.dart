import 'package:contact/view/widgets/default_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../enums.dart';
import '../model/onboarding_model.dart';
import '../model/shared/cache_helper.dart';
import '../router/app_route.dart';
import 'builder_onboarding.dart';

class OnBoardingScreen extends StatefulWidget {
   OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
var pageController = PageController();

var isLast= false;

void finishOnBoarding ( context, String screen){
  CacheHelper.putBOOL(key: SharedKeys.onBoarding, value: isLast);
  Navigator.pushNamedAndRemoveUntil(context, screen, (route) => false);
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        actions: [
         TextButton(onPressed: (){
           // Login
           //tzhr awl screen bs
           finishOnBoarding(context, AppRoute.loginScreen);
         }, child: DefaultText(text: "Skip",
           fontSize: 10.sp,))
      ],),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
               itemBuilder: (context , index){
                  return BuilderOnBoarding(onBoardingModel: dataOnBoarding[index],);
                 },
              itemCount:  dataOnBoarding.length,
               onPageChanged: (int index){
                if(index == dataOnBoarding.length-1){
                  setState(() {
                    isLast = true;
                  });
                }else {
                  setState(() {
                    isLast= false;
                  });

                }
               },
                ),
          ),

          Center(
            child: SmoothPageIndicator(
              controller: pageController,
              count:  dataOnBoarding.length,
              //axisDirection: Axis.vertical,
              effect:  const SlideEffect(
                  spacing:  8.0,
                  radius:  4.0,
                  dotWidth:  24.0,
                  dotHeight:  16.0,
                  paintStyle:  PaintingStyle.stroke,
                  strokeWidth:  1.5,
                  dotColor:  Colors.grey,
                  activeDotColor:  Colors.indigo
              ),
            ),
          ),
          SizedBox(height: 3.h,),
          Visibility(
            visible: isLast,
            child: ElevatedButton(onPressed: (){
              finishOnBoarding(context, AppRoute.loginScreen);
              // yzhr f a5er screen bs bnsba l pageView
            }, child: DefaultText(text: "Next", fontSize: 12.sp,)),
          )
        ],
      ));
  }
}

//باستخدام الشرد ازاى اقولو اني شوفت كل ال onboarding  ف متظهرهاش ليا تاني