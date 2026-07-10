package com.kutalmis.izin_talep_sistemi.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**") // Apply this rule to all our API endpoints
                        .allowedOrigins("http://localhost:3000", "http://localhost:8081") // Add your Flutter app's local URLs here!
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS") // Allow these HTTP actions
                        .allowedHeaders("*") // Allow any headers
                        .allowCredentials(true); // Allow passwords/authentication tokens
            }
        };
    }
}