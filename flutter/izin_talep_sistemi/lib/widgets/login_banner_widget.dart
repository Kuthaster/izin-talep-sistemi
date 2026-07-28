import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/theme/text/text_anim.dart';
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
        color: Theme.of(context).colorScheme.surfaceBright,
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceBright,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Hoşgeldiniz.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            Text(
              'İzin Talep Sistemi', //TODO BURAYI DEĞİŞTİR, TYPEWRITE ETKISI EKLE, BÜYÜT, ÇOK YAZILI OLSUN
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                InkWell(
                  onTap: openLink,
                  child: TextAnim(
                    textInput: "By: Kuthaster",
                    isAnimated: true,
                    textColor: Theme.of(context).colorScheme.tertiaryFixedDim,
                    caretColor: Theme.of(context).colorScheme.tertiaryFixedDim,
                    caretBlinkDuration: Duration(milliseconds: 1200),
                  ),
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
