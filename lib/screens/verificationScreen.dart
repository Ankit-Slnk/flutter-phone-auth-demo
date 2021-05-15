import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoneauth/screens/userProfileScreen.dart';
import 'package:phoneauth/utility/appColors.dart';
import 'package:phoneauth/utility/appDimens.dart';
import 'package:phoneauth/utility/utility.dart';

class VerificationScreen extends StatefulWidget {
  String countrycode;
  String mobile;
  VerificationScreen({@required this.mobile, @required this.countrycode});
  @override
  _VerificationScreenPageState createState() => _VerificationScreenPageState();
}

class _VerificationScreenPageState extends State<VerificationScreen> {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  FocusNode controller1fn = new FocusNode();
  FocusNode controller2fn = new FocusNode();
  FocusNode controller3fn = new FocusNode();
  FocusNode controller4fn = new FocusNode();
  FocusNode controller5fn = new FocusNode();
  FocusNode controller6fn = new FocusNode();
  static const double dist = 3.0;
  TextEditingController currController = new TextEditingController();
  String otp = "";
  AppDimens appDimens;
  bool isLoading = false;
  String _verificationId;
  bool autovalidate = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    currController = controller1;
    _verifyPhoneNumber();
  }

  void _verifyPhoneNumber() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Utility.showToast(msg: authException.message);
      print(authException.code);
      print(authException.message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      print("codeSent");
      print(verificationId);
      Utility.showToast(
          msg: "Please check your phone for the verification code.");
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("codeAutoRetrievalTimeout");
      _verificationId = verificationId;
    };

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      print("verificationCompleted");
    };

    if (kIsWeb) {
      await _auth
          .signInWithPhoneNumber(
        widget.countrycode + widget.mobile,
      )
          .then((value) {
        _verificationId = value.verificationId;
        print("then");
      }).catchError((onError) {
        print(onError);
      });
    } else {
      await _auth
          .verifyPhoneNumber(
              phoneNumber: widget.countrycode + widget.mobile,
              timeout: const Duration(seconds: 5),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent,
              codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
          .then((value) {
        print("then");
      }).catchError((onError) {
        print(onError);
      });
    }

    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  void _signInWithPhoneNumber(String otp) async {
    _showProgressDialog(true);
    if (await Utility.checkInternet()) {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: otp,
        );
        final User user = (await _auth.signInWithCredential(credential)).user;
        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        _showProgressDialog(false);
        if (user != null) {
          print(user);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(
                user: user,
              ),
            ),
          );
        } else {
          Utility.showToast(msg: "Sign in failed");
        }
      } catch (e) {
        print(e);

        Utility.showToast(msg: e.toString());
        _showProgressDialog(false);
      }
    } else {
      _showProgressDialog(false);
      Utility.showToast(msg: "No internet connection");
    }
  }

  _showProgressDialog(bool isloadingstate) {
    if (mounted)
      setState(() {
        isLoading = isloadingstate;
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  verifyOtp(String otpText) async {
    _signInWithPhoneNumber(otpText);
  }

  @override
  Widget build(BuildContext context) {
    appDimens = new AppDimens(MediaQuery.of(context).size);

    List<Widget> widgetList = [
      Padding(
        padding: const EdgeInsets.only(right: dist, left: dist),
        child: Container(
          alignment: Alignment.center,
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            enabled: true,
            controller: controller1,
            autofocus: true,
            focusNode: controller1fn,
            onChanged: (ct) {
              if (ct.length > 0) {
                _fieldFocusChange(context, controller1fn, controller2fn);
              }
            },
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: appDimens.text24, color: AppColors.greyText),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: dist, left: dist),
        child: new Container(
          alignment: Alignment.center,
          child: new TextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onChanged: (ct) {
              if (ct.length > 0) {
                _fieldFocusChange(context, controller2fn, controller3fn);
              } else if (ct.length == 0) {
                _fieldFocusChange(context, controller2fn, controller1fn);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            focusNode: controller2fn,
            enabled: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: appDimens.text24, color: AppColors.greyText),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: dist, left: dist),
        child: new Container(
          alignment: Alignment.center,
          child: new TextField(
            onChanged: (ct) {
              if (ct.length > 0) {
                _fieldFocusChange(context, controller3fn, controller4fn);
              } else if (ct.length == 0) {
                _fieldFocusChange(context, controller3fn, controller2fn);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: controller3,
            focusNode: controller3fn,
            textAlign: TextAlign.center,
            enabled: true,
            style: TextStyle(
                fontSize: appDimens.text24, color: AppColors.greyText),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: dist, left: dist),
        child: new Container(
          alignment: Alignment.center,
          child: new TextField(
            onChanged: (ct) {
              if (ct.length > 0) {
                _fieldFocusChange(context, controller4fn, controller5fn);
              } else if (ct.length == 0) {
                _fieldFocusChange(context, controller4fn, controller3fn);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: controller4,
            focusNode: controller4fn,
            enabled: true,
            style: TextStyle(
                fontSize: appDimens.text24, color: AppColors.greyText),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: dist, left: dist),
        child: new Container(
          alignment: Alignment.center,
          child: new TextField(
            onChanged: (ct) {
              if (ct.length > 0) {
                _fieldFocusChange(context, controller5fn, controller6fn);
              } else if (ct.length == 0) {
                _fieldFocusChange(context, controller5fn, controller4fn);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: controller5,
            focusNode: controller5fn,
            textAlign: TextAlign.center,
            enabled: true,
            style: TextStyle(
                fontSize: appDimens.text24, color: AppColors.greyText),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: dist, left: dist),
        child: new Container(
          alignment: Alignment.center,
          child: new TextField(
            onChanged: (ct) {
              if (ct.length == 0) {
                _fieldFocusChange(context, controller6fn, controller5fn);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: controller6,
            focusNode: controller6fn,
            enabled: true,
            style: TextStyle(
                fontSize: appDimens.text24, color: AppColors.greyText),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.blackColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            top: false,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(appDimens.paddingw16),
                        child: Center(
                          child: Text(
                            "An " +
                                "SMS"
                                    " with the verification code has been sent to your registered " +
                                "mobile number",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: appDimens.text16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: appDimens.paddingw16),
                        child: Visibility(
                          visible: widget.mobile == null ? false : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.countrycode + " " + widget.mobile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: appDimens.text20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.edit),
                                color: AppColors.greyText,
                                iconSize: appDimens.iconsize,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: appDimens.paddingw16),
                        child: Center(
                          child: Text(
                            "Enter 6 digits code",
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: appDimens.text12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: GridView.count(
                          crossAxisCount: 6,
                          mainAxisSpacing: 10.0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1,
                          scrollDirection: Axis.vertical,
                          children: List<Container>.generate(
                            6,
                            (int index) => Container(
                              child: widgetList[index],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Utility.loginButtonsWidget(
                        "",
                        "Continue",
                        () {
                          _onButtonClick();
                        },
                        AppColors.blackColor,
                        AppColors.blackColor,
                        appDimens,
                        AppColors.whiteColor,
                      ),
                      InkWell(
                        onTap: () {
                          _verifyPhoneNumber();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: appDimens.paddingw6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Spacer(),
                              Text(
                                "Didn't receive " + "SMS? ",
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: appDimens.text16,
                                ),
                              ),
                              Text(
                                "Resend",
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: appDimens.text16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading ? Utility.progress(context) : Container(),
        ],
      ),
    );
  }

  _onButtonClick() {
    if (currController.text.trim() == "" ||
        controller1.text.trim() == "" ||
        controller2.text.trim() == "" ||
        controller3.text.trim() == "" ||
        controller4.text.trim() == "" ||
        controller5.text.trim() == "" ||
        controller6.text.trim() == "") {
      Utility.showToast(msg: "Please enter valid verification code.");
    } else {
      verifyOtp(controller1.text.trim() +
          controller2.text.trim() +
          controller3.text.trim() +
          controller4.text.trim() +
          controller5.text.trim() +
          controller6.text.trim());
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller3;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }
}
