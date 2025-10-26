package com.microshop.backend.service.impl;

import com.microshop.backend.dto.AuthResponse;
import com.microshop.backend.dto.LoginRequest;
import com.microshop.backend.entity.Role;
import com.microshop.backend.entity.User;
import com.microshop.backend.entity.UserRole;
import com.microshop.backend.entity.UserRoleId;
import com.microshop.backend.repository.ExamAttemptDetailRepository;
import com.microshop.backend.repository.RoleRepository;
import com.microshop.backend.repository.UserRepository;
import com.microshop.backend.repository.UserRoleRepository;
import com.microshop.backend.service.AuthService;
import com.microshop.backend.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthenticationManager authManager;
    private final JwtUtil jwtUtil;
    private final UserRepository userRepo;
    private final RoleRepository roleRepo;
    private final PasswordEncoder encoder;
    private final UserRoleRepository userRoleRepository;

    @Override
    public AuthResponse login(LoginRequest req) {
        Authentication auth = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.getUsername(), req.getPassword())
        );

        User u = userRepo.findByUsername(req.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Lấy role đầu tiên (nếu 1 user 1 role). Nếu nhiều role, chọn theo yêu cầu của bạn
        String roleName = u.getUserRoles().stream()
                .findFirst()
                .map(ur -> ur.getRole().getRoleName())
                .orElse("STUDENT");

        String token = jwtUtil.generateToken(
                u.getUsername(),
                Map.of("uid", u.getId(), "role", roleName)
        );

        AuthResponse res = new AuthResponse();
        res.setToken(token);
        res.setUsername(u.getUsername());
        res.setRole(roleName);
        return res;
    }

    @Override
    public AuthResponse register(String username, String rawPassword, String fullName, String role) {
        if (userRepo.existsByUsername(username)) {
            throw new RuntimeException("Username already exists");
        }
        Role r = roleRepo.findByRoleName(role)
                .orElseThrow(() -> new RuntimeException("Role not found: " + role));

        User u = new User();
        u.setUsername(username);
        u.setPassword(encoder.encode(rawPassword));
        u.setFullName(fullName);
        u.setEnabled(true);
        // nếu entity có fullName → u.setFullName(fullName);
        // gán role:

        u = userRepo.save(u);

        UserRole ur = new UserRole();
        UserRoleId id = new UserRoleId();
        id.setUserId(u.getId());
        id.setRoleId(r.getId());
        ur.setId(id);
        ur.setUser(u);
        ur.setRole(r);

        userRoleRepository.save(ur);

        String token = jwtUtil.generateToken(
                u.getUsername(),
                Map.of("uid", u.getId(), "role", r.getRoleName())
        );
        AuthResponse res = new AuthResponse();
        res.setToken(token);
        res.setUsername(u.getUsername());
        res.setRole(r.getRoleName());
        return res;
    }
}
