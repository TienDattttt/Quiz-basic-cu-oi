package com.microshop.backend.repository;

import com.microshop.backend.entity.User;
import com.microshop.backend.entity.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByUsername(String username); // chỉnh nếu bạn login bằng email
    boolean existsByUsername(String username);
    @Query("""
    SELECT ur FROM UserRole ur 
    JOIN FETCH ur.role 
    WHERE ur.user.username = :username
""")
    List<UserRole> findRolesByUsername(String username);
    Optional<User> findById(Integer id);
}
