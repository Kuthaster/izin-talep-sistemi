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
      return 'MANAGER_LEVEL_3';
    case RoleAuthority.MANAGER_LEVEL_2:
      return 'MANAGER_LEVEL_2';
    case RoleAuthority.MANAGER_LEVEL_1:
      return 'MANAGER_LEVEL_1';
    case RoleAuthority.EMPLOYEE:
      return 'EMPLOYEE';
  }
}
