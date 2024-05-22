
import 'package:contact/view/widgets/default_form_field.dart';
import 'package:contact/view/widgets/default_phone_form.dart';
import 'package:contact/view/widgets/default_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../constant.dart';
import '../cubit/contact_cubit/contact_cubit.dart';

class EditingContacts extends StatelessWidget {
   Map  contactItems;
    EditingContacts({super.key , required this.contactItems});

  @override
  Widget build(BuildContext context) {
    return   Dialog(
       child: Form(
         key: formKey,
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Align(
               alignment: Alignment.topRight,
               child: TextButton(
                   onPressed: () {
                     Navigator.pop(context);
                   },
                   child: const Icon(Icons.clear,color: Colors.white,size: 30,)),
             ),
             DefaultFormField(
               controller: nameController,
               keyboardType: TextInputType.name,
               validator: (value) {
                 if (value!.isEmpty) {
                   return "Name Cant be empty ";
                 }
                 return null;
               },
               textColor: Colors.white,
               prefixIcon: const Icon(Icons.title),
               hintText: "Contacts Name",
             ),
             DefaultPhoneField(
               controller: phoneController,
               validator: (value) {
                 if (value!.isEmpty) {
                   return "phone number must not be empty ";
                 }
                 return null;
               },
               labelText: "Phone Number",
               onChange: (countryCode) {
                 myCountry = countryCode;
               },
               hintText: "Contact Phone Number",
             ),
             Row(
               children: [
             TextButton(onPressed: ()async{
               if(formKey.currentState!.validate()){
                 await ContactCubit.get(context).updateContact(
                     id: contactItems['id'] ,
                    name:  nameController.text,
                   phone: "${myCountry.dialCode}${phoneController.text}",
                 );
                 nameController.clear();
                 phoneController.clear();
                 Navigator.pop(context);

                 Fluttertoast.showToast(
                     msg: "Contact Editing Successfully",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.CENTER,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.red,
                     textColor: Colors.white,
                     fontSize: 16.0
                 );

               }
             } ,
                 child:  DefaultText(text:"Save" ,color: Colors.white24,
                     fontSize: 12.sp,
                 ),
             ),
             TextButton(onPressed: (){
               Navigator.pop(context);
             } ,
                 child:  DefaultText(text:"Cancel"  ,color: Colors.white24,
                 fontSize: 12.sp,))

               ],
             )
           ],
         ),
       ),

    ) ;
  }
}
