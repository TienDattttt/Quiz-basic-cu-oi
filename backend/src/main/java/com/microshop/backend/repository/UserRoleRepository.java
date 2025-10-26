package com.microshop.backend.repository;

import com.microshop.backend.entity.UserRole;
import com.microshop.backend.entity.UserRoleId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRoleRepository extends JpaRepository<UserRole, UserRoleId> {
}
