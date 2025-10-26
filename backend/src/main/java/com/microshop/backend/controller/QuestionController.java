package com.microshop.backend.controller;

import com.microshop.backend.dto.QuestionDTO;
import com.microshop.backend.service.QuestionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
@RequiredArgsConstructor
public class QuestionController {

    private final QuestionService questionService;

    @PostMapping
    public QuestionDTO create(@RequestBody QuestionDTO dto) {
        return questionService.create(dto);
    }

    @GetMapping
    public List<QuestionDTO> getBySubject(@RequestParam Integer subjectId) {
        return questionService.getBySubject(subjectId);
    }

    @GetMapping("/{id}")
    public QuestionDTO getById(@PathVariable Integer id) {
        return questionService.getById(id);
    }

    @PutMapping("/{id}")
    public QuestionDTO update(@PathVariable Integer id, @RequestBody QuestionDTO dto) {
        return questionService.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        questionService.delete(id);
    }
}
