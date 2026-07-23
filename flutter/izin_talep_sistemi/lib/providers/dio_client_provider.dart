import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

// TODO switch everything to this shit
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});