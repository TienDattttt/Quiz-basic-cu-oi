package com.microshop.backend.service.impl;

import com.microshop.backend.entity.Role;
import com.microshop.backend.entity.User;
import com.microshop.backend.entity.UserRole;
import com.microshop.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository userRepo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User u = userRepo.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        // ✅ fetch role bằng repo, không dùng LAZY collection
        List<UserRole> roles = userRepo.findRolesByUsername(username);

        Set<GrantedAuthority> authorities = roles.stream()
                .map(r -> new SimpleGrantedAuthority("ROLE_" + r.getRole().getRoleName()))
                .collect(Collectors.toSet());

        return new org.springframework.security.core.userdetails.User(
                u.getUsername(),
                u.getPassword(),
                Boolean.TRUE.equals(u.getEnabled()),
                true,
                true,
                true,
                authorities
        );
    }

}
