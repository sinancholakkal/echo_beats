import 'package:echo_beats_music/Presentation/Pages/HomePages/screen_home.dart';
import 'package:echo_beats_music/Presentation/Widgets/wScreenLogin/text_form_field.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameControll = TextEditingController();

  Future<void> handlePermission() async {
    // Check the status of manageExternalStorage (for Android 11+)
    var statusStorage = await Permission.manageExternalStorage.status;

    // Check the status of audio permission
    var statusAudio = await Permission.audio.status;
    var storage = await Permission.storage.status;

    // If both permissions are granted, navigate to the home screen
    if (statusAudio.isGranted || storage.isGranted || statusStorage.isGranted) {
      await setValueInSharedprfs(context);
      Get.off(() => const ScreenHomes(), transition: Transition.circularReveal);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Permission Required',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            """Please grant audio permission and external storage in settings to continue. Tap 'Open Settings' →
Tap 'Permissions' →
Select 'Music and Audio'""",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings(); // Redirect to settings
                Get.back();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body color
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        width: double.infinity,
        decoration: BoxDecoration(
            //gradient: AppColors.background,
            color: Theme.of(context).scaffoldBackgroundColor),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //Text App name
                        sizeBox(h: 130),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 70,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appNameColor,
                              height: 1.2,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Echo', // First part
                              ),
                              const TextSpan(
                                text: '\nMusic\n', // Second part
                              ),
                              TextSpan(
                                text: "Player.",
                                style: GoogleFonts.poppins(
                                  fontSize: 70,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  sizeBox(h: 80),
                  //textFormFieald----------------------------------------
                  TextFormFieldLogin(nameControll: _nameControll),

                  sizeBox(h: 10),
                  //Started Button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print(" Validated--------------------");
                        await handlePermission();
                      } else {
                        print("Not Validated--------------------");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appNameColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  //Disclimer: this text for about privecy
                  sizeBox(h: 10),
                  const Text(
                    "Disclaimer: We respect your privacy more than\nanything else. All of your data is stored locally on\nyour device only.",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(119, 255, 255, 255)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//It is for store data
  Future<void> setValueInSharedprfs(BuildContext context) async {
    final name = _nameControll.text;
    final sharedpfs = await SharedPreferences.getInstance();
    await sharedpfs.setString("username", name);
    //await handlePermission();
  }
}

