package com.kutalmis.izin_talep_sistemi.entity;

import jakarta.persistence.*;


@Entity
@Table(name = "users")

public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    private Long id;

    @Column(name = "first_name", nullable = false)
        private String firstName;
    
    @Column(name = "last_name", nullable = false)
        private String lastName;

    @Column(name = "email",nullable = false, unique = true)
        private String email;
        
    @Column(name = "password_hash", nullable = false)
        private String passwordHash;

    //İlişkiler

    @ManyToOne
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @ManyToOne
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    public User(){
    }

    // Getter Setter

    public void setId(Long id){
        this.id = id;
    } 

    public Long getId(){
        return id;
    }

   public void setFirstName(String FirstName){
    this.firstName = FirstName;
   }

   public String getFirstName(){
    return firstName;
   }

    public void setLastName(String LastName){
        this.lastName = LastName;
    }

    public String getLastName(){
        return lastName;
    }

    public String getEmail(){
        return email;
    }

    public void setEmail(String email){
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

}