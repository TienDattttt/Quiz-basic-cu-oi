package com.microshop.backend.config;

import com.microshop.backend.service.impl.UserDetailsServiceImpl;
import com.microshop.backend.util.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsServiceImpl uds;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String header = request.getHeader("Authorization");
        String token = (StringUtils.hasText(header) && header.startsWith("Bearer "))
                ? header.substring(7) : null;

        if (token != null && jwtUtil.validate(token)
                && SecurityContextHolder.getContext().getAuthentication() == null) {

            String username = jwtUtil.getSubject(token);
            var userDetails = uds.loadUserByUsername(username);

            // Lấy claims từ token
            var claims = jwtUtil.parse(token).getBody(); // Claims is Map<String, Object>

            UsernamePasswordAuthenticationToken auth =
                    new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());

            auth.setDetails(claims); // Set details to claims Map to allow SecurityUtils to read "uid"
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        filterChain.doFilter(request, response);
    }
}