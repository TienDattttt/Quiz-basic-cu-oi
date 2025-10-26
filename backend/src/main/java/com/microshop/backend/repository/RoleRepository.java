package com.microshop.backend.repository;

import com.microshop.backend.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Integer> {
    Optional<Role> findByRoleName(String roleName); // đổi nếu cột tên khác: name/code
}
