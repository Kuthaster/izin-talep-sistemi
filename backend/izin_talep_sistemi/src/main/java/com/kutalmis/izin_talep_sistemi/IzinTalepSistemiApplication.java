package com.kutalmis.izin_talep_sistemi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class IzinTalepSistemiApplication {

	public static void main(String[] args) {
		SpringApplication.run(IzinTalepSistemiApplication.class, args);
	}

}
