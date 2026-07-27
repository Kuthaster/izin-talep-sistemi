import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/widgets/text_anim.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginBannerWidget extends StatelessWidget {
  final Color purpleBg;
  final Color purpleDark;
  final Color purpleMedium;
  final Color blueAccent1;
  final Color blueAccent2;

  const LoginBannerWidget({
    super.key,
    this.purpleBg = const Color(0xFFEEEDFE),
    this.purpleDark = const Color(0xFF26215C),
    this.purpleMedium = const Color(0xFF3C3489),
    this.blueAccent1 = const Color(0xFF7F77DD),
    this.blueAccent2 = const Color(0xFFAFA9EC),
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: purpleBg,
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: purpleMedium,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: purpleBg,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoşgeldiniz',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: purpleDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'İzin Talep Sistemi',
                  style: TextStyle(fontSize: 16, color: purpleMedium),
                ),
              ],
            ),

            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: blueAccent1),
                InkWell(
                  onTap: openLink,
                  child: TextAnim(text: "By Kuthaster"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openLink() async {
    const url = 'https://github.com/kuthaster';
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
