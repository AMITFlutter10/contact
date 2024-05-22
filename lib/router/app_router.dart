
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/home_screen.dart';
import '../view/login_screen.dart';
import '../view/onboarding_screen.dart';
import '../view/register_screen.dart';
import '../view/splash_screen.dart';
import 'app_route.dart';
// import 'package:firebase48online/core/constants.dart' as screens;

  Route? onGenerateRouter(RouteSettings settings){
    switch(settings.name){
      case AppRoute.splashScreen :
        return MaterialPageRoute(builder: (_)=>const SplashScreen() );
       case AppRoute.onBoardingScreen :
        return MaterialPageRoute(builder: (_)=>  OnBoardingScreen() );
        case AppRoute.loginScreen :
        return MaterialPageRoute(builder: (_)=> LoginScreen() );
      case AppRoute.registerScreen :
        return MaterialPageRoute(builder: (_)=>const RegisterScreen() );
      case AppRoute.homeScreen :
        return MaterialPageRoute(builder: (_)=>  HomeScreen() );
      default :
        return null ;
    }

  // late Widget startScreen;
  //  Route? onGenerateRouter(RouteSettings settings){
  //    startScreen = const SplashScreen();
  //    switch(settings.name){
  //      case '/':
  //        return MaterialPageRoute(builder: (_)=> startScreen);
  //      case screens.homeScreen:
  //        return MaterialPageRoute(builder: (_)=> const HomeScreen());
  //      default:
  //        return null ;
  //    }
  //  }

}