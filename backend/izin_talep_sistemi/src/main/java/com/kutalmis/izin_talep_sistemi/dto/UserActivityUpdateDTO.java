package com.kutalmis.izin_talep_sistemi.dto;

import jakarta.validation.constraints.NotNull;

public record UserActivityUpdateDTO(@NotNull Boolean active) {}
