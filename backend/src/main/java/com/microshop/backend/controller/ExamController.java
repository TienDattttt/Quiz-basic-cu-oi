package com.microshop.backend.controller;

import com.microshop.backend.dto.ExamCreateRequest;
import com.microshop.backend.dto.ExamResponse;
import com.microshop.backend.service.ExamService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/exams")
@RequiredArgsConstructor
public class ExamController {

    private final ExamService examService;

    @PostMapping
    public ExamResponse create(@RequestBody ExamCreateRequest request) {
        return examService.create(request);
    }

    @GetMapping("/{id}")
    public ExamResponse getById(@PathVariable Integer id) {
        return examService.getById(id);
    }

    @GetMapping
    public List<ExamResponse> getBySubject(@RequestParam Integer subjectId) {
        return examService.getBySubject(subjectId);
    }
}
