package com.marvin.example.blogapp.models;

import com.marvin.example.blogapp.enums.Role;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "users")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank
    @Size(min = 3, max = 255)
    private String firstName;

    @NotBlank
    @Size(min = 3, max = 255)
    private String lastName;

    @NotBlank
    @Size(min = 3, max = 255)
    private String username;

    @NotBlank
    @Email
    private String email;

    @Size(min = 8, max = 255)
    @NotBlank
    private String password;

    @Transient
    private String passwordConfirmation;

    @Enumerated(EnumType.STRING)
    private Role role;

    private boolean isBanned = false;

    private LocalDate createdAt;

    //private LocalDateTime lastLogin;

    @Size(max = 255)
    private String profilePictureUrl = "/images/default-avatar-profile-icon.jpg";

    @PrePersist
    private void onCreate() {
        this.createdAt = LocalDate.now();
    }

    @OneToMany(mappedBy = "creator", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Post> posts = new HashSet<>();

    @ManyToMany(cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinTable(
            name = "blocked_users",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "blocked_user_id")
    )
    private List<User> blockedUsers = new ArrayList<>();

    public String getFormattedCreatedAt() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return createdAt.format(formatter);
    }
}
