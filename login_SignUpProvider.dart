import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:zing_fitnes_trainer/screens/Login_SignUp/modules/LoginRegular.dart';
import 'package:zing_fitnes_trainer/screens/Login_SignUp/modules/LoginTrainer.dart';
import 'package:zing_fitnes_trainer/utils/Config.dart';





class LoginSignUpProvider with ChangeNotifier {

  Firestore _firestore;
  //FirebaseStorage storage;

  FirebaseAuth firebaseAuth;


  LoginSignUpProvider.instance():
      _firestore = Firestore.instance,
      firebaseAuth = FirebaseAuth.instance;


  Future<String> login(){
    Future<FirebaseUser> user = firebaseAuth.currentUser();
    return user.then((FirebaseUser firebaseUser) async {
       if(firebaseUser.isEmailVerified)
         {
           return firebaseUser.uid;
         }else
           {
             return "Please Verify Your Email Address";
           }


    });
  }


  Future<String> saveUserData(String phoneNumber,String fullNames,String userType){
    Future<FirebaseUser> user = firebaseAuth.currentUser();
    return user.then((FirebaseUser firebaseUser) async {

      print("user id is dollar " +firebaseUser.uid );
      try {
        await firebaseUser.sendEmailVerification();

        var map =  Map<String, dynamic>();
        map[Config.userId] = firebaseUser.uid;
        map[Config.email] = firebaseUser.email;
        map[Config.phone] = phoneNumber;
        map[Config.fullNames] = fullNames;
        map[Config.userType] = userType;



        map[Config.admin] = false;



        // map[Config.notificationToken] = fcmToken;
        map[Config.createdOn] = FieldValue.serverTimestamp();
        _firestore.collection(Config.users)
            .document(firebaseUser.uid)
            .setData(map,merge: true)

            .then((_) {


        });

        return firebaseUser.uid;
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }

      return "An Error Occured";




    });
  }


  Future<String> loginUser(){
    Future<FirebaseUser> user = firebaseAuth.currentUser();
    return user.then((FirebaseUser firebaseUser) async {


      return firebaseUser.uid;


    });
  }







  String _loginEmail;
  set setEmail(value) {
    _loginEmail = value;
    notifyListeners();
  }

  get readEmail => _loginEmail;

  String _loginPass;
  set setpasssword(value) {
    _loginPass = value;
    notifyListeners();
  }

  get readloginPass => _loginPass;

  //these are the variables for the signup section
//
  String _signupTrainerName;
  set setTrainerName(value) {
    _signupTrainerName = value;
    notifyListeners();
  }

  get readTrainerName => _signupTrainerName;

  String _signUpEmail;
  set setsignUpEmail(value) {
    _signUpEmail = value;
    notifyListeners();
  }

  get readsignUpEmail => _signUpEmail;

  String _signUpPass;

  set setsignUppasssword(value) {
    _signUpPass = value;
    notifyListeners();
  }

  get readSignUpPassword => _signUpPass;

  String _signUpNumber;

  set setsignUpNumber(value) {
    _signUpNumber = value;
    notifyListeners();
  }

  get readSignUpNumber => _signUpNumber;

  //here we control autovalidation

  bool autovalidate = false;

  set setAutovalidate(bool value) {
    autovalidate = value;
  }

  get readAutovalidate => autovalidate;


  //here we manage the keyboard types for form inputs
  


  //
  //here is the section for the regular user
  //

  Widget _codeRegular = TempRegular();


  set changeCodeRegular(value) {
    _codeRegular = value;
    notifyListeners();
  }

  get showCodeRegular => _codeRegular;




  //
  //here is the trainer section
  //

  Widget _codeTrainer = TempTrainer();


  set changeCodeTrainer(value) {
    _codeTrainer = value;
    notifyListeners();
  }

  get showCodeTrainer => _codeTrainer;
}

//the class temp below holds is the default content of the provider varaible _code
//the main reason for creating the class is so that we can use the media query to get the screen height
//we can't just use it directly because it must be inside a context
class TempRegular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LoginRegular(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 30),
        )
      ],
    );
  }
}


class TempTrainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LoginTrainer(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 30),
        )
      ],
    );
  }
}
