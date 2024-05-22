import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../view/contact_screen.dart';
import '../../view/favorite_screen.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());
  static ContactCubit get(context)=> BlocProvider.of(context);
  // CRUd
final FirebaseFirestore store = FirebaseFirestore.instance;



insertContacts({required String name ,required String phone })async{
   int uniqueId = DateTime.now().millisecondsSinceEpoch;
   await store.collection("Contacts").doc(uniqueId.toString()).set({
     "id": uniqueId,
     "name" : name,
     "phone": phone,
     "type": "noFavorite"
   }).then((value) {
     getContact();
     print("Create New Contact ");
     emit(InsertContactSuccessState());
   }).catchError((error){
     emit(InsertContactErrorState());
     print(error);
   });
}

updateContact({required int id, String? name , String? phone})async{
  await store.collection("Contacts").doc(id.toString()).update({
    "name":name,
    "phone":phone,
    "type": "noFavorite"
  }).then((value) {
    getContact();
    getFavorite();
    emit(UpdateContactSuccessState());
  }).catchError((error){
    emit(UpdateContactErrorState());
  });
}

updateFavorite({required int id ,required String type})async {
  await store.collection("Contacts").doc(id.toString()).update({
    'type': type,
  }).then((value) {
    getContact();
    getFavorite();
    emit(UpdateFavoriteSuccessState());
  }).catchError((error) {
    emit(UpdateFavoriteErrorState());
  });
}
List<Map>contactsList =[];
List<Map>favoriteList =[];

//   1-loading
//   2-success
//   3-error

getContact()async{
  contactsList=[];
  emit(LoadingGetContactsState());
  await store.collection("Contacts").get().then((value){
     for(QueryDocumentSnapshot<Map<String,dynamic>> element in value.docs){
       contactsList.add(element.data());
       emit(GetContactSuccessState());
     }
  });
}

getFavorite()async{
    favoriteList =[];
    emit(LoadingGetFavoriteState());
    await store.collection("Contact").where("type",isEqualTo:"Favorite" ).get()
        .then((value){
      for(QueryDocumentSnapshot<Map<String,dynamic>> element in value.docs) {
        favoriteList.add(element.data());
        emit(GetFavoriteSuccessState());
      }
    });
  }

deleteContact({required int id})async{
   await store.collection("Contacts").doc(id.toString()).delete().then((value) {
     getContact();
     getFavorite();
     emit(DeleteSuccessState());
   });
  }

  Icon floatingIcon=  const Icon(Icons.add);

  bool isBottomSheetShow = false;
  int currentIndex = 0;

void changeBottomSheet({required bool isShown , required Icon icon}){
  isBottomSheetShow = isShown;
  floatingIcon =icon;
  emit(ChangeBottomState());

}


List<Widget>screens = [
  ContactScreen(),
  FavoriteScreen(),
];

List<String>title =[
  "Contact",
  "Favorite"
];

void changeButtonNavbar(int index ){
  currentIndex = index;
  emit(ChangeButtonNavbarState());
}
}
