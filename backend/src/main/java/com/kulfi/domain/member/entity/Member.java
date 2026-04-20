package com.kulfi.domain.member.entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.SQLRestriction;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@SQLDelete(sql = "UPDATE member SET is_delete = true, deleted_at = now() WHERE id = ?")
@SQLRestriction("is_deleted = false")
@Entity
@EntityListeners(AuditingEntityListener.class)
@Table(name = "member")
public class Member {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(length = 255, nullable = false, unique = true)
  private String email;

  @Column(length = 255)
  private String password;

  @Column(length = 50, nullable = false, unique = true)
  private String nickname;
  
  @Column(name = "profile_image", length = 500)
  private String profileImage;
  
  @Enumerated(EnumType.STRING)
  @Column(nullable = false, length = 20)
  private AuthProvider authProvider;

  @Column(name = "provider_id", length = 255)
  private String providerId;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false, length = 10)
  private Role role = Role.USER;

  @Column(name = "last_login_at")
  private LocalDateTime lastLoginAt;

  @Column(name = "is_deleted", nullable = false)
  private boolean isDeleted = false;

  @Column(name = "deleted_at")
  private LocalDateTime deletedAt;

  @CreatedDate
  @Column(name = "created_at", updatable = false)
  private LocalDateTime createdAt;
  
  @LastModifiedDate
  @Column(name = "updated_at")
  private LocalDateTime updatedAt;

  @Builder
  public Member(String email, String password, String nickname,
                String profileImage, AuthProvider provider, String providerId, Role role) {
        this.email = email;
        this.password = password;
        this.nickname = nickname;
        this.profileImage = profileImage;
        this.authProvider = authProvider != null ? provider : AuthProvider.LOCAL;
        this.providerId = providerId;
        this.role = role != null ? role : Role.USER;
  }
}
