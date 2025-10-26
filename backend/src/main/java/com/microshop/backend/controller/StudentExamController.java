package com.microshop.backend.controller;

import com.microshop.backend.dto.StudentExamResponse;
import com.microshop.backend.service.StudentExamService;
import com.microshop.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/student/exams")
@RequiredArgsConstructor
public class StudentExamController {

    private final StudentExamService service;
    private final UserRepository userRepo;

    @GetMapping
    public List<StudentExamResponse> getExams(@AuthenticationPrincipal UserDetails user) {
        // Lấy username từ token
        String username = user.getUsername();

        // Tìm userId từ DB
        Integer studentId = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();

        // Trả kết quả
        return service.getExamsByStudent(studentId);
    }
}
