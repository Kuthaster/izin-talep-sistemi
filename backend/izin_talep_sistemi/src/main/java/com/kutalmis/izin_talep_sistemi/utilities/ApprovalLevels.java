package com.kutalmis.izin_talep_sistemi.utilities;

import com.kutalmis.izin_talep_sistemi.entity.RoleAuthority;

import java.util.Set;

public final class ApprovalLevels {

    public static final int MAX_LEVEL = 3;

    public static final Set<RoleAuthority> MANAGER_ROLES = Set.of(
            RoleAuthority.MANAGER_LEVEL_1, RoleAuthority.MANAGER_LEVEL_2, RoleAuthority.MANAGER_LEVEL_3);

    private ApprovalLevels() {
    }

    public static RoleAuthority roleForLevel(int level) {
        return switch (level) {
            case 1 -> RoleAuthority.MANAGER_LEVEL_1;
            case 2 -> RoleAuthority.MANAGER_LEVEL_2;
            case 3 -> RoleAuthority.MANAGER_LEVEL_3;
            default -> null;
        };
    }

    public static Integer levelForRole(RoleAuthority role) {
        return switch (role) {
            case MANAGER_LEVEL_1 -> 1;
            case MANAGER_LEVEL_2 -> 2;
            case MANAGER_LEVEL_3 -> 3;
            default -> null;
        };
    }
}