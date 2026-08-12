package com.kutalmis.izin_talep_sistemi.dto;

import java.util.List;

public record ApproverGapDTO(Long departmentId, String departmentName, List<Integer> missingLevels) {
}