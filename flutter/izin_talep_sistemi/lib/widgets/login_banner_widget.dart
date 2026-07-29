import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/theme/text/text_anim.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginBannerWidget extends StatelessWidget {
  const LoginBannerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
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
                    color: Theme.of(context).colorScheme.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'İzin Talep Sistemi',
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    InkWell(
                      onTap: openLink,
                      child: TextAnim(
                        textInput: "By: Kuthaster",
                        isAnimated: true,
                        textColor: Theme.of(context).colorScheme.secondary,
                        caretColor: Theme.of(context).colorScheme.secondary,
                        caretBlinkDuration: Duration(milliseconds: 1200),
                      ),
                    ),
                  ],
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
