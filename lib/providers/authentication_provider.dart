import 'package:chatify/models/chat_user.dart';
import 'package:chatify/services/database_services.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier
{
  late final FirebaseAuth auth;
  late final NavigationServices navigationServices;
  late final DatabaseServices databaseServices;

  late ChatUser chatUser;

  AuthenticationProvider()
  {
    auth = FirebaseAuth.instance;
    navigationServices = GetIt.instance.get<NavigationServices>();
    databaseServices = GetIt.instance.get<DatabaseServices>();
    //auth.signOut();
    auth.authStateChanges().listen((user) {
      if(user != null)
      {
        databaseServices.updateUserLastSeenTime(user.uid);
        databaseServices.getUser(user.uid).then(
                (snapshot) {
              Map<String,dynamic> userData = snapshot.data() as Map<String,dynamic>;
              chatUser = ChatUser.fromJson(
                  {
                    'uid':user.uid,
                    'name':userData['name'],
                    'email':userData['email'],
                    'last_active':userData['last_active'],
                    'image':userData['image'],
                  },
              );
              //navigationServices.removeAndNavigateToRoute('/home');
              navigationServices.removeAndNavigateToRoute('/home');
              print(' Mapppppppppppppppppppppppp${chatUser.toMap()}');
            },
        );
        //print("Logged in");
      }else
      {
        navigationServices.removeAndNavigateToRoute('/login');
        print("Not Authenticated");
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email,String password) async
  {
    try
    {
      await auth.signInWithEmailAndPassword(email: email, password: password);
     // print(auth.currentUser);
    } on FirebaseAuthException
    {
      print('Error logging user into firebase');
    } catch(e)
    {
      print(e);
    }
  }

  Future<String?> registerUsingEmailAndPassword(String email,String password) async
  {
    try
    {
      UserCredential credentials = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user!.uid;
    } on FirebaseAuthException
    {
      print('Error registering user');
    }catch(e)
    {
      print(e);
    }
  }

  Future<void> logout() async
  {
    try
    {
      await auth.signOut();
    } catch(e)
    {
      print(e);
    }
  }
}