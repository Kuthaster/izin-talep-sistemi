# İzin Talep Sistemi

Çok seviyeli kurumsal izin talep/onay sistemi. Spring boot RESTFUL API backend + Flutter mobil istemci.
Kurumsal 

## Kullanılan Teknolojiler
- Backend: Spring Boot, Spring Security (JWT), PostgreSQL, Hibernate/JPA
- Frontend: Flutter
- API docs: springdoc-openapi (Swagger UI)

## Kurulum

### Gereksinimler
- JDK 21+, Maven, PostgreSQL 15+

### Adımlar
1. Repo'yu klonlayın.
2. `backend/izin_talep_sistemi/src/main/resources/application-example.properties` dosyasını `application.properties` olarak kopyalayıp gerçek DB bilgileri girin.
3. Ortam değişkenlerini ayarlayın: `BOOTSTRAP_ADMIN_PASSWORD`, `JWT_SECRET` (32+ karakter).
4. ./mvnw spring-boot:run`
5. Uygulama ilk açılışta gerekli rolleri, bootstrap admin hesabını ve varsayılan izin türlerini otomatik oluşturur (Bkz. `RoleSeeder`, `UserSeeder`, `LeaveTypeSeeder`).

## API Dokümantasyonu
Bkz. (Uygulama çalışırken) http://localhost:8080/swagger-ui.html`

## Veritabanı Şeması
Bkz. `docs/database-schema.md

## Yetkilendirme Modeli
- Role Authority: ADMIN, MANAGER_LEVEL_1, MANAGER_LEVEL_2, MANAGER_LEVEL_3, EMPLOYEE (sabit, admin panelinden yalnızca görünen ad değiştirilebilir)
- JWT tabanlı stateless kimlik doğrulama