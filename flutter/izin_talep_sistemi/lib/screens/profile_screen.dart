import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/widgets/change_password_form.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final firstName = user?.firstName;
    final lastName = user?.lastName;
    final email = user?.email;
    final departmentName = user?.departmentName;
    final roleDisplayName = user?.roleDisplayName;
    final roleAuthority = user?.roleAuthority;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromRGBO(0, 189, 246, 0.959),
              child: Text(
                _getInitials(firstName, user?.lastName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                Text('${firstName ?? ''} ${lastName ?? ''}'),
                Text(roleDisplayName ?? 'BULUNAMADI'),
                Text(authorityLabel(roleAuthority!)),
                Text(departmentName ?? 'BULUNAMADI'),
              ],
            ),
            SizedBox(
              height: 10,
              width: 150,
              child: Divider(color: Color.fromARGB(255, 69, 3, 250)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 300, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Color.fromARGB(255, 6, 6, 6)),
                  SizedBox(width: 8),
                  Text(
                    email ?? 'BULUNAMADI',
                    style: TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(160, 40),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const ChangePasswordForm(),
                );
              },
              child: Text("ŞİFREYİ DEĞİŞTİR"), //TODO BURAYI STILIZE ET
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO BU MAIN SCREEN DE DE KULLANILIYOR VE ILERIDE GUNCELLEYINCE APPROVAL EKRANINDA DA CALISANLAR ICIN KULLANILACAK PROFIL CEMBERI CIZMEYI AYRI BIR WIDGETE CEVIR ILERIDE
String _getInitials(String? first, String? last) {
  final f = (first != null && first.isNotEmpty) ? first[0] : '';
  final l = (last != null && last.isNotEmpty) ? last[0] : '';
  return (f + l).toUpperCase();
}
