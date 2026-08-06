import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';

void logout(BuildContext context, WidgetRef ref) {
  ref.read(authProvider.notifier).logout();
  Navigator.of(context).popUntil((route) => route.isFirst);
}
