package com.microshop.backend.controller;

import com.microshop.backend.dto.ClassResponse;
import com.microshop.backend.dto.ExamHistoryDetailWrapper;
import com.microshop.backend.dto.ExamResponse;
import com.microshop.backend.dto.StudentExamResultResponse;
import com.microshop.backend.service.TeacherResultService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/teacher/results")
@RequiredArgsConstructor
public class TeacherResultController {

    private final TeacherResultService service;

    // ✅ Lấy danh sách lớp mà giảng viên đang dạy
    @GetMapping("/classes")
    public List<ClassResponse> getTeacherClasses(@AuthenticationPrincipal UserDetails user) {
        return service.getTeacherClasses(user.getUsername());
    }

    // ✅ Lấy danh sách bài thi đã gán cho lớp
    @GetMapping("/class/{classId}/exams")
    public List<ExamResponse> getExamsByClass(@PathVariable Integer classId) {
        return service.getExamsByClass(classId);
    }

    // ✅ Lấy danh sách học viên đã làm bài thi đó
    @GetMapping("/exam/{examId}/students")
    public List<StudentExamResultResponse> getStudentResults(@PathVariable Integer examId) {
        return service.getStudentResults(examId);
    }

    // ✅ Xem chi tiết bài làm của học viên (reuse student logic)
    @GetMapping("/attempt/{attemptId}")
    public ExamHistoryDetailWrapper getAttemptDetail(@PathVariable Integer attemptId) {
        return service.getAttemptDetail(attemptId);
    }
}

