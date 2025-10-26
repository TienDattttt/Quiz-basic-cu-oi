package com.microshop.backend.controller;

import com.microshop.backend.dto.ExamAssignmentRequest;
import com.microshop.backend.dto.ExamAssignmentResponse;
import com.microshop.backend.service.ExamAssignmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/exam-assignments")
@RequiredArgsConstructor
public class ExamAssignmentController {

    private final ExamAssignmentService service;

    @PostMapping
    public ExamAssignmentResponse assign(@RequestBody ExamAssignmentRequest request) {
        return service.assign(request);
    }

    @GetMapping("/class/{classId}")
    public List<ExamAssignmentResponse> getByClass(@PathVariable Integer classId) {
        return service.getByClass(classId);
    }
}
