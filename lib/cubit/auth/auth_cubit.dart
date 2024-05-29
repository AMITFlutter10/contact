import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import '../../model/user_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;
  UserModel userModel = UserModel();
// register email& password
  GoogleSignIn googleSignIn = GoogleSignIn();
  final ImagePicker picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  late XFile image;

  registerByEmailAndPassword(
      {required String email, required String password, String? name}) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      emit(AuthRegisterByEmailState());
      userModel.name = name;
      userModel.email = email;
      userModel.password = password;
      userModel.id = credential.user!.uid;
      await storage
          .ref()
          .child("images/")
          .child("${userModel.id}.png}")
          .putFile(File(userImage!.path));
      userModel.pic = await storage
          .ref()
          .child("images/")
          .child("${userModel.id}.png}")
          .getDownloadURL();
      await store.collection("Users").doc(userModel.id).set(userModel.toMap());
      emit(RegisterByEmailAndPasswordSaveState());
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  // Future<void> registerByEmailAndPassword({
  //   required String email,
  //   required String password,
  //   String? name,
  //   File? userImage,
  // }) async {
  //   try {
  //     UserCredential credential = await auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     emit(AuthRegisterByEmailState());
  //
  //     String userId = credential.user!.uid;
  //
  //     userModel.name = name;
  //     userModel.email = email;
  //     userModel.password = password;
  //     userModel.id = userId;
  //
  //     if (userImage != null) {
  //       await storage.ref().child("images/$userId.png").putFile(userImage);
  //       userModel.pic = await storage.ref().child("images/$userId.png").getDownloadURL();
  //     }
  //
  //     await store.collection("Users").doc(userId).set(userModel.toMap());
  //
  //     // إنشاء مجموعة contacts فارغة للمستخدم الجديد
  //     await store.collection("Users").doc(userId).collection("contacts").add({});
  //
  //     emit(RegisterByEmailAndPasswordSaveState());
  //   } on FirebaseAuthException catch (e) {
  //     print('Failed with error code: ${e.code}');
  //     print(e.message);
  //   }
  // }

  // isAdmin  "register"
  // Future<void> registerByEmailAndPassword({
  //   required String email,
  //   required String password,
  //   String? name,
  //   File? userImage,
  // }) async {
  //   try {
  //     UserCredential credential = await auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     emit(AuthRegisterByEmailState());
  //
  //     String userId = credential.user!.uid;
  //
  //     userModel.name = name;
  //     userModel.email = email;
  //     userModel.password = password;
  //     userModel.id = userId;
  //
  //     if (userImage != null) {
  //       await storage.ref().child("images/$userId.png").putFile(userImage);
  //       userModel.pic = await storage.ref().child("images/$userId.png").getDownloadURL();
  //     }
  //
  //     // تحديد إذا كان المستخدم مسؤولاً بناءً على بريده الإلكتروني
  //     bool isAdmin = (email == "admin@example.com");
  //
  //     await store.collection("Users").doc(userId).set({
  //       ...userModel.toMap(),
  //       'isAdmin': isAdmin, // إضافة حقل isAdmin
  //     });
  //
  //     emit(RegisterByEmailAndPasswordSaveState());
  //   } on FirebaseAuthException catch (e) {
  //     print('Failed with error code: ${e.code}');
  //     print(e.message);
  //   }
  // }
  loginByEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userLogin =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    var userData = await store.collection("profile").doc(userModel.id).get();
    userModel = UserModel.fromMap(userData.data()!);
    //GetallUser
    emit(AuthRegisterByEmailState());
  }
// https://firebase.flutter.dev/docs/auth/phone

// isAdmin "login"
//   Future<void> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       String userId = credential.user!.uid;
//
//       DocumentSnapshot userDoc = await store.collection("Users").doc(userId).get();
//
//       if (userDoc.exists) {
//         bool isAdmin = userDoc['isAdmin'];
//
//         if (isAdmin) {
//           print('User is an admin');
//           // هنا يمكنك إضافة ما تريد فعله إذا كان المستخدم مسؤولاً
//         } else {
//           print('User is not an admin');
//           // هنا يمكنك إضافة ما تريد فعله إذا لم يكن المستخدم مسؤولاً
//         }
//
//         // يمكنك تخزين المعلومات في الحالة (state) لاستخدامها لاحقاً في واجهة المستخدم
//         emit(UserSignedInState(isAdmin: isAdmin));
//       }
//     } on FirebaseAuthException catch (e) {
//       print('Failed with error code: ${e.code}');
//       print(e.message);
//     }
//   }
  /////////// ristrict

  registerByGoogle() async {
    await googleSignIn.signOut();
    emit(AuthLoadingState());
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    AuthCredential userCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    UserCredential userByGoogle =
        await auth.signInWithCredential(userCredential);
    //////////////
    userModel.id = userByGoogle.user!.uid; //orpRW53##
    userModel.name = userByGoogle.user!.displayName;
    userModel.pic = userByGoogle.user!.photoURL;
    userModel.email = userByGoogle.user!.email;
    await store.collection("profile").doc(userModel.id).set(userModel.toMap());
    emit(AuthRegisterByGoogleState());
  }

  XFile? userImage;
  uploadImage(String camera) async {
    if (camera == "cam") {
      userImage = (await picker.pickImage(source: ImageSource.camera))!;
      await storage
          .ref()
          .child('images/')
          .child("${userModel.id} as camera.png")
          .putFile(File(userImage!.path));
      emit(UploadPhotoState());
      return userImage?.readAsBytes();
    } else {
      userImage = (await picker.pickImage(source: ImageSource.gallery))!;
      await storage
          .ref()
          .child('images/')
          .child("${userModel.id}as gallery")
          .putFile(File(userImage!.path));
      emit(UploadPhotoState());
      return userImage?.readAsBytes();
    }
  }

  List users = [];
  getUsers() async {
    try {
      var fireStoreUsers = await store
          .collection("profile")
          .where('id', isNotEqualTo: userModel.id)
          .get();
      fireStoreUsers.docs.forEach((element) {
        users.add(
          UserModel.fromMap(element.data()),
        );
      });
      emit(LoadUsersSuccessfully());
    } catch (e) {
      emit(FailedToLoadUsers());
    }
  }
}
