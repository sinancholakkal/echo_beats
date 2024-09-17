import 'package:echo_beats_music/Untils/Colors/colors.dart';
import 'package:echo_beats_music/Untils/constant/constent.dart';
import 'package:flutter/material.dart';

class ScreenPrivacyPolicy extends StatelessWidget {
  ScreenPrivacyPolicy({super.key});

  Text textHead(
      {required String text, required double fontSize, required fontwheight}) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: fontwheight,color: white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy policy",
          style: TextStyle(color: white),
        ),
        iconTheme: const IconThemeData(color: white, size: 30),
        //backgroundColor: const Color.fromARGB(255, 179, 17, 155),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            //gradient: AppColors.background,
            color: Theme.of(context).scaffoldBackgroundColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizeBox(h: 10),
                textHead(
                    text: "How we collect and use your information",
                    fontSize: 20,
                    fontwheight: FontWeight.bold),
                sizeBox(h: 20),
                textHead(
                    text: "Usage Data",
                    fontSize: 18,
                    fontwheight: FontWeight.bold),
                sizeBox(h: 20),
                textHead(
                    text:
                        "We may automatically gather some information when you access the service via or through a mobile device, including, without limitation, the type of mobile device you use, your mobile device unique ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use.",
                    fontSize: 14,
                    fontwheight: FontWeight.normal),
                sizeBox(h: 20),
                textHead(
                    text: "Technical Data",
                    fontSize: 18,
                    fontwheight: FontWeight.bold),
                sizeBox(h: 20),
                textHead(
                    text:
                        "Additionally, in order to provide a better user experience, we have integrated data statistics tools in the app, they won't collect users' privacy data and are only used for CRASH targeting and AB-testing for new features and design, such as device information (Screen Size, OEM Name, Model), Device system information (OS Name, OS Version, OS Build, System Language, Carrier Country) and Application information (App Name, App Build, APP Version Number, SDK Name, SDK Version). \nThis information is primarily needed to maintain the security and operation of our platform, and for our internal analytics and reporting purposes.",
                    fontSize: 14,
                    fontwheight: FontWeight.normal),
                sizeBox(h: 20),
                textHead(
                    text: "Personal Data",
                    fontSize: 18,
                    fontwheight: FontWeight.bold),
                sizeBox(h: 20),
                textHead(
                    text:
                        "App may process your personal data for the purposes specified in this Privacy Policy. The personal data of users collected and used by our service in particular, are as follows: phone number / email address which we will receive once you contact us, and identifier for advertisers designated in your mobile device used in accessing our services (The Identifier for Advertisers-IDFA), identifier for vendors/developers designated your mobile device (The Identifier for Vendors-IDVF) and Internet Protocol Address-IP Address).",
                    fontSize: 14,
                    fontwheight: FontWeight.normal),
                sizeBox(h: 20),
                textHead(
                    text: "App Permission",
                    fontSize: 18,
                    fontwheight: FontWeight.bold),
                sizeBox(h: 20),
                textHead(
                    text:
                        """Storage permission: This permission is necessary for accessing your local media when you scan the music stored on your device. Separately, if you want to use your local photo as the skin theme or change cover, we also may need this permission to access your local media to select photos.
            Notably, we shall not obtain any other information from your device, nor modify / delete the content in your local media. This permission is only applicable for the services we provide.""",
                    fontSize: 14,
                    fontwheight: FontWeight.normal),
                sizeBox(h: 20),
                textHead(
                    text: "Contact Me",
                    fontSize: 18,
                    fontwheight: FontWeight.bold),
                sizeBox(h: 20),
                textHead(
                    text:
                        "If you have any questions about this Privacy Policy, please contact us at\n@sinanzzsinu70@gmail.com",
                    fontSize: 14,
                    fontwheight: FontWeight.normal),
                    sizeBox(h: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
