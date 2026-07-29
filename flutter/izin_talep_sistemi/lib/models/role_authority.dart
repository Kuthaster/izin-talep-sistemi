// ignore_for_file: constant_identifier_names

enum RoleAuthority {
  ADMIN,
  MANAGER_LEVEL_3,
  MANAGER_LEVEL_2,
  MANAGER_LEVEL_1,
  EMPLOYEE,
}

String authorityLabel(RoleAuthority authority) {
  switch (authority) {
    case RoleAuthority.ADMIN:
      return 'ADMIN';
    case RoleAuthority.MANAGER_LEVEL_3:
      return '3. Kademe Yönetici';
    case RoleAuthority.MANAGER_LEVEL_2:
      return '2. Kademe Yönetici';
    case RoleAuthority.MANAGER_LEVEL_1:
      return '1. Kademe Yönetici';
    case RoleAuthority.EMPLOYEE:
      return 'Çalışan';
  }
}
