package com.microshop.backend.controller;

import com.microshop.backend.dto.SubjectDTO;
import com.microshop.backend.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/subjects")
@RequiredArgsConstructor
public class SubjectController {

    private final SubjectService subjectService;

    @PostMapping
    public SubjectDTO create(@RequestBody SubjectDTO dto) {
        return subjectService.create(dto);
    }

    @GetMapping
    public List<SubjectDTO> getAll() {
        return subjectService.getAll();
    }

    @GetMapping("/{id}")
    public SubjectDTO getById(@PathVariable Integer id) {
        return subjectService.getById(id);
    }

    @PutMapping("/{id}")
    public SubjectDTO update(@PathVariable Integer id, @RequestBody SubjectDTO dto) {
        return subjectService.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        subjectService.delete(id);
    }
}
