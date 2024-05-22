import 'package:contact/router/app_route.dart';
import 'package:contact/router/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_string.dart';
import 'app_theme.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/contact_cubit/contact_cubit.dart';
import 'cubit/observer.dart';
import 'cubit/theme_cubit/themes_cubit.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';

import 'model/shared/cache_helper.dart';


Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print("Handling ${message.messageId}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation
  <AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(channel);

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    sound: true,
    alert:  true,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: const MyApp()
  ),
  );
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    "idChannel",  // id
    "notificationChannel" // name
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState()
    {
      var androidInitializationSettings= AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings=  InitializationSettings(android: androidInitializationSettings);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification = message.notification!.android;
        if( notification != null && androidNotification != null){
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      icon: "@mipmap/ic_launcher"
                  )
              )
          );
        }
      });


      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? androidNotification = message.notification!.android;
        if( notification != null && androidNotification != null){
          showDialog(context: context, builder: (context)=> AlertDialog(
            title:  Text("${notification.title}"),
            content: Column(
              children: [
                Text("${notification.body}"),
              ],
            ) ,
          ));
        }
      });

      getToken();
      super.initState();
    }

  String? token;
  getToken()async {
    token = await FirebaseMessaging.instance.getToken();
  }
    // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthCubit(),
              ),
              BlocProvider(
                create: (context) =>
                ContactCubit()
                  ..getContact()
                  ..getFavorite(),
              ),
              BlocProvider(
                create: (context) => ThemesCubit(),
              ),
            ],
            child: BlocBuilder<ThemesCubit, ThemesState>(
              builder: (context, state) {
                ThemesCubit cubit = ThemesCubit.get(context);
                cubit.getTheme();
                return MaterialApp(
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  title: AppStrings.title,
                  theme: ThemesCubit
                      .get(context)
                      .isDark ?
                  Themes.darkTheme
                      : Themes.lightTheme,
                  // home: const LoginPage(),
                  //  routes: {
                  //    "login" : (context)=> const LoginPage(),
                  //     "register" : (context)=> const RegisterPage()
                  //  },
                  onGenerateRoute: onGenerateRouter,
                  initialRoute: AppRoute.registerScreen,
                );
              },
            ),
          );
        }
    );
  }
}


//
// class MyHomePage extends StatefulWidget {
//    MyHomePage({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   final fireStore = FirebaseFirestore.instance;
//  // task
//  //  object vs instance
//   sendData() {
//     fireStore.collection("note").add({
//       "message": massageController.text,
//       "time": timeController.text,
//     }).then((value) {
//       print(value);
//     });
//   }
//
//   // sendCollection() {
//   //   fireStore.collection("TextNote").add({
//   //     "message": massageController.text,
//   //     "time": timeController.text,
//   //   }).then((value) {
//   //     print(value);
//   //   });
//   // }
//
//   // getData() {
//   //   // fireStore.collection("note").get();
//   //   fireStore.collection("note").snapshots();
//   // }
//
//
//   var massageController = TextEditingController();
//   var timeController = TextEditingController();
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller:massageController ,
//               decoration: InputDecoration(
//                 hintText: "message",
//                 labelText: "note"
//               ),
//
//             ),
//             SizedBox(height: 20,),
//             TextFormField(
//               controller: timeController,
//               decoration: InputDecoration(
//                   hintText: "time",
//                   labelText: "Note Time"
//               ),
//
//             ),
//             SizedBox(height: 30,),
//             ElevatedButton(onPressed: (){
//               setState(() {
//                 sendData();
//               });
//
//             }, child: Text("Send")),
//             Divider(height: 10,thickness: 2.0, color: Colors.red,),
//
//              StreamBuilder(
//                  stream: fireStore.collection("note").snapshots(),
//                  builder: (context, snapshot ) {
//                    return snapshot.hasData ?
//                    snapshot.data!.docs.length != 0 ?
//                    ListView.builder(
//                        shrinkWrap: true,
//                        itemCount: snapshot.data!.docs.length,
//                        itemBuilder: (context, index) {
//                          return Center(
//                            child: Column(
//                              children: [
//                                Text(snapshot.data!.docs[index]['message']),
//                                SizedBox(height: 10,),
//                                Text(snapshot.data!.docs[index]['time']),
//                              ],
//                            ),
//
//                          );
//                        }) :
//                    const Center(child: Text("no Data"),) :
//                    snapshot.hasError ? const Text(
//                        "error"
//                    ) : const Center(child: CircularProgressIndicator(),);
//                  })
//       ],
//         ),
//       ),
//     );
//   }
// }