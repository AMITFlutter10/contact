import 'package:contact/view/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/contact_cubit/contact_cubit.dart';
import 'editing_item.dart';

class BuilderItem extends StatelessWidget {
  Map contactItem;
   BuilderItem({super.key,required this.contactItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (dismissed){
        showDialog(context: context, builder: (context)=> Container(
          child: Row(children: [
            TextButton(onPressed: (
                ContactCubit.get(context).deleteContact(id: contactItem['id'])
            ), child: Text("delete")),
            TextButton(onPressed: (){
            Navigator.pop(context);},
             child: Text("cancel"),),
          ],),

        ));
     //   ContactCubit.get(context).deleteContact(id: contactItem['id']);
        Fluttertoast.showToast(
            msg: "Delete Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
      child: InkWell(
         onTap:(){
          Fluttertoast.showToast(
              msg: "Long touch for contact editing,"
                  " Swipe left or right to delete,"
               "and double touch for calling Contact.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0

          );
        } ,
         onLongPress: (){
          showDialog(context: context, builder: (BuildContext context) {
            return EditingContacts(contactItems: contactItem,);
          }); },
         onDoubleTap:()async{
        final   Uri launchUri = Uri(
            scheme: 'tel',
            path: contactItem['phone']
        );
        print(launchUri);
        await launchUrl(launchUri);
      } ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade400
            ),
            padding: EdgeInsets.all(2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultText(text: contactItem['name'],
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    DefaultText(text: contactItem['phone']),
                  ],
                ),
                Visibility(
                  visible: contactItem["type"] =='Favorite',
                    replacement:IconButton(onPressed: ()async{
                      await ContactCubit.get(context).updateFavorite(
                          id: contactItem['id'],
                          type: "Favorite");
                    },
                      icon: const Icon(Icons.favorite, color: Colors.grey,),) ,
                    child: IconButton(onPressed: ()async{
                      await ContactCubit.get(context).updateFavorite(
                          id: contactItem['id'],
                          type: "All");
                    },
                  icon: const Icon(Icons.favorite, color: Colors.red,),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListContactItem extends StatelessWidget {
  List<Map> listItem;
  String contactType;
  String noContacts;
   ListContactItem({super.key,
     required this.listItem,
     required this.contactType,
     required this.noContacts});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: listItem.isNotEmpty,
      replacement: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(Icons.no_accounts,
          size: 60.sp,
            color: Colors.white,
          ),
          DefaultText(text: noContacts,
          fontSize: 12.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        ],),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index)=>
          SizedBox(height: 3.h,),
          itemCount: listItem.length,
         itemBuilder: (context,index)=>
            BuilderItem(contactItem: listItem[index],),),
    );
  }
}

// Widget listContactItem ({required List listItem}){
//   return
// }