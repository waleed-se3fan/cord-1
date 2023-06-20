import 'package:cord_2/app/chat/presentation/chat_screen.dart';
import 'package:cord_2/app/devices/presentation/devices_screen.dart';
import 'package:cord_2/app/home/presentation/home_screen.dart';
import 'package:cord_2/app/profile/patiant_profile_layout/patiant_profile.dart';
import 'package:cord_2/core/user_api/controller/public_requests.dart';
import 'package:cord_2/core/components/gradient_icon.dart';
import 'package:cord_2/core/styles/cord_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/styles/colors.dart';


class CordLayout extends StatefulWidget {
  const CordLayout({super.key});

  @override
  State<CordLayout> createState() => _CordLayoutState();
}

class _CordLayoutState extends State<CordLayout> {
  List<Widget> patientScreens = [
    const HomeScreen(),
    const DevicesScreen(),
    const ChatScreen(),
    const PatiantProfile(),
  ];
  List<Widget> assistantScreens = [
    const ChatScreen(),
    const PatiantProfile(),
  ];

  int currentIndex =0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex ,
          selectedItemColor: AppColors.kLightPurple,
          unselectedItemColor: AppColors.kGrey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          iconSize: 20.sp,
          onTap: (index) {
            debugPrint('$index');
            setState(() {
              currentIndex = index ;
            });
          },
          items: (PublicRequests.currentUser.type == 'patient')
              ? [
            BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? const GradientIcon(icon: CordIcon.home)
                  : const Icon(CordIcon.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? const GradientIcon(icon: CordIcon.device)
                  : const Icon(CordIcon.device),
              label: 'Devices',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? const GradientIcon(icon: CordIcon.chat)
                  : const Icon(CordIcon.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 3
                  ? const GradientIcon(icon: CordIcon.profile)
                  : const Icon(CordIcon.profile),
              label: 'Profile',
            ),
          ]:[
            BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? const GradientIcon(icon: CordIcon.chat)
                  : const Icon(CordIcon.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? const GradientIcon(icon: CordIcon.profile)
                  : const Icon(CordIcon.profile),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: (PublicRequests.currentUser.type == 'patient')
          ?patientScreens[currentIndex] : assistantScreens[currentIndex],
    );
  }
}
