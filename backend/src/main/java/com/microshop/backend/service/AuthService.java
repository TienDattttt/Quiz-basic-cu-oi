package com.microshop.backend.service;

import com.microshop.backend.dto.AuthResponse;
import com.microshop.backend.dto.LoginRequest;

public interface AuthService {
    AuthResponse login(LoginRequest req);
    AuthResponse register(String username, String rawPassword, String fullName, String role);
}
