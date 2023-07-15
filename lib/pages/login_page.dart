import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:chatify/widget/custom_input_fields.dart';
import 'package:chatify/widget/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late NavigationServices navigation;

  final loginFormKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    deviceHeight =MediaQuery.of(context).size.height;
    deviceWidth =MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationServices>();
    return buildUI() ;
  }

  Widget buildUI()
  {
    return Scaffold(
      body: Container(
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03 ,
          vertical: deviceHeight * 0.02 ,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
          [
            pageTitle(),
            SizedBox(
              height: deviceHeight * 0.04,
            ),
            loginForm(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            loginButton(),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget pageTitle()
  {
    return  Container(
      height: deviceHeight * 0.10,
      child: Text(
        'Chat',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget loginForm()
  {
    return Container(
      height: deviceHeight * 0.22,
      child: Form(
        key: loginFormKey,
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

  Widget loginButton()
  {
    return RoundedButton(
        name: 'Login',
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.65,
        onPressed: ()
        {
          if(loginFormKey.currentState!.validate())
          {
            loginFormKey.currentState!.save();
            //print('Email: $email, Password: $password');
            auth.loginUsingEmailAndPassword(email!, password!);
            print('Email: $email, Password: $password');
          }
        },
    );
  }

  Widget registerAccountLink()
  {
    return GestureDetector(
      onTap: ()
      {
        navigation.navigateToRoute('/register');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03 ,
          vertical: deviceHeight * 0.002 ,
        ),
        child: const Text(
          'Don\'t have an account',
          style: TextStyle(
           color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
