import 'package:echo_beats_music/Presentation/Pages/HomePages/screen_home.dart';
import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {

  
  Future<void> handlePermission() async {
    var status = await Permission.audio.status;
    if (status.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return ScreenHomes();
      }));
    } else if (status.isDenied) {
      // Redirect user to settings if permission is denied
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Permission Required'),
          content: Text('Please grant audio permission in settings to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings(); // Redirect to settings
              },
              child: Text('Open Settings'),
            ),
           
          ],
        ),
      );
    } else {
      // Permission denied and not shown in settings
      
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
          color: Theme.of(context).scaffoldBackgroundColor
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // Enables scrolling
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
                              text: '\nBeats\n', // Second part
                            ),
                            TextSpan(
                              text: "Music.",
                              style: GoogleFonts.poppins(
                                fontSize: 70,
                                fontWeight: FontWeight.w600,
                                color:
                                    Colors.white, // Assuming white is defined
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                sizeBox(h: 80), // Adds space between text and TextFormField
                TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide.none, // No visible border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Rounded corners when focused
                      borderSide:
                          BorderSide.none, // No visible border when focused
                    ),
                    prefixIcon: const Icon(Icons.account_circle_rounded,color: Colors.grey,),
                    hintText: "Enter Your Name",hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),

                sizeBox(h: 10),
                //Started Button
                ElevatedButton(
                  onPressed: ()async {
                    // Get.off(() => ScreenHomes(),
                    //     duration: Duration(seconds: 1),
                    //     transition: Transition.cupertino);
                    await handlePermission();
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
    );
  }
}
