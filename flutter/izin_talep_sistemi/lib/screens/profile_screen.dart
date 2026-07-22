import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/widgets/change_password_form.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  

  Widget build(BuildContext context, WidgetRef ref){
    final user = ref.watch(authProvider).value;
    final firstName = user?.firstName;
    final lastName = user?.lastName;
    final email = user?.email;
    final departmentName = user?.departmentName;
    final roleDisplayName = user?.roleDisplayName;
    final roleAuthority = user?.roleAuthority;
  
  
   return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
              ),
              Text('${firstName ?? ''} ${lastName ?? ''}'),
              Text(roleDisplayName ?? 'BULUNAMADI'),
              Text(roleAuthority?.name ?? 'BULUNAMADI'),
              Text(departmentName ?? 'BULUNAMADI'),
              SizedBox(
                height: 10,
                width: 150,
                child: Divider(color: Color.fromARGB(255, 3, 250, 32)),
              ),
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 25, 0, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.email, color: Color(0xFF181818)),
                    SizedBox(width: 8),
                    Text(email ?? 'BULUNAMADI'),
                  ],
                ),
              ),ElevatedButton(
                onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const ChangePasswordForm(),
              );}, 
                child: Text("ŞİFREYİ DEĞİŞTİR")  //TODO BURAYI STILIZE ET
              ),ElevatedButton(
              onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).popUntil((route) => route.isFirst
              );},
              child: const Text('Çıkış Yap'),
              )
            ],
          ),
        ),
    );
  }
}
