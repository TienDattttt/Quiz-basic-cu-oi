package com.microshop.backend.controller;

import com.microshop.backend.dto.ExamDetailResponse;
import com.microshop.backend.dto.ExamResultResponse;
import com.microshop.backend.dto.ExamSubmitRequest;
import com.microshop.backend.repository.UserRepository;
import com.microshop.backend.service.ExamService;
import com.microshop.backend.service.StudentDoExamService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/student/exams")
@RequiredArgsConstructor
public class StudentDoExamController {

    private final StudentDoExamService service;
    private final UserRepository userRepo;

    @PostMapping("/{examId}/submit")
    public ExamResultResponse submit(@PathVariable Integer examId,
                                     @RequestBody ExamSubmitRequest request) {
        return service.submit(examId, request);
    }

    @GetMapping("/{examId}/detail")
    public ExamDetailResponse getDetail(@PathVariable Integer examId,
                                        @AuthenticationPrincipal UserDetails user) {

        String username = user.getUsername();
        Integer studentId = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();

        return service.getExamDetail(examId, studentId);
    }

    @GetMapping("/exam/{examId}")
    public ExamDetailResponse getExamDetail(@PathVariable Integer examId) {
        return service.getExamDetail(examId, null); // studentId lấy từ token
    }
}
