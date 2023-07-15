import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloud_storage_services.dart';
import 'package:chatify/services/database_services.dart';
import 'package:chatify/services/media_services.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:chatify/widget/custom_input_fields.dart';
import 'package:chatify/widget/rounded_button.dart';
import 'package:chatify/widget/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider aut;
  late DatabaseServices db;
  late CloudStorageServices cloudStorageServices;
  late NavigationServices navigation;

  String? name;
  String? email;
  String? password;

  final registerFormKey = GlobalKey<FormState>();

  PlatformFile? profileImage;

  @override
  Widget build(BuildContext context) {
    aut = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance.get<DatabaseServices>();
    navigation = GetIt.instance.get<NavigationServices>();
    cloudStorageServices = GetIt.instance.get<CloudStorageServices>();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI()
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03,
          vertical: deviceHeight * 0.02,
        ),
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
          [
            profileImageField(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            registerForm(),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget profileImageField()
  {
   return GestureDetector(
     onTap: ()
     {
       GetIt.instance.get<MediaServices>().pickImageFromLibrary().then((file)
       {
         setState(() {
           profileImage = file;
         });
       });
     },
     child: ()
     {
       if(profileImage != null)
       {
         return RoundedImageFile(
           key: UniqueKey(),
           image: profileImage!,
           size: deviceHeight * 0.15,
         );
       }else
       {
         return RoundedImageNetwork(
           key: UniqueKey(),
           imagePath:'https://img.freepik.com/free-photo/modern-residential-district-with-green-roof-balcony-generated-by-ai_188544-10276.jpg?w=900&t=st=1684423576~exp=1684424176~hmac=847fa946deffe66484d6781c68060d08217db3cdc8569edb06ee1fd8a4a75c0c',
           size: deviceHeight * 0.15,
         );
       }
     }(),
   );
  }

  Widget registerForm()
  {
    return  Container(
      height: deviceHeight * 0.35,
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
          [
            CustomTextFormField(
              onSaved: (value)
              {
                setState(() {
                  name = value;
                });
              },
              regEx: r".{8,}",
              hintText: 'Name',
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value)
              {
                setState(() {
                  email = value;
                });
              },
              regEx:r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: 'Email',
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (value)
              {
                setState(() {
                  password = value;
                });
              },
              regEx: r".{8,}",
              hintText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget registerButton()
  {
    return RoundedButton(
        name: 'Register',
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.65,
        onPressed: () async {
          if(registerFormKey.currentState!.validate() && profileImage != null)
          {
            registerFormKey.currentState!.save();
            String? uid = await aut.registerUsingEmailAndPassword(email!, password!);
            String? imageURL = await cloudStorageServices.saveUserImageToStorage(uid!, profileImage!);
            await db.createUser(uid, email!, name!, imageURL!);
            //navigation.goBack();
            await aut.logout();
            await aut.loginUsingEmailAndPassword(email!, password!);
          }
        },
    );
  }
}
