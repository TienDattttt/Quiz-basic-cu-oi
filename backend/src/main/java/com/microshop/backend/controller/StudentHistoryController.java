package com.microshop.backend.controller;

import com.microshop.backend.dto.ExamHistoryDetailWrapper;
import com.microshop.backend.dto.ExamHistoryResponse;
import com.microshop.backend.service.StudentHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/student/history")
@RequiredArgsConstructor
public class StudentHistoryController {

    private final StudentHistoryService service;

    @GetMapping
    public List<ExamHistoryResponse> getHistory(@RequestParam Integer studentId) {
        return service.getHistory(studentId);
    }

    @GetMapping("/{attemptId}")
    public ExamHistoryDetailWrapper getDetail(@PathVariable Integer attemptId) {
        return service.getHistoryDetail(attemptId);
    }
}
