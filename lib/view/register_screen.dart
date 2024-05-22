import 'package:auth_buttons/auth_buttons.dart';
import 'package:contact/colors.dart';
import 'package:contact/view/widgets/default_form_field.dart';
import 'package:contact/view/widgets/default_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../cubit/auth/auth_cubit.dart';
import '../router/app_route.dart';
import '../translations/locale_keys.g.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool? isPassword;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.pink,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: w,
                      height: h * 0.70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          // bottomRight: Radius.circular(50),
                          // topLeft: Radius.circular(50),
                          topRight: Radius.circular(100),
                        ),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(4.0.h),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DefaultText(
                                text: LocaleKeys.title_Register.tr(),
                                //   title_Register.tr(),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                 color: AppTheme.kPrimaryColor
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              DefaultFormField(
                                  labelText: LocaleKeys.user_name.tr(),
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Email cannot be empty ";
                                    } else {
                                      return null;
                                    }
                                  }),
                               SizedBox(
                                height: 2.h,
                              ),
                              DefaultFormField(
                                  labelText: "email",
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  // prefix: Icon(Icons.email),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Email cannot be empty ";
                                    }
                                    if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]")
                                        .hasMatch(value)) {
                                      return ("please enter valid email");
                                    } else {
                                      return null;
                                    }
                                  }),
                               SizedBox(
                                height: 2.h,
                              ),
                              DefaultFormField(
                                  labelText: LocaleKeys.password.tr(),
                                  keyboardType: TextInputType.text,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Email cannot be empty ";
                                  //  }
                                    // if (!RegExp(
                                    //         "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-z]")
                                    //     .hasMatch(value)) {
                                    //   return ("please enter valid password");
                                    // } else {
                                    //  return null;
                                    }
                                  }),
                               SizedBox(
                                height:2.h,
                              ),
                              SizedBox(
                                width: w * .5,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await   AuthCubit.get(context)
                                          .registerByEmailAndPassword(
                                              name: nameController.text,
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                       ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Successfully Register'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                       Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AppRoute.homeScreen,
                                          (route) => false);
                                      // await cubit.getAllUser();
                                    } },
                                  style: ElevatedButton.styleFrom(
                                    //primary: kSecondaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  child: DefaultText(text: LocaleKeys.title_Register.tr() ),
                                ),
                              ),
                               SizedBox(
                                height: 3.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GoogleAuthButton(
                                    onPressed: () async {
                                      await AuthCubit.get(context).registerByGoogle();
                                      Navigator.pushNamed(context, AppRoute.homeScreen);
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => HomeScreen(),
                                      //     ));
                                    },
                                    style: const AuthButtonStyle(
                                      buttonType: AuthButtonType.icon,
                                      iconType: AuthIconType.secondary,
                                    ),
                                  ),

                                  FacebookAuthButton(
                                    onPressed: () {},
                                    style: const AuthButtonStyle(
                                      //textStyle: TextStyle(color: Colors.black12),
                                        buttonType: AuthButtonType.icon,
                                        iconType: AuthIconType.secondary),
                                  ),
                                  GithubAuthButton(
                                    onPressed: () {},style: const AuthButtonStyle(
                                    //textStyle: TextStyle(color: Colors.black12),
                                      buttonType: AuthButtonType.icon,
                                      iconType: AuthIconType.secondary),)
                                ],
                              ),
                               SizedBox(
                                height: 2.h,
                              ),
                              // Select photo from cam or gallery
                              ElevatedButton(
                                  onPressed: () async {
                                    await AuthCubit.get(context).uploadImage( "ggfdjk");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)),
                                  ),
                                  child:  DefaultText(
                                   text:  LocaleKeys.choose_photo.tr(),
                                   color: AppTheme.primaryColor
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            LocaleKeys.have_account.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                            Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
                            },
                            child: Text(
                              LocaleKeys.Login_bottom.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: ()async{
                          await context.setLocale(const Locale('ar'));
                        }, child:const Text("Arabic")),
                        ElevatedButton(onPressed: ()async{
                          await context.setLocale(const Locale('en'));
                        }, child:const Text("English")),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    //   },
    // );;
    // ),
    //     ),
    //   );
  }
}
