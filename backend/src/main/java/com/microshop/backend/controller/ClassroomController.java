package com.microshop.backend.controller;

import com.microshop.backend.dto.ClassroomAssignRequest;
import com.microshop.backend.dto.ClassroomResponse;
import com.microshop.backend.service.ClassroomService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.microshop.backend.dto.ClassroomSimpleResponse;


import java.util.List;

@RestController
@RequestMapping("/api/classrooms")
@RequiredArgsConstructor
public class ClassroomController {

    private final ClassroomService service;

    @PostMapping("/{classId}/students")
    public void addStudents(@PathVariable Integer classId,
                            @RequestBody ClassroomAssignRequest req) {
        service.addStudentsToClass(classId, req.getStudentIds());
    }

    @GetMapping("/{classId}/students")
    public List<ClassroomResponse> getStudents(@PathVariable Integer classId) {
        return service.getStudentsByClass(classId);
    }

    @GetMapping("/students/available")
    public List<ClassroomResponse> getAvailableStudents() {
        return service.getAvailableStudents();
    }

    @GetMapping
    public List<ClassroomSimpleResponse> getAllClassrooms() {
        return service.getAllClassrooms();
    }


}
