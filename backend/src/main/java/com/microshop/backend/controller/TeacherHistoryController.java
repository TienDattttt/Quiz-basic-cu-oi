package com.microshop.backend.controller;

import com.microshop.backend.dto.ExamHistoryDetailWrapper;
import com.microshop.backend.dto.ExamHistoryResponse;
import com.microshop.backend.service.TeacherHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/teacher/history")
@RequiredArgsConstructor
public class TeacherHistoryController {

    private final TeacherHistoryService service;

    @GetMapping("/class/{classId}")
    public List<ExamHistoryResponse> getHistoryByClass(@PathVariable Integer classId) {
        return service.getHistoryByClass(classId);
    }

    @GetMapping("/attempt/{attemptId}")
    public ExamHistoryDetailWrapper getAttemptDetail(@PathVariable Integer attemptId) {
        return service.getAttemptDetail(attemptId);
    }
}
