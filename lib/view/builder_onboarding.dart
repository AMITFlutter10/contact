import 'package:contact/view/widgets/default_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../model/onboarding_model.dart';

class BuilderOnBoarding extends StatelessWidget {
  OnBoardingModel onBoardingModel ;
    BuilderOnBoarding({super.key ,required this.onBoardingModel });

   @override
   Widget build(BuildContext context) {
     return  Column(
       children: [
          Image.asset("${onBoardingModel.image}"),
          SizedBox(height:  2.h,),
          DefaultText(text: "${onBoardingModel.dis}"),

       ],
     );
   }
 }
